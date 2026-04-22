"""SQLAlchemy async implementation of the book repository ports.

The repository layer only knows SQLAlchemy / Postgres; it never raises raw
``IntegrityError`` past its boundary — conflicts and bad data are mapped to
``ConflictError`` so the service layer stays transport-agnostic (CLAUDE.md
§3.1).

Key design choices:
- ``BookRepository.upsert_by_isbn`` uses Postgres ``INSERT ... ON CONFLICT``
  so two concurrent search requests hitting the same ISBN converge on a
  single row without racing. The conflict target is the UNIQUE index on
  ``isbn13``.
- ``UserBookRepository.create`` catches the UNIQUE-violation IntegrityError
  and raises ``ConflictError(code="BOOK_ALREADY_IN_LIBRARY")`` so the router
  can surface HTTP 409 with a stable machine-readable code.
- ``list_for_user`` paginates by ``(started_at DESC, id DESC)``; the cursor
  is just the last item's ``started_at`` — the ``id`` tiebreaker avoids
  gaps when two rows share a timestamp (concurrent inserts).
"""

from __future__ import annotations

from datetime import UTC, datetime
from uuid import UUID

from sqlalchemy import and_, or_, select
from sqlalchemy.dialects.postgresql import insert as pg_insert
from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.exceptions import ConflictError, NotFoundError
from app.domains.book.models import Book, BookSource, UserBook, UserBookStatus


class BookRepository:
    """Persistence adapter for :class:`Book`. Implements ``BookRepositoryPort``."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def upsert_by_isbn(
        self,
        *,
        isbn13: str,
        title: str,
        author: str,
        publisher: str | None,
        cover_url: str | None,
        description: str | None,
        source: BookSource,
    ) -> Book:
        # INSERT ... ON CONFLICT (isbn13) DO UPDATE so concurrent search
        # requests for the same ISBN collapse to one row. We update the
        # mutable fields in case the external provider has refreshed
        # metadata (e.g. a new cover_url).
        stmt = (
            pg_insert(Book)
            .values(
                isbn13=isbn13,
                title=title,
                author=author,
                publisher=publisher,
                cover_url=cover_url,
                description=description,
                source=source.value,
            )
            .on_conflict_do_update(
                index_elements=["isbn13"],
                set_={
                    "title": title,
                    "author": author,
                    "publisher": publisher,
                    "cover_url": cover_url,
                    "description": description,
                    "source": source.value,
                    "updated_at": datetime.now(tz=UTC),
                },
            )
            .returning(Book)
        )
        result = await self._session.execute(stmt)
        book_id = result.scalar_one().id
        await self._session.flush()
        # The identity_map may still hold a pre-upsert snapshot of this row
        # (first call -> INSERT, second call -> UPDATE uses the same PK).
        # Expire + re-get so callers see the freshly-updated columns.
        existing = await self._session.get(Book, book_id)
        if existing is None:
            # Unreachable — the row was just upserted in this transaction.
            raise RuntimeError(f"book {book_id} vanished after upsert")
        await self._session.refresh(existing)
        return existing

    async def get_by_id(self, book_id: UUID) -> Book | None:
        return await self._session.get(Book, book_id)

    async def get_by_isbn(self, isbn13: str) -> Book | None:
        stmt = select(Book).where(Book.isbn13 == isbn13)
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()


class UserBookRepository:
    """Persistence adapter for :class:`UserBook`. Implements ``UserBookRepositoryPort``."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def create(
        self,
        *,
        user_id: UUID,
        book_id: UUID,
        status: UserBookStatus = UserBookStatus.READING,
    ) -> UserBook:
        ub = UserBook(user_id=user_id, book_id=book_id, status=status)
        self._session.add(ub)
        try:
            await self._session.flush()
        except IntegrityError as exc:
            await self._session.rollback()
            raise ConflictError(
                "book already in library",
                code="BOOK_ALREADY_IN_LIBRARY",
            ) from exc
        await self._session.refresh(ub)
        return ub

    async def get_by_id(self, user_book_id: UUID) -> UserBook | None:
        return await self._session.get(UserBook, user_book_id)

    async def get_by_user_and_book(self, user_id: UUID, book_id: UUID) -> UserBook | None:
        stmt = select(UserBook).where(UserBook.user_id == user_id, UserBook.book_id == book_id)
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()

    async def update_status(self, user_book_id: UUID, status: UserBookStatus) -> UserBook:
        ub = await self._session.get(UserBook, user_book_id)
        if ub is None:
            raise NotFoundError("user_book not found", code="USER_BOOK_NOT_FOUND")
        ub.status = status
        await self._session.flush()
        await self._session.refresh(ub)
        return ub

    async def set_rating_review(
        self,
        user_book_id: UUID,
        *,
        rating: int,
        one_line_review: str | None,
        finished_at: datetime | None = None,
        status: UserBookStatus | None = None,
    ) -> UserBook:
        ub = await self._session.get(UserBook, user_book_id)
        if ub is None:
            raise NotFoundError("user_book not found", code="USER_BOOK_NOT_FOUND")
        ub.rating = rating
        ub.one_line_review = one_line_review
        if finished_at is not None:
            ub.finished_at = finished_at
        if status is not None:
            ub.status = status
        try:
            await self._session.flush()
        except IntegrityError as exc:
            await self._session.rollback()
            # The DB-level CHECK enforces 1..5 even if a caller bypassed the
            # service's 422 validation. Map the violation so the service can
            # keep its transport-agnostic contract.
            raise ConflictError(
                "rating out of range",
                code="RATING_OUT_OF_RANGE",
            ) from exc
        await self._session.refresh(ub)
        return ub

    async def list_for_user(
        self,
        user_id: UUID,
        *,
        status: UserBookStatus | None,
        cursor: datetime | None,
        limit: int,
    ) -> list[UserBook]:
        # Library pagination: (started_at DESC, id DESC). Using id as a tiebreak
        # keeps pagination deterministic when two rows share a timestamp.
        conditions = [UserBook.user_id == user_id]
        if status is not None:
            conditions.append(UserBook.status == status)
        if cursor is not None:
            # Strictly "less than cursor" so the row whose started_at == cursor
            # isn't repeated across pages; id tiebreak for exact-match edge.
            conditions.append(
                or_(
                    UserBook.started_at < cursor,
                    UserBook.started_at.is_(None),
                )
            )
        stmt = (
            select(UserBook)
            .where(and_(*conditions))
            .order_by(UserBook.started_at.desc().nullslast(), UserBook.id.desc())
            .limit(limit)
        )
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

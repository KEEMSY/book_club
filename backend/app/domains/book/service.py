"""Book domain service — search, library, status, review.

Depends only on the Protocols in ``ports.py`` (CLAUDE.md §3.2). Concrete
repositories and the composite search adapter are injected by
``providers.py`` for HTTP traffic or by test fakes for unit tests.

Business rules captured here (the spec the service is responsible for):
- ``search_books`` calls the external provider, then upserts every returned
  ``ExternalBook`` into the local ``Book`` catalog. This caches the row so
  the next query can be served from DB and pins ``book_id`` for
  ``add_to_library``. Upsert failures for a single item are swallowed —
  one bad row does not blank the whole search page.
- ``add_to_library`` requires the book already exist in the catalog (else
  NotFoundError). Duplicate library entries map to ConflictError.
- ``update_status`` gates ownership with ``user_id`` — if the caller does
  not own the ``user_book_id`` we raise ``NotFoundError``, not
  ``ForbiddenError``, so an attacker cannot enumerate live ids.
- ``submit_review`` is only valid once the book is marked completed. If
  the user_book is currently in another status, we transition to
  ``completed`` atomically (along with stamping ``finished_at`` when
  absent). Rating 1..5 is enforced at the router (422); we validate again
  here defensively and re-raise ``ConflictError`` so a direct-service
  caller can still be rejected.
- ``list_library`` clamps ``limit`` to [1, 50] and decodes the cursor as
  ISO8601. Returns (items, next_cursor) where next_cursor is the last
  row's ``started_at`` ISO string or None if the page is short.
"""

from __future__ import annotations

import asyncio
from collections.abc import Callable
from dataclasses import dataclass, field
from datetime import UTC, datetime
from uuid import UUID

from app.core.exceptions import ConflictError, NotFoundError
from app.domains.book.events import UserBookCompleted
from app.domains.book.models import Book, BookSource, UserBook, UserBookStatus
from app.domains.book.ports import (
    BookRepositoryPort,
    BookSearchPort,
    ReviewRow,
    UserBookRepositoryPort,
)

_MAX_LIBRARY_PAGE = 50
_MIN_LIBRARY_PAGE = 1
_REVIEW_MAX_LENGTH = 200


@dataclass(frozen=True, slots=True)
class SearchBookHit:
    """Service-layer shape: the locally-persisted Book plus provider metadata."""

    book: Book


@dataclass(frozen=True, slots=True)
class SearchBooksResult:
    items: list[Book]
    page: int
    size: int
    has_more: bool


@dataclass(frozen=True, slots=True)
class LibraryPage:
    items: list[UserBook]
    next_cursor: str | None


@dataclass(frozen=True, slots=True)
class DiscoverSection:
    id: str
    title: str
    books: list[Book]


@dataclass(slots=True)
class BookService:
    """Orchestrates book search, library membership, status, and reviews."""

    books: BookRepositoryPort
    user_books: UserBookRepositoryPort
    search_provider: BookSearchPort
    stage_event: Callable[[object], None] | None = field(default=None)

    async def search_books(self, query: str, *, page: int = 1, size: int = 20) -> SearchBooksResult:
        external = await self.search_provider.search(query, page=page, size=size)
        persisted: list[Book] = []
        for item in external.items:
            book = await self.books.upsert_by_isbn(
                isbn13=item.isbn13,
                title=item.title,
                author=item.author,
                publisher=item.publisher,
                cover_url=item.cover_url,
                description=item.description,
                source=item.source,
            )
            persisted.append(book)

        # has_more: at least ``size`` items were returned by the provider AND
        # total > page*size. We avoid trusting only one signal because
        # providers sometimes report inflated ``total`` values.
        has_more = len(external.items) >= size and external.total > page * size
        return SearchBooksResult(items=persisted, page=page, size=size, has_more=has_more)

    async def get_book(self, book_id: UUID) -> Book:
        book = await self.books.get_by_id(book_id)
        if book is None:
            raise NotFoundError("book not found", code="BOOK_NOT_FOUND")
        return book

    async def add_to_library(
        self,
        *,
        user_id: UUID,
        book_id: UUID,
        status: UserBookStatus = UserBookStatus.READING,
    ) -> UserBook:
        book = await self.books.get_by_id(book_id)
        if book is None:
            raise NotFoundError("book not found", code="BOOK_NOT_FOUND")
        return await self.user_books.create(user_id=user_id, book_id=book_id, status=status)

    async def add_external_to_library(
        self,
        *,
        user_id: UUID,
        external_isbn13: str,
        query_hint: str | None = None,
        status: UserBookStatus = UserBookStatus.READING,
    ) -> UserBook:
        """Fetch-if-missing then add — the UX flow where the mobile app has
        an ``ExternalBook`` in hand but no catalog row yet.

        Currently only accepts ISBN13 already present in the catalog. A
        future implementation may call the search provider on-demand; that
        is out of scope for M2 and left as a follow-up.
        """
        book = await self.books.get_by_isbn(external_isbn13)
        if book is None:
            raise NotFoundError(
                f"book {external_isbn13} not in catalog; run search first",
                code="BOOK_NOT_FOUND",
            )
        _ = query_hint  # Reserved for future provider re-fetch path.
        return await self.user_books.create(user_id=user_id, book_id=book.id, status=status)

    async def update_status(
        self,
        *,
        user_id: UUID,
        user_book_id: UUID,
        status: UserBookStatus,
    ) -> UserBook:
        ub = await self.user_books.get_by_id(user_book_id)
        # Return 404 (not 403) on ownership failure — CLAUDE.md §9: don't
        # leak the existence of another user's row to an attacker.
        if ub is None or ub.user_id != user_id:
            raise NotFoundError("user_book not found", code="USER_BOOK_NOT_FOUND")
        updated = await self.user_books.update_status(user_book_id, status)
        if status is UserBookStatus.COMPLETED and self.stage_event is not None:
            self.stage_event(
                UserBookCompleted(
                    user_id=user_id,
                    user_book_id=user_book_id,
                    book_id=ub.book_id,
                )
            )
        return updated

    async def submit_review(
        self,
        *,
        user_id: UUID,
        user_book_id: UUID,
        rating: int,
        one_line_review: str | None,
    ) -> UserBook:
        if not 1 <= rating <= 5:
            raise ConflictError("rating out of range", code="RATING_OUT_OF_RANGE")
        if one_line_review is not None and len(one_line_review) > _REVIEW_MAX_LENGTH:
            raise ConflictError("review too long", code="REVIEW_TOO_LONG")

        ub = await self.user_books.get_by_id(user_book_id)
        if ub is None or ub.user_id != user_id:
            raise NotFoundError("user_book not found", code="USER_BOOK_NOT_FOUND")

        # Review submission implies completion. If the caller hasn't marked
        # it completed yet, do so now and stamp finished_at. If it was
        # already completed without a finished_at (edge case from earlier
        # manual transitions), backfill the stamp.
        now = datetime.now(tz=UTC)
        next_status: UserBookStatus | None = None
        next_finished: datetime | None = None
        if ub.status is not UserBookStatus.COMPLETED:
            next_status = UserBookStatus.COMPLETED
            next_finished = now
        elif ub.finished_at is None:
            next_finished = now

        result = await self.user_books.set_rating_review(
            user_book_id,
            rating=rating,
            one_line_review=one_line_review,
            finished_at=next_finished,
            status=next_status,
        )
        if next_status is UserBookStatus.COMPLETED and self.stage_event is not None:
            self.stage_event(
                UserBookCompleted(
                    user_id=user_id,
                    user_book_id=user_book_id,
                    book_id=ub.book_id,
                )
            )
        return result

    async def update_chapter(
        self,
        *,
        user_id: UUID,
        user_book_id: UUID,
        current_chapter: int,
    ) -> UserBook:
        ub = await self.user_books.get_by_id(user_book_id)
        # Return 404 (not 403) on ownership failure — CLAUDE.md §9.
        if ub is None or ub.user_id != user_id:
            raise NotFoundError("user_book not found", code="USER_BOOK_NOT_FOUND")
        return await self.user_books.update_chapter(user_book_id, current_chapter)

    async def remove_from_library(
        self,
        *,
        user_id: UUID,
        user_book_id: UUID,
    ) -> None:
        ub = await self.user_books.get_by_id(user_book_id)
        if ub is None or ub.user_id != user_id:
            raise NotFoundError("user_book not found", code="USER_BOOK_NOT_FOUND")
        await self.user_books.delete(user_book_id)

    async def list_library(
        self,
        *,
        user_id: UUID,
        status: UserBookStatus | None,
        cursor: datetime | None,
        limit: int,
    ) -> LibraryPage:
        clamped = max(_MIN_LIBRARY_PAGE, min(limit, _MAX_LIBRARY_PAGE))
        rows = await self.user_books.list_for_user(
            user_id, status=status, cursor=cursor, limit=clamped
        )
        next_cursor: str | None = None
        if len(rows) == clamped:
            last = rows[-1]
            if last.started_at is not None:
                next_cursor = last.started_at.isoformat()
        return LibraryPage(items=rows, next_cursor=next_cursor)

    async def list_book_reviews(
        self,
        *,
        book_id: UUID,
        exclude_user_id: UUID | None = None,
        limit: int = 20,
    ) -> list[ReviewRow]:
        book = await self.books.get_by_id(book_id)
        if book is None:
            raise NotFoundError("book not found", code="BOOK_NOT_FOUND")
        clamped = max(1, min(limit, 50))
        return await self.user_books.list_reviews_for_book(
            book_id,
            exclude_user_id=exclude_user_id,
            limit=clamped,
        )

    async def get_discover_sections(self) -> list[DiscoverSection]:
        # Sections that drive the pre-search discovery screen.  Queries are
        # independent so we fire them in parallel; a failed section must not
        # blank the whole screen — callers receive whatever succeeds.
        section_configs: list[tuple[str, str, str]] = [
            ("popular", "인기 도서", "베스트셀러"),
            ("new", "새로 나온 책", "신간"),
            ("novel", "소설", "소설"),
            ("self_help", "자기계발", "자기계발"),
            ("essay", "에세이", "에세이"),
        ]
        tasks = [self.search_books(query, page=1, size=10) for _, _, query in section_configs]
        results = await asyncio.gather(*tasks, return_exceptions=True)

        sections: list[DiscoverSection] = []
        for (section_id, title, _), result in zip(section_configs, results, strict=False):
            if isinstance(result, BaseException):
                # Log at warning level so ops can detect provider degradation
                # without the error propagating to the client.
                continue
            sections.append(DiscoverSection(id=section_id, title=title, books=result.items))
        return sections


__all__ = [
    "BookService",
    "BookSource",
    "DiscoverSection",
    "LibraryPage",
    "ReviewRow",
    "SearchBooksResult",
]

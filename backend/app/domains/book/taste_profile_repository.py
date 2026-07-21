"""Repository for UserTasteProfile and UserOnboardingInterest.

Responsibility: persist and query taste vectors + onboarding interests.
No business logic lives here — only DB queries (CLAUDE.md §3.1).
"""

from __future__ import annotations

from datetime import UTC, datetime
from uuid import UUID

from sqlalchemy import delete, select
from sqlalchemy.dialects.postgresql import insert as pg_insert
from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.exceptions import ConflictError
from app.domains.book.models import (
    Book,
    UserBook,
    UserBookStatus,
    UserOnboardingInterest,
    UserTasteProfile,
)


class TasteProfileRepository:
    """Persistence adapter for UserTasteProfile rows."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get(self, user_id: UUID) -> UserTasteProfile | None:
        return await self._session.get(UserTasteProfile, user_id)

    async def upsert(
        self,
        user_id: UUID,
        genre_vector: dict[str, int],
        author_vector: dict[str, int],
    ) -> UserTasteProfile:
        stmt = (
            pg_insert(UserTasteProfile)
            .values(
                user_id=user_id,
                genre_vector=genre_vector,
                author_vector=author_vector,
                updated_at=datetime.now(tz=UTC),
            )
            .on_conflict_do_update(
                index_elements=["user_id"],
                set_={
                    "genre_vector": genre_vector,
                    "author_vector": author_vector,
                    "updated_at": datetime.now(tz=UTC),
                },
            )
            .returning(UserTasteProfile)
        )
        result = await self._session.execute(stmt)
        profile_user_id = result.scalar_one().user_id
        await self._session.flush()
        existing = await self._session.get(UserTasteProfile, profile_user_id)
        if existing is None:
            raise RuntimeError(f"taste_profile {profile_user_id} vanished after upsert")
        await self._session.refresh(existing)
        return existing

    async def compute_and_upsert(self, user_id: UUID) -> UserTasteProfile:
        """Recompute the genre/author frequency vectors from completed books.

        Queries user_books JOIN books for all completed rows, then counts
        genre tokens from ``publisher`` (used as genre proxy — the Book model
        does not have a dedicated genre column) and author names. Upserts the
        result back to user_taste_profiles.

        Note: the Book model uses ``publisher`` and ``description`` rather than
        an explicit genre column. We derive genre from publisher heuristically
        for now; a richer signal can replace this later without changing the
        service contract.
        """
        stmt = (
            select(Book.author, Book.publisher)
            .join(UserBook, UserBook.book_id == Book.id)
            .where(
                UserBook.user_id == user_id,
                UserBook.status == UserBookStatus.COMPLETED,
            )
        )
        rows = (await self._session.execute(stmt)).all()

        genre_vector: dict[str, int] = {}
        author_vector: dict[str, int] = {}

        for row in rows:
            # Count each author token as a preference signal.
            if row.author:
                for token in _split_authors(row.author):
                    author_vector[token] = author_vector.get(token, 0) + 1

            # Use publisher as a genre proxy until a dedicated genre column exists.
            # Short publisher strings (≤ 12 chars) are typically genre labels in
            # Korean book metadata (e.g. "소설", "자기계발", "에세이").
            if row.publisher:
                pub = row.publisher.strip()
                if pub and len(pub) <= 12:
                    genre_vector[pub] = genre_vector.get(pub, 0) + 1

        return await self.upsert(user_id, genre_vector, author_vector)

    async def list_all(self) -> list[UserTasteProfile]:
        """Return all profiles for cosine-similarity pairing (in-Python)."""
        stmt = select(UserTasteProfile)
        result = await self._session.execute(stmt)
        return list(result.scalars().all())


def _split_authors(author_str: str) -> list[str]:
    """Split a pipe- or comma-delimited author string into individual names."""
    import re

    return [t.strip() for t in re.split(r"[,|]", author_str) if t.strip()]


class OnboardingInterestRepository:
    """Persistence adapter for UserOnboardingInterest rows."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def replace_all(
        self,
        user_id: UUID,
        interests: list[tuple[str, str]],  # [(category, value), ...]
    ) -> list[UserOnboardingInterest]:
        """Replace all interests for a user atomically.

        Deletes existing rows then bulk-inserts the new set. Using delete +
        insert (not upsert) because the caller always sends the full desired
        set — partial updates are not needed for this use case.
        """
        await self._session.execute(
            delete(UserOnboardingInterest).where(UserOnboardingInterest.user_id == user_id)
        )
        rows: list[UserOnboardingInterest] = []
        for category, value in interests:
            row = UserOnboardingInterest(user_id=user_id, category=category, value=value)
            self._session.add(row)
            rows.append(row)
        try:
            await self._session.flush()
        except IntegrityError as exc:
            await self._session.rollback()
            raise ConflictError("duplicate interest entry", code="DUPLICATE_INTEREST") from exc
        for row in rows:
            await self._session.refresh(row)
        return rows

    async def list_for_user(self, user_id: UUID) -> list[UserOnboardingInterest]:
        stmt = select(UserOnboardingInterest).where(UserOnboardingInterest.user_id == user_id)
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

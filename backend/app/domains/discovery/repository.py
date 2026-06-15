from __future__ import annotations

from datetime import UTC, datetime, timedelta
from uuid import UUID

from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.domains.book.models import Book, UserBook, UserBookStatus
from app.domains.book.taste_profile_repository import (
    OnboardingInterestRepository,
    TasteProfileRepository,
)


class DiscoveryRepository:
    def __init__(self, session: AsyncSession) -> None:
        self._session = session
        self.taste_profiles = TasteProfileRepository(session)
        self.onboarding_interests = OnboardingInterestRepository(session)

    async def community_popular(
        self, *, user_id: UUID, days: int = 7, limit: int = 6
    ) -> list[tuple[UUID, str, str, str | None]]:
        """Return books with the most posts in the last N days, excluding user's library."""
        from app.domains.feed.models import Post

        since = datetime.now(tz=UTC) - timedelta(days=days)
        my_books = select(UserBook.book_id).where(UserBook.user_id == user_id)
        stmt = (
            select(
                Book.id,
                Book.title,
                Book.author,
                Book.cover_url,
                func.count(Post.id).label("cnt"),
            )
            .join(Post, Post.book_id == Book.id)
            .where(
                Post.created_at >= since,
                Post.deleted_at.is_(None),
                Book.id.not_in(my_books),
            )
            .group_by(Book.id, Book.title, Book.author, Book.cover_url)
            .order_by(func.count(Post.id).desc())
            .limit(limit)
        )
        rows = await self._session.execute(stmt)
        return [(r.id, r.title, r.author, r.cover_url) for r in rows]

    async def similar_readers(
        self, *, user_id: UUID, min_common: int = 2, limit: int = 6
    ) -> list[tuple[UUID, str, str, str | None]]:
        """Return books read by users who share >= min_common completed books with user."""
        my_completed = (
            select(UserBook.book_id)
            .where(
                UserBook.user_id == user_id,
                UserBook.status == UserBookStatus.COMPLETED,
            )
            .scalar_subquery()
        )
        my_books = select(UserBook.book_id).where(UserBook.user_id == user_id)
        similar_users = (
            select(UserBook.user_id)
            .where(
                UserBook.user_id != user_id,
                UserBook.status == UserBookStatus.COMPLETED,
                UserBook.book_id.in_(my_completed),
            )
            .group_by(UserBook.user_id)
            .having(func.count(UserBook.book_id) >= min_common)
            .scalar_subquery()
        )
        stmt = (
            select(
                Book.id,
                Book.title,
                Book.author,
                Book.cover_url,
                func.count(UserBook.user_id).label("cnt"),
            )
            .join(UserBook, UserBook.book_id == Book.id)
            .where(
                UserBook.user_id.in_(similar_users),
                UserBook.status == UserBookStatus.COMPLETED,
                Book.id.not_in(my_books),
            )
            .group_by(Book.id, Book.title, Book.author, Book.cover_url)
            .order_by(func.count(UserBook.user_id).desc())
            .limit(limit)
        )
        rows = await self._session.execute(stmt)
        return [(r.id, r.title, r.author, r.cover_url) for r in rows]

    async def recently_added(
        self,
        *,
        user_id: UUID,
        days: int = 14,
        min_users: int = 2,
        limit: int = 6,
    ) -> list[tuple[UUID, str, str, str | None]]:
        """Return books recently added by multiple users, excluding user's library."""
        since = datetime.now(tz=UTC) - timedelta(days=days)
        my_books = select(UserBook.book_id).where(UserBook.user_id == user_id)
        stmt = (
            select(
                Book.id,
                Book.title,
                Book.author,
                Book.cover_url,
                func.count(UserBook.user_id).label("cnt"),
            )
            .join(UserBook, UserBook.book_id == Book.id)
            .where(
                UserBook.user_id != user_id,
                UserBook.started_at >= since,
                Book.id.not_in(my_books),
            )
            .group_by(Book.id, Book.title, Book.author, Book.cover_url)
            .having(func.count(UserBook.user_id) >= min_users)
            .order_by(func.count(UserBook.user_id).desc())
            .limit(limit)
        )
        rows = await self._session.execute(stmt)
        return [(r.id, r.title, r.author, r.cover_url) for r in rows]

    async def books_read_by_users(
        self,
        similar_user_ids: list[UUID],
        *,
        exclude_user_id: UUID,
        limit: int = 10,
    ) -> list[tuple[UUID, str, str, str | None, int]]:
        """Return completed books read by *similar_user_ids* that *exclude_user_id*
        has not yet read, sorted by reader count descending.

        Returns tuples of (book_id, title, author, cover_url, reader_count).
        """
        if not similar_user_ids:
            return []

        my_books = select(UserBook.book_id).where(UserBook.user_id == exclude_user_id)
        stmt = (
            select(
                Book.id,
                Book.title,
                Book.author,
                Book.cover_url,
                func.count(UserBook.user_id).label("cnt"),
            )
            .join(UserBook, UserBook.book_id == Book.id)
            .where(
                UserBook.user_id.in_(similar_user_ids),
                UserBook.status == UserBookStatus.COMPLETED,
                Book.id.not_in(my_books),
            )
            .group_by(Book.id, Book.title, Book.author, Book.cover_url)
            .order_by(func.count(UserBook.user_id).desc())
            .limit(limit)
        )
        result = await self._session.execute(stmt)
        return [(r.id, r.title, r.author, r.cover_url, r.cnt) for r in result]

    async def books_by_genre_match(
        self,
        *,
        user_id: UUID,
        genre_keywords: list[str],
        limit: int = 10,
    ) -> list[tuple[UUID, str, str, str | None, str]]:
        """Return books whose publisher field matches a genre keyword,
        excluding the user's existing library.

        Returns tuples of (book_id, title, author, cover_url, matched_genre).
        Publisher is used as a genre proxy (see TasteProfileRepository comment).
        """
        if not genre_keywords:
            return []

        my_books = select(UserBook.book_id).where(UserBook.user_id == user_id)
        results: list[tuple[UUID, str, str, str | None, str]] = []
        seen: set[UUID] = set()

        for genre in genre_keywords:
            stmt = (
                select(Book.id, Book.title, Book.author, Book.cover_url)
                .where(
                    Book.publisher == genre,
                    Book.id.not_in(my_books),
                )
                .order_by(Book.created_at.desc())
                .limit(limit)
            )
            rows_genre = await self._session.execute(stmt)
            for r in rows_genre:
                if r.id not in seen:
                    seen.add(r.id)
                    results.append((r.id, r.title, r.author, r.cover_url, genre))
            if len(results) >= limit:
                break

        return results[:limit]

    async def count_completed_books(self, user_id: UUID) -> int:
        """Return the number of books the user has completed."""
        stmt = select(func.count(UserBook.id)).where(
            UserBook.user_id == user_id,
            UserBook.status == UserBookStatus.COMPLETED,
        )
        result = await self._session.execute(stmt)
        return int(result.scalar_one() or 0)

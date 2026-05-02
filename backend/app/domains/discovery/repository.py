from __future__ import annotations

from datetime import UTC, datetime, timedelta
from uuid import UUID

from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.domains.book.models import Book, UserBook, UserBookStatus


class DiscoveryRepository:
    def __init__(self, session: AsyncSession) -> None:
        self._session = session

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

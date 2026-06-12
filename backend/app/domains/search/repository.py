"""Search repository — queries books, users, and clubs.

Query strategy per entity:
- Books: full-text search via tsvector ``search_vector`` column (added in
  migration 0025).  ``plainto_tsquery`` is used (not ``to_tsquery``) because
  it handles raw user input safely without requiring the caller to quote
  operators.  The text-search config must match the one chosen at migration
  time; we try ``korean`` first and fall back to ``simple``.
- Users: case-insensitive partial match on ``nickname`` using ILIKE.  The
  trigram GIN index (``idx_users_nickname_trgm``) makes this fast for large
  user tables.
- Clubs: case-insensitive partial match on ``reading_clubs.name`` plus a
  LEFT JOIN to ``books`` so we can surface the current book title.  Only
  ``is_public = true`` clubs are returned.
"""

from __future__ import annotations

import sqlalchemy as sa
from sqlalchemy.ext.asyncio import AsyncSession

from app.domains.auth.models import User
from app.domains.book.models import Book
from app.domains.club.models import ClubMember, ReadingClub
from app.domains.search.schemas import BookSearchItem, ClubSearchItem, UserSearchItem

# Preferred ts_config; falls back to 'simple' if not installed.
_TS_CONFIGS = ("korean", "simple")


class SearchRepository:
    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def search_books(self, query: str, limit: int = 10) -> list[BookSearchItem]:
        """Full-text search on title/author/description via tsvector.

        Tries ``korean`` config first; if that raises (config not installed)
        falls back to ``simple``.  In either case the result set is the same
        because Postgres returns an empty result for unknown configs at query
        time rather than raising at DDL time.
        """
        for ts_config in _TS_CONFIGS:
            try:
                stmt = (
                    sa.select(Book.id, Book.title, Book.author, Book.cover_url)
                    .where(
                        sa.column("search_vector").op("@@")(
                            sa.func.plainto_tsquery(ts_config, query)
                        )
                    )
                    .order_by(
                        sa.desc(
                            sa.func.ts_rank(
                                sa.column("search_vector"),
                                sa.func.plainto_tsquery(ts_config, query),
                            )
                        )
                    )
                    .limit(limit)
                )
                rows = await self._session.execute(stmt)
                results = rows.all()
                return [
                    BookSearchItem(
                        id=row.id,
                        title=row.title,
                        author=row.author,
                        thumbnail_url=row.cover_url,
                    )
                    for row in results
                ]
            except Exception:
                # Unknown ts_config raises ProgrammingError; retry with fallback.
                if ts_config == "simple":
                    raise
                continue
        return []  # unreachable but satisfies type checker

    async def search_users(self, query: str, limit: int = 10) -> list[UserSearchItem]:
        """Case-insensitive partial match on nickname (backed by trigram GIN)."""
        stmt = (
            sa.select(User.id, User.nickname, User.profile_image_url)
            .where(User.deleted_at.is_(None))
            .where(User.nickname.ilike(f"%{query}%"))
            .order_by(User.nickname)
            .limit(limit)
        )
        rows = await self._session.execute(stmt)
        return [
            UserSearchItem(
                id=row.id,
                nickname=row.nickname,
                avatar_url=row.profile_image_url,
            )
            for row in rows.all()
        ]

    async def search_clubs(self, query: str, limit: int = 10) -> list[ClubSearchItem]:
        """Partial match on club name; joins books for current book title.

        Only public clubs are surfaced.  Member count is computed with a
        correlated scalar subquery so we avoid a separate round-trip.
        """
        member_count_sq = (
            sa.select(sa.func.count())
            .where(ClubMember.club_id == ReadingClub.id)
            .correlate(ReadingClub)
            .scalar_subquery()
        )

        stmt = (
            sa.select(
                ReadingClub.id,
                ReadingClub.name,
                member_count_sq.label("member_count"),
                Book.title.label("current_book_title"),
            )
            .outerjoin(Book, Book.id == ReadingClub.book_id)
            .where(ReadingClub.is_public.is_(True))
            .where(ReadingClub.name.ilike(f"%{query}%"))
            .order_by(sa.desc(member_count_sq), ReadingClub.name)
            .limit(limit)
        )
        rows = await self._session.execute(stmt)
        return [
            ClubSearchItem(
                id=row.id,
                name=row.name,
                member_count=row.member_count or 0,
                current_book_title=row.current_book_title,
            )
            for row in rows.all()
        ]

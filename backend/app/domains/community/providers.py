"""FastAPI dependency factories for the community domain."""

from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import Depends
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.auth.repository import UserRepository
from app.domains.book.models import Book, UserBook
from app.domains.challenge.repository import ChallengeRepository
from app.domains.community.ports import (
    BadgeSummary,
    GradeStats,
    HighlightSummary,
)
from app.domains.community.repository import CommunityRepository
from app.domains.community.service import CommunityService
from app.domains.feed.adapters.r2_image_storage_adapter import R2ImageStorageAdapter
from app.domains.feed.models import PostHighlight
from app.domains.feed.ports import ImageStoragePort
from app.domains.feed.repository import PostRepository, ReactionRepository
from app.domains.reading.repository import UserGradeRepository


class _ProfileReadingQueryAdapter:
    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get_grade_stats(self, user_id: UUID) -> GradeStats | None:
        row = await UserGradeRepository(self._session).get_or_init(user_id)
        return GradeStats(
            grade=row.grade,
            tier=row.tier,
            total_books=row.total_books,
            total_seconds=row.total_seconds,
            streak_days=row.streak_days,
        )


class _ProfileChallengeQueryAdapter:
    def __init__(self, session: AsyncSession, image_storage: ImageStoragePort) -> None:
        self._session = session
        self._image_storage = image_storage

    async def get_user_badges(self, user_id: UUID, limit: int) -> list[BadgeSummary]:
        pairs = await ChallengeRepository(self._session).my_badges(user_id)
        results: list[BadgeSummary] = []
        for badge, user_badge in pairs[:limit]:
            icon_url = await self._image_storage.public_url(badge.icon_key)
            results.append(
                BadgeSummary(
                    id=badge.id,
                    name=badge.name,
                    icon_url=icon_url,
                    category=badge.category,
                    earned_at=user_badge.earned_at,
                )
            )
        return results


class _ProfileHighlightQueryAdapter:
    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get_recent_highlights(self, user_id: UUID, limit: int) -> list[HighlightSummary]:
        stmt = (
            select(
                PostHighlight.id,
                PostHighlight.quote_text,
                PostHighlight.created_at,
                Book.title.label("book_title"),
            )
            .join(UserBook, UserBook.id == PostHighlight.user_book_id)
            .join(Book, Book.id == UserBook.book_id)
            .where(
                PostHighlight.user_id == user_id,
            )
            .order_by(PostHighlight.created_at.desc())
            .limit(limit)
        )
        result = await self._session.execute(stmt)
        return [
            HighlightSummary(
                id=row.id,
                quote_text=row.quote_text,
                book_title=row.book_title,
                created_at=row.created_at,
            )
            for row in result
        ]


def get_community_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> CommunityService:
    return CommunityService(
        community_repo=CommunityRepository(session),
        post_repo=PostRepository(session),
        reactions=ReactionRepository(session),
        image_storage=R2ImageStorageAdapter(),
        user_repo=UserRepository(session),
        reading_query=_ProfileReadingQueryAdapter(session),
        challenge_query=_ProfileChallengeQueryAdapter(session, R2ImageStorageAdapter()),
        highlight_query=_ProfileHighlightQueryAdapter(session),
    )

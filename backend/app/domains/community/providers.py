"""FastAPI dependency factories for the community domain."""

from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import Depends
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.auth.repository import UserRepository
from app.domains.book.models import Book, UserBook, UserBookStatus
from app.domains.book.repository import UserBookRepository
from app.domains.challenge.repository import ChallengeRepository
from app.domains.club.repository import ClubRepository
from app.domains.community.ports import (
    ActivityAgendaItem,
    ActivityBookItem,
    ActivityClubItem,
    ActivityHighlightItem,
    ActivityReviewItem,
    BadgeSummary,
    GradeStats,
    HighlightSummary,
)
from app.domains.community.repository import CommunityRepository
from app.domains.community.service import CommunityService
from app.domains.feed.adapters.r2_image_storage_adapter import R2ImageStorageAdapter
from app.domains.feed.models import PostHighlight
from app.domains.feed.ports import ImageStoragePort
from app.domains.feed.repository import HighlightRepository, PostRepository, ReactionRepository
from app.domains.reading.repository import UserGradeRepository
from app.domains.review.repository import BookReviewRepository


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


class _ActivityReviewQueryAdapter:
    """Implements ``ActivityReviewQueryPort`` over the review domain's own
    repository (BC-80) — a same-process read, not a service reconstruction,
    so the summary avoids wiring the write-side feed-event machinery that
    ``ReviewService`` otherwise carries."""

    def __init__(self, session: AsyncSession) -> None:
        self._repo = BookReviewRepository(session)

    async def preview(self, user_id: UUID, limit: int) -> tuple[int, list[ActivityReviewItem]]:
        total = await self._repo.count_by_user(user_id)
        rows = await self._repo.list_by_user(user_id, limit=limit, offset=0)
        items = [
            ActivityReviewItem(
                id=row.review.id,
                book_id=row.review.book_id,
                book_title=row.book_title,
                book_cover_url=row.book_cover_url,
                rating=float(row.review.rating),
                body=row.review.body,
                created_at=row.review.created_at,
            )
            for row in rows
        ]
        return total, items


class _ActivityHighlightQueryAdapter:
    """Implements ``ActivityHighlightQueryPort`` over the feed domain's own
    highlight repository (BC-80)."""

    def __init__(self, session: AsyncSession) -> None:
        self._repo = HighlightRepository(session)

    async def preview(self, user_id: UUID, limit: int) -> tuple[int, list[ActivityHighlightItem]]:
        total = await self._repo.count_by_user(user_id)
        rows = await self._repo.list_recent_for_user(user_id, limit=limit, offset=0)
        items = [
            ActivityHighlightItem(
                id=row.highlight.id,
                book_id=row.book_id,
                book_title=row.book_title,
                book_cover_url=row.book_cover_url,
                quote_text=row.highlight.quote_text,
                created_at=row.highlight.created_at,
            )
            for row in rows
        ]
        return total, items


class _ActivityAgendaQueryAdapter:
    """Implements ``ActivityAgendaQueryPort`` over the club domain's own
    repository (BC-80)."""

    def __init__(self, session: AsyncSession) -> None:
        self._repo = ClubRepository(session)

    async def preview(self, user_id: UUID, limit: int) -> tuple[int, list[ActivityAgendaItem]]:
        total = await self._repo.count_agendas_by_author(user_id)
        rows = await self._repo.list_agendas_by_author(user_id, limit=limit, offset=0)
        items = [
            ActivityAgendaItem(
                id=row.agenda.id,
                club_id=row.club_id,
                club_name=row.club_name,
                session_id=row.agenda.session_id,
                session_title=row.session_title,
                status=row.agenda.status,
                published_at=row.agenda.published_at,
                created_at=row.agenda.created_at,
            )
            for row in rows
        ]
        return total, items


class _ActivityClubQueryAdapter:
    """Implements ``ActivityClubQueryPort`` over the club domain's own
    repository (BC-80). ``list_by_user`` is unpaginated (club counts per
    user are small) — the preview truncates in-memory to ``limit``."""

    def __init__(self, session: AsyncSession) -> None:
        self._repo = ClubRepository(session)

    async def preview(self, user_id: UUID, limit: int) -> tuple[int, list[ActivityClubItem]]:
        clubs = await self._repo.list_by_user(user_id)
        items = [
            ActivityClubItem(id=c.id, name=c.name, created_at=c.created_at) for c in clubs[:limit]
        ]
        return len(clubs), items


class _ActivityLibraryQueryAdapter:
    """Implements ``ActivityLibraryQueryPort`` over the book domain's own
    repository (BC-80) — filtered to ``status=reading`` ("읽는 중")."""

    def __init__(self, session: AsyncSession) -> None:
        self._repo = UserBookRepository(session)

    async def preview(self, user_id: UUID, limit: int) -> tuple[int, list[ActivityBookItem]]:
        total = await self._repo.count_for_user(user_id, status=UserBookStatus.READING)
        rows = await self._repo.list_for_user(
            user_id, status=UserBookStatus.READING, cursor=None, limit=limit
        )
        items = [
            ActivityBookItem(
                user_book_id=ub.id,
                book_id=ub.book_id,
                title=ub.book.title,
                cover_url=ub.book.cover_url,
                current_chapter=ub.current_chapter,
                started_at=ub.started_at,
            )
            for ub in rows
        ]
        return total, items


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
        activity_reviews=_ActivityReviewQueryAdapter(session),
        activity_highlights=_ActivityHighlightQueryAdapter(session),
        activity_agendas=_ActivityAgendaQueryAdapter(session),
        activity_clubs=_ActivityClubQueryAdapter(session),
        activity_library=_ActivityLibraryQueryAdapter(session),
    )

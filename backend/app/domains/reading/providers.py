"""FastAPI dependency factories for the reading domain.

Also hosts the cross-domain adapter that implements
``ReadingBookQueryPort`` on top of the book domain's ``UserBookRepository``.
Per CLAUDE.md §3.3 the reading service must not import a book
repository directly — the adapter here is the only seam.

Each request gets its own ``ReadingService`` bound to the request-scoped
``AsyncSession``; the ``EventBus`` is process-wide, constructed once and
reused so all requests share subscribers. The ``stage_event`` callable is
closed over the session so events get queued on that specific session's
info dict (see ``app.shared.event_bus.stage_event``).
"""

from __future__ import annotations

from datetime import UTC, date, datetime
from functools import lru_cache
from typing import Annotated
from uuid import UUID

from fastapi import Depends
from sqlalchemy import Date, and_, func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.book.models import Book, UserBook, UserBookStatus
from app.domains.reading.models import ReadingSession
from app.domains.reading.ports import DailySessionInfo
from app.domains.reading.repository import (
    BookmarkRepository,
    DailyStatRepository,
    GoalRepository,
    ReadingSessionRepository,
    ReadingStatsRepository,
    UserGradeRepository,
)
from app.domains.reading.service import ReadingService
from app.shared.event_bus import (
    EventBus,
    LocalEventBus,
    commit_and_publish,
    stage_event,
)


# Import deferred to break the potential circular import:
# reading.providers → feed.providers → reading.providers (get_event_bus).
# The function-level import below avoids the module-level cycle.
def _get_feed_service(session: AsyncSession) -> object:
    from app.domains.feed.providers import get_feed_service

    return get_feed_service(session)


def _get_taste_profile_service(session: AsyncSession) -> object:
    """Deferred import to avoid circular dependency with the discovery domain."""
    from app.domains.book.taste_profile_repository import TasteProfileRepository
    from app.domains.discovery.taste_profile_service import TasteProfileService

    return TasteProfileService(taste_profiles=TasteProfileRepository(session))


class BookQueryAdapter:
    """Implements ``ReadingBookQueryPort`` by reading the book domain's
    UserBook table directly.

    Defined here (not in the book domain) because the reading domain is
    the consumer that owns the port definition. This adapter is the only
    code allowed to cross the domain boundary — and it's a read-only
    query, not a mutation, which keeps §3.3 intact.
    """

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def user_book_belongs_to_user(
        self,
        *,
        user_id: UUID,
        user_book_id: UUID,
    ) -> bool:
        ub = await self._session.get(UserBook, user_book_id)
        return ub is not None and ub.user_id == user_id

    async def count_completed_books(
        self,
        *,
        user_id: UUID,
        from_date: date | None = None,
        to_date: date | None = None,
    ) -> int:
        conditions = [
            UserBook.user_id == user_id,
            UserBook.status == UserBookStatus.COMPLETED,
        ]
        if from_date is not None:
            conditions.append(UserBook.finished_at >= from_date)
        if to_date is not None:
            # Interpret to_date inclusive — add one day to the filter so
            # a row finished at 23:59 still counts.
            from datetime import timedelta

            conditions.append(UserBook.finished_at < to_date + timedelta(days=1))
        stmt = select(func.count(UserBook.id)).where(and_(*conditions))
        result = await self._session.execute(stmt)
        count = result.scalar_one()
        return int(count or 0)

    async def get_daily_sessions_with_book_info(
        self,
        *,
        user_id: UUID,
        target_date: date,
    ) -> list[DailySessionInfo]:
        # Cast ended_at to date server-side to match the target_date filter
        # without pulling every session row into Python.
        stmt = (
            select(
                ReadingSession.id,
                ReadingSession.started_at,
                ReadingSession.ended_at,
                ReadingSession.duration_sec,
                ReadingSession.source,
                Book.id.label("book_id"),
                Book.title.label("book_title"),
                Book.author.label("book_author"),
                Book.cover_url.label("book_cover_url"),
            )
            .join(UserBook, ReadingSession.user_book_id == UserBook.id)
            .join(Book, UserBook.book_id == Book.id)
            .where(
                and_(
                    ReadingSession.user_id == user_id,
                    ReadingSession.ended_at.is_not(None),
                    func.cast(ReadingSession.ended_at, Date) == target_date,
                )
            )
            .order_by(ReadingSession.started_at.asc())
        )
        rows = (await self._session.execute(stmt)).all()
        return [
            DailySessionInfo(
                session_id=row.id,
                started_at=row.started_at,
                ended_at=row.ended_at,
                duration_sec=row.duration_sec,
                source=row.source.value if hasattr(row.source, "value") else row.source,
                book_id=row.book_id,
                book_title=row.book_title,
                book_author=row.book_author,
                book_cover_url=row.book_cover_url,
            )
            for row in rows
        ]


class SubscriptionQueryAdapter:
    """Implements ``SubscriptionQueryPort`` by reading the user's Pro columns.

    Wraps the subscription domain's repository (read-only) so the reading
    service never imports it directly (CLAUDE.md §3.3). A stored Pro flag
    whose period has lapsed is treated as non-Pro; the lazy write-back of the
    expired state stays in the subscription service's own ``get_status``.
    """

    def __init__(self, session: AsyncSession) -> None:
        from app.domains.subscription.repository import SubscriptionRepository

        self._repo = SubscriptionRepository(session)

    async def is_pro(self, user_id: UUID) -> bool:
        row = await self._repo.get_subscription_status(user_id)
        is_pro = bool(row["is_pro"])
        expires_at = row["pro_expires_at"]
        if is_pro and isinstance(expires_at, datetime) and expires_at < datetime.now(tz=UTC):
            return False
        return is_pro


@lru_cache(maxsize=1)
def get_event_bus() -> EventBus:
    """Process-wide singleton event bus.

    M6 can swap this for a Redis-backed implementation when the service
    runs across multiple Fly machines; the service layer keeps working
    because it depends only on the Protocol.
    """
    return LocalEventBus()


def get_reading_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> ReadingService:
    """Construct a request-scoped ReadingService.

    ``stage_event`` is a closure over ``session`` so events land on the
    correct queue; ``commit_and_publish`` attaches the after_commit hook
    for THIS session so the events delivered by this request's bus fire
    only if the request's transaction actually commits.
    """
    bus = get_event_bus()

    def _stage(event: object) -> None:
        stage_event(session, event)

    # Register the after_commit/rollback hook once per request so events
    # staged during this request are drained onto the bus on success or
    # discarded on rollback. Safe to call on every request because each
    # listener is ``once=True`` — no leak.
    commit_and_publish(session, bus)

    return ReadingService(
        sessions=ReadingSessionRepository(session),
        daily_stats=DailyStatRepository(session),
        user_grades=UserGradeRepository(session),
        goals=GoalRepository(session),
        book_query=BookQueryAdapter(session),
        bus=bus,
        stage_event=_stage,
        bookmark_repo=BookmarkRepository(session),
        stats_repo=ReadingStatsRepository(session),
        feed_service=_get_feed_service(session),  # type: ignore[arg-type]
        taste_profile_service=_get_taste_profile_service(session),  # type: ignore[arg-type]
        subscription_query=SubscriptionQueryAdapter(session),
    )

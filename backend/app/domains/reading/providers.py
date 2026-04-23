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

from datetime import date
from functools import lru_cache
from typing import Annotated
from uuid import UUID

from fastapi import Depends
from sqlalchemy import and_, func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.book.models import UserBook, UserBookStatus
from app.domains.reading.repository import (
    DailyStatRepository,
    GoalRepository,
    ReadingSessionRepository,
    UserGradeRepository,
)
from app.domains.reading.service import ReadingService
from app.shared.event_bus import (
    EventBus,
    LocalEventBus,
    commit_and_publish,
    stage_event,
)


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
    )

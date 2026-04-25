"""FastAPI dependency factories for the notification domain.

Cross-domain query adapters are implemented here (not in the reading or auth
domains) because the notification domain is the consumer that owns the port
definitions (CLAUDE.md §3.2 / §3.3). Each adapter is read-only and crosses
the domain boundary only through SQL queries — no service calls.
"""

from __future__ import annotations

from datetime import date
from functools import lru_cache
from typing import Annotated
from uuid import UUID

from apscheduler.schedulers.asyncio import AsyncIOScheduler
from fastapi import Depends
from sqlalchemy import and_, func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import get_settings
from app.core.db import get_session, get_sessionmaker
from app.domains.auth.models import DeviceToken, User
from app.domains.notification.adapters.fcm_push_adapter import FcmPushAdapter
from app.domains.notification.adapters.null_push_adapter import NullPushAdapter
from app.domains.notification.ports import PushPort
from app.domains.notification.repository import NotificationRepository, WeeklyReportRepository
from app.domains.notification.service import NotificationService
from app.domains.notification.service_router import NotificationRouterService
from app.domains.reading.models import DailyReadingStat, ReadingSession, ReadingSessionSource

# ---------------------------------------------------------------------------
# Cross-domain query adapters
# ---------------------------------------------------------------------------


class _DeviceTokenQueryAdapter:
    """Reads FCM tokens from the auth domain's device_tokens table."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get_active_tokens(self, user_id: UUID) -> list[str]:
        stmt = select(DeviceToken.token).where(DeviceToken.user_id == user_id)
        result = await self._session.execute(stmt)
        return list(result.scalars().all())


class _ActiveUserQueryAdapter:
    """Returns non-deleted user IDs from the auth domain's users table."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get_all_active_user_ids(self) -> list[UUID]:
        stmt = select(User.id).where(User.deleted_at.is_(None))
        result = await self._session.execute(stmt)
        return list(result.scalars().all())


class _DailyStatQueryAdapter:
    """Reads daily reading totals from the reading domain's stats table."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get_stats_for_week(
        self, user_id: UUID, week_start: date, week_end: date
    ) -> list[tuple[date, int]]:
        stmt = (
            select(DailyReadingStat.date, DailyReadingStat.total_seconds)
            .where(
                and_(
                    DailyReadingStat.user_id == user_id,
                    DailyReadingStat.date >= week_start,
                    DailyReadingStat.date <= week_end,
                )
            )
            .order_by(DailyReadingStat.date.asc())
        )
        result = await self._session.execute(stmt)
        return [(row.date, row.total_seconds) for row in result.all()]


class _SessionQueryAdapter:
    """Reads reading session data from the reading domain."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get_longest_in_range(self, user_id: UUID, from_date: date, to_date: date) -> int:
        # Only timer sessions count toward stats (CLAUDE.md design §reading).
        stmt = select(func.max(ReadingSession.duration_sec)).where(
            and_(
                ReadingSession.user_id == user_id,
                ReadingSession.source == ReadingSessionSource.TIMER,
                ReadingSession.ended_at.isnot(None),
                func.date(ReadingSession.started_at) >= from_date,
                func.date(ReadingSession.started_at) <= to_date,
            )
        )
        result = await self._session.execute(stmt)
        value = result.scalar_one_or_none()
        return int(value) if value is not None else 0


# ---------------------------------------------------------------------------
# Push port factory
# ---------------------------------------------------------------------------


@lru_cache(maxsize=1)
def get_push_port() -> PushPort:
    """Return NullPushAdapter in dev/test; FcmPushAdapter when credentials present."""
    settings = get_settings()
    if not settings.firebase_credentials_json:
        return NullPushAdapter()
    return FcmPushAdapter(settings.firebase_credentials_json, settings.firebase_project_id)


# ---------------------------------------------------------------------------
# NotificationService (event handler + batch — uses its own sessions)
# ---------------------------------------------------------------------------


def get_notification_service() -> NotificationService:
    """Build the process-wide NotificationService.

    Uses process-wide sessionmaker so event handlers (which run after the
    originating request's session is closed) can open fresh sessions.
    Cross-domain adapters are wired with a transient session opened inside
    the batch loop; for live event handlers, adapters receive the per-event
    session via NotificationService internals.
    """
    # Adapters for cross-domain queries that the batch job uses.
    # For event-handler paths, the adapters are created inside each handler
    # using the per-event session (via NotificationService._get_tokens etc.).
    # Here we pass process-wide adapters that open their own sessions; this is
    # safe because the batch runs outside request context.
    sessionmaker = get_sessionmaker()

    # Build stub adapters that open sessions on demand for the batch job.
    # Event handler cross-domain reads go directly through the handler's session.
    class _BatchDeviceTokenAdapter:
        async def get_active_tokens(self, user_id: UUID) -> list[str]:
            async with sessionmaker() as s:
                stmt = select(DeviceToken.token).where(DeviceToken.user_id == user_id)
                result = await s.execute(stmt)
                return list(result.scalars().all())

    class _BatchActiveUserAdapter:
        async def get_all_active_user_ids(self) -> list[UUID]:
            async with sessionmaker() as s:
                stmt = select(User.id).where(User.deleted_at.is_(None))
                result = await s.execute(stmt)
                return list(result.scalars().all())

    class _BatchDailyStatAdapter:
        async def get_stats_for_week(
            self, user_id: UUID, week_start: date, week_end: date
        ) -> list[tuple[date, int]]:
            async with sessionmaker() as s:
                stmt = (
                    select(DailyReadingStat.date, DailyReadingStat.total_seconds)
                    .where(
                        and_(
                            DailyReadingStat.user_id == user_id,
                            DailyReadingStat.date >= week_start,
                            DailyReadingStat.date <= week_end,
                        )
                    )
                    .order_by(DailyReadingStat.date.asc())
                )
                result = await s.execute(stmt)
                return [(row.date, row.total_seconds) for row in result.all()]

    class _BatchSessionAdapter:
        async def get_longest_in_range(self, user_id: UUID, from_date: date, to_date: date) -> int:
            async with sessionmaker() as s:
                stmt = select(func.max(ReadingSession.duration_sec)).where(
                    and_(
                        ReadingSession.user_id == user_id,
                        ReadingSession.source == ReadingSessionSource.TIMER,
                        ReadingSession.ended_at.isnot(None),
                        func.date(ReadingSession.started_at) >= from_date,
                        func.date(ReadingSession.started_at) <= to_date,
                    )
                )
                result = await s.execute(stmt)
                value = result.scalar_one_or_none()
                return int(value) if value is not None else 0

    return NotificationService(
        sessionmaker=sessionmaker,
        push=get_push_port(),
        device_tokens=_BatchDeviceTokenAdapter(),
        daily_stats=_BatchDailyStatAdapter(),
        session_query=_BatchSessionAdapter(),
        active_users=_BatchActiveUserAdapter(),
    )


# ---------------------------------------------------------------------------
# NotificationRouterService (router read path — uses request-scoped session)
# ---------------------------------------------------------------------------


def get_notification_router_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> NotificationRouterService:
    """Router-facing service: list, mark-read, unread-count, weekly report."""
    return NotificationRouterService(
        notifications=NotificationRepository(session),
        weekly_reports=WeeklyReportRepository(session),
    )


# ---------------------------------------------------------------------------
# APScheduler factory
# ---------------------------------------------------------------------------


def create_scheduler(notification_svc: NotificationService) -> AsyncIOScheduler:
    """Build an AsyncIOScheduler with the weekly report batch job."""
    scheduler = AsyncIOScheduler(timezone="Asia/Seoul")
    scheduler.add_job(
        notification_svc.run_weekly_report_batch,
        "cron",
        day_of_week="sun",
        hour=21,
        minute=0,
        id="weekly_report",
    )
    return scheduler

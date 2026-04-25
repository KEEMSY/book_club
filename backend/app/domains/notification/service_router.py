"""Read-path service for the notification domain — router use only.

``NotificationRouterService`` handles queries that originate from HTTP
requests and share the request-scoped session. This is intentionally separate
from ``NotificationService`` (event handler + batch) which opens its own
sessions because it runs outside the request lifecycle.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import date, datetime
from uuid import UUID

from app.domains.notification.models import Notification, WeeklyReport
from app.domains.notification.repository import NotificationRepository, WeeklyReportRepository


@dataclass(slots=True)
class NotificationRouterService:
    """Read/mark-read operations for the notification inbox (router-facing)."""

    notifications: NotificationRepository
    weekly_reports: WeeklyReportRepository

    async def list_notifications(
        self,
        user_id: UUID,
        *,
        cursor_dt: datetime | None,
        limit: int,
    ) -> tuple[list[Notification], str | None, int]:
        items = await self.notifications.list_for_user(user_id, cursor_dt, limit)
        next_cursor: str | None = None
        if len(items) == limit:
            next_cursor = items[-1].created_at.isoformat()
        unread = await self.notifications.unread_count(user_id)
        return items, next_cursor, unread

    async def mark_read(self, notification_id: UUID, *, user_id: UUID) -> None:
        await self.notifications.mark_read(notification_id, user_id)

    async def unread_count(self, user_id: UUID) -> int:
        return await self.notifications.unread_count(user_id)

    async def get_weekly_report(
        self, user_id: UUID, *, week_start: date | None
    ) -> WeeklyReport | None:
        if week_start is None:
            # Return the most recent report when no week is specified.
            return await self._get_latest_report(user_id)
        return await self.weekly_reports.get_for_user_and_week(user_id, week_start)

    async def _get_latest_report(self, user_id: UUID) -> WeeklyReport | None:
        from sqlalchemy import select

        # Direct session access via repository internals is intentional here:
        # WeeklyReportRepository owns the session, and this is a read-only query
        # that doesn't belong in the port (single-implementation path).
        stmt = (
            select(WeeklyReport)
            .where(WeeklyReport.user_id == user_id)
            .order_by(WeeklyReport.week_start.desc())
            .limit(1)
        )
        result = await self.weekly_reports._session.execute(stmt)
        return result.scalar_one_or_none()

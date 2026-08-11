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

from app.domains.notification.models import (
    TOGGLEABLE_NOTIFICATION_TYPES,
    Notification,
    WeeklyReport,
)
from app.domains.notification.repository import (
    NotificationPreferenceRepository,
    NotificationRepository,
    WeeklyReportRepository,
)

_TOGGLEABLE_KEYS = frozenset(t.value for t in TOGGLEABLE_NOTIFICATION_TYPES)


@dataclass(slots=True)
class NotificationRouterService:
    """Read/mark-read operations for the notification inbox (router-facing)."""

    notifications: NotificationRepository
    weekly_reports: WeeklyReportRepository
    preferences: NotificationPreferenceRepository

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

    async def mark_read_all(self, user_id: UUID) -> None:
        """Mark every unread notification as read for *user_id*."""
        await self.notifications.mark_read_all(user_id)

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

    async def get_notification_preferences(self, user_id: UUID) -> dict[str, bool]:
        """Return every toggleable type's on/off state, defaulting unset ones to on."""
        overrides = await self.preferences.get_overrides(user_id)
        return _merge_with_defaults(overrides)

    async def update_notification_preferences(
        self, user_id: UUID, updates: dict[str, bool]
    ) -> dict[str, bool]:
        """Partially update the reader's preferences and return the merged state.

        Unknown keys (typos, a required type, a not-yet-toggleable future type)
        are silently dropped rather than rejected — this keeps the endpoint
        forward-compatible with older/newer mobile clients (mirrors the
        lenient cursor parsing in ``router.py``).
        """
        filtered = {k: v for k, v in updates.items() if k in _TOGGLEABLE_KEYS}
        stored = await self.preferences.get_overrides(user_id)
        merged_overrides = {**stored, **filtered}
        saved = await self.preferences.upsert_overrides(user_id, merged_overrides)
        return _merge_with_defaults(saved)


def _merge_with_defaults(overrides: dict[str, bool]) -> dict[str, bool]:
    """Every toggleable type, defaulting to on unless explicitly overridden."""
    return {t.value: overrides.get(t.value, True) for t in TOGGLEABLE_NOTIFICATION_TYPES}

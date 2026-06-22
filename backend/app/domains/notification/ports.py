"""Port Protocols for the notification domain (CLAUDE.md §3.2).

PushPort and DeviceTokenQueryPort are external-boundary ports with multiple
concrete implementations (NullPushAdapter for dev, FcmPushAdapter for prod).
Repository ports follow the single-implementation pattern to avoid over-engineering.
"""

from __future__ import annotations

from datetime import date, datetime
from typing import Protocol
from uuid import UUID

from app.domains.notification.models import Notification, WeeklyReport


class PushPort(Protocol):
    """Delivery mechanism for FCM push notifications."""

    async def send_to_tokens(
        self,
        tokens: list[str],
        title: str,
        body: str,
        data: dict[str, str],
    ) -> None: ...


class NotificationRepositoryPort(Protocol):
    """Persistence port for in-app notification rows."""

    async def create(
        self,
        *,
        user_id: UUID,
        ntype: str,
        title: str,
        body: str,
        data: dict[str, str],
    ) -> Notification: ...

    async def list_for_user(
        self,
        user_id: UUID,
        cursor_dt: datetime | None,
        limit: int,
    ) -> list[Notification]: ...

    async def mark_read(self, notification_id: UUID, user_id: UUID) -> None: ...

    async def unread_count(self, user_id: UUID) -> int: ...


class WeeklyReportRepositoryPort(Protocol):
    """Persistence port for weekly reading report rows."""

    async def upsert(
        self,
        *,
        user_id: UUID,
        week_start: date,
        total_seconds: int,
        session_count: int,
        best_day: date | None,
        longest_session_sec: int,
    ) -> WeeklyReport: ...

    async def get_for_user_and_week(
        self, user_id: UUID, week_start: date
    ) -> WeeklyReport | None: ...

    async def mark_push_sent(self, report_id: UUID, sent_at: datetime) -> None: ...


class DeviceTokenQueryPort(Protocol):
    """Cross-domain query: FCM tokens for a given user."""

    async def get_active_tokens(self, user_id: UUID) -> list[str]: ...


class DailyStatQueryPort(Protocol):
    """Cross-domain query: daily reading seconds within a date range."""

    async def get_stats_for_week(
        self, user_id: UUID, week_start: date, week_end: date
    ) -> list[tuple[date, int]]: ...

    # Returns (date, total_seconds) for days with any reading activity.


class SessionQueryPort(Protocol):
    """Cross-domain query: longest single session within a date range."""

    async def get_longest_in_range(self, user_id: UUID, from_date: date, to_date: date) -> int: ...

    # Returns max duration_sec; 0 if no sessions found.


class ActiveUserQueryPort(Protocol):
    """Cross-domain query: users eligible to receive weekly reports."""

    async def get_all_active_user_ids(self) -> list[UUID]: ...

    # Excludes soft-deleted accounts.


class TrialExpiryQueryPort(Protocol):
    """Cross-domain query: users whose Pro trial ends within a horizon."""

    async def get_users_with_trial_ending_within(
        self, hours: int
    ) -> list[tuple[UUID, datetime]]: ...

    # Returns (user_id, trial_ends_at) for non-deleted, non-Pro users whose
    # trial_ends_at falls between now and now + ``hours``. Excludes users who
    # already converted to Pro.


class LapsedTrialQueryPort(Protocol):
    """Cross-domain query: users whose trial lapsed ~N days ago without converting."""

    async def get_users_with_trial_expired_around(self, days_ago: int) -> list[UUID]: ...

    # Returns user ids of non-deleted, non-Pro users whose trial_ends_at fell in
    # the one-day window ending ``days_ago`` days before now (the D+7 cohort).


class CouponIssuePort(Protocol):
    """Cross-domain write: issue a re-engagement discount coupon.

    Implemented over the subscription domain's coupon repository. Idempotent —
    re-issuing an existing code is a no-op so a daily batch never duplicates.
    """

    async def issue_coupon(self, *, code: str, discount_pct: int, valid_days: int) -> None: ...

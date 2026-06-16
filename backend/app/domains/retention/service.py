"""Retention domain service — re-engagement campaigns and streak recovery.

Business rules:
- ``run_reengagement_campaign`` fans out 'day7_inactive' pushes to users who
  have not been active for ≥ 7 days, skipping anyone who already received the
  push today. Capped at 1 000 users per run. Returns the count of pushes sent.
- ``recover_streak`` lets a user recover 1 streak day. Monthly cap is 2
  recoveries per rolling 30-day window. On success streak_days is incremented
  in the user_grades snapshot via the ``UserGradeRepositoryPort`` and a log
  row is persisted. Returns recovered_days and recoveries_remaining.

Depends only on ``RetentionRepository``, ``NotificationService``, and a narrow
``UserGradeRepositoryPort`` — no direct DB access (CLAUDE.md §3.1).
"""

from __future__ import annotations

import logging
from dataclasses import dataclass
from uuid import UUID

from app.core.exceptions import ConflictError
from app.domains.retention.repository import RetentionRepository

logger = logging.getLogger(__name__)

# Maximum recoveries allowed within a rolling 30-day window.
_RECOVERY_MONTHLY_LIMIT = 2


@dataclass(slots=True)
class RetentionService:
    """Orchestrates retention use cases."""

    repo: RetentionRepository
    # Narrow cross-domain port — only the grade-snapshot mutation is needed.
    user_grades: object  # UserGradeRepositoryPort (runtime duck-typed)
    # Notification service for push delivery.
    notification_service: object  # NotificationService (runtime duck-typed)

    async def run_reengagement_campaign(self) -> int:
        """Dispatch 'day7_inactive' pushes and return the number of pushes sent.

        For each eligible user the flow is:
        1. Skip if a push of the same type was already sent today.
        2. Attempt FCM push via NotificationService.send_push_to_user.
        3. Persist the log so subsequent runs skip the user for today.
        Errors for individual users are swallowed so a single bad token or
        transient FCM error does not abort the whole batch.
        """
        inactive_users = await self.repo.get_inactive_users(inactive_days=7, limit=1000)
        push_type = "day7_inactive"
        sent = 0

        for user in inactive_users:
            try:
                already_sent = await self.repo.has_push_today(user.id, push_type)
                if already_sent:
                    continue

                await self.notification_service.send_reengagement_push(  # type: ignore[attr-defined]
                    user_id=user.id,
                    push_type=push_type,
                )
                await self.repo.log_push(user.id, push_type)
                sent += 1
            except Exception:
                logger.exception(
                    "reengagement_campaign_user_failed user_id=%s", user.id
                )

        logger.info("reengagement_campaign_finished sent=%d", sent)
        return sent

    async def recover_streak(self, user_id: UUID) -> dict[str, int]:
        """Increment the user's streak by 1, subject to the monthly cap.

        Raises:
            ConflictError: if the user has already used all 2 recoveries this month.

        Returns:
            {"recovered_days": 1, "recoveries_remaining": N}
        """
        used = await self.repo.count_recoveries_last_30_days(user_id)
        if used >= _RECOVERY_MONTHLY_LIMIT:
            raise ConflictError(
                "streak recovery limit reached (2 per 30 days)",
                code="STREAK_RECOVERY_LIMIT",
            )

        # Increment streak_days by 1 via the repository port.
        grade = await self.user_grades.get_or_init(user_id)  # type: ignore[attr-defined]
        await self.user_grades.update_snapshot(  # type: ignore[attr-defined]
            user_id,
            streak_days=grade.streak_days + 1,
        )

        await self.repo.log_recovery(user_id, days=1)

        recoveries_remaining = _RECOVERY_MONTHLY_LIMIT - (used + 1)
        return {"recovered_days": 1, "recoveries_remaining": recoveries_remaining}

    async def get_recovery_status(self, user_id: UUID) -> dict[str, int]:
        """Return the number of recoveries used and remaining this month."""
        used = await self.repo.count_recoveries_last_30_days(user_id)
        remaining = max(0, _RECOVERY_MONTHLY_LIMIT - used)
        return {"recoveries_used": used, "recoveries_remaining": remaining}

    async def get_campaign_stats(self) -> dict[str, int]:
        """Return basic retention stats for the admin dashboard.

        Queries are intentionally simple aggregates — a dedicated analytics
        pipeline should own heavy reporting (CLAUDE.md §8.1).
        """
        from datetime import UTC, datetime, timedelta

        from sqlalchemy import and_, func, select

        from app.domains.auth.models import User
        from app.domains.retention.models import ReengagementPushLog, StreakRecoveryLog

        session = self.repo._session  # same-layer access within domain

        # Total pushes sent in the last 7 days.
        since_7d = datetime.now(tz=UTC) - timedelta(days=7)
        push_count_stmt = select(func.count(ReengagementPushLog.id)).where(
            ReengagementPushLog.sent_at >= since_7d
        )
        push_count_result = await session.execute(push_count_stmt)
        pushes_last_7d = int(push_count_result.scalar_one() or 0)

        # Total streak recoveries in the last 30 days.
        since_30d = datetime.now(tz=UTC) - timedelta(days=30)
        recovery_count_stmt = select(func.count(StreakRecoveryLog.id)).where(
            StreakRecoveryLog.recovered_at >= since_30d
        )
        recovery_count_result = await session.execute(recovery_count_stmt)
        recoveries_last_30d = int(recovery_count_result.scalar_one() or 0)

        # 7-day inactive user count.
        cutoff_7d = datetime.now(tz=UTC) - timedelta(days=7)
        inactive_stmt = select(func.count(User.id)).where(
            and_(
                User.deleted_at.is_(None),
                User.last_active_at.isnot(None),
                User.last_active_at < cutoff_7d,
            )
        )
        inactive_result = await session.execute(inactive_stmt)
        inactive_7d_count = int(inactive_result.scalar_one() or 0)

        return {
            "pushes_sent_last_7d": pushes_last_7d,
            "streak_recoveries_last_30d": recoveries_last_30d,
            "inactive_users_7d": inactive_7d_count,
        }

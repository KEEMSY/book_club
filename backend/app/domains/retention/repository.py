"""SQLAlchemy async repository for the retention domain.

Follows the single-responsibility rule from CLAUDE.md §3.1 — only DB queries,
no business logic. The service layer owns the rules (e.g. recovery limits).
"""

from __future__ import annotations

import logging
from datetime import UTC, datetime, timedelta
from uuid import UUID

from sqlalchemy import and_, func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.domains.auth.models import User
from app.domains.retention.models import ReengagementPushLog, StreakRecoveryLog

logger = logging.getLogger(__name__)


class RetentionRepository:
    """Persistence operations for re-engagement and streak-recovery tracking."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get_inactive_users(
        self, inactive_days: int = 7, limit: int = 1000
    ) -> list[User]:
        """Return active users whose last_active_at is older than inactive_days.

        Excludes soft-deleted accounts. Results are ordered oldest-active-first
        so the most dormant users get prioritised when the batch is capped.
        """
        cutoff = datetime.now(tz=UTC) - timedelta(days=inactive_days)
        stmt = (
            select(User)
            .where(
                and_(
                    User.deleted_at.is_(None),
                    User.last_active_at.isnot(None),
                    User.last_active_at < cutoff,
                )
            )
            .order_by(User.last_active_at.asc())
            .limit(limit)
        )
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

    async def has_push_today(self, user_id: UUID, push_type: str) -> bool:
        """Return True if the user already received this push_type today (UTC date)."""
        today_start = datetime.now(tz=UTC).replace(hour=0, minute=0, second=0, microsecond=0)
        tomorrow_start = today_start + timedelta(days=1)
        stmt = select(ReengagementPushLog.id).where(
            and_(
                ReengagementPushLog.user_id == user_id,
                ReengagementPushLog.push_type == push_type,
                ReengagementPushLog.sent_at >= today_start,
                ReengagementPushLog.sent_at < tomorrow_start,
            )
        )
        result = await self._session.execute(stmt)
        return result.first() is not None

    async def log_push(self, user_id: UUID, push_type: str) -> ReengagementPushLog:
        """Persist a re-engagement push record and return the new row."""
        row = ReengagementPushLog(user_id=user_id, push_type=push_type)
        self._session.add(row)
        await self._session.flush()
        await self._session.refresh(row)
        return row

    async def count_recoveries_last_30_days(self, user_id: UUID) -> int:
        """Return the number of streak recovery events in the last 30 days."""
        since = datetime.now(tz=UTC) - timedelta(days=30)
        stmt = select(func.count(StreakRecoveryLog.id)).where(
            and_(
                StreakRecoveryLog.user_id == user_id,
                StreakRecoveryLog.recovered_at >= since,
            )
        )
        result = await self._session.execute(stmt)
        count = result.scalar_one()
        return int(count or 0)

    async def log_recovery(self, user_id: UUID, days: int) -> StreakRecoveryLog:
        """Persist a streak recovery record and return the new row."""
        row = StreakRecoveryLog(user_id=user_id, days_recovered=days)
        self._session.add(row)
        await self._session.flush()
        await self._session.refresh(row)
        return row

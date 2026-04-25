"""SQLAlchemy async implementations of the notification repository ports.

Design choices:
- ``NotificationRepository.list_for_user`` uses keyset pagination on
  ``created_at`` DESC so the client can page through the inbox without
  offset skew as new rows arrive.
- ``mark_read`` is a conditional UPDATE — a double-read is idempotent by
  design so we only set ``read_at`` when it is currently NULL.
- ``WeeklyReportRepository.upsert`` uses Postgres INSERT ... ON CONFLICT
  DO UPDATE so the Sunday batch job can safely re-run after failure.
"""

from __future__ import annotations

from datetime import UTC, date, datetime
from uuid import UUID

from sqlalchemy import func, select, update
from sqlalchemy.dialects.postgresql import insert as pg_insert
from sqlalchemy.ext.asyncio import AsyncSession

from app.domains.notification.models import Notification, WeeklyReport


class NotificationRepository:
    """Persistence adapter for :class:`Notification`."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def create(
        self,
        *,
        user_id: UUID,
        ntype: str,
        title: str,
        body: str,
        data: dict[str, str],
    ) -> Notification:
        row = Notification(
            user_id=user_id,
            ntype=ntype,
            title=title,
            body=body,
            data=data,
        )
        self._session.add(row)
        await self._session.flush()
        await self._session.refresh(row)
        return row

    async def list_for_user(
        self,
        user_id: UUID,
        cursor_dt: datetime | None,
        limit: int,
    ) -> list[Notification]:
        stmt = select(Notification).where(Notification.user_id == user_id)
        if cursor_dt is not None:
            stmt = stmt.where(Notification.created_at < cursor_dt)
        stmt = stmt.order_by(Notification.created_at.desc()).limit(limit)
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

    async def mark_read(self, notification_id: UUID, user_id: UUID) -> None:
        # Conditional update: only stamp read_at when it is currently NULL so
        # the first-read timestamp is preserved on repeated calls.
        stmt = (
            update(Notification)
            .where(
                Notification.id == notification_id,
                Notification.user_id == user_id,
                Notification.read_at.is_(None),
            )
            .values(read_at=datetime.now(tz=UTC))
        )
        await self._session.execute(stmt)
        await self._session.flush()

    async def unread_count(self, user_id: UUID) -> int:
        stmt = select(func.count(Notification.id)).where(
            Notification.user_id == user_id,
            Notification.read_at.is_(None),
        )
        result = await self._session.execute(stmt)
        count = result.scalar_one()
        return int(count or 0)


class WeeklyReportRepository:
    """Persistence adapter for :class:`WeeklyReport`."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def upsert(
        self,
        *,
        user_id: UUID,
        week_start: date,
        total_seconds: int,
        session_count: int,
        best_day: date | None,
        longest_session_sec: int,
    ) -> WeeklyReport:
        stmt = (
            pg_insert(WeeklyReport)
            .values(
                user_id=user_id,
                week_start=week_start,
                total_seconds=total_seconds,
                session_count=session_count,
                best_day=best_day,
                longest_session_sec=longest_session_sec,
            )
            .on_conflict_do_update(
                constraint="uq_weekly_reports_user_week",
                set_={
                    "total_seconds": total_seconds,
                    "session_count": session_count,
                    "best_day": best_day,
                    "longest_session_sec": longest_session_sec,
                },
            )
            .returning(WeeklyReport)
        )
        result = await self._session.execute(stmt)
        await self._session.flush()
        row = result.scalar_one()
        return row

    async def get_for_user_and_week(self, user_id: UUID, week_start: date) -> WeeklyReport | None:
        stmt = select(WeeklyReport).where(
            WeeklyReport.user_id == user_id,
            WeeklyReport.week_start == week_start,
        )
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()

    async def mark_push_sent(self, report_id: UUID, sent_at: datetime) -> None:
        stmt = update(WeeklyReport).where(WeeklyReport.id == report_id).values(push_sent_at=sent_at)
        await self._session.execute(stmt)
        await self._session.flush()

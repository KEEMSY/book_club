"""Notification domain service — event handlers and weekly report batch.

Event handlers (on_reaction_added, on_comment_added, on_grade_up) are called
from the EventBus after_commit callback, meaning the originating request's
session is already closed. Each handler therefore opens its own session via
the injected sessionmaker rather than sharing the caller's session.

``run_weekly_report_batch`` is invoked by APScheduler (Sunday 21:00 KST) and
builds WeeklyReport rows from the reading domain's DailyReadingStat table via
cross-domain query adapters wired in providers.py.
"""

from __future__ import annotations

import logging
from dataclasses import dataclass
from datetime import UTC, date, datetime, timedelta
from uuid import UUID

from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker

from app.domains.notification.models import Notification, NotificationType
from app.domains.notification.ports import (
    ActiveUserQueryPort,
    DailyStatQueryPort,
    DeviceTokenQueryPort,
    PushPort,
    SessionQueryPort,
)
from app.domains.notification.repository import NotificationRepository, WeeklyReportRepository
from app.domains.reading.events import UserGradeRecomputed

logger = logging.getLogger(__name__)

# Grade display names indexed by grade value (1-based, capped at 5).
_GRADE_NAMES = ["새싹", "새싹+", "초록이", "숲속이", "숲속이+"]


@dataclass(slots=True)
class NotificationService:
    """Handles push delivery and in-app notification persistence.

    ``sessionmaker`` is process-wide; each event handler opens a fresh session
    because the originating request session is committed and closed by the time
    the EventBus delivers the event.
    """

    sessionmaker: async_sessionmaker[AsyncSession]
    push: PushPort
    device_tokens: DeviceTokenQueryPort
    daily_stats: DailyStatQueryPort
    session_query: SessionQueryPort
    active_users: ActiveUserQueryPort

    async def on_reaction_added(self, event: object) -> None:
        """Create an in-app notification and push when a reaction is added.

        Self-reactions are skipped — the post author reacting to their own post
        should not generate a notification.
        """
        from app.domains.feed.events import ReactionAdded

        if not isinstance(event, ReactionAdded):
            return
        if event.reactor_id == event.post_author_id:
            return

        async with self.sessionmaker() as session:
            notif = await self._save_notification(
                session,
                user_id=event.post_author_id,
                ntype=NotificationType.REACTION,
                title="새 반응이 달렸어요",
                body="회원님의 글에 반응이 달렸습니다.",
                data={"post_id": str(event.post_id)},
            )
            tokens = await self.device_tokens.get_active_tokens(event.post_author_id)
            await session.commit()

        if tokens:
            await self.push.send_to_tokens(
                tokens, notif.title, notif.body, {"post_id": str(event.post_id)}
            )

    async def on_comment_added(self, event: object) -> None:
        """Notify the post author and the parent commenter when a comment lands.

        Fan-out deduplication: if both the post author and parent commenter are
        the same person, or the commenter is the recipient, they are skipped.
        Each recipient gets their own session to keep transactions independent.
        """
        from app.domains.feed.events import CommentAdded

        if not isinstance(event, CommentAdded):
            return

        to_notify: set[UUID] = set()
        if event.commenter_id != event.post_author_id:
            to_notify.add(event.post_author_id)
        if (
            event.parent_author_id is not None
            and event.parent_author_id != event.commenter_id
            and event.parent_author_id != event.post_author_id
        ):
            to_notify.add(event.parent_author_id)

        for uid in to_notify:
            await self._notify_comment_recipient(event, uid)

    async def _notify_comment_recipient(
        self,
        event: object,
        uid: UUID,
    ) -> None:
        from app.domains.feed.events import CommentAdded

        if not isinstance(event, CommentAdded):
            return

        async with self.sessionmaker() as session:
            notif = await self._save_notification(
                session,
                user_id=uid,
                ntype=NotificationType.COMMENT,
                title="새 댓글이 달렸어요",
                body="회원님의 글에 댓글이 달렸습니다.",
                data={
                    "post_id": str(event.post_id),
                    "comment_id": str(event.comment_id),
                },
            )
            tokens = await self.device_tokens.get_active_tokens(uid)
            await session.commit()

        if tokens:
            await self.push.send_to_tokens(
                tokens,
                notif.title,
                notif.body,
                {"comment_id": str(event.comment_id)},
            )

    async def on_grade_up(self, event: object) -> None:
        """Push a grade-up notification when the user crosses a grade boundary.

        Same-grade recomputations (no actual change) are silently ignored.
        """
        if not isinstance(event, UserGradeRecomputed):
            return
        if event.new_grade <= event.old_grade:
            return

        grade_name = _GRADE_NAMES[min(event.new_grade - 1, len(_GRADE_NAMES) - 1)]
        async with self.sessionmaker() as session:
            notif = await self._save_notification(
                session,
                user_id=event.user_id,
                ntype=NotificationType.GRADE_UP,
                title=f"등급 상승! {grade_name}이 됐어요",
                body=f"독서 실력이 향상되어 {grade_name} 등급에 도달했습니다.",
                data={"new_grade": str(event.new_grade)},
            )
            tokens = await self.device_tokens.get_active_tokens(event.user_id)
            await session.commit()

        if tokens:
            await self.push.send_to_tokens(
                tokens,
                notif.title,
                notif.body,
                {"grade": str(event.new_grade)},
            )

    async def run_weekly_report_batch(self) -> None:
        """Generate WeeklyReports for last week and push summaries.

        Called by APScheduler every Sunday 21:00 KST. Safe to re-run — the
        upsert constraint on (user_id, week_start) makes the operation idempotent.
        """
        today = date.today()
        days_since_monday = today.weekday()
        last_monday = today - timedelta(days=days_since_monday + 7)
        last_sunday = last_monday + timedelta(days=6)

        user_ids = await self.active_users.get_all_active_user_ids()
        logger.info("weekly_report_batch started week=%s users=%d", last_monday, len(user_ids))

        for user_id in user_ids:
            try:
                await self._generate_report_for_user(user_id, last_monday, last_sunday)
            except Exception:
                logger.exception(
                    "weekly_report_batch_user_failed user_id=%s week=%s",
                    user_id,
                    last_monday,
                )

        logger.info("weekly_report_batch finished week=%s", last_monday)

    async def _generate_report_for_user(
        self, user_id: UUID, week_start: date, week_end: date
    ) -> None:
        stats = await self.daily_stats.get_stats_for_week(user_id, week_start, week_end)
        if not stats:
            return

        total_seconds = sum(s for _, s in stats)
        session_count = len(stats)
        best_day: date | None = max(stats, key=lambda x: x[1])[0] if stats else None
        longest = await self.session_query.get_longest_in_range(user_id, week_start, week_end)

        async with self.sessionmaker() as session:
            report_repo = WeeklyReportRepository(session)
            report = await report_repo.upsert(
                user_id=user_id,
                week_start=week_start,
                total_seconds=total_seconds,
                session_count=session_count,
                best_day=best_day,
                longest_session_sec=longest,
            )
            minutes = total_seconds // 60
            notif = await self._save_notification(
                session,
                user_id=user_id,
                ntype=NotificationType.WEEKLY_REPORT,
                title="이번 주 독서 리포트가 도착했어요",
                body=f"지난 한 주 동안 총 {minutes}분 독서했어요.",
                data={"week_start": str(week_start)},
            )
            tokens = await self.device_tokens.get_active_tokens(user_id)
            await report_repo.mark_push_sent(report.id, datetime.now(tz=UTC))
            await session.commit()

        if tokens:
            await self.push.send_to_tokens(
                tokens,
                notif.title,
                notif.body,
                {"week_start": str(week_start)},
            )

    @staticmethod
    async def _save_notification(
        session: AsyncSession,
        *,
        user_id: UUID,
        ntype: NotificationType,
        title: str,
        body: str,
        data: dict[str, str],
    ) -> Notification:
        repo = NotificationRepository(session)
        return await repo.create(
            user_id=user_id,
            ntype=ntype.value,
            title=title,
            body=body,
            data=data,
        )

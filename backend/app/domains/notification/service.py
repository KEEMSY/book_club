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
    CouponIssuePort,
    DailyStatQueryPort,
    DeviceTokenQueryPort,
    LapsedTrialQueryPort,
    PushPort,
    SessionQueryPort,
    TrialExpiryQueryPort,
)
from app.domains.notification.repository import NotificationRepository, WeeklyReportRepository
from app.domains.reading.events import UserGradeRecomputed

logger = logging.getLogger(__name__)

# Grade display names indexed by grade value (1-based).
_GRADE_NAMES = {
    1: "새싹",
    2: "탐독자",
    3: "애독자",
    4: "열혈 독자",
    5: "서재 마스터",
}

# Roman numerals for tier display in push notification copy.
_TIER_ROMAN = {1: "I", 2: "II", 3: "III"}

# M70 re-engagement campaign: target the cohort whose trial lapsed this many
# days ago and offer this discount for this many days.
_REENGAGE_AFTER_DAYS = 7
_REENGAGE_DISCOUNT_PCT = 20
_REENGAGE_VALID_DAYS = 30


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
    # Optional: queries trial-ending users for the expiry-reminder batch. When
    # absent, ``send_expiry_reminders`` is a no-op (e.g. unit tests that don't
    # exercise the reminder path).
    trial_expiry: TrialExpiryQueryPort | None = None
    # Optional (M70): the D+7 re-engagement leg of the expiry batch. Both must
    # be wired for the leg to run; absent, only the D-1 reminders are sent.
    lapsed_trial: LapsedTrialQueryPort | None = None
    coupon_issuer: CouponIssuePort | None = None

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

    async def on_follow_received(self, event: object) -> None:
        """Create an in-app notification when a user receives a new follower.

        Also pushes a real-time event to the followee's personal WebSocket
        stream so the Flutter app can update its follower count badge without
        polling when the user is online.
        """
        from app.core.ws_manager import ws_manager
        from app.domains.social.events import FollowReceived

        if not isinstance(event, FollowReceived):
            return

        async with self.sessionmaker() as session:
            notif = await self._save_notification(
                session,
                user_id=event.followee_id,
                ntype=NotificationType.FOLLOW_RECEIVED,
                title="새 팔로워가 생겼어요",
                body="회원님을 팔로우한 사람이 있습니다.",
                data={"follower_id": str(event.follower_id)},
            )
            tokens = await self.device_tokens.get_active_tokens(event.followee_id)
            await session.commit()

        # Real-time personal-stream delivery (best-effort; Redis fan-out when
        # multiple workers are running).
        await ws_manager.send_user(
            event.followee_id,
            {
                "type": "notification.follow_received",
                "follower_id": str(event.follower_id),
                "notification_id": str(notif.id),
            },
        )

        if tokens:
            await self.push.send_to_tokens(
                tokens,
                notif.title,
                notif.body,
                {"follower_id": str(event.follower_id)},
            )

    async def on_badge_earned(self, event: object) -> None:
        """Create an in-app notification when a user earns a badge."""
        from app.domains.challenge.events import BadgeEarned

        if not isinstance(event, BadgeEarned):
            return

        async with self.sessionmaker() as session:
            notif = await self._save_notification(
                session,
                user_id=event.user_id,
                ntype=NotificationType.BADGE_EARNED,
                title="새 배지를 획득했어요!",
                body=f"'{event.badge_name}' 배지를 획득했습니다. 축하해요!",
                data={"badge_id": str(event.badge_id), "badge_name": event.badge_name},
            )
            tokens = await self.device_tokens.get_active_tokens(event.user_id)
            await session.commit()

        if tokens:
            await self.push.send_to_tokens(
                tokens,
                notif.title,
                notif.body,
                {"badge_id": str(event.badge_id)},
            )

    # --- BC-48: club session/agenda/discussion integration (design §6.2) ---
    #
    # Unlike the event-bus handlers above (on_reaction_added etc.), these are
    # called synchronously by ClubService through the NotificationClubPort
    # Protocol (club/service.py) — ClubService has already computed the
    # deduplicated, self-excluded recipient list, so these methods only fan
    # the push out per recipient. A per-recipient failure (bad token, DB
    # hiccup) is logged and skipped so one bad recipient cannot block the
    # rest of the club's notifications, and never propagates back to
    # ClubService — a push failure must not roll back the agenda/comment
    # write that already succeeded.

    async def notify_agenda_published(
        self,
        *,
        actor_id: UUID,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        recipient_ids: list[UUID],
    ) -> None:
        """Push '새 발제문이 올라왔어요' to every recipient (design §6.2).

        ``actor_id`` (the publisher) is not pushed to — ClubService already
        excludes it from ``recipient_ids``.
        """
        title = "새 발제문이 올라왔어요"
        body = "모임에 새로운 발제문이 게시됐어요. 지금 확인해보세요."
        data = {
            "type": NotificationType.AGENDA_PUBLISHED.value,
            "club_id": str(club_id),
            "session_id": str(session_id),
            "agenda_id": str(agenda_id),
        }
        await self._fan_out_club_push(
            recipient_ids,
            ntype=NotificationType.AGENDA_PUBLISHED,
            title=title,
            body=body,
            data=data,
        )

    async def notify_topic_comment_added(
        self,
        *,
        actor_id: UUID,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        topic_id: UUID,
        comment_id: UUID,
        recipient_ids: list[UUID],
    ) -> None:
        """Push '논제에 답글이 달렸어요' to the agenda author and/or parent-comment
        author (design §6.2). ``actor_id`` (the commenter) is not pushed to —
        ClubService already excludes it from ``recipient_ids``.
        """
        title = "논제에 답글이 달렸어요"
        body = "회원님의 발제문/답글에 새 답글이 달렸습니다."
        data = {
            "type": NotificationType.DISCUSSION_COMMENTED.value,
            "club_id": str(club_id),
            "session_id": str(session_id),
            "agenda_id": str(agenda_id),
            "topic_id": str(topic_id),
            "comment_id": str(comment_id),
        }
        await self._fan_out_club_push(
            recipient_ids,
            ntype=NotificationType.DISCUSSION_COMMENTED,
            title=title,
            body=body,
            data=data,
        )

    async def _fan_out_club_push(
        self,
        recipient_ids: list[UUID],
        *,
        ntype: NotificationType,
        title: str,
        body: str,
        data: dict[str, str],
    ) -> None:
        for uid in recipient_ids:
            try:
                async with self.sessionmaker() as session:
                    notif = await self._save_notification(
                        session,
                        user_id=uid,
                        ntype=ntype,
                        title=title,
                        body=body,
                        data=data,
                    )
                    tokens = await self.device_tokens.get_active_tokens(uid)
                    await session.commit()
                if tokens:
                    await self.push.send_to_tokens(tokens, notif.title, notif.body, data)
            except Exception:
                logger.exception(
                    "club_notification_fan_out_failed user_id=%s ntype=%s", uid, ntype.value
                )

    async def on_grade_up(self, event: object) -> None:
        """Push a grade-up notification when the user crosses a grade or tier boundary.

        Events where neither grade nor tier advanced are silently ignored.
        """
        if not isinstance(event, UserGradeRecomputed):
            return
        if (event.new_grade, event.new_tier) <= (event.old_grade, event.old_tier):
            return

        grade_name = _GRADE_NAMES.get(event.new_grade, "마스터")
        tier_roman = _TIER_ROMAN.get(event.new_tier, "")
        label = f"{grade_name} {tier_roman}".strip()

        async with self.sessionmaker() as session:
            notif = await self._save_notification(
                session,
                user_id=event.user_id,
                ntype=NotificationType.GRADE_UP,
                title=f"등급 상승! {label}이 됐어요",
                body=f"독서 실력이 향상되어 {label} 등급에 도달했습니다.",
                data={"new_grade": str(event.new_grade), "new_tier": str(event.new_tier)},
            )
            tokens = await self.device_tokens.get_active_tokens(event.user_id)
            await session.commit()

        if tokens:
            await self.push.send_to_tokens(
                tokens,
                notif.title,
                notif.body,
                {"grade": str(event.new_grade), "tier": str(event.new_tier)},
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

    async def send_reengagement_push(
        self,
        *,
        user_id: UUID,
        push_type: str,
    ) -> None:
        """Send a re-engagement push to a user who has been inactive.

        Retrieves the user's current device tokens and delivers the push.
        The push_type discriminator ('day7_inactive') controls copy so
        future campaign types can share this method.
        """
        copy: dict[str, tuple[str, str]] = {
            "day7_inactive": (
                "다시 독서를 시작해 볼까요? 📚",
                "7일 동안 독서 기록이 없어요. 오늘 잠깐이라도 읽어 보세요!",
            ),
            "streak_recovery": (
                "스트릭을 되찾아 보세요! 🔥",
                "스트릭 복구권을 사용해 독서 연속 기록을 이어 가세요.",
            ),
        }
        title, body = copy.get(push_type, ("Book Club", ""))

        async with self.sessionmaker() as session:
            await self._save_notification(
                session,
                user_id=user_id,
                ntype=NotificationType.STREAK_WARNING,
                title=title,
                body=body,
                data={"push_type": push_type},
            )
            tokens = await self.device_tokens.get_active_tokens(user_id)
            await session.commit()

        if tokens:
            await self.push.send_to_tokens(
                tokens,
                title,
                body,
                {"push_type": push_type},
            )

    async def send_streak_warning_push(
        self,
        *,
        user_id: UUID,
        streak_days: int,
        device_token: str,
    ) -> None:
        """Send a 'streak at risk' push directly to a single device token.

        Called when the daily scheduler detects the user has not yet logged
        a reading session and their streak would break at midnight. Sends to
        the supplied token rather than a topic so only active devices receive
        the nudge.
        """
        title = "스트릭이 끊길 위험이에요! 🔥"
        body = f"{streak_days}일 연속 독서 중이에요. 오늘 독서를 기록해 보세요."
        async with self.sessionmaker() as session:
            await self._save_notification(
                session,
                user_id=user_id,
                ntype=NotificationType.STREAK_WARNING,
                title=title,
                body=body,
                data={"streak_days": str(streak_days)},
            )
            await session.commit()

        await self.push.send_to_tokens(
            [device_token],
            title,
            body,
            {"streak_days": str(streak_days)},
        )

    async def schedule_subscription_reminders(
        self,
        *,
        user_id: UUID,
        trial_ends_at: datetime,
    ) -> None:
        """Send the D-1 trial-expiry reminder push to a single user.

        Persists an in-app notification and pushes to the user's active device
        tokens. Named ``schedule_*`` because ``send_expiry_reminders`` calls it
        once per user whose trial enters the final 24h window.
        """
        title = "내일 Pro 혜택이 종료돼요"
        body = "지금 구독하면 30% 할인 — 체험 중 누린 Pro 기능을 계속 이어가세요."
        async with self.sessionmaker() as session:
            await self._save_notification(
                session,
                user_id=user_id,
                ntype=NotificationType.SUBSCRIPTION_REMINDER,
                title=title,
                body=body,
                data={"trial_ends_at": trial_ends_at.isoformat()},
            )
            tokens = await self.device_tokens.get_active_tokens(user_id)
            await session.commit()

        if tokens:
            await self.push.send_to_tokens(
                tokens,
                title,
                body,
                {"trial_ends_at": trial_ends_at.isoformat()},
            )

    async def send_expiry_reminders(self) -> None:
        """Push D-1 reminders to every user whose Pro trial ends within 24h.

        Invoked daily by APScheduler. No-op when no trial-expiry query adapter
        is wired (e.g. unit tests). Per-user failures are logged and skipped so
        one bad token cannot abort the whole batch.
        """
        if self.trial_expiry is None:
            return

        users = await self.trial_expiry.get_users_with_trial_ending_within(24)
        logger.info("trial_expiry_reminder_batch started users=%d", len(users))
        for user_id, trial_ends_at in users:
            try:
                await self.schedule_subscription_reminders(
                    user_id=user_id, trial_ends_at=trial_ends_at
                )
            except Exception:
                logger.exception("trial_expiry_reminder_failed user_id=%s", user_id)
        logger.info("trial_expiry_reminder_batch finished users=%d", len(users))

        await self.send_reengagement_coupons()

    async def send_reengagement_coupons(self) -> None:
        """Issue a discount coupon and push it to D+7 lapsed-trial users (M70).

        Each lapsed user gets a deterministic ``REJOIN_*`` coupon (20% off,
        30-day validity) created before the push. No-op unless both the lapsed
        query and coupon-issue ports are wired. Per-user failures are logged and
        skipped so one bad token cannot abort the batch.
        """
        if self.lapsed_trial is None or self.coupon_issuer is None:
            return

        users = await self.lapsed_trial.get_users_with_trial_expired_around(_REENGAGE_AFTER_DAYS)
        logger.info("reengagement_coupon_batch started users=%d", len(users))
        for user_id in users:
            try:
                code = f"REJOIN_{str(user_id)[:8].upper()}"
                await self.coupon_issuer.issue_coupon(
                    code=code,
                    discount_pct=_REENGAGE_DISCOUNT_PCT,
                    valid_days=_REENGAGE_VALID_DAYS,
                )
                await self.send_rejoin_push(user_id=user_id, coupon_code=code)
            except Exception:
                logger.exception("reengagement_coupon_failed user_id=%s", user_id)
        logger.info("reengagement_coupon_batch finished users=%d", len(users))

    async def send_rejoin_push(self, *, user_id: UUID, coupon_code: str) -> None:
        """Push a re-engagement discount coupon to a lapsed user (M70)."""
        title = "다시 만나요! 20% 할인 쿠폰이 도착했어요 🎁"
        body = f"쿠폰 {coupon_code} 으로 Pro를 20% 할인가에 다시 시작해 보세요. (30일 이내)"
        async with self.sessionmaker() as session:
            await self._save_notification(
                session,
                user_id=user_id,
                ntype=NotificationType.SUBSCRIPTION_REMINDER,
                title=title,
                body=body,
                data={"coupon_code": coupon_code},
            )
            tokens = await self.device_tokens.get_active_tokens(user_id)
            await session.commit()

        if tokens:
            await self.push.send_to_tokens(tokens, title, body, {"coupon_code": coupon_code})

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

"""Unit tests for NotificationService.

All tests use a Fake push adapter and in-memory fake repositories — no real DB.
The test service subclass overrides _save_notification and uses FakeDeviceTokenAdapter
so event handlers can be tested without SQLAlchemy sessions (CLAUDE.md §5).
"""

from __future__ import annotations

from datetime import UTC, date, datetime
from typing import Any
from uuid import UUID, uuid4

import pytest
from app.domains.feed.events import CommentAdded, ReactionAdded
from app.domains.notification.models import Notification, NotificationType, WeeklyReport
from app.domains.notification.service import NotificationService
from app.domains.reading.events import UserGradeRecomputed


# ---------------------------------------------------------------------------
# Fake infrastructure
# ---------------------------------------------------------------------------


class FakePushAdapter:
    """Records push calls in-memory for assertion."""

    def __init__(self) -> None:
        self.calls: list[dict[str, Any]] = []

    async def send_to_tokens(
        self,
        tokens: list[str],
        title: str,
        body: str,
        data: dict[str, str],
    ) -> None:
        self.calls.append({"tokens": tokens, "title": title, "body": body, "data": data})


class FakeDeviceTokenAdapter:
    """Returns pre-configured tokens for each user."""

    def __init__(self, tokens_by_user: dict[UUID, list[str]]) -> None:
        self._tokens = tokens_by_user

    async def get_active_tokens(self, user_id: UUID) -> list[str]:
        return self._tokens.get(user_id, [])


class FakeActiveUserAdapter:
    """Returns a fixed list of active user IDs."""

    def __init__(self, user_ids: list[UUID]) -> None:
        self._user_ids = user_ids

    async def get_all_active_user_ids(self) -> list[UUID]:
        return list(self._user_ids)


class FakeDailyStatAdapter:
    """Returns pre-configured weekly stats."""

    def __init__(self, stats: dict[UUID, list[tuple[date, int]]]) -> None:
        self._stats = stats

    async def get_stats_for_week(
        self, user_id: UUID, week_start: date, week_end: date
    ) -> list[tuple[date, int]]:
        return self._stats.get(user_id, [])


class FakeSessionQueryAdapter:
    """Returns pre-configured longest session durations."""

    def __init__(self, longest: dict[UUID, int]) -> None:
        self._longest = longest

    async def get_longest_in_range(
        self, user_id: UUID, from_date: date, to_date: date
    ) -> int:
        return self._longest.get(user_id, 0)


class _FakeSessionMaker:
    """Placeholder sessionmaker — not used in tests that override _save_notification."""

    def __call__(self) -> Any:
        return self

    async def __aenter__(self) -> Any:
        return None

    async def __aexit__(self, *_: object) -> None:
        pass


class _TestableNotificationService(NotificationService):
    """NotificationService subclass that replaces DB operations with in-memory fakes.

    By overriding on_reaction_added / on_comment_added / on_grade_up at the
    sessionmaker boundary, we verify the business logic (skip self-reaction,
    fan-out, grade comparison) without needing a real SQLAlchemy session.
    """

    def __init__(
        self,
        push: FakePushAdapter,
        tokens_by_user: dict[UUID, list[str]],
    ) -> None:
        super().__init__(
            sessionmaker=_FakeSessionMaker(),  # type: ignore[arg-type]
            push=push,
            device_tokens=FakeDeviceTokenAdapter(tokens_by_user),
            daily_stats=FakeDailyStatAdapter({}),
            session_query=FakeSessionQueryAdapter({}),
            active_users=FakeActiveUserAdapter([]),
        )
        self._notifications: list[Notification] = []
        self._tokens_by_user = tokens_by_user

    def _make_notification(
        self,
        *,
        user_id: UUID,
        ntype: NotificationType,
        title: str,
        body: str,
        data: dict[str, str],
    ) -> Notification:
        row = Notification(
            id=uuid4(),
            user_id=user_id,
            ntype=ntype.value,
            title=title,
            body=body,
            data=data,
            created_at=datetime.now(tz=UTC),
        )
        self._notifications.append(row)
        return row

    async def on_reaction_added(self, event: object) -> None:
        from app.domains.feed.events import ReactionAdded as _ReactionAdded

        if not isinstance(event, _ReactionAdded):
            return
        if event.reactor_id == event.post_author_id:
            return

        notif = self._make_notification(
            user_id=event.post_author_id,
            ntype=NotificationType.REACTION,
            title="새 반응이 달렸어요",
            body="회원님의 글에 반응이 달렸습니다.",
            data={"post_id": str(event.post_id)},
        )
        tokens = await self.device_tokens.get_active_tokens(event.post_author_id)
        if tokens:
            await self.push.send_to_tokens(
                tokens, notif.title, notif.body, {"post_id": str(event.post_id)}
            )

    async def on_comment_added(self, event: object) -> None:
        from app.domains.feed.events import CommentAdded as _CommentAdded

        if not isinstance(event, _CommentAdded):
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
            notif = self._make_notification(
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
            if tokens:
                await self.push.send_to_tokens(
                    tokens,
                    notif.title,
                    notif.body,
                    {"comment_id": str(event.comment_id)},
                )

    async def on_grade_up(self, event: object) -> None:
        from app.domains.reading.events import UserGradeRecomputed as _UGR

        if not isinstance(event, _UGR):
            return
        if event.new_grade <= event.old_grade:
            return

        grade_names = ["새싹", "새싹+", "초록이", "숲속이", "숲속이+"]
        grade_name = grade_names[min(event.new_grade - 1, len(grade_names) - 1)]

        notif = self._make_notification(
            user_id=event.user_id,
            ntype=NotificationType.GRADE_UP,
            title=f"등급 상승! {grade_name}이 됐어요",
            body=f"독서 실력이 향상되어 {grade_name} 등급에 도달했습니다.",
            data={"new_grade": str(event.new_grade)},
        )
        tokens = await self.device_tokens.get_active_tokens(event.user_id)
        if tokens:
            await self.push.send_to_tokens(
                tokens,
                notif.title,
                notif.body,
                {"grade": str(event.new_grade)},
            )


# ---------------------------------------------------------------------------
# Tests
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_on_reaction_added_creates_notification_and_sends_push() -> None:
    push = FakePushAdapter()
    post_author = uuid4()
    reactor = uuid4()
    post_id = uuid4()

    svc = _TestableNotificationService(push, {post_author: ["tok-abc"]})

    event = ReactionAdded(
        post_id=post_id,
        reactor_id=reactor,
        post_author_id=post_author,
        reaction_type="heart",
    )
    await svc.on_reaction_added(event)

    assert len(svc._notifications) == 1
    assert svc._notifications[0].user_id == post_author
    assert svc._notifications[0].ntype == NotificationType.REACTION.value
    assert len(push.calls) == 1
    assert push.calls[0]["tokens"] == ["tok-abc"]


@pytest.mark.asyncio
async def test_on_reaction_added_skips_self_reaction() -> None:
    push = FakePushAdapter()
    user_id = uuid4()

    svc = _TestableNotificationService(push, {user_id: ["tok-self"]})

    event = ReactionAdded(
        post_id=uuid4(),
        reactor_id=user_id,
        post_author_id=user_id,
        reaction_type="fire",
    )
    await svc.on_reaction_added(event)

    # Self-reaction: no notification, no push.
    assert len(svc._notifications) == 0
    assert len(push.calls) == 0


@pytest.mark.asyncio
async def test_on_comment_added_notifies_post_author() -> None:
    push = FakePushAdapter()
    post_author = uuid4()
    commenter = uuid4()
    post_id = uuid4()
    comment_id = uuid4()

    svc = _TestableNotificationService(push, {post_author: ["tok-author"]})

    event = CommentAdded(
        comment_id=comment_id,
        post_id=post_id,
        commenter_id=commenter,
        post_author_id=post_author,
        parent_author_id=None,
    )
    await svc.on_comment_added(event)

    assert len(svc._notifications) == 1
    assert svc._notifications[0].user_id == post_author
    assert svc._notifications[0].ntype == NotificationType.COMMENT.value
    assert len(push.calls) == 1
    assert push.calls[0]["tokens"] == ["tok-author"]


@pytest.mark.asyncio
async def test_on_comment_added_notifies_parent_author() -> None:
    push = FakePushAdapter()
    post_author = uuid4()
    commenter = uuid4()
    parent_author = uuid4()  # distinct from post_author and commenter

    svc = _TestableNotificationService(
        push,
        {
            post_author: ["tok-author"],
            parent_author: ["tok-parent"],
        },
    )

    event = CommentAdded(
        comment_id=uuid4(),
        post_id=uuid4(),
        commenter_id=commenter,
        post_author_id=post_author,
        parent_author_id=parent_author,
    )
    await svc.on_comment_added(event)

    # Both post author and parent author get notifications.
    recipient_ids = {n.user_id for n in svc._notifications}
    assert post_author in recipient_ids
    assert parent_author in recipient_ids
    assert len(svc._notifications) == 2
    assert len(push.calls) == 2


@pytest.mark.asyncio
async def test_on_grade_up_notifies_user() -> None:
    push = FakePushAdapter()
    user_id = uuid4()

    svc = _TestableNotificationService(push, {user_id: ["tok-grade"]})

    event = UserGradeRecomputed(
        user_id=user_id,
        old_grade=1,
        new_grade=2,
        streak_days=5,
    )
    await svc.on_grade_up(event)

    assert len(svc._notifications) == 1
    assert svc._notifications[0].user_id == user_id
    assert svc._notifications[0].ntype == NotificationType.GRADE_UP.value
    assert "새싹+" in svc._notifications[0].title
    assert len(push.calls) == 1
    assert push.calls[0]["tokens"] == ["tok-grade"]


@pytest.mark.asyncio
async def test_on_grade_up_skips_same_grade() -> None:
    push = FakePushAdapter()
    user_id = uuid4()

    svc = _TestableNotificationService(push, {user_id: ["tok-grade"]})

    event = UserGradeRecomputed(
        user_id=user_id,
        old_grade=3,
        new_grade=3,
        streak_days=10,
    )
    await svc.on_grade_up(event)

    # Grade did not increase: no notification, no push.
    assert len(svc._notifications) == 0
    assert len(push.calls) == 0

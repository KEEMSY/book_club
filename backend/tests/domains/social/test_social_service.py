"""Unit tests for SocialService.

All tests use FakeSocialRepository (in-memory dict implementation) — no real
DB required (CLAUDE.md §5 pattern: service unit tests with Fake ports).
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import UTC, datetime
from typing import Any
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError
from app.domains.social.events import FollowReceived
from app.domains.social.service import SocialService

# ---------------------------------------------------------------------------
# Lightweight stand-ins for ORM models used by the fake repo.
# Using plain dataclasses avoids SQLAlchemy instrumentation errors when
# constructing objects outside of a session.
# ---------------------------------------------------------------------------


@dataclass
class _FakeUser:
    id: UUID
    nickname: str = "user"
    profile_image_url: str | None = None
    bio: str | None = None
    deleted_at: datetime | None = None


@dataclass
class _FakeFollow:
    id: UUID = field(default_factory=uuid4)
    follower_id: UUID = field(default_factory=uuid4)
    followee_id: UUID = field(default_factory=uuid4)
    created_at: datetime = field(default_factory=lambda: datetime.now(tz=UTC))


@dataclass
class _FakeBlock:
    id: UUID = field(default_factory=uuid4)
    blocker_id: UUID = field(default_factory=uuid4)
    blocked_id: UUID = field(default_factory=uuid4)
    created_at: datetime = field(default_factory=lambda: datetime.now(tz=UTC))


@dataclass
class _FakeReport:
    id: UUID = field(default_factory=uuid4)
    reporter_id: UUID = field(default_factory=uuid4)
    target_type: str = "post"
    target_id: UUID = field(default_factory=uuid4)
    reason: str = ""
    created_at: datetime = field(default_factory=lambda: datetime.now(tz=UTC))


class FakeSocialRepository:
    """In-memory implementation of SocialRepositoryPort for unit tests."""

    def __init__(self) -> None:
        self._follows: dict[tuple[UUID, UUID], _FakeFollow] = {}
        self._blocks: dict[tuple[UUID, UUID], _FakeBlock] = {}
        self._reports: dict[tuple[UUID, str, UUID], _FakeReport] = {}
        self._users: dict[UUID, _FakeUser] = {}

    def register_user(self, user: _FakeUser) -> None:
        self._users[user.id] = user

    # --- Follow ---

    async def follow(self, follower_id: UUID, followee_id: UUID) -> _FakeFollow:
        row = _FakeFollow(follower_id=follower_id, followee_id=followee_id)
        self._follows[(follower_id, followee_id)] = row
        return row

    async def unfollow(self, follower_id: UUID, followee_id: UUID) -> None:
        self._follows.pop((follower_id, followee_id), None)

    async def is_following(self, follower_id: UUID, followee_id: UUID) -> bool:
        return (follower_id, followee_id) in self._follows

    async def get_follow_counts(self, user_id: UUID) -> tuple[int, int]:
        followers = sum(1 for (_, fe) in self._follows if fe == user_id)
        following = sum(1 for (fr, _) in self._follows if fr == user_id)
        return followers, following

    async def list_followers(
        self,
        user_id: UUID,
        viewer_id: UUID,
        cursor: str | None,
        limit: int,
    ) -> tuple[list[Any], str | None]:
        followers = [
            self._users[fr]
            for (fr, fe) in self._follows
            if fe == user_id and fr in self._users
        ]
        return followers[:limit], None

    async def list_following(
        self,
        user_id: UUID,
        viewer_id: UUID,
        cursor: str | None,
        limit: int,
    ) -> tuple[list[Any], str | None]:
        following = [
            self._users[fe]
            for (fr, fe) in self._follows
            if fr == user_id and fe in self._users
        ]
        return following[:limit], None

    # --- Block ---

    async def block(self, blocker_id: UUID, blocked_id: UUID) -> _FakeBlock:
        row = _FakeBlock(blocker_id=blocker_id, blocked_id=blocked_id)
        self._blocks[(blocker_id, blocked_id)] = row
        return row

    async def unblock(self, blocker_id: UUID, blocked_id: UUID) -> None:
        self._blocks.pop((blocker_id, blocked_id), None)

    async def is_blocked(self, blocker_id: UUID, blocked_id: UUID) -> bool:
        return (blocker_id, blocked_id) in self._blocks

    async def list_blocks(
        self,
        blocker_id: UUID,
        cursor: str | None,
        limit: int,
    ) -> tuple[list[Any], str | None]:
        blocked = [
            self._users[bid]
            for (br, bid) in self._blocks
            if br == blocker_id and bid in self._users
        ]
        return blocked[:limit], None

    # --- Report ---

    async def report(
        self,
        reporter_id: UUID,
        target_type: str,
        target_id: UUID,
        reason: str,
    ) -> _FakeReport:
        row = _FakeReport(
            reporter_id=reporter_id,
            target_type=target_type,
            target_id=target_id,
            reason=reason,
        )
        self._reports[(reporter_id, target_type, target_id)] = row
        return row

    async def has_reported(
        self,
        reporter_id: UUID,
        target_type: str,
        target_id: UUID,
    ) -> bool:
        return (reporter_id, target_type, target_id) in self._reports


class _EventCapture:
    """Records staged events for assertion."""

    def __init__(self) -> None:
        self.events: list[Any] = []

    def __call__(self, event: object) -> None:
        self.events.append(event)


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------


def _make_service(
    repo: FakeSocialRepository,
    event_capture: _EventCapture | None = None,
) -> SocialService:
    return SocialService(
        repo=repo,
        bus=None,
        stage_event=event_capture,
    )


# ---------------------------------------------------------------------------
# Tests
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_follow_success() -> None:
    """A user can follow another user; FollowReceived event is staged."""
    repo = FakeSocialRepository()
    events = _EventCapture()
    svc = _make_service(repo, events)

    actor = uuid4()
    target = uuid4()
    await svc.follow(actor, target)

    assert await repo.is_following(actor, target)
    assert len(events.events) == 1
    ev = events.events[0]
    assert isinstance(ev, FollowReceived)
    assert ev.follower_id == actor
    assert ev.followee_id == target


@pytest.mark.asyncio
async def test_follow_self_raises() -> None:
    """Following oneself raises ConflictError with code FOLLOW_SELF."""
    repo = FakeSocialRepository()
    svc = _make_service(repo)

    user = uuid4()
    with pytest.raises(ConflictError) as exc_info:
        await svc.follow(user, user)
    assert exc_info.value.code == "FOLLOW_SELF"


@pytest.mark.asyncio
async def test_follow_blocked_user_raises() -> None:
    """Following a user who has blocked the actor raises ConflictError."""
    repo = FakeSocialRepository()
    svc = _make_service(repo)

    actor = uuid4()
    target = uuid4()
    # target blocks actor
    await repo.block(target, actor)

    with pytest.raises(ConflictError) as exc_info:
        await svc.follow(actor, target)
    assert exc_info.value.code == "FOLLOW_BLOCKED"


@pytest.mark.asyncio
async def test_unfollow_idempotent() -> None:
    """Unfollowing a user that is not followed does not raise."""
    repo = FakeSocialRepository()
    svc = _make_service(repo)

    actor = uuid4()
    target = uuid4()
    # Call twice — second call should be a no-op.
    await svc.unfollow(actor, target)
    await svc.unfollow(actor, target)

    assert not await repo.is_following(actor, target)


@pytest.mark.asyncio
async def test_block_auto_unfollows() -> None:
    """Blocking a user removes follow edges in both directions."""
    repo = FakeSocialRepository()
    svc = _make_service(repo)

    actor = uuid4()
    target = uuid4()

    # Establish follow edges in both directions.
    await repo.follow(actor, target)
    await repo.follow(target, actor)

    assert await repo.is_following(actor, target)
    assert await repo.is_following(target, actor)

    await svc.block(actor, target)

    # Both follow edges should be removed.
    assert not await repo.is_following(actor, target)
    assert not await repo.is_following(target, actor)
    # The block edge should exist.
    assert await repo.is_blocked(actor, target)


@pytest.mark.asyncio
async def test_report_duplicate_raises_conflict() -> None:
    """Reporting the same content twice raises ConflictError."""
    repo = FakeSocialRepository()
    svc = _make_service(repo)

    reporter = uuid4()
    post_id = uuid4()

    await svc.report(reporter, "post", post_id, "spam")

    with pytest.raises(ConflictError) as exc_info:
        await svc.report(reporter, "post", post_id, "spam again")
    assert exc_info.value.code == "REPORT_DUPLICATE"


@pytest.mark.asyncio
async def test_report_success() -> None:
    """First report on a target succeeds and is persisted."""
    repo = FakeSocialRepository()
    svc = _make_service(repo)

    reporter = uuid4()
    post_id = uuid4()

    await svc.report(reporter, "post", post_id, "inappropriate")

    assert await repo.has_reported(reporter, "post", post_id)


@pytest.mark.asyncio
async def test_follow_removes_reverse_block() -> None:
    """Following a user the actor had previously blocked removes that block first."""
    repo = FakeSocialRepository()
    svc = _make_service(repo)

    actor = uuid4()
    target = uuid4()

    # actor has previously blocked target
    await repo.block(actor, target)
    assert await repo.is_blocked(actor, target)

    # actor now wants to follow target — block should be lifted
    await svc.follow(actor, target)

    assert await repo.is_following(actor, target)
    assert not await repo.is_blocked(actor, target)


@pytest.mark.asyncio
async def test_block_self_raises() -> None:
    """Blocking oneself raises ConflictError with code BLOCK_SELF."""
    repo = FakeSocialRepository()
    svc = _make_service(repo)

    user = uuid4()
    with pytest.raises(ConflictError) as exc_info:
        await svc.block(user, user)
    assert exc_info.value.code == "BLOCK_SELF"


@pytest.mark.asyncio
async def test_unblock_idempotent() -> None:
    """Unblocking a user that is not blocked does not raise."""
    repo = FakeSocialRepository()
    svc = _make_service(repo)

    actor = uuid4()
    target = uuid4()
    # Both calls should succeed silently.
    await svc.unblock(actor, target)
    await svc.unblock(actor, target)

    assert not await repo.is_blocked(actor, target)


@pytest.mark.asyncio
async def test_block_prevents_follow_by_blocked_user() -> None:
    """A user who was blocked cannot follow back (target→actor direction)."""
    repo = FakeSocialRepository()
    svc = _make_service(repo)

    actor = uuid4()
    target = uuid4()

    # actor blocks target
    await svc.block(actor, target)

    # target tries to follow actor — actor has blocked target, so FOLLOW_BLOCKED
    with pytest.raises(ConflictError) as exc_info:
        await svc.follow(target, actor)
    assert exc_info.value.code == "FOLLOW_BLOCKED"

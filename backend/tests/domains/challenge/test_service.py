"""Unit tests for ChallengeService.

All tests use FakeChallengeRepository (in-memory implementation) — no real DB
required (CLAUDE.md §5 pattern: service unit tests with Fake injected repos).
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import UTC, datetime, timedelta
from typing import Any
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import NotFoundError
from app.domains.challenge.service import (
    AlreadyJoinedError,
    ChallengeEndedError,
    ChallengeService,
)

# ---------------------------------------------------------------------------
# Lightweight stand-ins for ORM models (no SQLAlchemy instrumentation needed)
# ---------------------------------------------------------------------------


@dataclass
class _FakeBadge:
    id: UUID = field(default_factory=uuid4)
    name: str = "badge"
    description: str = ""
    category: str = "challenge"
    icon_key: str = "icons/badge.png"
    created_at: datetime = field(default_factory=lambda: datetime.now(tz=UTC))


@dataclass
class _FakeChallenge:
    id: UUID = field(default_factory=uuid4)
    title: str = "challenge"
    description: str | None = None
    challenge_type: str = "books_count"
    target_value: int = 5
    genre_filter: str | None = None
    starts_at: datetime = field(
        default_factory=lambda: datetime.now(tz=UTC) - timedelta(days=1)
    )
    ends_at: datetime = field(
        default_factory=lambda: datetime.now(tz=UTC) + timedelta(days=30)
    )
    badge_id: UUID | None = None
    created_at: datetime = field(default_factory=lambda: datetime.now(tz=UTC))


@dataclass
class _FakeParticipant:
    challenge_id: UUID = field(default_factory=uuid4)
    user_id: UUID = field(default_factory=uuid4)
    current_value: int = 0
    achieved_at: datetime | None = None
    joined_at: datetime = field(default_factory=lambda: datetime.now(tz=UTC))


@dataclass
class _FakeUserBadge:
    user_id: UUID = field(default_factory=uuid4)
    badge_id: UUID = field(default_factory=uuid4)
    earned_at: datetime = field(default_factory=lambda: datetime.now(tz=UTC))


# ---------------------------------------------------------------------------
# Fake repository
# ---------------------------------------------------------------------------


class FakeChallengeRepository:
    """In-memory ChallengeRepository for unit tests."""

    def __init__(self) -> None:
        self._challenges: dict[UUID, _FakeChallenge] = {}
        self._participants: dict[tuple[UUID, UUID], _FakeParticipant] = {}
        self._badges: dict[UUID, _FakeBadge] = {}
        self._user_badges: dict[tuple[UUID, UUID], _FakeUserBadge] = {}

    # Helpers for test setup

    def add_challenge(self, ch: _FakeChallenge) -> None:
        self._challenges[ch.id] = ch

    def add_badge(self, badge: _FakeBadge) -> None:
        self._badges[badge.id] = badge

    # Challenges

    async def list_challenges(
        self,
        status: str | None,
        limit: int,
        cursor_at: datetime | None,
    ) -> list[Any]:
        now = datetime.now(tz=UTC)
        results: list[_FakeChallenge] = []
        for ch in self._challenges.values():
            if status == "active" and not (ch.starts_at <= now <= ch.ends_at):
                continue
            if status == "upcoming" and ch.starts_at <= now:
                continue
            if status == "ended" and ch.ends_at >= now:
                continue
            results.append(ch)
        results.sort(key=lambda c: c.ends_at)
        return results[:limit]

    async def get_challenge(self, challenge_id: UUID) -> _FakeChallenge | None:
        return self._challenges.get(challenge_id)

    async def get_participant(
        self, challenge_id: UUID, user_id: UUID
    ) -> _FakeParticipant | None:
        return self._participants.get((challenge_id, user_id))

    async def join(self, challenge_id: UUID, user_id: UUID) -> _FakeParticipant:
        row = _FakeParticipant(challenge_id=challenge_id, user_id=user_id)
        self._participants[(challenge_id, user_id)] = row
        return row

    async def leave(self, challenge_id: UUID, user_id: UUID) -> None:
        self._participants.pop((challenge_id, user_id), None)

    async def leaderboard(
        self, challenge_id: UUID, limit: int = 50
    ) -> list[Any]:
        from dataclasses import dataclass as dc

        @dc
        class _FakeUser:
            id: UUID
            nickname: str = "user"
            profile_image_url: str | None = None
            deleted_at: datetime | None = None

        rows = [
            (p, _FakeUser(id=p.user_id))
            for p in self._participants.values()
            if p.challenge_id == challenge_id
        ]
        rows.sort(key=lambda r: r[0].current_value, reverse=True)
        return rows[:limit]

    async def my_challenges(
        self, user_id: UUID, limit: int = 20
    ) -> list[Any]:
        rows = [
            (self._challenges[p.challenge_id], p)
            for p in self._participants.values()
            if p.user_id == user_id and p.challenge_id in self._challenges
        ]
        rows.sort(key=lambda r: r[1].joined_at, reverse=True)
        return rows[:limit]

    async def participant_count(self, challenge_id: UUID) -> int:
        return sum(1 for p in self._participants.values() if p.challenge_id == challenge_id)

    async def update_progress(
        self,
        challenge_id: UUID,
        user_id: UUID,
        value: int,
        achieved_at: datetime | None,
    ) -> None:
        key = (challenge_id, user_id)
        if key in self._participants:
            self._participants[key].current_value = value
            self._participants[key].achieved_at = achieved_at

    # Badges

    async def has_badge(self, user_id: UUID, badge_id: UUID) -> bool:
        return (user_id, badge_id) in self._user_badges

    async def award_badge(self, user_id: UUID, badge_id: UUID) -> _FakeUserBadge:
        row = _FakeUserBadge(user_id=user_id, badge_id=badge_id)
        self._user_badges[(user_id, badge_id)] = row
        return row

    async def list_badges(self, category: str | None) -> list[Any]:
        badges = list(self._badges.values())
        if category is not None:
            badges = [b for b in badges if b.category == category]
        return badges

    async def my_badges(self, user_id: UUID) -> list[Any]:
        return [
            (self._badges[badge_id], ub)
            for (uid, badge_id), ub in self._user_badges.items()
            if uid == user_id and badge_id in self._badges
        ]

    async def badge_earner_count(self, badge_id: UUID) -> int:
        return sum(1 for (_, bid) in self._user_badges if bid == badge_id)


# ---------------------------------------------------------------------------
# Helper
# ---------------------------------------------------------------------------


def _svc(repo: FakeChallengeRepository) -> ChallengeService:
    return ChallengeService(repo=repo)


# ---------------------------------------------------------------------------
# Tests
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_join_challenge_success() -> None:
    """A user can join an active challenge and becomes a participant."""
    repo = FakeChallengeRepository()
    ch = _FakeChallenge()
    repo.add_challenge(ch)
    svc = _svc(repo)

    user_id = uuid4()
    participant = await svc.join(ch.id, user_id)

    assert participant.challenge_id == ch.id
    assert participant.user_id == user_id
    assert participant.current_value == 0
    assert await repo.get_participant(ch.id, user_id) is not None


@pytest.mark.asyncio
async def test_join_already_joined_raises() -> None:
    """Joining a challenge the user already participates in raises AlreadyJoinedError."""
    repo = FakeChallengeRepository()
    ch = _FakeChallenge()
    repo.add_challenge(ch)
    svc = _svc(repo)

    user_id = uuid4()
    await svc.join(ch.id, user_id)

    with pytest.raises(AlreadyJoinedError):
        await svc.join(ch.id, user_id)


@pytest.mark.asyncio
async def test_join_ended_challenge_raises() -> None:
    """Joining a challenge whose ends_at is in the past raises ChallengeEndedError."""
    repo = FakeChallengeRepository()
    ended_ch = _FakeChallenge(
        ends_at=datetime.now(tz=UTC) - timedelta(hours=1),
    )
    repo.add_challenge(ended_ch)
    svc = _svc(repo)

    with pytest.raises(ChallengeEndedError):
        await svc.join(ended_ch.id, uuid4())


@pytest.mark.asyncio
async def test_leave_challenge_success() -> None:
    """A participant can leave a challenge; they are no longer in the participant list."""
    repo = FakeChallengeRepository()
    ch = _FakeChallenge()
    repo.add_challenge(ch)
    svc = _svc(repo)

    user_id = uuid4()
    await svc.join(ch.id, user_id)
    await svc.leave(ch.id, user_id)

    assert await repo.get_participant(ch.id, user_id) is None


@pytest.mark.asyncio
async def test_leave_not_joined_raises() -> None:
    """Leaving a challenge without being a participant raises NotFoundError."""
    repo = FakeChallengeRepository()
    ch = _FakeChallenge()
    repo.add_challenge(ch)
    svc = _svc(repo)

    with pytest.raises(NotFoundError):
        await svc.leave(ch.id, uuid4())


@pytest.mark.asyncio
async def test_list_challenges_by_status() -> None:
    """list_challenges correctly filters by active / upcoming / ended status."""
    repo = FakeChallengeRepository()
    now = datetime.now(tz=UTC)

    active = _FakeChallenge(
        starts_at=now - timedelta(days=1),
        ends_at=now + timedelta(days=10),
    )
    upcoming = _FakeChallenge(
        starts_at=now + timedelta(days=5),
        ends_at=now + timedelta(days=20),
    )
    ended = _FakeChallenge(
        starts_at=now - timedelta(days=30),
        ends_at=now - timedelta(days=1),
    )
    for ch in (active, upcoming, ended):
        repo.add_challenge(ch)

    svc = _svc(repo)
    viewer_id = uuid4()

    active_page = await svc.list_challenges(viewer_id, "active", 20, None)
    active_ids = {item.id for item in active_page.items}
    assert active.id in active_ids
    assert upcoming.id not in active_ids
    assert ended.id not in active_ids

    upcoming_page = await svc.list_challenges(viewer_id, "upcoming", 20, None)
    upcoming_ids = {item.id for item in upcoming_page.items}
    assert upcoming.id in upcoming_ids
    assert active.id not in upcoming_ids

    ended_page = await svc.list_challenges(viewer_id, "ended", 20, None)
    ended_ids = {item.id for item in ended_page.items}
    assert ended.id in ended_ids
    assert active.id not in ended_ids


@pytest.mark.asyncio
async def test_leaderboard_ordering() -> None:
    """Leaderboard entries are ranked in descending order of current_value."""
    repo = FakeChallengeRepository()
    ch = _FakeChallenge()
    repo.add_challenge(ch)
    svc = _svc(repo)

    users = [uuid4() for _ in range(3)]
    values = [10, 30, 20]
    for uid, val in zip(users, values, strict=True):
        await repo.join(ch.id, uid)
        await repo.update_progress(ch.id, uid, val, None)

    entries = await svc.leaderboard(ch.id, limit=10)

    assert len(entries) == 3
    assert entries[0].rank == 1
    assert entries[0].current_value == 30
    assert entries[1].current_value == 20
    assert entries[2].current_value == 10

    for i, entry in enumerate(entries):
        assert entry.rank == i + 1

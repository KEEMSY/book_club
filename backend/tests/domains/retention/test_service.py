"""Unit tests for RetentionService with in-memory fakes — no DB, no HTTP.

Covers:
- run_reengagement_campaign: inactive users batched, dedup by has_push_today,
  per-user errors are swallowed, return value equals actual send count
- recover_streak: happy path increments streak, rolling-30d cap enforced
- get_recovery_status: correct used/remaining arithmetic for 0/1/2 usages
"""

from __future__ import annotations

from dataclasses import dataclass
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError
from app.domains.retention.service import RetentionService

# ---------------------------------------------------------------------------
# In-memory fakes
# ---------------------------------------------------------------------------


@dataclass
class _FakeUser:
    id: UUID
    nickname: str
    fcm_token: str | None = "test-token"


@dataclass
class _FakeGrade:
    """Minimal user-grade snapshot stub."""

    streak_days: int = 0


class FakeRetentionRepository:
    """In-memory stand-in for RetentionRepository."""

    def __init__(self) -> None:
        self._inactive_users: list[_FakeUser] = []
        # Set of (user_id, push_type) that already have a push today.
        self._pushed_today: set[tuple[UUID, str]] = set()
        # Logged push records: (user_id, push_type)
        self.push_log: list[tuple[UUID, str]] = []
        # Logged recovery records: (user_id, days)
        self.recovery_log: list[tuple[UUID, int]] = []

    # --- helpers for test setup ---

    def seed_inactive_users(self, users: list[_FakeUser]) -> None:
        self._inactive_users = list(users)

    def mark_pushed_today(self, user_id: UUID, push_type: str) -> None:
        self._pushed_today.add((user_id, push_type))

    def seed_recovery_count(self, user_id: UUID, count: int) -> None:
        """Pre-populate recovery_log with `count` entries for user_id."""
        for _ in range(count):
            self.recovery_log.append((user_id, 1))

    # --- repository interface ---

    async def get_inactive_users(
        self, inactive_days: int = 7, limit: int = 1000
    ) -> list[_FakeUser]:
        return self._inactive_users[:limit]

    async def has_push_today(self, user_id: UUID, push_type: str) -> bool:
        return (user_id, push_type) in self._pushed_today

    async def log_push(self, user_id: UUID, push_type: str) -> None:
        self.push_log.append((user_id, push_type))
        self._pushed_today.add((user_id, push_type))

    async def count_recoveries_last_30_days(self, user_id: UUID) -> int:
        return sum(1 for uid, _ in self.recovery_log if uid == user_id)

    async def log_recovery(self, user_id: UUID, days: int) -> None:
        self.recovery_log.append((user_id, days))


class FakeUserGradeRepository:
    """Minimal in-memory user-grade store matching the duck-typed port."""

    def __init__(self) -> None:
        self._grades: dict[UUID, _FakeGrade] = {}

    async def get_or_init(self, user_id: UUID) -> _FakeGrade:
        if user_id not in self._grades:
            self._grades[user_id] = _FakeGrade(streak_days=0)
        return self._grades[user_id]

    async def update_snapshot(
        self, user_id: UUID, *, streak_days: int | None = None, **_kwargs: object
    ) -> _FakeGrade:
        grade = await self.get_or_init(user_id)
        if streak_days is not None:
            grade.streak_days = streak_days
        return grade


class FakeNotificationService:
    """Records send_reengagement_push calls; can be configured to fail for specific users."""

    def __init__(self) -> None:
        self.push_calls: list[tuple[UUID, str]] = []
        self.should_fail_for: set[UUID] = set()

    async def send_reengagement_push(self, *, user_id: UUID, push_type: str) -> None:
        if user_id in self.should_fail_for:
            raise RuntimeError(f"simulated FCM failure for user {user_id}")
        self.push_calls.append((user_id, push_type))


# ---------------------------------------------------------------------------
# Factory
# ---------------------------------------------------------------------------


def _build_service() -> tuple[
    RetentionService, FakeRetentionRepository, FakeNotificationService, FakeUserGradeRepository
]:
    repo = FakeRetentionRepository()
    grades = FakeUserGradeRepository()
    notif = FakeNotificationService()
    svc = RetentionService(repo=repo, user_grades=grades, notification_service=notif)  # type: ignore[arg-type]
    return svc, repo, notif, grades


# ---------------------------------------------------------------------------
# run_reengagement_campaign
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_campaign_sends_to_inactive_users() -> None:
    """Three 7-day-inactive users each get one push dispatched."""
    svc, repo, notif, _ = _build_service()
    users = [_FakeUser(id=uuid4(), nickname=f"user{i}") for i in range(3)]
    repo.seed_inactive_users(users)

    sent = await svc.run_reengagement_campaign()

    assert sent == 3
    assert len(notif.push_calls) == 3
    pushed_ids = {uid for uid, _ in notif.push_calls}
    assert pushed_ids == {u.id for u in users}


@pytest.mark.asyncio
async def test_campaign_skips_already_pushed_today() -> None:
    """Users that already have a push_today entry are skipped entirely."""
    svc, repo, notif, _ = _build_service()
    users = [_FakeUser(id=uuid4(), nickname=f"user{i}") for i in range(3)]
    repo.seed_inactive_users(users)
    # Mark the first user as already pushed today.
    repo.mark_pushed_today(users[0].id, "day7_inactive")

    sent = await svc.run_reengagement_campaign()

    assert sent == 2
    pushed_ids = {uid for uid, _ in notif.push_calls}
    assert users[0].id not in pushed_ids


@pytest.mark.asyncio
async def test_campaign_returns_sent_count() -> None:
    """Return value equals the number of pushes actually dispatched."""
    svc, repo, notif, _ = _build_service()
    users = [_FakeUser(id=uuid4(), nickname=f"u{i}") for i in range(5)]
    repo.seed_inactive_users(users)
    # Pre-mark 2 users as already pushed.
    for u in users[:2]:
        repo.mark_pushed_today(u.id, "day7_inactive")

    sent = await svc.run_reengagement_campaign()

    assert sent == 3
    assert len(notif.push_calls) == 3


@pytest.mark.asyncio
async def test_campaign_continues_on_single_error() -> None:
    """An FCM failure for one user must not abort the remaining dispatches."""
    svc, repo, notif, _ = _build_service()
    users = [_FakeUser(id=uuid4(), nickname=f"u{i}") for i in range(3)]
    repo.seed_inactive_users(users)
    # Make the second user's push raise a RuntimeError.
    notif.should_fail_for.add(users[1].id)

    sent = await svc.run_reengagement_campaign()

    # Only 2 out of 3 succeed; the failed one is not counted.
    assert sent == 2
    pushed_ids = {uid for uid, _ in notif.push_calls}
    assert users[1].id not in pushed_ids
    assert users[0].id in pushed_ids
    assert users[2].id in pushed_ids


# ---------------------------------------------------------------------------
# recover_streak
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_recover_streak_success() -> None:
    """First recovery increments streak by 1 and leaves 1 slot remaining."""
    svc, repo, _, grades = _build_service()
    user_id = uuid4()
    # Seed streak_days = 5 so we can verify increment.
    grade = await grades.get_or_init(user_id)
    grade.streak_days = 5

    result = await svc.recover_streak(user_id)

    assert result["recovered_days"] == 1
    assert result["recoveries_remaining"] == 1
    updated = await grades.get_or_init(user_id)
    assert updated.streak_days == 6
    assert len(repo.recovery_log) == 1


@pytest.mark.asyncio
async def test_recover_streak_limit_exceeded() -> None:
    """After 2 recoveries in the rolling 30-day window a third raises ConflictError."""
    svc, repo, _, _ = _build_service()
    user_id = uuid4()
    repo.seed_recovery_count(user_id, count=2)  # already used both slots

    with pytest.raises(ConflictError) as exc_info:
        await svc.recover_streak(user_id)

    assert exc_info.value.code == "STREAK_RECOVERY_LIMIT"


@pytest.mark.asyncio
async def test_recover_streak_exactly_at_limit() -> None:
    """Using the second-last slot succeeds; a subsequent call raises ConflictError."""
    svc, repo, _, _ = _build_service()
    user_id = uuid4()
    repo.seed_recovery_count(user_id, count=1)  # 1 used, 1 remaining

    # Second recovery should succeed.
    result = await svc.recover_streak(user_id)
    assert result["recoveries_remaining"] == 0

    # Third recovery must be rejected.
    with pytest.raises(ConflictError) as exc_info:
        await svc.recover_streak(user_id)
    assert exc_info.value.code == "STREAK_RECOVERY_LIMIT"


# ---------------------------------------------------------------------------
# get_recovery_status
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_recovery_status_fresh_user() -> None:
    """A user with no recovery history reports used=0, remaining=2, can_recover=True."""
    svc, _, _, _ = _build_service()
    user_id = uuid4()

    status = await svc.get_recovery_status(user_id)

    assert status["recoveries_used"] == 0
    assert status["recoveries_remaining"] == 2


@pytest.mark.asyncio
async def test_recovery_status_after_one_use() -> None:
    """After one recovery the status shows used=1, remaining=1."""
    svc, repo, _, _ = _build_service()
    user_id = uuid4()
    repo.seed_recovery_count(user_id, count=1)

    status = await svc.get_recovery_status(user_id)

    assert status["recoveries_used"] == 1
    assert status["recoveries_remaining"] == 1


@pytest.mark.asyncio
async def test_recovery_status_exhausted() -> None:
    """After 2 recoveries both slots are consumed and remaining is 0."""
    svc, repo, _, _ = _build_service()
    user_id = uuid4()
    repo.seed_recovery_count(user_id, count=2)

    status = await svc.get_recovery_status(user_id)

    assert status["recoveries_used"] == 2
    assert status["recoveries_remaining"] == 0

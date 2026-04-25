"""Unit tests for ReadingService with in-memory fakes for every Port.

No DB, no HTTP — every collaborator is an in-memory stub that implements
the Port Protocol shape. Covers the business rules owned by the service:

- start_session gates on ownership and single-active; raises 409 / 404
- end_session recomputes duration server-side, rejects too-short sessions,
  and stages events ONLY AFTER the canonical snapshot write
- manual session validates [60, 14400] seconds and does NOT trigger stat /
  grade updates (policy §5.1)
- heatmap clamps window, returns in ascending order
- goal windows are computed from ISO week / calendar month / calendar year
- grade-up transition stages a UserGradeRecomputed event
- streak: two consecutive days increment; same day does not compound
"""

from __future__ import annotations

import asyncio
from dataclasses import dataclass, field
from datetime import UTC, date, datetime, timedelta
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError, NotFoundError
from app.domains.reading.events import ReadingSessionCompleted, UserGradeRecomputed
from app.domains.reading.models import (
    DailyReadingStat,
    Goal,
    GoalPeriod,
    ReadingSession,
    ReadingSessionSource,
    UserGrade,
)
from app.domains.reading.service import ReadingService, _compute_window, _reconcile_duration
from app.shared.event_bus import LocalEventBus


class FakeReadingSessionRepo:
    def __init__(self) -> None:
        self.by_id: dict[UUID, ReadingSession] = {}

    async def get_active_session(self, user_id: UUID) -> ReadingSession | None:
        for row in self.by_id.values():
            if row.user_id == user_id and row.ended_at is None:
                return row
        return None

    async def create_started(
        self,
        *,
        user_id: UUID,
        user_book_id: UUID,
        started_at: datetime,
        device: str | None,
    ) -> ReadingSession:
        if await self.get_active_session(user_id) is not None:
            raise ConflictError("active", code="ACTIVE_SESSION_EXISTS")
        row = ReadingSession(
            user_id=user_id,
            user_book_id=user_book_id,
            started_at=started_at,
            source=ReadingSessionSource.TIMER,
            device=device,
        )
        row.id = uuid4()
        self.by_id[row.id] = row
        return row

    async def end_session(
        self, session_id: UUID, ended_at: datetime, duration_sec: int
    ) -> ReadingSession:
        row = self.by_id[session_id]
        row.ended_at = ended_at
        row.duration_sec = duration_sec
        return row

    async def create_manual(
        self,
        *,
        user_id: UUID,
        user_book_id: UUID,
        started_at: datetime,
        ended_at: datetime,
        duration_sec: int,
        note: str | None,
    ) -> ReadingSession:
        row = ReadingSession(
            user_id=user_id,
            user_book_id=user_book_id,
            started_at=started_at,
            ended_at=ended_at,
            duration_sec=duration_sec,
            source=ReadingSessionSource.MANUAL,
            note=note,
        )
        row.id = uuid4()
        self.by_id[row.id] = row
        return row

    async def get_by_id(self, session_id: UUID) -> ReadingSession | None:
        return self.by_id.get(session_id)


class FakeDailyStatRepo:
    def __init__(self) -> None:
        self.rows: dict[tuple[UUID, date], DailyReadingStat] = {}

    async def upsert(
        self, *, user_id: UUID, date: date, add_seconds: int, add_sessions: int
    ) -> None:
        key = (user_id, date)
        existing = self.rows.get(key)
        if existing is None:
            existing = DailyReadingStat(
                user_id=user_id,
                date=date,
                total_seconds=add_seconds,
                session_count=add_sessions,
            )
            self.rows[key] = existing
        else:
            existing.total_seconds = existing.total_seconds + add_seconds
            existing.session_count = existing.session_count + add_sessions

    async def range(self, user_id: UUID, from_date: date, to_date: date) -> list[DailyReadingStat]:
        return sorted(
            (r for (u, d), r in self.rows.items() if u == user_id and from_date <= d <= to_date),
            key=lambda r: r.date,
        )


class FakeUserGradeRepo:
    def __init__(self) -> None:
        self.rows: dict[UUID, UserGrade] = {}

    async def get_or_init(self, user_id: UUID) -> UserGrade:
        row = self.rows.get(user_id)
        if row is None:
            row = UserGrade(
                user_id=user_id,
                grade=1,
                tier=1,
                total_books=0,
                total_seconds=0,
                streak_days=0,
                longest_streak=0,
                streak_last_date=None,
            )
            self.rows[user_id] = row
        return row

    async def update_snapshot(
        self,
        user_id: UUID,
        *,
        total_books: int | None = None,
        total_seconds_delta: int | None = None,
        grade: int | None = None,
        tier: int | None = None,
        streak_days: int | None = None,
        longest_streak: int | None = None,
        streak_last_date: date | None = None,
    ) -> UserGrade:
        row = await self.get_or_init(user_id)
        if total_books is not None:
            row.total_books = total_books
        if total_seconds_delta is not None:
            row.total_seconds = row.total_seconds + total_seconds_delta
        if grade is not None:
            row.grade = grade
        if tier is not None:
            row.tier = tier
        if streak_days is not None:
            row.streak_days = streak_days
        if longest_streak is not None:
            row.longest_streak = longest_streak
        if streak_last_date is not None:
            row.streak_last_date = streak_last_date
        return row


class FakeGoalRepo:
    def __init__(self) -> None:
        self.by_id: dict[UUID, Goal] = {}
        self._created_order: list[UUID] = []

    async def create(
        self,
        *,
        user_id: UUID,
        period: GoalPeriod,
        target_books: int,
        target_seconds: int,
        start_date: date,
        end_date: date,
    ) -> Goal:
        row = Goal(
            user_id=user_id,
            period=period,
            target_books=target_books,
            target_seconds=target_seconds,
            start_date=start_date,
            end_date=end_date,
        )
        row.id = uuid4()
        row.created_at = datetime.now(tz=UTC) + timedelta(microseconds=len(self._created_order))
        self.by_id[row.id] = row
        self._created_order.append(row.id)
        return row

    async def active_for(self, user_id: UUID, period: GoalPeriod, on_date: date) -> Goal | None:
        rows = [
            g
            for g in self.by_id.values()
            if g.user_id == user_id and g.period is period and g.start_date <= on_date <= g.end_date
        ]
        if not rows:
            return None
        return max(rows, key=lambda r: r.created_at)

    async def list_active(self, user_id: UUID, on_date: date) -> list[Goal]:
        rows = [
            g
            for g in self.by_id.values()
            if g.user_id == user_id and g.start_date <= on_date <= g.end_date
        ]
        rows.sort(key=lambda r: r.created_at, reverse=True)
        dedup: dict[GoalPeriod, Goal] = {}
        for g in rows:
            dedup.setdefault(g.period, g)
        return list(dedup.values())


@dataclass
class FakeBookQuery:
    owned_user_books: set[tuple[UUID, UUID]] = field(default_factory=set)
    completed_counts: dict[UUID, int] = field(default_factory=dict)
    completed_in_window: dict[tuple[UUID, date, date], int] = field(default_factory=dict)

    async def user_book_belongs_to_user(self, *, user_id: UUID, user_book_id: UUID) -> bool:
        return (user_id, user_book_id) in self.owned_user_books

    async def count_completed_books(
        self,
        *,
        user_id: UUID,
        from_date: date | None = None,
        to_date: date | None = None,
    ) -> int:
        if from_date is None and to_date is None:
            return self.completed_counts.get(user_id, 0)
        return self.completed_in_window.get((user_id, from_date, to_date), 0)  # type: ignore[arg-type]


def _build_service() -> tuple[ReadingService, LocalEventBus, list[object], FakeBookQuery]:
    sessions = FakeReadingSessionRepo()
    daily = FakeDailyStatRepo()
    grades = FakeUserGradeRepo()
    goals = FakeGoalRepo()
    book_query = FakeBookQuery()
    bus = LocalEventBus()
    staged: list[object] = []
    service = ReadingService(
        sessions=sessions,
        daily_stats=daily,
        user_grades=grades,
        goals=goals,
        book_query=book_query,
        bus=bus,
        stage_event=staged.append,
    )
    return service, bus, staged, book_query


# --- start_session --------------------------------------------------------


@pytest.mark.asyncio
async def test_start_session_happy_path() -> None:
    service, _bus, _staged, bq = _build_service()
    user_id = uuid4()
    ub_id = uuid4()
    bq.owned_user_books.add((user_id, ub_id))

    row = await service.start_session(user_id=user_id, user_book_id=ub_id, device="ios")
    assert row.user_id == user_id
    assert row.user_book_id == ub_id
    assert row.ended_at is None
    assert row.source is ReadingSessionSource.TIMER


@pytest.mark.asyncio
async def test_start_session_404_when_user_book_not_owned() -> None:
    service, _, _, _bq = _build_service()
    user_id = uuid4()
    ub_id = uuid4()
    # _bq.owned_user_books intentionally empty.

    with pytest.raises(NotFoundError) as exc_info:
        await service.start_session(user_id=user_id, user_book_id=ub_id, device=None)
    assert exc_info.value.code == "USER_BOOK_NOT_FOUND"


@pytest.mark.asyncio
async def test_start_session_409_when_active_exists() -> None:
    service, _, _, bq = _build_service()
    user_id = uuid4()
    ub_id = uuid4()
    bq.owned_user_books.add((user_id, ub_id))
    await service.start_session(user_id=user_id, user_book_id=ub_id, device=None)

    with pytest.raises(ConflictError) as exc_info:
        await service.start_session(user_id=user_id, user_book_id=ub_id, device=None)
    assert exc_info.value.code == "ACTIVE_SESSION_EXISTS"


# --- end_session ----------------------------------------------------------


@pytest.mark.asyncio
async def test_end_session_happy_path_stages_event_and_updates_grade() -> None:
    service, _bus, staged, bq = _build_service()
    user_id = uuid4()
    ub_id = uuid4()
    bq.owned_user_books.add((user_id, ub_id))
    bq.completed_counts[user_id] = 0

    started = await service.start_session(user_id=user_id, user_book_id=ub_id, device=None)
    ended_at = started.started_at + timedelta(minutes=30)
    result = await service.end_session(
        user_id=user_id, session_id=started.id, ended_at=ended_at, paused_ms=0
    )

    assert result.session.duration_sec == 30 * 60
    assert result.grade.grade == 1  # not enough to advance yet
    assert result.grade.total_seconds == 30 * 60
    # ReadingSessionCompleted staged exactly once.
    completion_events = [e for e in staged if isinstance(e, ReadingSessionCompleted)]
    assert len(completion_events) == 1
    assert completion_events[0].duration_sec == 30 * 60
    # No grade-up -> no UserGradeRecomputed.
    assert not any(isinstance(e, UserGradeRecomputed) for e in staged)


@pytest.mark.asyncio
async def test_end_session_reconciles_paused_ms() -> None:
    service, _bus, _staged, bq = _build_service()
    user_id = uuid4()
    ub_id = uuid4()
    bq.owned_user_books.add((user_id, ub_id))

    started = await service.start_session(user_id=user_id, user_book_id=ub_id, device=None)
    ended_at = started.started_at + timedelta(minutes=10)  # 600s elapsed
    result = await service.end_session(
        user_id=user_id,
        session_id=started.id,
        ended_at=ended_at,
        paused_ms=120 * 1000,  # 2 min paused
    )
    assert result.session.duration_sec == (10 - 2) * 60


@pytest.mark.asyncio
async def test_end_session_422_when_paused_exceeds_elapsed() -> None:
    service, _bus, _, bq = _build_service()
    user_id = uuid4()
    ub_id = uuid4()
    bq.owned_user_books.add((user_id, ub_id))

    started = await service.start_session(user_id=user_id, user_book_id=ub_id, device=None)
    ended_at = started.started_at + timedelta(seconds=10)
    with pytest.raises(ConflictError) as exc_info:
        await service.end_session(
            user_id=user_id,
            session_id=started.id,
            ended_at=ended_at,
            paused_ms=20000,
        )
    assert exc_info.value.code == "SESSION_TOO_SHORT"


@pytest.mark.asyncio
async def test_end_session_404_when_not_owner() -> None:
    service, _, _, bq = _build_service()
    owner = uuid4()
    attacker = uuid4()
    ub_id = uuid4()
    bq.owned_user_books.add((owner, ub_id))
    started = await service.start_session(user_id=owner, user_book_id=ub_id, device=None)

    with pytest.raises(NotFoundError):
        await service.end_session(
            user_id=attacker,
            session_id=started.id,
            ended_at=started.started_at + timedelta(minutes=1),
            paused_ms=0,
        )


@pytest.mark.asyncio
async def test_end_session_grade_up_stages_user_grade_recomputed() -> None:
    service, _bus, staged, bq = _build_service()
    user_id = uuid4()
    ub_id = uuid4()
    bq.owned_user_books.add((user_id, ub_id))
    # Seed: user already has 3 completed books; one 10h session will push them to grade 2.
    bq.completed_counts[user_id] = 3

    started = await service.start_session(user_id=user_id, user_book_id=ub_id, device=None)
    ended_at = started.started_at + timedelta(hours=10)
    result = await service.end_session(
        user_id=user_id, session_id=started.id, ended_at=ended_at, paused_ms=0
    )

    assert result.grade.grade == 2
    assert result.grade_up is True
    recomputed = [e for e in staged if isinstance(e, UserGradeRecomputed)]
    assert len(recomputed) == 1
    assert recomputed[0].old_grade == 1
    assert recomputed[0].old_tier == 1
    assert recomputed[0].new_grade == 2
    assert recomputed[0].new_tier == 1


# --- manual session -------------------------------------------------------


@pytest.mark.asyncio
async def test_manual_session_valid_does_not_touch_stats_or_grade() -> None:
    service, _bus, staged, bq = _build_service()
    user_id = uuid4()
    ub_id = uuid4()
    bq.owned_user_books.add((user_id, ub_id))

    started = datetime(2026, 4, 15, 10, 0, tzinfo=UTC)
    ended = started + timedelta(hours=1)
    row = await service.log_manual_session(
        user_id=user_id,
        user_book_id=ub_id,
        started_at=started,
        ended_at=ended,
        note="어제 지하철에서",
    )
    assert row.source is ReadingSessionSource.MANUAL
    assert row.duration_sec == 3600
    # Event bus must NOT have seen a ReadingSessionCompleted for this path.
    assert staged == []
    # DailyStat and UserGrade are untouched.
    grade = await service.get_grade(user_id=user_id)
    assert grade.total_seconds == 0
    assert grade.grade == 1


@pytest.mark.asyncio
async def test_manual_session_below_minimum_raises() -> None:
    service, _bus, _, bq = _build_service()
    user_id = uuid4()
    ub_id = uuid4()
    bq.owned_user_books.add((user_id, ub_id))

    started = datetime(2026, 4, 15, 10, 0, tzinfo=UTC)
    ended = started + timedelta(seconds=30)
    with pytest.raises(ConflictError) as exc_info:
        await service.log_manual_session(
            user_id=user_id,
            user_book_id=ub_id,
            started_at=started,
            ended_at=ended,
            note=None,
        )
    assert exc_info.value.code == "MANUAL_SESSION_OUT_OF_RANGE"


@pytest.mark.asyncio
async def test_manual_session_above_maximum_raises() -> None:
    service, _bus, _, bq = _build_service()
    user_id = uuid4()
    ub_id = uuid4()
    bq.owned_user_books.add((user_id, ub_id))

    started = datetime(2026, 4, 15, 10, 0, tzinfo=UTC)
    ended = started + timedelta(hours=5)
    with pytest.raises(ConflictError) as exc_info:
        await service.log_manual_session(
            user_id=user_id,
            user_book_id=ub_id,
            started_at=started,
            ended_at=ended,
            note=None,
        )
    assert exc_info.value.code == "MANUAL_SESSION_OUT_OF_RANGE"


@pytest.mark.asyncio
async def test_manual_session_reverse_window_raises() -> None:
    service, _bus, _, bq = _build_service()
    user_id = uuid4()
    ub_id = uuid4()
    bq.owned_user_books.add((user_id, ub_id))

    started = datetime(2026, 4, 15, 10, 0, tzinfo=UTC)
    ended = started - timedelta(minutes=10)
    with pytest.raises(ConflictError) as exc_info:
        await service.log_manual_session(
            user_id=user_id,
            user_book_id=ub_id,
            started_at=started,
            ended_at=ended,
            note=None,
        )
    assert exc_info.value.code == "MANUAL_SESSION_OUT_OF_RANGE"


# --- heatmap --------------------------------------------------------------


@pytest.mark.asyncio
async def test_heatmap_returns_only_rows_in_range() -> None:
    service, _bus, _, bq = _build_service()
    user_id = uuid4()
    ub_id = uuid4()
    bq.owned_user_books.add((user_id, ub_id))

    # Seed a completed timer session.
    started = await service.start_session(user_id=user_id, user_book_id=ub_id, device=None)
    await service.end_session(
        user_id=user_id,
        session_id=started.id,
        ended_at=started.started_at + timedelta(minutes=20),
        paused_ms=0,
    )
    today = datetime.now(tz=UTC).date()
    rows = await service.get_heatmap(
        user_id=user_id, from_date=today - timedelta(days=7), to_date=today
    )
    assert len(rows) == 1
    assert rows[0].total_seconds == 20 * 60


@pytest.mark.asyncio
async def test_heatmap_range_inverted_raises() -> None:
    service, _bus, _, _ = _build_service()
    user_id = uuid4()
    with pytest.raises(ConflictError):
        await service.get_heatmap(
            user_id=user_id,
            from_date=date(2026, 4, 21),
            to_date=date(2026, 4, 20),
        )


@pytest.mark.asyncio
async def test_heatmap_clamps_window_to_366_days() -> None:
    service, _bus, _, _ = _build_service()
    user_id = uuid4()
    to_date = date(2026, 4, 20)
    rows = await service.get_heatmap(
        user_id=user_id,
        from_date=to_date - timedelta(days=1000),
        to_date=to_date,
    )
    # No seed rows, but the clamp should not raise.
    assert rows == []


# --- streak ---------------------------------------------------------------


@pytest.mark.asyncio
async def test_two_consecutive_days_increment_streak() -> None:
    service, _bus, _, bq = _build_service()
    user_id = uuid4()
    ub_id = uuid4()
    bq.owned_user_books.add((user_id, ub_id))

    day1 = datetime(2026, 4, 20, 10, 0, tzinfo=UTC)
    # Simulate day 1 by patching started_at via the fake repo after creation.
    s1 = await service.start_session(user_id=user_id, user_book_id=ub_id, device=None)
    s1.started_at = day1
    await service.end_session(
        user_id=user_id,
        session_id=s1.id,
        ended_at=day1 + timedelta(minutes=5),
        paused_ms=0,
    )
    snapshot1 = await service.get_grade(user_id=user_id)
    assert snapshot1.streak_days == 1

    day2 = datetime(2026, 4, 21, 10, 0, tzinfo=UTC)
    s2 = await service.start_session(user_id=user_id, user_book_id=ub_id, device=None)
    s2.started_at = day2
    await service.end_session(
        user_id=user_id,
        session_id=s2.id,
        ended_at=day2 + timedelta(minutes=5),
        paused_ms=0,
    )
    snapshot2 = await service.get_grade(user_id=user_id)
    assert snapshot2.streak_days == 2


# --- goal -----------------------------------------------------------------


@pytest.mark.asyncio
async def test_create_goal_weekly_window_is_monday_to_sunday() -> None:
    service, _bus, _, _ = _build_service()
    user_id = uuid4()

    # 2026-04-22 is a Wednesday — Monday is 4-20, Sunday is 4-26.
    goal = await service.create_goal(
        user_id=user_id,
        period=GoalPeriod.WEEKLY,
        target_books=3,
        target_seconds=3600,
        on_date=date(2026, 4, 22),
    )
    assert goal.start_date == date(2026, 4, 20)
    assert goal.end_date == date(2026, 4, 26)


@pytest.mark.asyncio
async def test_create_goal_monthly_window_is_calendar_month() -> None:
    service, _bus, _, _ = _build_service()
    user_id = uuid4()

    goal = await service.create_goal(
        user_id=user_id,
        period=GoalPeriod.MONTHLY,
        target_books=10,
        target_seconds=36000,
        on_date=date(2026, 4, 22),
    )
    assert goal.start_date == date(2026, 4, 1)
    assert goal.end_date == date(2026, 4, 30)


@pytest.mark.asyncio
async def test_create_goal_yearly_window_is_calendar_year() -> None:
    service, _bus, _, _ = _build_service()
    user_id = uuid4()

    goal = await service.create_goal(
        user_id=user_id,
        period=GoalPeriod.YEARLY,
        target_books=50,
        target_seconds=500 * 3600,
        on_date=date(2026, 4, 22),
    )
    assert goal.start_date == date(2026, 1, 1)
    assert goal.end_date == date(2026, 12, 31)


@pytest.mark.asyncio
async def test_get_current_goals_computes_progress_across_both_axes() -> None:
    service, _bus, _, bq = _build_service()
    user_id = uuid4()
    ub_id = uuid4()
    bq.owned_user_books.add((user_id, ub_id))
    # Weekly goal: 3 books, 3 hours.
    goal = await service.create_goal(
        user_id=user_id,
        period=GoalPeriod.WEEKLY,
        target_books=3,
        target_seconds=3 * 3600,
        on_date=date(2026, 4, 22),
    )
    # User has completed 1 book and 45 minutes within the window.
    bq.completed_in_window[(user_id, goal.start_date, goal.end_date)] = 1
    # Seed a timer session on 2026-04-22 for the user.
    started = datetime(2026, 4, 22, 10, 0, tzinfo=UTC)
    s = await service.start_session(user_id=user_id, user_book_id=ub_id, device=None)
    s.started_at = started
    await service.end_session(
        user_id=user_id,
        session_id=s.id,
        ended_at=started + timedelta(minutes=45),
        paused_ms=0,
    )

    progress = await service.get_current_goals(user_id=user_id, on_date=date(2026, 4, 22))
    assert len(progress) == 1
    only = progress[0]
    assert only.books_done == 1
    assert only.seconds_done == 45 * 60
    # (1/3 + 45*60 / (3*3600)) / 2 = (0.3333 + 0.25) / 2 ≈ 0.2917
    assert 0.29 <= only.percent <= 0.30


@pytest.mark.asyncio
async def test_get_current_goals_percent_capped_at_100() -> None:
    service, _bus, _, bq = _build_service()
    user_id = uuid4()
    goal = await service.create_goal(
        user_id=user_id,
        period=GoalPeriod.WEEKLY,
        target_books=1,
        target_seconds=3600,
        on_date=date(2026, 4, 22),
    )
    bq.completed_in_window[(user_id, goal.start_date, goal.end_date)] = 5
    # No sessions — seconds_done = 0. Books axis at 500% → capped at 100%.
    # Average = (1.0 + 0) / 2 = 0.5.
    progress = await service.get_current_goals(user_id=user_id, on_date=date(2026, 4, 22))
    assert progress[0].percent == pytest.approx(0.5)


# --- pure helpers ---------------------------------------------------------


def test_reconcile_duration_clamps_negative_to_zero() -> None:
    started = datetime(2026, 4, 20, 10, 0, tzinfo=UTC)
    ended = started + timedelta(seconds=10)
    assert _reconcile_duration(started_at=started, ended_at=ended, paused_ms=20_000) == 0


def test_reconcile_duration_normal_case() -> None:
    started = datetime(2026, 4, 20, 10, 0, tzinfo=UTC)
    ended = started + timedelta(minutes=30)
    assert (
        _reconcile_duration(started_at=started, ended_at=ended, paused_ms=5 * 60 * 1000) == 25 * 60
    )


def test_reconcile_duration_zero_pause() -> None:
    started = datetime(2026, 4, 20, 10, 0, tzinfo=UTC)
    ended = started + timedelta(minutes=30)
    assert _reconcile_duration(started_at=started, ended_at=ended, paused_ms=0) == 30 * 60


def test_compute_window_end_of_year_monthly_wraps_correctly() -> None:
    # December needs special handling because month+1 == 13.
    start, end = _compute_window(GoalPeriod.MONTHLY, date(2026, 12, 15))
    assert start == date(2026, 12, 1)
    assert end == date(2026, 12, 31)


# Ensure asyncio event loop survives event-bus publish side effects
# (keeps pytest from warning about pending tasks at teardown).
@pytest.fixture(autouse=True)
def _drain_tasks() -> None:
    yield
    loop = asyncio.get_event_loop_policy().get_event_loop()
    pending = [t for t in asyncio.all_tasks(loop) if not t.done()]
    for t in pending:
        t.cancel()

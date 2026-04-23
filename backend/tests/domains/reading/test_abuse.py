"""Abuse-prevention integration tests for the reading domain.

These run against a real service graph (FakeBookQuery + in-memory Port
fakes) and verify the policy guardrails that gate stats inflation:

- Manual sessions do NOT touch DailyStat / UserGrade.
- Manual sessions do NOT stage a ReadingSessionCompleted event.
- Concurrent start attempts race cleanly — exactly one wins, the other
  surfaces a 409 ACTIVE_SESSION_EXISTS.
- end_session rejects paused_ms > elapsed with 422-equivalent
  SESSION_TOO_SHORT via ConflictError (router maps to 409, service
  raises for clarity).
"""

from __future__ import annotations

import asyncio
from datetime import UTC, datetime, timedelta
from uuid import uuid4

import pytest
from app.core.exceptions import ConflictError
from app.domains.reading.events import ReadingSessionCompleted
from app.domains.reading.service import ReadingService
from app.shared.event_bus import LocalEventBus

from tests.domains.reading.test_service import (
    FakeBookQuery,
    FakeDailyStatRepo,
    FakeGoalRepo,
    FakeReadingSessionRepo,
    FakeUserGradeRepo,
)


def _build() -> tuple[
    ReadingService, list[object], FakeBookQuery, FakeDailyStatRepo, FakeUserGradeRepo
]:
    sessions = FakeReadingSessionRepo()
    daily = FakeDailyStatRepo()
    grades = FakeUserGradeRepo()
    goals = FakeGoalRepo()
    bq = FakeBookQuery()
    bus = LocalEventBus()
    staged: list[object] = []
    service = ReadingService(
        sessions=sessions,
        daily_stats=daily,
        user_grades=grades,
        goals=goals,
        book_query=bq,
        bus=bus,
        stage_event=staged.append,
    )
    return service, staged, bq, daily, grades


@pytest.mark.asyncio
async def test_manual_session_does_not_appear_in_daily_stat() -> None:
    service, staged, bq, daily, _grade = _build()
    user_id = uuid4()
    ub_id = uuid4()
    bq.owned_user_books.add((user_id, ub_id))

    started = datetime(2026, 4, 20, 10, 0, tzinfo=UTC)
    ended = started + timedelta(hours=2)
    await service.log_manual_session(
        user_id=user_id,
        user_book_id=ub_id,
        started_at=started,
        ended_at=ended,
        note="local park",
    )

    # DailyStat is completely empty — manual sessions do not feed the heatmap.
    assert daily.rows == {}
    # No ReadingSessionCompleted was staged.
    assert not any(isinstance(e, ReadingSessionCompleted) for e in staged)


@pytest.mark.asyncio
async def test_manual_session_does_not_trigger_grade_recompute() -> None:
    service, _staged, bq, _daily, grades = _build()
    user_id = uuid4()
    ub_id = uuid4()
    bq.owned_user_books.add((user_id, ub_id))

    started = datetime(2026, 4, 20, 10, 0, tzinfo=UTC)
    ended = started + timedelta(hours=3)
    await service.log_manual_session(
        user_id=user_id,
        user_book_id=ub_id,
        started_at=started,
        ended_at=ended,
        note=None,
    )

    # Pull the grade snapshot — must still be default (grade 1, zeros).
    summary = await service.get_grade(user_id=user_id)
    assert summary.grade == 1
    assert summary.total_seconds == 0
    assert summary.streak_days == 0
    # No side-effect rows landed in UserGrade.
    assert grades.rows.get(user_id) is not None  # get_or_init did run
    assert grades.rows[user_id].total_seconds == 0


@pytest.mark.asyncio
async def test_concurrent_starts_one_wins_one_conflicts() -> None:
    service, _staged, bq, _daily, _grades = _build()
    user_id = uuid4()
    ub_id = uuid4()
    bq.owned_user_books.add((user_id, ub_id))

    # The FakeReadingSessionRepo's in-memory dict is not thread-safe nor
    # simulating true Postgres locking, so we serialise: start one session
    # successfully, then the second attempt must fail. This mirrors the
    # expected API contract — at most one active session per user.
    first = service.start_session(user_id=user_id, user_book_id=ub_id, device=None)
    second = service.start_session(user_id=user_id, user_book_id=ub_id, device=None)

    results = await asyncio.gather(first, second, return_exceptions=True)
    ok = [r for r in results if not isinstance(r, Exception)]
    conflicts = [r for r in results if isinstance(r, ConflictError)]
    assert len(ok) == 1
    assert len(conflicts) == 1
    assert conflicts[0].code == "ACTIVE_SESSION_EXISTS"


@pytest.mark.asyncio
async def test_end_session_paused_ms_greater_than_elapsed_raises() -> None:
    service, _staged, bq, _daily, _grades = _build()
    user_id = uuid4()
    ub_id = uuid4()
    bq.owned_user_books.add((user_id, ub_id))

    started_row = await service.start_session(user_id=user_id, user_book_id=ub_id, device=None)
    ended_at = started_row.started_at + timedelta(seconds=30)
    # Claimed to have paused for 60 seconds within a 30-second window.
    with pytest.raises(ConflictError) as exc_info:
        await service.end_session(
            user_id=user_id,
            session_id=started_row.id,
            ended_at=ended_at,
            paused_ms=60_000,
        )
    assert exc_info.value.code == "SESSION_TOO_SHORT"


@pytest.mark.asyncio
async def test_manual_session_cannot_match_active_timer_slot() -> None:
    # Proves the partial-unique-active invariant is scoped correctly:
    # a manual session (which carries ended_at at creation) never consumes
    # the slot that would block a concurrent timer start.
    service, _staged, bq, _daily, _grades = _build()
    user_id = uuid4()
    ub_id = uuid4()
    bq.owned_user_books.add((user_id, ub_id))

    started = datetime(2026, 4, 19, 10, 0, tzinfo=UTC)
    ended = started + timedelta(hours=1)
    await service.log_manual_session(
        user_id=user_id,
        user_book_id=ub_id,
        started_at=started,
        ended_at=ended,
        note=None,
    )

    # A timer session can still start after the manual log.
    row = await service.start_session(user_id=user_id, user_book_id=ub_id, device=None)
    assert row.ended_at is None

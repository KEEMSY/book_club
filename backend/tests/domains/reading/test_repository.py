"""Integration tests for the reading repository adapters (async Postgres).

Verifies the structural invariants M3 depends on:
- create_started is idempotent on a single active session (partial unique)
- end_session is noop on a already-ended row, raises on unknown id
- DailyStat.upsert accumulates on conflict
- UserGrade.get_or_init is idempotent
- Goal.active_for returns the in-window row, None otherwise
"""

from __future__ import annotations

from datetime import UTC, date, datetime, timedelta
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError, NotFoundError
from app.domains.auth.models import AuthProvider
from app.domains.auth.repository import UserRepository
from app.domains.book.models import BookSource
from app.domains.book.repository import BookRepository, UserBookRepository
from app.domains.reading.models import GoalPeriod
from app.domains.reading.repository import (
    DailyStatRepository,
    GoalRepository,
    ReadingSessionRepository,
    UserGradeRepository,
)
from sqlalchemy.ext.asyncio import AsyncSession


async def _create_user_and_user_book(session: AsyncSession, *, sub: str) -> tuple[UUID, UUID]:
    user_repo = UserRepository(session)
    user = await user_repo.create(
        provider=AuthProvider.KAKAO,
        sub=sub,
        email=None,
        nickname=f"user-{sub}",
        profile_image_url=None,
    )
    book_repo = BookRepository(session)
    book = await book_repo.upsert_by_isbn(
        isbn13=f"97889374{hash(sub) % 100000:05d}",
        title=f"book-{sub}",
        author="a",
        publisher=None,
        cover_url=None,
        description=None,
        source=BookSource.NAVER,
    )
    ub_repo = UserBookRepository(session)
    ub = await ub_repo.create(user_id=user.id, book_id=book.id)
    return (user.id, ub.id)


@pytest.mark.asyncio
async def test_create_started_conflict_when_active_exists(session: AsyncSession) -> None:
    user_id, ub_id = await _create_user_and_user_book(session, sub="rs-conflict")
    repo = ReadingSessionRepository(session)

    started = datetime.now(tz=UTC)
    first = await repo.create_started(
        user_id=user_id, user_book_id=ub_id, started_at=started, device=None
    )
    assert first.ended_at is None

    # Second start for the same user while the first is still active.
    with pytest.raises(ConflictError) as exc_info:
        await repo.create_started(
            user_id=user_id,
            user_book_id=ub_id,
            started_at=started + timedelta(seconds=1),
            device=None,
        )
    assert exc_info.value.code == "ACTIVE_SESSION_EXISTS"


@pytest.mark.asyncio
async def test_end_session_stamps_duration_and_handles_missing(session: AsyncSession) -> None:
    user_id, ub_id = await _create_user_and_user_book(session, sub="rs-end")
    repo = ReadingSessionRepository(session)

    start = datetime.now(tz=UTC)
    created = await repo.create_started(
        user_id=user_id, user_book_id=ub_id, started_at=start, device="ios"
    )
    end = start + timedelta(minutes=30)
    updated = await repo.end_session(created.id, end, 30 * 60)
    assert updated.ended_at == end
    assert updated.duration_sec == 30 * 60

    # Unknown id -> NotFoundError.
    with pytest.raises(NotFoundError):
        await repo.end_session(uuid4(), end, 60)


@pytest.mark.asyncio
async def test_end_session_on_already_ended_is_idempotent_noop(session: AsyncSession) -> None:
    user_id, ub_id = await _create_user_and_user_book(session, sub="rs-idem")
    repo = ReadingSessionRepository(session)

    start = datetime.now(tz=UTC)
    created = await repo.create_started(
        user_id=user_id, user_book_id=ub_id, started_at=start, device=None
    )
    end = start + timedelta(minutes=10)
    first = await repo.end_session(created.id, end, 10 * 60)

    # Second end -> same row, first duration preserved.
    second = await repo.end_session(created.id, end + timedelta(minutes=5), 99999)
    assert second.id == first.id
    assert second.duration_sec == 10 * 60


@pytest.mark.asyncio
async def test_create_manual_does_not_collide_with_active_timer(session: AsyncSession) -> None:
    # Manual sessions always have ended_at set so they do not consume the
    # partial-unique-active slot — proving the guard is scoped correctly.
    user_id, ub_id = await _create_user_and_user_book(session, sub="rs-manual")
    repo = ReadingSessionRepository(session)

    start = datetime.now(tz=UTC)
    await repo.create_started(user_id=user_id, user_book_id=ub_id, started_at=start, device=None)

    manual_start = start - timedelta(days=1)
    manual_end = manual_start + timedelta(minutes=30)
    manual = await repo.create_manual(
        user_id=user_id,
        user_book_id=ub_id,
        started_at=manual_start,
        ended_at=manual_end,
        duration_sec=30 * 60,
        note="어제 읽음",
    )
    assert manual.ended_at == manual_end


@pytest.mark.asyncio
async def test_daily_stat_upsert_accumulates(session: AsyncSession) -> None:
    user_id, _ = await _create_user_and_user_book(session, sub="ds-acc")
    repo = DailyStatRepository(session)
    today = date(2026, 4, 20)

    await repo.upsert(user_id=user_id, date=today, add_seconds=300, add_sessions=1)
    await repo.upsert(user_id=user_id, date=today, add_seconds=600, add_sessions=2)
    rows = await repo.range(user_id, today, today)
    assert len(rows) == 1
    assert rows[0].total_seconds == 900
    assert rows[0].session_count == 3


@pytest.mark.asyncio
async def test_daily_stat_range_ordering_and_window(session: AsyncSession) -> None:
    user_id, _ = await _create_user_and_user_book(session, sub="ds-range")
    repo = DailyStatRepository(session)
    d1 = date(2026, 4, 18)
    d2 = date(2026, 4, 19)
    d3 = date(2026, 4, 20)
    d4 = date(2026, 4, 21)
    for d in (d1, d2, d3, d4):
        await repo.upsert(user_id=user_id, date=d, add_seconds=60, add_sessions=1)

    rows = await repo.range(user_id, d2, d3)
    assert [r.date for r in rows] == [d2, d3]


@pytest.mark.asyncio
async def test_user_grade_get_or_init_idempotent(session: AsyncSession) -> None:
    user_id, _ = await _create_user_and_user_book(session, sub="ug-init")
    repo = UserGradeRepository(session)

    first = await repo.get_or_init(user_id)
    assert first.grade == 1
    assert first.total_books == 0

    second = await repo.get_or_init(user_id)
    assert second.grade == 1


@pytest.mark.asyncio
async def test_user_grade_update_snapshot_applies_all_fields(session: AsyncSession) -> None:
    user_id, _ = await _create_user_and_user_book(session, sub="ug-update")
    repo = UserGradeRepository(session)
    await repo.get_or_init(user_id)

    updated = await repo.update_snapshot(
        user_id,
        total_books=3,
        total_seconds_delta=10 * 3600,
        grade=2,
        streak_days=5,
        longest_streak=7,
        streak_last_date=date(2026, 4, 20),
    )
    assert updated.total_books == 3
    assert updated.total_seconds == 10 * 3600
    assert updated.grade == 2
    assert updated.streak_days == 5
    assert updated.longest_streak == 7
    assert updated.streak_last_date == date(2026, 4, 20)


@pytest.mark.asyncio
async def test_goal_active_for_inside_and_outside_window(session: AsyncSession) -> None:
    user_id, _ = await _create_user_and_user_book(session, sub="g-active")
    repo = GoalRepository(session)

    goal = await repo.create(
        user_id=user_id,
        period=GoalPeriod.WEEKLY,
        target_books=1,
        target_seconds=3600,
        start_date=date(2026, 4, 20),
        end_date=date(2026, 4, 26),
    )

    inside = await repo.active_for(user_id, GoalPeriod.WEEKLY, date(2026, 4, 22))
    assert inside is not None
    assert inside.id == goal.id

    before = await repo.active_for(user_id, GoalPeriod.WEEKLY, date(2026, 4, 19))
    assert before is None

    after = await repo.active_for(user_id, GoalPeriod.WEEKLY, date(2026, 4, 27))
    assert after is None


@pytest.mark.asyncio
async def test_goal_list_active_dedupes_by_period_newest_wins(session: AsyncSession) -> None:
    user_id, _ = await _create_user_and_user_book(session, sub="g-list")
    repo = GoalRepository(session)

    base = datetime(2026, 4, 20, 12, 0, tzinfo=UTC)
    older = await repo.create(
        user_id=user_id,
        period=GoalPeriod.WEEKLY,
        target_books=1,
        target_seconds=3600,
        start_date=date(2026, 4, 20),
        end_date=date(2026, 4, 26),
    )
    older.created_at = base
    await session.flush()

    newer = await repo.create(
        user_id=user_id,
        period=GoalPeriod.WEEKLY,
        target_books=3,
        target_seconds=3 * 3600,
        start_date=date(2026, 4, 20),
        end_date=date(2026, 4, 26),
    )
    newer.created_at = base + timedelta(minutes=1)
    await session.flush()

    monthly = await repo.create(
        user_id=user_id,
        period=GoalPeriod.MONTHLY,
        target_books=10,
        target_seconds=30 * 3600,
        start_date=date(2026, 4, 1),
        end_date=date(2026, 4, 30),
    )
    monthly.created_at = base + timedelta(minutes=2)
    await session.flush()

    rows = await repo.list_active(user_id, date(2026, 4, 22))
    ids = {r.id for r in rows}
    assert newer.id in ids
    assert older.id not in ids
    assert monthly.id in ids
    assert len(rows) == 2

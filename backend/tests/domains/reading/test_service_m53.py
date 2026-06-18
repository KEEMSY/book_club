"""Unit tests for M53 — Pro-only advanced reading statistics.

Every collaborator is an in-memory fake implementing the relevant Port shape;
no DB or HTTP is touched.  The suite covers the Pro gate and the four
advanced-stats aggregations surfaced by ``ReadingService.get_advanced_stats``.
"""

from __future__ import annotations

from datetime import UTC, date, datetime
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import PermissionDeniedError
from app.domains.reading.service import ReadingService
from app.shared.event_bus import LocalEventBus


class FakeSubscriptionQuery:
    """Returns a fixed Pro flag for any user."""

    def __init__(self, *, pro: bool) -> None:
        self._pro = pro

    async def is_pro(self, user_id: UUID) -> bool:
        return self._pro


class FakeAdvancedStatsRepo:
    """Fake ReadingStatsRepository covering only the advanced-stats queries.

    ``get_genre_distribution`` derives ``pct`` from the configured counts the
    same way the real repository does, so the 100%-sum property is genuinely
    exercised rather than hard-coded.
    """

    def __init__(
        self,
        *,
        speed_trend: list[dict[str, object]] | None = None,
        genre_counts: list[tuple[str, int]] | None = None,
        yearly_counts: dict[int, int] | None = None,
        longest_streak: int = 0,
    ) -> None:
        self._speed_trend = speed_trend or []
        self._genre_counts = genre_counts or []
        self._yearly_counts = yearly_counts or {}
        self._longest_streak = longest_streak

    async def get_speed_trend(self, user_id: UUID, weeks: int = 4) -> list[dict[str, object]]:
        return self._speed_trend

    async def get_genre_distribution(self, user_id: UUID) -> list[dict[str, object]]:
        total = sum(c for _, c in self._genre_counts)
        if total == 0:
            return []
        return [{"genre": g, "count": c, "pct": c / total * 100.0} for g, c in self._genre_counts]

    async def get_yearly_reading_count(self, user_id: UUID, year: int) -> int:
        return self._yearly_counts.get(year, 0)

    async def get_longest_streak(self, user_id: UUID) -> int:
        return self._longest_streak


def _build_service(
    *,
    pro: bool = True,
    wire_subscription: bool = True,
    stats_repo: FakeAdvancedStatsRepo | None = None,
) -> ReadingService:
    subscription_query = FakeSubscriptionQuery(pro=pro) if wire_subscription else None
    return ReadingService(
        sessions=object(),  # type: ignore[arg-type]
        daily_stats=object(),  # type: ignore[arg-type]
        user_grades=object(),  # type: ignore[arg-type]
        goals=object(),  # type: ignore[arg-type]
        book_query=object(),  # type: ignore[arg-type]
        bus=LocalEventBus(),
        stage_event=lambda _event: None,
        bookmark_repo=object(),  # type: ignore[arg-type]
        stats_repo=stats_repo or FakeAdvancedStatsRepo(),  # type: ignore[arg-type]
        subscription_query=subscription_query,  # type: ignore[arg-type]
    )


@pytest.mark.asyncio
async def test_advanced_stats_pro_user_returns_data() -> None:
    current_year = datetime.now(tz=UTC).year
    repo = FakeAdvancedStatsRepo(
        speed_trend=[{"week_start": date(2026, 6, 1), "minutes_per_page": 2.5}],
        genre_counts=[("소설", 3), ("에세이", 1)],
        yearly_counts={current_year: 5, current_year - 1: 2},
        longest_streak=12,
    )
    service = _build_service(pro=True, stats_repo=repo)

    stats = await service.get_advanced_stats(user_id=uuid4())

    assert len(stats.speed_trend) == 1
    assert len(stats.genre_distribution) == 2
    assert stats.longest_streak_days == 12


@pytest.mark.asyncio
async def test_advanced_stats_non_pro_raises_pro_required() -> None:
    service = _build_service(pro=False)

    with pytest.raises(PermissionDeniedError) as exc:
        await service.get_advanced_stats(user_id=uuid4())
    assert exc.value.code == "PRO_REQUIRED"
    assert exc.value.status_code == 403


@pytest.mark.asyncio
async def test_advanced_stats_without_subscription_port_fails_closed() -> None:
    # No subscription_query wired → treated as non-Pro so the gate never leaks.
    service = _build_service(wire_subscription=False)

    with pytest.raises(PermissionDeniedError) as exc:
        await service.get_advanced_stats(user_id=uuid4())
    assert exc.value.code == "PRO_REQUIRED"


@pytest.mark.asyncio
async def test_speed_trend_maps_and_rounds_weekly_points() -> None:
    repo = FakeAdvancedStatsRepo(
        speed_trend=[
            {"week_start": date(2026, 5, 25), "minutes_per_page": 1.23456},
            {"week_start": date(2026, 6, 1), "minutes_per_page": 3.0},
        ],
    )
    service = _build_service(pro=True, stats_repo=repo)

    stats = await service.get_advanced_stats(user_id=uuid4())

    assert [p.week_start for p in stats.speed_trend] == [
        date(2026, 5, 25),
        date(2026, 6, 1),
    ]
    assert stats.speed_trend[0].minutes_per_page == 1.23  # rounded to 2 dp


@pytest.mark.asyncio
async def test_genre_distribution_pct_sums_to_100() -> None:
    repo = FakeAdvancedStatsRepo(
        genre_counts=[("소설", 5), ("에세이", 3), ("과학", 2)],
    )
    service = _build_service(pro=True, stats_repo=repo)

    stats = await service.get_advanced_stats(user_id=uuid4())

    assert sum(g.count for g in stats.genre_distribution) == 10
    assert sum(g.pct for g in stats.genre_distribution) == pytest.approx(100.0, abs=0.1)


@pytest.mark.asyncio
async def test_yearly_comparison_contains_current_and_previous_year() -> None:
    current_year = datetime.now(tz=UTC).year
    prev_year = current_year - 1
    repo = FakeAdvancedStatsRepo(yearly_counts={current_year: 7, prev_year: 4})
    service = _build_service(pro=True, stats_repo=repo)

    stats = await service.get_advanced_stats(user_id=uuid4())

    assert stats.yearly_comparison == {str(current_year): 7, str(prev_year): 4}


@pytest.mark.asyncio
async def test_longest_streak_passes_through() -> None:
    repo = FakeAdvancedStatsRepo(longest_streak=42)
    service = _build_service(pro=True, stats_repo=repo)

    stats = await service.get_advanced_stats(user_id=uuid4())

    assert stats.longest_streak_days == 42


@pytest.mark.asyncio
async def test_advanced_stats_empty_data_returns_empty_collections() -> None:
    service = _build_service(pro=True, stats_repo=FakeAdvancedStatsRepo())

    stats = await service.get_advanced_stats(user_id=uuid4())

    current_year = datetime.now(tz=UTC).year
    assert stats.speed_trend == []
    assert stats.genre_distribution == []
    assert stats.yearly_comparison == {str(current_year): 0, str(current_year - 1): 0}
    assert stats.longest_streak_days == 0

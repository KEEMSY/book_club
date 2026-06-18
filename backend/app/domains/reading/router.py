"""HTTP surface for the reading domain — /reading/*.

Handlers are thin DTO -> service -> DTO adapters. Business decisions live
in ``service.py``; domain exceptions translate to HTTP via the global
handler registered in ``app.core.exceptions`` (CLAUDE.md §3.1).
"""

from __future__ import annotations

import json
import logging
from datetime import UTC, date, datetime
from typing import Annotated
from uuid import UUID

import redis.asyncio as aioredis
from fastapi import APIRouter, Depends, HTTPException, Query, status

from app.core.cache import get_redis
from app.core.deps import get_current_user_id
from app.domains.reading.models import GoalPeriod
from app.domains.reading.providers import get_reading_service
from app.domains.reading.schemas import (
    AdvancedStatsResponse,
    BookmarkPublic,
    CreateBookmarkRequest,
    CreateGoalRequest,
    DailySessionPublic,
    DailySessionsResponse,
    EndSessionRequest,
    FormatBreakdownPublic,
    GenreBreakdownPublic,
    GenreDistributionItem,
    GoalProgressPublic,
    GoalPublic,
    GradeSummaryPublic,
    HeatmapDayPublic,
    HeatmapResponse,
    ManualSessionRequest,
    MilestoneItem,
    MilestonesResponse,
    MilestoneType,
    MonthlyHoursPublic,
    MonthlyRecapResponse,
    ReadingRecapResponse,
    ReadingSessionPublic,
    ReadingSpeedStatsPublic,
    ReadingStatsResponse,
    ReadingYearStatsPublic,
    RecapBook,
    RecapCard,
    RecapCardType,
    SessionCompletionResponse,
    SpeedTrendItem,
    StartSessionRequest,
)
from app.domains.reading.service import ReadingService
from app.domains.referral.providers import get_referral_service
from app.domains.referral.service import ReferralService

logger = logging.getLogger(__name__)

_STATS_CACHE_TTL = 60 * 60 * 24  # 24 hours

router = APIRouter(prefix="/reading", tags=["reading"])

# Separate router for /me/* endpoints that must not carry the /reading prefix.
me_router = APIRouter(tags=["reading"])


@router.post(
    "/sessions/start",
    response_model=ReadingSessionPublic,
    status_code=status.HTTP_201_CREATED,
)
async def start_session(
    body: StartSessionRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReadingService, Depends(get_reading_service)],
) -> ReadingSessionPublic:
    row = await service.start_session(
        user_id=UUID(user_id),
        user_book_id=body.user_book_id,
        device=body.device,
    )
    return ReadingSessionPublic.from_row(row)


@router.get("/sessions/active", response_model=ReadingSessionPublic | None)
async def get_active_session(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReadingService, Depends(get_reading_service)],
) -> ReadingSessionPublic | None:
    row = await service.get_active_session(UUID(user_id))
    return ReadingSessionPublic.from_row(row) if row else None


@router.post("/sessions/{session_id}/end", response_model=SessionCompletionResponse)
async def end_session(
    session_id: UUID,
    body: EndSessionRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReadingService, Depends(get_reading_service)],
    referral_service: Annotated[ReferralService, Depends(get_referral_service)],
) -> SessionCompletionResponse:
    completion = await service.end_session(
        user_id=UUID(user_id),
        session_id=session_id,
        ended_at=body.ended_at,
        paused_ms=body.paused_ms,
    )
    # Post-process: complete any pending referral when the session is long enough.
    # Always a no-op if the user has no open referral row.
    await referral_service.complete_referral_if_eligible(
        user_id=UUID(user_id),
        duration_sec=completion.session.duration_sec or 0,
    )
    return SessionCompletionResponse(
        session=ReadingSessionPublic.from_row(completion.session),
        grade=GradeSummaryPublic.from_summary(completion.grade),
        streak_days=completion.grade.streak_days,
        grade_up=completion.grade_up,
    )


@router.post(
    "/sessions/manual",
    response_model=ReadingSessionPublic,
    status_code=status.HTTP_201_CREATED,
)
async def log_manual_session(
    body: ManualSessionRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReadingService, Depends(get_reading_service)],
) -> ReadingSessionPublic:
    row = await service.log_manual_session(
        user_id=UUID(user_id),
        user_book_id=body.user_book_id,
        started_at=body.started_at,
        ended_at=body.ended_at,
        note=body.note,
    )
    return ReadingSessionPublic.from_row(row)


@router.get("/sessions/daily", response_model=DailySessionsResponse)
async def get_daily_sessions(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReadingService, Depends(get_reading_service)],
    target_date: Annotated[date, Query(alias="date")],
) -> DailySessionsResponse:
    sessions = await service.get_daily_sessions(
        user_id=UUID(user_id),
        target_date=target_date,
    )
    return DailySessionsResponse(
        date=target_date.isoformat(),
        total_seconds=sum(s.duration_sec for s in sessions),
        sessions=[
            DailySessionPublic(
                session_id=s.session_id,
                started_at=s.started_at,
                ended_at=s.ended_at,
                duration_sec=s.duration_sec,
                source=s.source,  # type: ignore[arg-type]
                book_id=s.book_id,
                book_title=s.book_title,
                book_author=s.book_author,
                book_cover_url=s.book_cover_url,
            )
            for s in sessions
        ],
    )


@router.get("/heatmap", response_model=HeatmapResponse)
async def get_heatmap(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReadingService, Depends(get_reading_service)],
    from_date: Annotated[date, Query(alias="from")],
    to_date: Annotated[date, Query(alias="to")],
) -> HeatmapResponse:
    days = await service.get_heatmap(
        user_id=UUID(user_id),
        from_date=from_date,
        to_date=to_date,
    )
    return HeatmapResponse(items=[HeatmapDayPublic.from_day(d) for d in days])


@router.get("/grade", response_model=GradeSummaryPublic)
async def get_grade(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReadingService, Depends(get_reading_service)],
) -> GradeSummaryPublic:
    summary = await service.get_grade(user_id=UUID(user_id))
    return GradeSummaryPublic.from_summary(summary)


@router.get("/stats", response_model=ReadingYearStatsPublic)
async def get_year_stats(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReadingService, Depends(get_reading_service)],
    year: Annotated[int, Query(ge=2000, le=2100)] = 0,
) -> ReadingYearStatsPublic:
    effective_year = year if year > 0 else datetime.now(tz=UTC).year
    stats = await service.get_year_stats(user_id=UUID(user_id), year=effective_year)
    return ReadingYearStatsPublic(
        year=stats.year,
        year_books=stats.year_books,
        year_seconds=stats.year_seconds,
        year_best_day_date=stats.year_best_day_date,
        year_best_day_seconds=stats.year_best_day_seconds,
        total_books=stats.total_books,
        total_seconds=stats.total_seconds,
        streak_days=stats.streak_days,
        longest_streak=stats.longest_streak,
    )


@router.post(
    "/goals",
    response_model=GoalPublic,
    status_code=status.HTTP_201_CREATED,
)
async def create_goal(
    body: CreateGoalRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReadingService, Depends(get_reading_service)],
) -> GoalPublic:
    try:
        period = GoalPeriod(body.period)
    except ValueError as exc:  # pragma: no cover - guarded by Literal
        raise HTTPException(status_code=422, detail="invalid period") from exc
    goal = await service.create_goal(
        user_id=UUID(user_id),
        period=period,
        target_books=body.target_books,
        target_seconds=body.target_seconds,
    )
    return GoalPublic.from_row(goal)


@router.get("/goals/current", response_model=list[GoalProgressPublic])
async def list_current_goals(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReadingService, Depends(get_reading_service)],
) -> list[GoalProgressPublic]:
    today = datetime.now(tz=UTC).date()
    rows = await service.get_current_goals(user_id=UUID(user_id), on_date=today)
    return [GoalProgressPublic.from_progress(r) for r in rows]


@router.post(
    "/bookmarks/{user_book_id}",
    response_model=BookmarkPublic,
    status_code=status.HTTP_201_CREATED,
)
async def create_bookmark(
    user_book_id: str,
    body: CreateBookmarkRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReadingService, Depends(get_reading_service)],
) -> BookmarkPublic:
    bookmark = await service.add_bookmark(
        user_id=UUID(user_id),
        user_book_id=UUID(user_book_id),
        page=body.page,
        note=body.note,
    )
    return BookmarkPublic.model_validate(bookmark)


@router.get(
    "/bookmarks/{user_book_id}/latest",
    response_model=BookmarkPublic | None,
)
async def get_latest_bookmark(
    user_book_id: str,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReadingService, Depends(get_reading_service)],
) -> BookmarkPublic | None:
    bookmark = await service.get_latest_bookmark(
        user_id=UUID(user_id),
        user_book_id=UUID(user_book_id),
    )
    if bookmark is None:
        return None
    return BookmarkPublic.model_validate(bookmark)


@me_router.get("/me/reading-stats", response_model=ReadingStatsResponse)
async def get_reading_stats(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReadingService, Depends(get_reading_service)],
    redis: Annotated[aioredis.Redis, Depends(get_redis)],
) -> ReadingStatsResponse:
    """Aggregate reading statistics for the authenticated user.

    Results are cached in Redis for 24 hours (key: ``reading_stats:{user_id}``).
    The cache is a JSON-serialised ``ReadingStatsResponse``; a Redis failure
    falls through to a live DB query so the endpoint stays available.
    """
    cache_key = f"reading_stats:{user_id}"

    # Try cache first; swallow Redis errors so a Redis outage doesn't
    # take down the endpoint.
    try:
        cached = await redis.get(cache_key)
        if cached is not None:
            return ReadingStatsResponse.model_validate(json.loads(cached))
    except Exception:
        logger.warning("Redis read failed for %s — falling through to DB", cache_key)

    stats = await service.get_reading_stats(user_id=UUID(user_id))

    response = ReadingStatsResponse(
        speed=ReadingSpeedStatsPublic(
            avg_minutes_per_page=stats.speed.avg_minutes_per_page,
            avg_pages_per_hour=stats.speed.avg_pages_per_hour,
        ),
        format_breakdown=FormatBreakdownPublic(
            paper=stats.format_breakdown.paper,
            ebook=stats.format_breakdown.ebook,
            audio=stats.format_breakdown.audio,
        ),
        monthly_hours=[
            MonthlyHoursPublic(month=m.month, hours=m.hours) for m in stats.monthly_hours
        ],
        genre_breakdown=[
            GenreBreakdownPublic(genre=g.genre, count=g.count) for g in stats.genre_breakdown
        ],
        avg_completion_days=stats.avg_completion_days,
    )

    # Write to cache; swallow failures for the same resilience reason.
    try:
        await redis.set(
            cache_key,
            response.model_dump_json(),
            ex=_STATS_CACHE_TTL,
        )
    except Exception:
        logger.warning("Redis write failed for %s", cache_key)

    return response


@me_router.get("/me/reading-recap", response_model=ReadingRecapResponse)
async def get_reading_recap(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReadingService, Depends(get_reading_service)],
    redis: Annotated[aioredis.Redis, Depends(get_redis)],
    period: Annotated[str, Query(description="YYYY-H1 / YYYY-H2 / YYYY")] = "",
) -> ReadingRecapResponse:
    """Reading recap cards for the authenticated user.

    Results are cached in Redis for 24 hours
    (key: ``reading_recap:{user_id}:{period}``).
    ``period`` defaults to the current calendar year when omitted.
    """
    effective_period = period.strip() or str(datetime.now(tz=UTC).year)

    cache_key = f"reading_recap:{user_id}:{effective_period}"
    try:
        cached = await redis.get(cache_key)
        if cached is not None:
            return ReadingRecapResponse.model_validate(json.loads(cached))
    except Exception:
        logger.warning("Redis read failed for %s — falling through to DB", cache_key)

    try:
        recap = await service.get_reading_recap(
            user_id=UUID(user_id),
            period=effective_period,
        )
    except ValueError as exc:
        raise HTTPException(status_code=422, detail=str(exc)) from exc

    # Derive year and half from the period string for the mobile header.
    _parts = recap.period.split("-H")
    _year = int(_parts[0]) if _parts[0].isdigit() else 0
    _half = int(_parts[1]) if len(_parts) > 1 and _parts[1].isdigit() else 0

    response = ReadingRecapResponse(
        period=recap.period,
        year=_year,
        half=_half,
        total_books=recap.total_books,
        total_seconds=recap.total_seconds,
        longest_streak_days=recap.longest_streak_days,
        cards=[
            RecapCard(
                card_type=RecapCardType(c.card_type),
                book=RecapBook(
                    title=c.title,
                    cover_url=c.cover_url,
                    author=c.author,
                ),
                stat_value=c.stat_value,
            )
            for c in recap.cards
        ],
        top_books=[
            RecapBook(
                title=b.title,
                cover_url=b.cover_url,
                author=b.author,
                read_seconds=b.read_seconds,
            )
            for b in recap.top_books
        ],
    )

    try:
        await redis.set(cache_key, response.model_dump_json(), ex=_STATS_CACHE_TTL)
    except Exception:
        logger.warning("Redis write failed for %s", cache_key)

    return response


@me_router.get("/me/recap/monthly", response_model=MonthlyRecapResponse)
async def get_monthly_recap(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReadingService, Depends(get_reading_service)],
    year: Annotated[int, Query(ge=2000, le=2100)] = 0,
    month: Annotated[int, Query(ge=1, le=12)] = 0,
) -> MonthlyRecapResponse:
    """Monthly recap stats for the authenticated user.

    ``year`` and ``month`` default to the current calendar month when omitted.
    """
    now = datetime.now(tz=UTC)
    effective_year = year if year > 0 else now.year
    effective_month = month if month > 0 else now.month

    recap = await service.get_monthly_recap(
        user_id=UUID(user_id),
        year=effective_year,
        month=effective_month,
    )
    return MonthlyRecapResponse(
        year=recap.year,
        month=recap.month,
        books_completed=recap.books_completed,
        total_hours=recap.total_hours,
        avg_daily_minutes=recap.avg_daily_minutes,
        longest_streak=recap.longest_streak,
        top_genre=recap.top_genre,
        prev_month_hours=recap.prev_month_hours,
    )


@me_router.get("/me/stats/advanced", response_model=AdvancedStatsResponse)
async def get_advanced_stats(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReadingService, Depends(get_reading_service)],
) -> AdvancedStatsResponse:
    """Pro-only advanced reading statistics.

    The service raises ``PermissionDeniedError`` (``PRO_REQUIRED`` → HTTP 403)
    for non-Pro callers; the global handler translates it to the wire shape.
    """
    stats = await service.get_advanced_stats(user_id=UUID(user_id))
    return AdvancedStatsResponse(
        speed_trend=[
            SpeedTrendItem(week_start=p.week_start, minutes_per_page=p.minutes_per_page)
            for p in stats.speed_trend
        ],
        genre_distribution=[
            GenreDistributionItem(genre=g.genre, count=g.count, pct=g.pct)
            for g in stats.genre_distribution
        ],
        yearly_comparison=stats.yearly_comparison,
        longest_streak_days=stats.longest_streak_days,
    )


@me_router.get("/me/recap/milestones", response_model=MilestonesResponse)
async def get_milestones(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReadingService, Depends(get_reading_service)],
) -> MilestonesResponse:
    """All achieved reading milestones for the authenticated user."""
    milestone_data = await service.get_milestones(user_id=UUID(user_id))
    return MilestonesResponse(
        milestones=[
            MilestoneItem(
                type=MilestoneType(m.milestone_type),
                achieved_at=m.achieved_at,
                value=m.value,
            )
            for m in milestone_data
        ]
    )

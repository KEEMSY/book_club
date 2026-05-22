"""HTTP surface for the reading domain — /reading/*.

Handlers are thin DTO -> service -> DTO adapters. Business decisions live
in ``service.py``; domain exceptions translate to HTTP via the global
handler registered in ``app.core.exceptions`` (CLAUDE.md §3.1).
"""

from __future__ import annotations

from datetime import UTC, date, datetime
from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, Query, status

from app.core.deps import get_current_user_id
from app.domains.reading.models import GoalPeriod
from app.domains.reading.providers import get_reading_service
from app.domains.reading.schemas import (
    BookmarkPublic,
    CreateBookmarkRequest,
    CreateGoalRequest,
    DailySessionPublic,
    DailySessionsResponse,
    EndSessionRequest,
    GoalProgressPublic,
    GoalPublic,
    GradeSummaryPublic,
    HeatmapDayPublic,
    HeatmapResponse,
    ManualSessionRequest,
    ReadingSessionPublic,
    ReadingYearStatsPublic,
    SessionCompletionResponse,
    StartSessionRequest,
)
from app.domains.reading.service import ReadingService

router = APIRouter(prefix="/reading", tags=["reading"])


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
) -> SessionCompletionResponse:
    completion = await service.end_session(
        user_id=UUID(user_id),
        session_id=session_id,
        ended_at=body.ended_at,
        paused_ms=body.paused_ms,
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

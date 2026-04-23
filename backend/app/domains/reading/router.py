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
    CreateGoalRequest,
    EndSessionRequest,
    GoalProgressPublic,
    GoalPublic,
    GradeSummaryPublic,
    HeatmapDayPublic,
    HeatmapResponse,
    ManualSessionRequest,
    ReadingSessionPublic,
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

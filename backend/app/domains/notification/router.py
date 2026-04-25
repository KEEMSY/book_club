"""HTTP surface for the notification domain.

Handlers are thin DTO -> service -> DTO adapters. The router only reads/marks
notifications; event-driven creation is handled by NotificationService
subscribers wired in main.py lifespan (CLAUDE.md §3.1).
"""

from __future__ import annotations

from datetime import datetime
from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, Query, status

from app.core.deps import get_current_user_id
from app.domains.notification.providers import get_notification_router_service
from app.domains.notification.schemas import (
    NotificationListOut,
    NotificationOut,
    WeeklyReportOut,
)
from app.domains.notification.service_router import NotificationRouterService

router = APIRouter(tags=["notification"])


@router.get("/notifications", response_model=NotificationListOut)
async def list_notifications(
    user_id: Annotated[str, Depends(get_current_user_id)],
    svc: Annotated[NotificationRouterService, Depends(get_notification_router_service)],
    cursor: str | None = Query(default=None),
    limit: int = Query(default=20, ge=1, le=100),
) -> NotificationListOut:
    cursor_dt = _parse_cursor(cursor)
    uid = UUID(user_id)
    items, next_cursor, unread = await svc.list_notifications(uid, cursor_dt=cursor_dt, limit=limit)
    return NotificationListOut(
        items=[NotificationOut.model_validate(n) for n in items],
        next_cursor=next_cursor,
        unread_count=unread,
    )


@router.post(
    "/notifications/{notification_id}/read",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def mark_read(
    notification_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    svc: Annotated[NotificationRouterService, Depends(get_notification_router_service)],
) -> None:
    await svc.mark_read(notification_id, user_id=UUID(user_id))


@router.get("/notifications/unread-count")
async def unread_count(
    user_id: Annotated[str, Depends(get_current_user_id)],
    svc: Annotated[NotificationRouterService, Depends(get_notification_router_service)],
) -> dict[str, int]:
    count = await svc.unread_count(UUID(user_id))
    return {"count": count}


@router.get("/reports/weekly", response_model=WeeklyReportOut | None)
async def get_weekly_report(
    user_id: Annotated[str, Depends(get_current_user_id)],
    svc: Annotated[NotificationRouterService, Depends(get_notification_router_service)],
    week: str | None = Query(default=None, description="ISO week Monday (YYYY-MM-DD)"),
) -> WeeklyReportOut | None:
    from datetime import date

    week_start: date | None = None
    if week is not None:
        try:
            week_start = date.fromisoformat(week)
        except ValueError:
            week_start = None

    report = await svc.get_weekly_report(UUID(user_id), week_start=week_start)
    if report is None:
        return None
    return WeeklyReportOut.model_validate(report)


def _parse_cursor(cursor: str | None) -> datetime | None:
    if not cursor:
        return None
    try:
        return datetime.fromisoformat(cursor)
    except ValueError:
        return None

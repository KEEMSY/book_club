"""Pydantic response schemas for the notification domain."""

from __future__ import annotations

from datetime import date, datetime
from uuid import UUID

from pydantic import BaseModel, ConfigDict


class NotificationOut(BaseModel):
    """Single in-app notification row returned to the client."""

    id: UUID
    ntype: str
    title: str
    body: str
    data: dict[str, str]
    read_at: datetime | None
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)


class NotificationListOut(BaseModel):
    """Paginated in-app notification inbox."""

    items: list[NotificationOut]
    next_cursor: str | None
    unread_count: int


class WeeklyReportOut(BaseModel):
    """Weekly reading report returned to the client."""

    id: UUID
    week_start: date
    total_seconds: int
    session_count: int
    best_day: date | None
    longest_session_sec: int
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)

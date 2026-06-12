"""Pydantic schemas for the reminder domain."""

from __future__ import annotations

from datetime import datetime
from datetime import time as time_type
from uuid import UUID

from pydantic import BaseModel, Field, field_validator


class ReminderCreate(BaseModel):
    """Request body for creating or replacing a reading reminder."""

    days_of_week: list[int] = Field(min_length=1, max_length=7)
    # "HH:MM:SS" or "HH:MM" — Python's time type handles both.
    remind_at: time_type
    is_active: bool = True

    @field_validator("days_of_week")
    @classmethod
    def validate_days(cls, v: list[int]) -> list[int]:
        if not all(0 <= d <= 6 for d in v):
            raise ValueError("days_of_week values must be 0 (Mon) through 6 (Sun)")
        return sorted(set(v))


class ReminderPublic(BaseModel):
    """Outbound representation of a single reminder."""

    model_config = {"from_attributes": True}

    id: UUID
    days_of_week: list[int]
    remind_at: time_type
    is_active: bool
    created_at: datetime


class ReminderListResponse(BaseModel):
    """Paginated (flat) list of a user's reminders."""

    items: list[ReminderPublic]

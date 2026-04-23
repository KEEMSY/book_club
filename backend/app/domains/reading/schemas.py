"""Pydantic v2 DTOs for the reading router.

These are the sole types the mobile client observes at the HTTP boundary.
The router never leaks SQLAlchemy models past this shell.
"""

from __future__ import annotations

from datetime import date, datetime
from typing import Literal
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field

from app.domains.reading.models import Goal, ReadingSession
from app.domains.reading.ports import (
    GoalProgress,
    GradeSummary,
    HeatmapDay,
)

# ----------------- requests -----------------


class StartSessionRequest(BaseModel):
    user_book_id: UUID
    device: str | None = None


class EndSessionRequest(BaseModel):
    ended_at: datetime
    paused_ms: int = Field(ge=0, description="Client-reported cumulative pause in ms.")


class ManualSessionRequest(BaseModel):
    user_book_id: UUID
    started_at: datetime
    ended_at: datetime
    note: str | None = Field(default=None, max_length=200)


class CreateGoalRequest(BaseModel):
    period: Literal["weekly", "monthly", "yearly"]
    target_books: int = Field(ge=1, le=365)
    target_seconds: int = Field(ge=60, le=365 * 24 * 3600)


# ----------------- responses ----------------


class ReadingSessionPublic(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    user_book_id: UUID
    started_at: datetime
    ended_at: datetime | None
    duration_sec: int | None
    source: Literal["timer", "manual"]

    @classmethod
    def from_row(cls, row: ReadingSession) -> ReadingSessionPublic:
        return cls(
            id=row.id,
            user_book_id=row.user_book_id,
            started_at=row.started_at,
            ended_at=row.ended_at,
            duration_sec=row.duration_sec,
            source=row.source.value,
        )


class GradeThresholdPublic(BaseModel):
    target_books: int
    target_seconds: int


class GradeSummaryPublic(BaseModel):
    grade: int
    total_books: int
    total_seconds: int
    streak_days: int
    longest_streak: int
    next_grade_thresholds: GradeThresholdPublic | None

    @classmethod
    def from_summary(cls, s: GradeSummary) -> GradeSummaryPublic:
        thresh: GradeThresholdPublic | None = None
        if s.next_grade_thresholds is not None:
            thresh = GradeThresholdPublic(
                target_books=s.next_grade_thresholds.target_books,
                target_seconds=s.next_grade_thresholds.target_seconds,
            )
        return cls(
            grade=s.grade,
            total_books=s.total_books,
            total_seconds=s.total_seconds,
            streak_days=s.streak_days,
            longest_streak=s.longest_streak,
            next_grade_thresholds=thresh,
        )


class SessionCompletionResponse(BaseModel):
    session: ReadingSessionPublic
    grade: GradeSummaryPublic
    streak_days: int
    grade_up: bool


class HeatmapDayPublic(BaseModel):
    date: date
    total_seconds: int
    session_count: int

    @classmethod
    def from_day(cls, day: HeatmapDay) -> HeatmapDayPublic:
        return cls(
            date=day.date,
            total_seconds=day.total_seconds,
            session_count=day.session_count,
        )


class HeatmapResponse(BaseModel):
    items: list[HeatmapDayPublic]


class GoalPublic(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    period: Literal["weekly", "monthly", "yearly"]
    target_books: int
    target_seconds: int
    start_date: date
    end_date: date

    @classmethod
    def from_row(cls, row: Goal) -> GoalPublic:
        return cls(
            id=row.id,
            period=row.period.value,
            target_books=row.target_books,
            target_seconds=row.target_seconds,
            start_date=row.start_date,
            end_date=row.end_date,
        )


class GoalProgressPublic(BaseModel):
    goal: GoalPublic
    books_done: int
    seconds_done: int
    percent: float = Field(ge=0.0, le=1.0)

    @classmethod
    def from_progress(cls, p: GoalProgress) -> GoalProgressPublic:
        return cls(
            goal=GoalPublic.from_row(p.goal),
            books_done=p.books_done,
            seconds_done=p.seconds_done,
            percent=p.percent,
        )

"""Pydantic v2 DTOs for the community router."""

from __future__ import annotations

from datetime import datetime
from uuid import UUID

from pydantic import BaseModel, Field


class GradeStatsPublic(BaseModel):
    grade: int
    tier: int
    total_books: int
    total_seconds: int
    streak_days: int


class BadgeSummaryPublic(BaseModel):
    id: UUID
    name: str
    icon_url: str
    category: str
    earned_at: datetime


class HighlightSummaryPublic(BaseModel):
    id: UUID
    quote_text: str
    book_title: str | None = None
    created_at: datetime


class UserProfileResponse(BaseModel):
    id: UUID
    nickname: str | None = None
    profile_image_url: str | None = None
    bio: str | None = None
    follower_count: int
    following_count: int
    is_following: bool
    is_me: bool
    grade_stats: GradeStatsPublic | None = None
    badges: list[BadgeSummaryPublic] = Field(default_factory=list)
    recent_highlights: list[HighlightSummaryPublic] = Field(default_factory=list)

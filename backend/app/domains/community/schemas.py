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
    # Profile expressiveness (BC-81). featured_book_id is a bare id — fetch
    # title/cover via the existing GET /books/{id} if the client needs them.
    cover_image_url: str | None = None
    theme: str | None = None
    featured_book_id: UUID | None = None
    featured_quote: str | None = None


# --- BC-80: "내 활동" (my activity) summary ---


class ActivityCountsPublic(BaseModel):
    reviews: int
    highlights: int
    agendas: int
    clubs: int
    reading_books: int


class ActivityReviewItemPublic(BaseModel):
    id: UUID
    book_id: UUID
    book_title: str | None = None
    book_cover_url: str | None = None
    rating: float
    body: str | None = None
    created_at: datetime


class ActivityHighlightItemPublic(BaseModel):
    id: UUID
    book_id: UUID
    book_title: str | None = None
    book_cover_url: str | None = None
    quote_text: str
    created_at: datetime


class ActivityAgendaItemPublic(BaseModel):
    id: UUID
    club_id: UUID
    club_name: str
    session_id: UUID
    session_title: str
    status: str
    published_at: datetime | None = None
    created_at: datetime


class ActivityClubItemPublic(BaseModel):
    id: UUID
    name: str
    created_at: datetime


class ActivityBookItemPublic(BaseModel):
    user_book_id: UUID
    book_id: UUID
    title: str
    cover_url: str | None = None
    current_chapter: int
    started_at: datetime | None = None


class MyActivityResponse(BaseModel):
    """GET /community/me/activity — counts plus a short newest-first preview
    per category. Each category's full, paginated list lives behind its own
    domain endpoint (see the module docstring in ``community/router.py``)."""

    counts: ActivityCountsPublic
    reviews: list[ActivityReviewItemPublic] = Field(default_factory=list)
    highlights: list[ActivityHighlightItemPublic] = Field(default_factory=list)
    agendas: list[ActivityAgendaItemPublic] = Field(default_factory=list)
    clubs: list[ActivityClubItemPublic] = Field(default_factory=list)
    reading_books: list[ActivityBookItemPublic] = Field(default_factory=list)

"""Pydantic v2 DTOs for the social router.

These are the sole types the mobile client observes at the HTTP boundary
(CLAUDE.md §3.1: the router does not leak SQLAlchemy models).
"""

from __future__ import annotations

from datetime import date, datetime
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field


class FollowStatus(BaseModel):
    """Follow relationship counts from a viewer's perspective."""

    model_config = ConfigDict(from_attributes=True)

    is_following: bool
    follower_count: int
    following_count: int


class UserSummary(BaseModel):
    """Compact user card used in follower/following list items."""

    model_config = ConfigDict(from_attributes=True)

    id: UUID
    nickname: str
    profile_image_url: str | None
    bio: str | None
    # Populated from the requesting actor's perspective, not the listed user's.
    is_following: bool


class UserSummaryPage(BaseModel):
    """Cursor-paginated list of UserSummary items."""

    items: list[UserSummary]
    next_cursor: str | None


class ReportCreate(BaseModel):
    """Body for POST /reports/{target_type}/{target_id}."""

    reason: str = Field(..., min_length=1, max_length=500)


class LeaderboardEntry(BaseModel):
    """One row in the weekly reading leaderboard."""

    model_config = ConfigDict(from_attributes=True)

    rank: int
    user_id: UUID
    nickname: str
    profile_image_url: str | None
    # Human-readable tier label derived from grade + tier (e.g. "Gold I").
    # None when the user has no grade row yet.
    grade_tier: str | None
    weekly_minutes: int
    # True when this entry belongs to the requesting user.
    is_me: bool


class LeaderboardResponse(BaseModel):
    """Weekly leaderboard for the requesting user and their followings."""

    entries: list[LeaderboardEntry]
    # Monday of the rolling 7-day window used for this snapshot.
    week_start: date
    generated_at: datetime

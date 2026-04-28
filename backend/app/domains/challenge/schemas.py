"""Pydantic response and view-model schemas for the challenge domain.

``ChallengePublic`` is used for both the list view and detail view; the detail
view exposes the ``badge`` field while the list view omits it for performance.
``ChallengeDetailView`` is an alias kept for router clarity.

``BadgeView`` is the API-facing badge representation (icon_url is a composed
URL rather than the raw icon_key stored in the DB).
"""

from __future__ import annotations

import enum
from datetime import datetime
from uuid import UUID

from pydantic import BaseModel


class ChallengeStatus(enum.StrEnum):
    """Filtering status for challenge list endpoint."""

    ACTIVE = "active"
    UPCOMING = "upcoming"
    ENDED = "ended"
    JOINED = "joined"


class BadgeView(BaseModel):
    """Badge as returned to API consumers — icon_url is a composed R2 URL."""

    id: UUID
    name: str
    description: str
    category: str
    icon_url: str

    model_config = {"from_attributes": True}


class BadgeWithEarnedAt(BadgeView):
    """Badge view augmented with the timestamp it was earned."""

    earned_at: datetime


class ChallengePublic(BaseModel):
    """Challenge representation for list and detail API responses."""

    id: UUID
    title: str
    description: str | None
    challenge_type: str
    target_value: int
    genre_filter: str | None
    starts_at: datetime
    ends_at: datetime
    participant_count: int
    is_joined: bool
    my_progress: int | None
    achieved_at: datetime | None
    badge: BadgeView | None

    model_config = {"from_attributes": True}


# Detail view shares the same shape — aliased for router readability.
ChallengeDetailView = ChallengePublic


class ChallengePage(BaseModel):
    """Paginated challenge list response."""

    items: list[ChallengePublic]
    next_cursor: str | None


class LeaderboardEntry(BaseModel):
    """One ranked entry in a challenge leaderboard."""

    rank: int
    user_id: UUID
    nickname: str | None
    profile_image_url: str | None
    current_value: int
    achieved_at: datetime | None


class LeaderboardResponse(BaseModel):
    """Leaderboard endpoint response envelope."""

    items: list[LeaderboardEntry]


class MyChallengeItem(BaseModel):
    """One challenge in the "my challenges" list."""

    id: UUID
    title: str
    challenge_type: str
    target_value: int
    starts_at: datetime
    ends_at: datetime
    current_value: int
    achieved_at: datetime | None
    joined_at: datetime


class MyChallengeResponse(BaseModel):
    """My-challenges endpoint response envelope."""

    items: list[MyChallengeItem]


class MyBadgeItem(BaseModel):
    """One item in the "my badges" list."""

    badge: BadgeWithEarnedAt


class MyBadgeResponse(BaseModel):
    """My-badges endpoint response envelope."""

    items: list[MyBadgeItem]


class BadgeListResponse(BaseModel):
    """Badge list endpoint response envelope."""

    items: list[BadgeView]

"""Pydantic v2 request / response schemas for the team domain (M70)."""

from __future__ import annotations

from datetime import datetime
from uuid import UUID

from pydantic import BaseModel, Field


class CreateTeamRequest(BaseModel):
    """Body for ``POST /teams``."""

    team_name: str = Field(min_length=1, max_length=128)
    seat_count: int = Field(default=10, ge=1, le=500)
    valid_months: int = Field(default=12, ge=1, le=36)


class AddMemberRequest(BaseModel):
    """Body for ``POST /teams/{id}/members``."""

    user_id: UUID


class TeamMemberResponse(BaseModel):
    """A single seat on the roster, with the member's public profile fields."""

    user_id: UUID
    nickname: str
    profile_image_url: str | None
    joined_at: datetime


class TeamResponse(BaseModel):
    """Team plan details plus the current seat roster."""

    id: UUID
    team_name: str
    admin_user_id: UUID
    seat_count: int
    plan_type: str
    valid_from: datetime
    valid_until: datetime
    used_seats: int
    members: list[TeamMemberResponse]

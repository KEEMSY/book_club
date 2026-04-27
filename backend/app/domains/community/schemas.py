"""Pydantic v2 DTOs for the community router."""

from __future__ import annotations

from uuid import UUID

from pydantic import BaseModel


class UserProfileResponse(BaseModel):
    id: UUID
    nickname: str | None = None
    profile_image_url: str | None = None
    bio: str | None = None
    follower_count: int
    following_count: int
    is_following: bool
    is_me: bool

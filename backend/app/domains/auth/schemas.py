"""Pydantic v2 DTOs for the auth router.

These are the sole types the mobile client observes at the HTTP boundary
(CLAUDE.md §3.1: the router does not leak SQLAlchemy models). UserPublic
deliberately excludes ``deleted_at`` and internal audit timestamps other
than ``created_at`` so the deletion status cannot be inferred from API
responses.
"""

from __future__ import annotations

from datetime import datetime
from typing import Literal
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field

from app.domains.auth.models import User


class KakaoLoginRequest(BaseModel):
    # The Kakao Flutter SDK on native iOS/Android never surfaces an OAuth
    # authorization code — it returns an access_token directly. We accept that
    # token here and call Kakao's /v2/user/me in the adapter; no token-exchange
    # step is needed.
    access_token: str = Field(..., min_length=1)


class AppleLoginRequest(BaseModel):
    identity_token: str = Field(..., min_length=1)
    # authorization_code is accepted for forward compatibility: a future
    # server-side refresh implementation will exchange it for Apple's
    # long-lived refresh token. M1 ignores it.
    authorization_code: str | None = None


class DevLoginRequest(BaseModel):
    """Dev-only login payload. The router rejects this when ``settings.env``
    is anything other than ``"dev"`` so the endpoint cannot escape into a
    production deploy.
    """

    nickname: str = Field(default="개발자", min_length=1, max_length=32)
    email: str | None = Field(default=None, max_length=254)


class RefreshRequest(BaseModel):
    refresh_token: str = Field(..., min_length=1)


class DeviceTokenRegisterRequest(BaseModel):
    token: str = Field(..., min_length=1, max_length=512)
    platform: Literal["ios", "aos"]


ProfileThemeLiteral = Literal["classic", "sepia", "midnight", "forest", "sunset", "ocean"]


class UserPublic(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    nickname: str
    profile_image_url: str | None
    bio: str | None
    email: str | None
    created_at: datetime
    provider: Literal["kakao", "apple"]
    # Profile expressiveness (BC-81).
    cover_image_url: str | None = None
    theme: ProfileThemeLiteral | None = None
    featured_book_id: UUID | None = None
    featured_quote: str | None = None

    @classmethod
    def from_user(cls, user: User) -> UserPublic:
        return cls.model_validate(user)


class TrialStatusResponse(BaseModel):
    """Pro trial window state for the authenticated user (M65)."""

    is_in_trial: bool
    trial_ends_at: datetime | None
    days_remaining: int


class UpdateProfileRequest(BaseModel):
    nickname: str | None = Field(default=None, min_length=1, max_length=64)
    # An explicit None clears the bio; omitting the field leaves it unchanged.
    bio: str | None = Field(default=None, max_length=200)
    # Profile expressiveness (BC-81) — same None convention as bio/nickname
    # above: the service only applies a field when it is not None, so these
    # can be set but not yet cleared back to NULL via this endpoint.
    cover_image_url: str | None = Field(default=None, max_length=1024)
    theme: ProfileThemeLiteral | None = Field(default=None)
    featured_book_id: UUID | None = Field(default=None)
    featured_quote: str | None = Field(default=None, max_length=300)


class LoginResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: Literal["Bearer"] = "Bearer"
    expires_in: int
    user: UserPublic
    is_new_user: bool


class RefreshResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: Literal["Bearer"] = "Bearer"
    expires_in: int

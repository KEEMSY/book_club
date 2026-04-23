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


class UserPublic(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    nickname: str
    profile_image_url: str | None
    email: str | None
    created_at: datetime
    provider: Literal["kakao", "apple"]

    @classmethod
    def from_user(cls, user: User) -> UserPublic:
        return cls.model_validate(user)


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

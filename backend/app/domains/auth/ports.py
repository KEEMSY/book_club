"""Auth domain ports — the only contracts ``service.py`` is allowed to import.

Per CLAUDE.md §3.2 the Port/Adapter boundary is enforced strictly for external
collaborators (OAuth providers, push). The repository ports are kept Port-shaped
even though they have a 1:1 implementation, because the service layer is
unit-tested against in-memory fakes that implement the same Protocol.

DTOs (``KakaoUserProfile`` / ``AppleUserProfile``) live here rather than in
``schemas.py`` so they never leak pydantic / HTTP concerns into the domain.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
from typing import Protocol
from uuid import UUID

from app.domains.auth.models import AuthProvider, DevicePlatform, DeviceToken, User


@dataclass(frozen=True, slots=True)
class KakaoUserProfile:
    """Normalized shape returned by the Kakao OAuth adapter."""

    sub: str
    email: str | None
    nickname: str
    profile_image_url: str | None


@dataclass(frozen=True, slots=True)
class AppleUserProfile:
    """Normalized shape returned by the Apple OAuth adapter."""

    sub: str
    email: str | None


class UserRepositoryPort(Protocol):
    async def get_by_provider_sub(self, provider: AuthProvider, sub: str) -> User | None: ...

    async def create(
        self,
        *,
        provider: AuthProvider,
        sub: str,
        email: str | None,
        nickname: str,
        profile_image_url: str | None,
    ) -> User: ...

    async def update_last_login(self, user_id: UUID, at: datetime) -> None: ...

    async def get_by_id(self, user_id: UUID) -> User | None: ...

    async def soft_delete(self, user_id: UUID, at: datetime) -> None: ...


class DeviceTokenRepositoryPort(Protocol):
    async def upsert(self, user_id: UUID, token: str, platform: DevicePlatform) -> DeviceToken: ...

    async def get_active_tokens_for_user(self, user_id: UUID) -> list[DeviceToken]: ...

    async def touch(self, token: str) -> None: ...


class KakaoOAuthPort(Protocol):
    async def exchange_code_for_user(
        self, code: str, redirect_uri: str | None
    ) -> KakaoUserProfile: ...


class AppleOAuthPort(Protocol):
    async def verify_identity_token(self, identity_token: str) -> AppleUserProfile: ...

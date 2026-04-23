"""Auth domain service — login / refresh / device token / account deletion.

Depends only on the Protocols in ``ports.py`` (CLAUDE.md §3.2). Concrete
repository and adapter classes are injected by ``providers.py`` for HTTP
traffic or by test fakes for unit tests.

Business rules captured here:
- Login is ``upsert-and-stamp``: existing (provider, sub) -> update
  last_login_at; missing -> create + mark is_new_user = True.
- Apple users without email get a placeholder nickname ``"애플회원"`` at
  first login because the UI still needs a non-null label. The user can
  later edit this in-app (out of scope for M1).
- Refresh strictly requires ``token_type == 'refresh'`` so an access token
  cannot be swapped for a new pair — this is what hardens /auth/refresh
  against stolen access tokens.
- ``delete_account`` soft-deletes the user and relies on the FK cascade
  to drop device tokens. No hard-delete here; a future scheduled purge
  removes rows after the legally required retention window.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import UTC, datetime
from uuid import UUID

from app.core.exceptions import AuthError, NotFoundError
from app.core.security import (
    create_access_token,
    create_refresh_token,
    decode_token,
)
from app.domains.auth.models import AuthProvider, DevicePlatform, User
from app.domains.auth.ports import (
    AppleOAuthPort,
    DeviceTokenRepositoryPort,
    KakaoOAuthPort,
    UserRepositoryPort,
)

_APPLE_FALLBACK_NICKNAME = "애플회원"


@dataclass(frozen=True, slots=True)
class LoginResult:
    """Service-layer shape returned by the two login methods."""

    access_token: str
    refresh_token: str
    user: User
    is_new_user: bool


@dataclass(frozen=True, slots=True)
class RefreshResult:
    """Service-layer shape returned by refresh()."""

    access_token: str
    refresh_token: str


@dataclass(slots=True)
class AuthService:
    """Orchestrates login, session refresh, device tokens, and account deletion."""

    users: UserRepositoryPort
    device_tokens: DeviceTokenRepositoryPort
    kakao: KakaoOAuthPort
    apple: AppleOAuthPort

    async def login_with_kakao(self, *, access_token: str) -> LoginResult:
        profile = await self.kakao.fetch_user_by_access_token(access_token)
        existing = await self.users.get_by_provider_sub(AuthProvider.KAKAO, profile.sub)
        is_new_user = existing is None
        if existing is None:
            user = await self.users.create(
                provider=AuthProvider.KAKAO,
                sub=profile.sub,
                email=profile.email,
                nickname=profile.nickname,
                profile_image_url=profile.profile_image_url,
            )
        else:
            user = existing
        now = datetime.now(tz=UTC)
        await self.users.update_last_login(user.id, now)
        return self._issue_tokens(user, is_new_user=is_new_user)

    async def login_dev(self, *, nickname: str, email: str | None) -> LoginResult:
        """Dev-only login. Reuses the ``kakao`` provider with a ``dev:``
        prefix on ``provider_sub`` so no migration is required. The router
        gates this behind ``settings.env == "dev"`` — the service itself
        has no environment knowledge on purpose (unit-testable offline).
        """
        sub = f"dev:{nickname}"
        existing = await self.users.get_by_provider_sub(AuthProvider.KAKAO, sub)
        is_new_user = existing is None
        if existing is None:
            user = await self.users.create(
                provider=AuthProvider.KAKAO,
                sub=sub,
                email=email,
                nickname=nickname,
                profile_image_url=None,
            )
        else:
            user = existing
        now = datetime.now(tz=UTC)
        await self.users.update_last_login(user.id, now)
        return self._issue_tokens(user, is_new_user=is_new_user)

    async def login_with_apple(self, *, identity_token: str) -> LoginResult:
        profile = await self.apple.verify_identity_token(identity_token)
        existing = await self.users.get_by_provider_sub(AuthProvider.APPLE, profile.sub)
        is_new_user = existing is None
        if existing is None:
            user = await self.users.create(
                provider=AuthProvider.APPLE,
                sub=profile.sub,
                email=profile.email,
                # Apple returns no name on subsequent sign-ins — the placeholder
                # covers first-login-without-email; settings UI will let users
                # edit later.
                nickname=_APPLE_FALLBACK_NICKNAME,
                profile_image_url=None,
            )
        else:
            user = existing
        now = datetime.now(tz=UTC)
        await self.users.update_last_login(user.id, now)
        return self._issue_tokens(user, is_new_user=is_new_user)

    async def refresh(self, *, refresh_token: str) -> RefreshResult:
        payload = decode_token(refresh_token)
        token_type = payload.get("type")
        if token_type != "refresh":
            raise AuthError("expected a refresh token", code="TOKEN_TYPE_MISMATCH")
        sub = payload.get("sub")
        if not isinstance(sub, str) or not sub:
            raise AuthError("refresh token missing sub", code="TOKEN_INVALID")
        try:
            user_id = UUID(sub)
        except ValueError as exc:
            raise AuthError("refresh token sub is not a uuid", code="TOKEN_INVALID") from exc

        user = await self.users.get_by_id(user_id)
        if user is None:
            raise AuthError("user no longer exists", code="USER_GONE")

        return RefreshResult(
            access_token=create_access_token(str(user.id)),
            refresh_token=create_refresh_token(str(user.id)),
        )

    async def register_device_token(
        self, *, user_id: UUID, token: str, platform: DevicePlatform
    ) -> None:
        await self.device_tokens.upsert(user_id, token, platform)

    async def get_me(self, *, user_id: UUID) -> User:
        user = await self.users.get_by_id(user_id)
        if user is None:
            raise NotFoundError("user not found", code="USER_NOT_FOUND")
        return user

    async def delete_account(self, *, user_id: UUID) -> None:
        now = datetime.now(tz=UTC)
        await self.users.soft_delete(user_id, now)
        # device_tokens cascade via the FK when a hard purge runs; until then
        # they stay but no longer map to an active login flow (get_me -> 404).

    def _issue_tokens(self, user: User, *, is_new_user: bool) -> LoginResult:
        subject = str(user.id)
        return LoginResult(
            access_token=create_access_token(subject),
            refresh_token=create_refresh_token(subject),
            user=user,
            is_new_user=is_new_user,
        )

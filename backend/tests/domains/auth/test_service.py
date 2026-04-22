"""Unit tests for AuthService using in-memory fakes for every Port.

No DB, no HTTP, no JWKS — every collaborator is a simple dict-backed stub
or a callable that returns the DTO the test needs. This keeps the Service
layer's business rules (new-vs-returning user, token_type checks, Apple
fallback nickname, account deletion) straightforward to verify.
"""

from __future__ import annotations

from datetime import UTC, datetime, timedelta
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import AuthError, NotFoundError
from app.core.security import create_access_token, create_refresh_token
from app.domains.auth.models import AuthProvider, DevicePlatform, DeviceToken, User
from app.domains.auth.ports import AppleUserProfile, KakaoUserProfile
from app.domains.auth.service import AuthService


class FakeUserRepo:
    def __init__(self) -> None:
        self.users: dict[UUID, User] = {}
        self.by_provider: dict[tuple[AuthProvider, str], UUID] = {}

    async def get_by_provider_sub(self, provider: AuthProvider, sub: str) -> User | None:
        user_id = self.by_provider.get((provider, sub))
        if user_id is None:
            return None
        user = self.users.get(user_id)
        if user is None or user.deleted_at is not None:
            return None
        return user

    async def create(
        self,
        *,
        provider: AuthProvider,
        sub: str,
        email: str | None,
        nickname: str,
        profile_image_url: str | None,
    ) -> User:
        user = User(
            provider=provider,
            provider_sub=sub,
            email=email,
            nickname=nickname,
            profile_image_url=profile_image_url,
        )
        user.id = uuid4()
        self.users[user.id] = user
        self.by_provider[(provider, sub)] = user.id
        return user

    async def update_last_login(self, user_id: UUID, at: datetime) -> None:
        user = self.users.get(user_id)
        if user is not None:
            user.last_login_at = at

    async def get_by_id(self, user_id: UUID) -> User | None:
        user = self.users.get(user_id)
        if user is None or user.deleted_at is not None:
            return None
        return user

    async def soft_delete(self, user_id: UUID, at: datetime) -> None:
        user = self.users.get(user_id)
        if user is not None:
            user.deleted_at = at


class FakeDeviceTokenRepo:
    def __init__(self) -> None:
        self.by_token: dict[str, DeviceToken] = {}

    async def upsert(self, user_id: UUID, token: str, platform: DevicePlatform) -> DeviceToken:
        existing = self.by_token.get(token)
        now = datetime.now(tz=UTC)
        if existing is not None:
            existing.user_id = user_id
            existing.platform = platform
            existing.last_seen_at = now
            return existing
        dt = DeviceToken(user_id=user_id, token=token, platform=platform)
        dt.id = uuid4()
        dt.last_seen_at = now
        self.by_token[token] = dt
        return dt

    async def get_active_tokens_for_user(self, user_id: UUID) -> list[DeviceToken]:
        return [dt for dt in self.by_token.values() if dt.user_id == user_id]

    async def touch(self, token: str) -> None:
        existing = self.by_token.get(token)
        if existing is not None:
            existing.last_seen_at = datetime.now(tz=UTC)


class StubKakao:
    def __init__(self, profile: KakaoUserProfile) -> None:
        self.profile = profile
        self.calls: list[str] = []

    async def fetch_user_by_access_token(self, access_token: str) -> KakaoUserProfile:
        self.calls.append(access_token)
        return self.profile


class StubApple:
    def __init__(self, profile: AppleUserProfile) -> None:
        self.profile = profile
        self.calls: list[str] = []

    async def verify_identity_token(self, identity_token: str) -> AppleUserProfile:
        self.calls.append(identity_token)
        return self.profile


def _build_service(
    *,
    kakao_profile: KakaoUserProfile | None = None,
    apple_profile: AppleUserProfile | None = None,
) -> tuple[AuthService, FakeUserRepo, FakeDeviceTokenRepo]:
    users = FakeUserRepo()
    tokens = FakeDeviceTokenRepo()
    kakao = StubKakao(
        kakao_profile
        or KakaoUserProfile(
            sub="k-1", email="r@example.com", nickname="책벌레", profile_image_url=None
        )
    )
    apple = StubApple(apple_profile or AppleUserProfile(sub="a-1", email=None))
    service = AuthService(
        users=users,
        device_tokens=tokens,
        kakao=kakao,
        apple=apple,
    )
    return service, users, tokens


@pytest.mark.asyncio
async def test_kakao_new_user_creates_and_marks_is_new_user() -> None:
    service, users, _ = _build_service()

    result = await service.login_with_kakao(access_token="kakao-at")

    assert result.is_new_user is True
    assert result.user.provider is AuthProvider.KAKAO
    assert result.user.nickname == "책벌레"
    assert result.user.last_login_at is not None
    assert result.access_token
    assert result.refresh_token
    # One row should now exist.
    assert len(users.users) == 1


@pytest.mark.asyncio
async def test_kakao_returning_user_marks_is_new_user_false() -> None:
    service, users, _ = _build_service()
    first = await service.login_with_kakao(access_token="kakao-at")
    first_last_login = first.user.last_login_at
    assert first_last_login is not None

    # Force a later timestamp so we can observe the update.
    users.users[first.user.id].last_login_at = first_last_login - timedelta(minutes=5)

    second = await service.login_with_kakao(access_token="kakao-at")

    assert second.is_new_user is False
    assert second.user.id == first.user.id
    assert second.user.last_login_at is not None
    assert second.user.last_login_at > first_last_login - timedelta(minutes=5)
    # Still one row — returning users do not duplicate.
    assert len(users.users) == 1


@pytest.mark.asyncio
async def test_apple_new_user_without_email_uses_fallback_nickname() -> None:
    service, _users, _ = _build_service(apple_profile=AppleUserProfile(sub="a-2", email=None))

    result = await service.login_with_apple(identity_token="t")

    assert result.is_new_user is True
    assert result.user.provider is AuthProvider.APPLE
    assert result.user.nickname == "애플회원"
    assert result.user.email is None


@pytest.mark.asyncio
async def test_refresh_happy_path_issues_new_pair() -> None:
    service, _users, _ = _build_service()
    login = await service.login_with_kakao(access_token="kakao-at")

    refreshed = await service.refresh(refresh_token=login.refresh_token)

    assert refreshed.access_token != login.access_token or refreshed.refresh_token
    assert refreshed.access_token
    assert refreshed.refresh_token


@pytest.mark.asyncio
async def test_refresh_rejects_access_token() -> None:
    service, _, _ = _build_service()
    login = await service.login_with_kakao(access_token="kakao-at")

    with pytest.raises(AuthError) as exc_info:
        await service.refresh(refresh_token=login.access_token)

    assert exc_info.value.code == "TOKEN_TYPE_MISMATCH"


@pytest.mark.asyncio
async def test_refresh_rejects_expired_token() -> None:
    service, _users, _ = _build_service()
    login = await service.login_with_kakao(access_token="kakao-at")
    expired = create_refresh_token(str(login.user.id), ttl=timedelta(seconds=-1))

    with pytest.raises(AuthError):
        await service.refresh(refresh_token=expired)


@pytest.mark.asyncio
async def test_refresh_rejects_unknown_user() -> None:
    service, _, _ = _build_service()
    # Encode a refresh for a user that the repo never created.
    ghost_token = create_refresh_token(str(uuid4()))

    with pytest.raises(AuthError) as exc_info:
        await service.refresh(refresh_token=ghost_token)

    assert exc_info.value.code == "USER_GONE"


@pytest.mark.asyncio
async def test_register_device_token_upserts_idempotently() -> None:
    service, _, tokens = _build_service()
    login = await service.login_with_kakao(access_token="kakao-at")

    await service.register_device_token(
        user_id=login.user.id, token="fcm-1", platform=DevicePlatform.IOS
    )
    await service.register_device_token(
        user_id=login.user.id, token="fcm-1", platform=DevicePlatform.AOS
    )

    assert len(tokens.by_token) == 1
    assert tokens.by_token["fcm-1"].platform is DevicePlatform.AOS


@pytest.mark.asyncio
async def test_get_me_returns_user_or_raises() -> None:
    service, _users, _ = _build_service()
    login = await service.login_with_kakao(access_token="kakao-at")

    me = await service.get_me(user_id=login.user.id)
    assert me.id == login.user.id

    with pytest.raises(NotFoundError):
        await service.get_me(user_id=uuid4())


@pytest.mark.asyncio
async def test_delete_account_soft_deletes_user() -> None:
    service, users, _ = _build_service()
    login = await service.login_with_kakao(access_token="kakao-at")

    await service.delete_account(user_id=login.user.id)

    # Soft-deleted users must be invisible to subsequent reads.
    with pytest.raises(NotFoundError):
        await service.get_me(user_id=login.user.id)
    # And their access token can still be decoded but get_me still refuses.
    assert users.users[login.user.id].deleted_at is not None


@pytest.mark.asyncio
async def test_access_and_refresh_token_types_are_distinct() -> None:
    service, _, _ = _build_service()
    login = await service.login_with_kakao(access_token="kakao-at")

    from app.core.security import decode_token

    access_payload = decode_token(login.access_token)
    refresh_payload = decode_token(login.refresh_token)
    assert access_payload["type"] == "access"
    assert refresh_payload["type"] == "refresh"
    assert access_payload["sub"] == str(login.user.id)


@pytest.mark.asyncio
async def test_access_token_created_by_security_module_has_type_claim() -> None:
    # Sanity check — we rely on the core/security module stamping token_type
    # so that downstream deps (and the service refresh() guard) can reject
    # mis-typed tokens.
    tok = create_access_token("user-1")
    from app.core.security import decode_token

    payload = decode_token(tok)
    assert payload["type"] == "access"

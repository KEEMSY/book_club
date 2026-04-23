"""HTTP contract tests for the auth router.

Uses FastAPI ``app.dependency_overrides`` to swap ``get_auth_service`` with a
FakeAuthService that implements the same method signatures as the real one.
This lets us verify DTO mapping, status codes, and auth dependencies end-to-end
without Postgres or JWKS.
"""

from __future__ import annotations

from collections.abc import AsyncIterator
from datetime import UTC, datetime
from uuid import UUID, uuid4

import pytest
import pytest_asyncio
from app.core.config import Settings, get_settings
from app.core.exceptions import AuthError, NotFoundError
from app.core.security import create_access_token, create_refresh_token
from app.domains.auth.models import AuthProvider, DevicePlatform, User
from app.domains.auth.providers import get_auth_service
from app.domains.auth.service import LoginResult, RefreshResult
from app.main import create_app
from httpx import ASGITransport, AsyncClient


class FakeAuthService:
    """Drop-in replacement for AuthService. Records calls for assertions."""

    def __init__(self) -> None:
        self.kakao_calls: list[str] = []
        self.apple_calls: list[str] = []
        self.dev_calls: list[tuple[str, str | None]] = []
        self.refresh_calls: list[str] = []
        self.device_token_calls: list[tuple[UUID, str, DevicePlatform]] = []
        self.get_me_calls: list[UUID] = []
        self.delete_calls: list[UUID] = []
        self.fail_refresh: bool = False
        self.fail_get_me: bool = False
        self.dev_is_new_user: bool = True
        self.user = self._make_user()

    @staticmethod
    def _make_user() -> User:
        user = User(
            provider=AuthProvider.KAKAO,
            provider_sub="k-1",
            email="r@example.com",
            nickname="책벌레",
            profile_image_url=None,
        )
        user.id = uuid4()
        user.created_at = datetime.now(tz=UTC)
        user.updated_at = datetime.now(tz=UTC)
        return user

    async def login_with_kakao(self, *, access_token: str) -> LoginResult:
        self.kakao_calls.append(access_token)
        return LoginResult(
            access_token=create_access_token(str(self.user.id)),
            refresh_token=create_refresh_token(str(self.user.id)),
            user=self.user,
            is_new_user=True,
        )

    async def login_with_apple(self, *, identity_token: str) -> LoginResult:
        self.apple_calls.append(identity_token)
        return LoginResult(
            access_token=create_access_token(str(self.user.id)),
            refresh_token=create_refresh_token(str(self.user.id)),
            user=self.user,
            is_new_user=False,
        )

    async def login_dev(self, *, nickname: str, email: str | None) -> LoginResult:
        self.dev_calls.append((nickname, email))
        self.user.nickname = nickname
        return LoginResult(
            access_token=create_access_token(str(self.user.id)),
            refresh_token=create_refresh_token(str(self.user.id)),
            user=self.user,
            is_new_user=self.dev_is_new_user,
        )

    async def refresh(self, *, refresh_token: str) -> RefreshResult:
        self.refresh_calls.append(refresh_token)
        if self.fail_refresh:
            raise AuthError("refresh rejected", code="TOKEN_TYPE_MISMATCH")
        return RefreshResult(
            access_token=create_access_token(str(self.user.id)),
            refresh_token=create_refresh_token(str(self.user.id)),
        )

    async def register_device_token(
        self, *, user_id: UUID, token: str, platform: DevicePlatform
    ) -> None:
        self.device_token_calls.append((user_id, token, platform))

    async def get_me(self, *, user_id: UUID) -> User:
        self.get_me_calls.append(user_id)
        if self.fail_get_me:
            raise NotFoundError("user not found", code="USER_NOT_FOUND")
        return self.user

    async def delete_account(self, *, user_id: UUID) -> None:
        self.delete_calls.append(user_id)


@pytest_asyncio.fixture
async def client_and_fake() -> AsyncIterator[tuple[AsyncClient, FakeAuthService]]:
    app = create_app()
    fake = FakeAuthService()
    app.dependency_overrides[get_auth_service] = lambda: fake
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://testserver") as client:
        yield client, fake
    app.dependency_overrides.clear()


@pytest.mark.asyncio
async def test_kakao_login_returns_tokens_and_user(
    client_and_fake: tuple[AsyncClient, FakeAuthService],
) -> None:
    client, fake = client_and_fake

    response = await client.post(
        "/auth/kakao",
        json={"access_token": "kakao-sdk-access-token"},
    )

    assert response.status_code == 200
    body = response.json()
    assert body["token_type"] == "Bearer"
    assert body["expires_in"] > 0
    assert body["is_new_user"] is True
    assert body["access_token"]
    assert body["refresh_token"]
    assert body["user"]["nickname"] == "책벌레"
    assert body["user"]["provider"] == "kakao"
    assert fake.kakao_calls == ["kakao-sdk-access-token"]


@pytest.mark.asyncio
async def test_kakao_login_missing_access_token_returns_422(
    client_and_fake: tuple[AsyncClient, FakeAuthService],
) -> None:
    client, _ = client_and_fake
    response = await client.post("/auth/kakao", json={})
    assert response.status_code == 422


@pytest.mark.asyncio
async def test_apple_login_accepts_optional_authorization_code(
    client_and_fake: tuple[AsyncClient, FakeAuthService],
) -> None:
    client, fake = client_and_fake
    response = await client.post(
        "/auth/apple",
        json={"identity_token": "id.tok.sig", "authorization_code": "ignored"},
    )
    assert response.status_code == 200
    body = response.json()
    assert body["is_new_user"] is False
    assert fake.apple_calls == ["id.tok.sig"]


@pytest.mark.asyncio
async def test_refresh_returns_new_pair(
    client_and_fake: tuple[AsyncClient, FakeAuthService],
) -> None:
    client, fake = client_and_fake
    response = await client.post("/auth/refresh", json={"refresh_token": "dummy"})
    assert response.status_code == 200
    body = response.json()
    assert body["access_token"]
    assert body["refresh_token"]
    assert body["token_type"] == "Bearer"
    assert fake.refresh_calls == ["dummy"]


@pytest.mark.asyncio
async def test_refresh_401_on_token_type_mismatch(
    client_and_fake: tuple[AsyncClient, FakeAuthService],
) -> None:
    client, fake = client_and_fake
    fake.fail_refresh = True
    response = await client.post("/auth/refresh", json={"refresh_token": "bad"})
    assert response.status_code == 401
    body = response.json()
    assert body["error"]["code"] == "TOKEN_TYPE_MISMATCH"


@pytest.mark.asyncio
async def test_device_token_register_requires_auth(
    client_and_fake: tuple[AsyncClient, FakeAuthService],
) -> None:
    client, _ = client_and_fake
    response = await client.post("/auth/device-tokens", json={"token": "fcm-1", "platform": "ios"})
    assert response.status_code == 401


@pytest.mark.asyncio
async def test_device_token_register_returns_204(
    client_and_fake: tuple[AsyncClient, FakeAuthService],
) -> None:
    client, fake = client_and_fake
    token = create_access_token(str(fake.user.id))
    response = await client.post(
        "/auth/device-tokens",
        json={"token": "fcm-1", "platform": "aos"},
        headers={"Authorization": f"Bearer {token}"},
    )
    assert response.status_code == 204
    assert fake.device_token_calls == [(fake.user.id, "fcm-1", DevicePlatform.AOS)]


@pytest.mark.asyncio
async def test_device_token_rejects_invalid_platform(
    client_and_fake: tuple[AsyncClient, FakeAuthService],
) -> None:
    client, fake = client_and_fake
    token = create_access_token(str(fake.user.id))
    response = await client.post(
        "/auth/device-tokens",
        json={"token": "fcm-1", "platform": "windows"},
        headers={"Authorization": f"Bearer {token}"},
    )
    assert response.status_code == 422


@pytest.mark.asyncio
async def test_me_returns_user_profile(
    client_and_fake: tuple[AsyncClient, FakeAuthService],
) -> None:
    client, fake = client_and_fake
    token = create_access_token(str(fake.user.id))
    response = await client.get("/me", headers={"Authorization": f"Bearer {token}"})
    assert response.status_code == 200
    body = response.json()
    assert body["nickname"] == "책벌레"
    assert body["provider"] == "kakao"
    assert UUID(body["id"]) == fake.user.id


@pytest.mark.asyncio
async def test_me_401_without_token(
    client_and_fake: tuple[AsyncClient, FakeAuthService],
) -> None:
    client, _ = client_and_fake
    response = await client.get("/me")
    assert response.status_code == 401


@pytest.mark.asyncio
async def test_me_401_with_refresh_token(
    client_and_fake: tuple[AsyncClient, FakeAuthService],
) -> None:
    client, fake = client_and_fake
    refresh = create_refresh_token(str(fake.user.id))
    response = await client.get("/me", headers={"Authorization": f"Bearer {refresh}"})
    assert response.status_code == 401
    body = response.json()
    assert body["error"]["code"] == "TOKEN_TYPE_MISMATCH"


@pytest.mark.asyncio
async def test_delete_me_returns_204(
    client_and_fake: tuple[AsyncClient, FakeAuthService],
) -> None:
    client, fake = client_and_fake
    token = create_access_token(str(fake.user.id))
    response = await client.delete("/me", headers={"Authorization": f"Bearer {token}"})
    assert response.status_code == 204
    assert fake.delete_calls == [fake.user.id]


@pytest.mark.asyncio
async def test_delete_me_requires_auth(
    client_and_fake: tuple[AsyncClient, FakeAuthService],
) -> None:
    client, _ = client_and_fake
    response = await client.delete("/me")
    assert response.status_code == 401


@pytest.mark.asyncio
async def test_dev_login_creates_new_user(
    client_and_fake: tuple[AsyncClient, FakeAuthService],
) -> None:
    client, fake = client_and_fake
    fake.dev_is_new_user = True

    response = await client.post("/auth/dev-login", json={"nickname": "테스터"})

    assert response.status_code == 200
    body = response.json()
    assert body["is_new_user"] is True
    assert body["user"]["nickname"] == "테스터"
    assert body["access_token"]
    assert body["refresh_token"]
    assert fake.dev_calls == [("테스터", None)]


@pytest.mark.asyncio
async def test_dev_login_returns_existing_user(
    client_and_fake: tuple[AsyncClient, FakeAuthService],
) -> None:
    client, fake = client_and_fake

    # First call — treated as new.
    fake.dev_is_new_user = True
    first = await client.post("/auth/dev-login", json={"nickname": "개발자"})
    assert first.status_code == 200
    assert first.json()["is_new_user"] is True

    # Second call — same nickname, service reports existing user.
    fake.dev_is_new_user = False
    second = await client.post("/auth/dev-login", json={"nickname": "개발자"})
    assert second.status_code == 200
    assert second.json()["is_new_user"] is False
    assert fake.dev_calls == [("개발자", None), ("개발자", None)]


@pytest.mark.asyncio
async def test_dev_login_404_in_non_dev() -> None:
    # Override the settings dependency to pretend we're in production;
    # the endpoint must disappear with a plain 404, not an explicit error
    # code that would leak the route's existence.
    app = create_app()
    fake = FakeAuthService()
    app.dependency_overrides[get_auth_service] = lambda: fake
    app.dependency_overrides[get_settings] = lambda: Settings(env="prod")
    transport = ASGITransport(app=app)
    try:
        async with AsyncClient(transport=transport, base_url="http://testserver") as client:
            response = await client.post("/auth/dev-login", json={"nickname": "개발자"})
        assert response.status_code == 404
        assert fake.dev_calls == []
    finally:
        app.dependency_overrides.clear()

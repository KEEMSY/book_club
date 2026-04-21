"""Contract tests for the Kakao OAuth adapter.

Uses ``respx`` to stub the Kakao endpoints with fixtures under
``tests/fixtures/kakao/``. Asserts the adapter normalises the Kakao response
into :class:`KakaoUserProfile` and maps failures to :class:`KakaoAuthError`.
"""

from __future__ import annotations

import json
from collections.abc import AsyncIterator
from pathlib import Path
from typing import Any

import httpx
import pytest
import pytest_asyncio
import respx
from app.core.exceptions import KakaoAuthError
from app.core.http.base_client import AsyncHttpClient
from app.domains.auth.adapters.kakao_oauth_adapter import KakaoOAuthAdapter

FIXTURES = Path(__file__).resolve().parent.parent.parent / "fixtures"


def _load(path: str) -> dict[str, Any]:
    return json.loads((FIXTURES / path).read_text())


@pytest_asyncio.fixture
async def kakao_adapter() -> AsyncIterator[KakaoOAuthAdapter]:
    client = AsyncHttpClient(timeout=2.0, max_retries=0)
    adapter = KakaoOAuthAdapter(http_client=client)
    try:
        yield adapter
    finally:
        await client.aclose()


@pytest.mark.asyncio
async def test_kakao_happy_path(kakao_adapter: KakaoOAuthAdapter) -> None:
    token_payload = _load("kakao/token_success.json")
    me_payload = _load("kakao/me_success.json")

    with respx.mock(assert_all_called=True) as mock:
        mock.post("https://kauth.kakao.com/oauth/token").mock(
            return_value=httpx.Response(200, json=token_payload)
        )
        mock.get("https://kapi.kakao.com/v2/user/me").mock(
            return_value=httpx.Response(200, json=me_payload)
        )

        profile = await kakao_adapter.exchange_code_for_user(
            code="valid-code", redirect_uri="bookclub://auth/callback"
        )

    assert profile.sub == "4242424242"
    assert profile.email == "reader@example.com"
    assert profile.nickname == "책벌레"
    assert profile.profile_image_url == "https://k.kakaocdn.net/dn/test/profile_640x640.jpg"


@pytest.mark.asyncio
async def test_kakao_missing_email_still_returns_profile(
    kakao_adapter: KakaoOAuthAdapter,
) -> None:
    token_payload = _load("kakao/token_success.json")
    me_payload = _load("kakao/me_missing_email.json")

    with respx.mock(assert_all_called=True) as mock:
        mock.post("https://kauth.kakao.com/oauth/token").mock(
            return_value=httpx.Response(200, json=token_payload)
        )
        mock.get("https://kapi.kakao.com/v2/user/me").mock(
            return_value=httpx.Response(200, json=me_payload)
        )

        profile = await kakao_adapter.exchange_code_for_user(code="x", redirect_uri=None)

    assert profile.email is None
    assert profile.nickname == "이메일없음"
    assert profile.profile_image_url is None


@pytest.mark.asyncio
async def test_kakao_token_endpoint_4xx_raises(
    kakao_adapter: KakaoOAuthAdapter,
) -> None:
    error_payload = _load("kakao/token_error.json")

    with respx.mock(assert_all_called=True) as mock:
        mock.post("https://kauth.kakao.com/oauth/token").mock(
            return_value=httpx.Response(401, json=error_payload)
        )

        with pytest.raises(KakaoAuthError):
            await kakao_adapter.exchange_code_for_user(code="bad", redirect_uri=None)


@pytest.mark.asyncio
async def test_kakao_user_info_4xx_raises(
    kakao_adapter: KakaoOAuthAdapter,
) -> None:
    token_payload = _load("kakao/token_success.json")

    with respx.mock(assert_all_called=True) as mock:
        mock.post("https://kauth.kakao.com/oauth/token").mock(
            return_value=httpx.Response(200, json=token_payload)
        )
        mock.get("https://kapi.kakao.com/v2/user/me").mock(
            return_value=httpx.Response(401, json={"code": -401, "msg": "invalid"})
        )

        with pytest.raises(KakaoAuthError):
            await kakao_adapter.exchange_code_for_user(code="c", redirect_uri=None)

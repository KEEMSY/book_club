"""Contract tests for the Kakao OAuth adapter.

Uses ``respx`` to stub the Kakao user-info endpoint with fixtures under
``tests/fixtures/kakao/``. Asserts the adapter normalises the Kakao response
into :class:`KakaoUserProfile` and maps failures to :class:`KakaoAuthError`.

Note: the adapter no longer calls ``/oauth/token`` because the mobile Kakao
SDK on native platforms hands the client an access_token directly. All cases
here therefore only stub the user-info endpoint.
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
    me_payload = _load("kakao/me_success.json")

    with respx.mock(assert_all_called=True) as mock:
        mock.get("https://kapi.kakao.com/v2/user/me").mock(
            return_value=httpx.Response(200, json=me_payload)
        )

        profile = await kakao_adapter.fetch_user_by_access_token("valid-access-token")

    assert profile.sub == "4242424242"
    assert profile.email == "reader@example.com"
    assert profile.nickname == "책벌레"
    assert profile.profile_image_url == "https://k.kakaocdn.net/dn/test/profile_640x640.jpg"


@pytest.mark.asyncio
async def test_kakao_missing_email_still_returns_profile(
    kakao_adapter: KakaoOAuthAdapter,
) -> None:
    me_payload = _load("kakao/me_missing_email.json")

    with respx.mock(assert_all_called=True) as mock:
        mock.get("https://kapi.kakao.com/v2/user/me").mock(
            return_value=httpx.Response(200, json=me_payload)
        )

        profile = await kakao_adapter.fetch_user_by_access_token("tok")

    assert profile.email is None
    assert profile.nickname == "이메일없음"
    assert profile.profile_image_url is None


@pytest.mark.asyncio
async def test_kakao_user_info_401_maps_to_token_invalid(
    kakao_adapter: KakaoOAuthAdapter,
) -> None:
    with respx.mock(assert_all_called=True) as mock:
        mock.get("https://kapi.kakao.com/v2/user/me").mock(
            return_value=httpx.Response(401, json={"code": -401, "msg": "invalid"})
        )

        with pytest.raises(KakaoAuthError) as exc_info:
            await kakao_adapter.fetch_user_by_access_token("expired-or-bad")

    assert exc_info.value.code == "KAKAO_TOKEN_INVALID"

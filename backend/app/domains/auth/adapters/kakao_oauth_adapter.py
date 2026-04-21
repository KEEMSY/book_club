"""Kakao OAuth adapter.

Exchanges an authorization ``code`` for a Kakao access_token, then fetches
the Kakao user profile and normalizes it into ``KakaoUserProfile``.

- All HTTP calls flow through ``AsyncHttpClient`` so they inherit retries,
  timeouts, and header redaction (CLAUDE.md §9).
- Any non-2xx from Kakao maps to ``KakaoAuthError`` (401 to the caller).
- The nickname fallback ``"카카오회원"`` covers accounts that did not consent
  to profile scope — we need a non-null UI label even so.
"""

from __future__ import annotations

from typing import Any

from app.core.config import get_settings
from app.core.exceptions import KakaoAuthError
from app.core.http.base_client import AsyncHttpClient
from app.domains.auth.ports import KakaoUserProfile

_TOKEN_URL = "https://kauth.kakao.com/oauth/token"
_USER_ME_URL = "https://kapi.kakao.com/v2/user/me"
_DEFAULT_NICKNAME = "카카오회원"


class KakaoOAuthAdapter:
    """Implements :class:`app.domains.auth.ports.KakaoOAuthPort`."""

    def __init__(self, http_client: AsyncHttpClient | None = None) -> None:
        # A client passed by the caller lets tests inject a MockTransport.
        self._http = http_client or AsyncHttpClient(timeout=5.0, max_retries=2)
        self._owns_client = http_client is None

    async def aclose(self) -> None:
        if self._owns_client:
            await self._http.aclose()

    async def exchange_code_for_user(self, code: str, redirect_uri: str | None) -> KakaoUserProfile:
        access_token = await self._exchange_token(code, redirect_uri)
        return await self._fetch_profile(access_token)

    async def _exchange_token(self, code: str, redirect_uri: str | None) -> str:
        settings = get_settings()
        payload: dict[str, str] = {
            "grant_type": "authorization_code",
            "client_id": settings.kakao_rest_api_key,
            "code": code,
        }
        if redirect_uri:
            payload["redirect_uri"] = redirect_uri

        response = await self._http.post(
            _TOKEN_URL,
            data=payload,
            headers={"Content-Type": "application/x-www-form-urlencoded"},
        )
        if response.status_code >= 400:
            raise KakaoAuthError(
                f"kakao token exchange failed: {response.status_code}",
                code="KAKAO_TOKEN_EXCHANGE_FAILED",
            )

        body: dict[str, Any] = response.json()
        access_token = body.get("access_token")
        if not isinstance(access_token, str) or not access_token:
            raise KakaoAuthError(
                "kakao token response missing access_token",
                code="KAKAO_TOKEN_MALFORMED",
            )
        return access_token

    async def _fetch_profile(self, access_token: str) -> KakaoUserProfile:
        response = await self._http.get(
            _USER_ME_URL,
            headers={"Authorization": f"Bearer {access_token}"},
        )
        if response.status_code >= 400:
            raise KakaoAuthError(
                f"kakao user info failed: {response.status_code}",
                code="KAKAO_USER_INFO_FAILED",
            )

        body: dict[str, Any] = response.json()
        kakao_id = body.get("id")
        if kakao_id is None:
            raise KakaoAuthError(
                "kakao user info missing id",
                code="KAKAO_USER_INFO_MALFORMED",
            )
        sub = str(kakao_id)

        account: dict[str, Any] = body.get("kakao_account") or {}
        properties: dict[str, Any] = body.get("properties") or {}

        email = account.get("email") if isinstance(account.get("email"), str) else None
        nickname = properties.get("nickname")
        if not isinstance(nickname, str) or not nickname.strip():
            nickname = _DEFAULT_NICKNAME

        profile_image_url = properties.get("profile_image")
        if not isinstance(profile_image_url, str) or not profile_image_url.strip():
            profile_image_url = None

        return KakaoUserProfile(
            sub=sub,
            email=email,
            nickname=nickname,
            profile_image_url=profile_image_url,
        )

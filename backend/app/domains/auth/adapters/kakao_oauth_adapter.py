"""Kakao OAuth adapter.

Calls ``GET https://kapi.kakao.com/v2/user/me`` with the bearer access_token
the mobile Kakao SDK already obtained, and normalizes the response into
:class:`KakaoUserProfile`.

- No ``/oauth/token`` exchange step: the Kakao Flutter SDK on native iOS /
  Android never yields an authorization code, only an access_token. Calling
  the token endpoint with an already-exchanged token would be rejected by
  Kakao, so we talk directly to the user-info endpoint instead.
- All HTTP calls flow through ``AsyncHttpClient`` so they inherit retries,
  timeouts, and header redaction (CLAUDE.md §9).
- 401/403 from user-info maps to ``KakaoAuthError`` with code
  ``KAKAO_TOKEN_INVALID``; any other 4xx maps to ``KAKAO_USER_INFO_FAILED``.
- The nickname fallback ``"카카오회원"`` covers accounts that did not consent
  to profile scope — we need a non-null UI label even so.
"""

from __future__ import annotations

from typing import Any

from app.core.exceptions import KakaoAuthError
from app.core.http.base_client import AsyncHttpClient
from app.domains.auth.ports import KakaoUserProfile

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

    async def fetch_user_by_access_token(self, access_token: str) -> KakaoUserProfile:
        response = await self._http.get(
            _USER_ME_URL,
            headers={"Authorization": f"Bearer {access_token}"},
        )
        if response.status_code in (401, 403):
            raise KakaoAuthError(
                f"kakao access_token rejected: {response.status_code}",
                code="KAKAO_TOKEN_INVALID",
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

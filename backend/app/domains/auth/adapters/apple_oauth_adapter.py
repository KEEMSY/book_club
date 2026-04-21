"""Apple Sign In identity_token verification.

Verifies the RS256-signed identity_token issued by Apple against the JWKS at
``APPLE_KEYS_URL``. PyJWKClient handles the JWKS fetch + PEM conversion;
we wrap it in a process-wide cache with a 1-hour TTL because Apple rotates
keys regularly but not per-request.

Thread/async safety:
- The cache is guarded by an asyncio lock so two concurrent logins don't
  trigger two JWKS fetches at once.
- On verification failure of any kind (signature, aud, iss, exp, unknown kid)
  we raise :class:`AppleAuthError` with a specific ``code`` for observability.
"""

from __future__ import annotations

import asyncio
import time
from typing import Any

import jwt
from jwt import PyJWKClient

from app.core.config import get_settings
from app.core.exceptions import AppleAuthError
from app.domains.auth.ports import AppleUserProfile

_JWKS_TTL_SECONDS = 60 * 60


class _JWKSCache:
    """Process-global cache of Apple's PyJWKClient keyed by keys URL."""

    def __init__(self) -> None:
        self._clients: dict[str, tuple[PyJWKClient, float]] = {}
        self._lock = asyncio.Lock()

    async def get(self, keys_url: str) -> PyJWKClient:
        now = time.monotonic()
        async with self._lock:
            cached = self._clients.get(keys_url)
            if cached is not None:
                client, expires_at = cached
                if now < expires_at:
                    return client
            # PyJWKClient fetches lazily on first .get_signing_key_from_jwt() call,
            # but we reuse the instance so its internal cache survives between
            # requests within the TTL.
            client = PyJWKClient(keys_url)
            self._clients[keys_url] = (client, now + _JWKS_TTL_SECONDS)
            return client

    def clear(self) -> None:
        """Test hook: drop all cached clients."""
        self._clients.clear()


_jwks_cache = _JWKSCache()


class AppleOAuthAdapter:
    """Implements :class:`app.domains.auth.ports.AppleOAuthPort`."""

    def __init__(self, jwks_cache: _JWKSCache | None = None) -> None:
        self._cache = jwks_cache or _jwks_cache

    async def verify_identity_token(self, identity_token: str) -> AppleUserProfile:
        settings = get_settings()
        client = await self._cache.get(settings.apple_keys_url)

        try:
            signing_key = client.get_signing_key_from_jwt(identity_token)
        except jwt.PyJWKClientError as exc:
            raise AppleAuthError(
                f"apple jwks lookup failed: {exc}",
                code="APPLE_KID_UNKNOWN",
            ) from exc
        except Exception as exc:  # network / JSON errors from PyJWKClient
            raise AppleAuthError(
                f"apple jwks fetch failed: {exc}",
                code="APPLE_JWKS_UNAVAILABLE",
            ) from exc

        try:
            payload: dict[str, Any] = jwt.decode(
                identity_token,
                signing_key.key,
                algorithms=["RS256"],
                audience=settings.apple_client_id,
                issuer=settings.apple_issuer,
            )
        except jwt.ExpiredSignatureError as exc:
            raise AppleAuthError(
                "apple identity_token expired", code="APPLE_TOKEN_EXPIRED"
            ) from exc
        except jwt.InvalidAudienceError as exc:
            raise AppleAuthError(
                "apple identity_token audience mismatch", code="APPLE_BAD_AUDIENCE"
            ) from exc
        except jwt.InvalidIssuerError as exc:
            raise AppleAuthError(
                "apple identity_token issuer mismatch", code="APPLE_BAD_ISSUER"
            ) from exc
        except jwt.InvalidTokenError as exc:
            raise AppleAuthError(
                f"apple identity_token invalid: {exc}",
                code="APPLE_TOKEN_INVALID",
            ) from exc

        sub = payload.get("sub")
        if not isinstance(sub, str) or not sub:
            raise AppleAuthError(
                "apple identity_token missing sub",
                code="APPLE_TOKEN_MALFORMED",
            )
        email = payload.get("email") if isinstance(payload.get("email"), str) else None
        return AppleUserProfile(sub=sub, email=email)

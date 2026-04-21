"""JWT access / refresh token helpers.

Symmetric HS256 signing with a secret from Settings. Access tokens default to
60 minutes; refresh tokens default to 30 days. TTLs are overridable per call
for testing (e.g. to produce already-expired tokens).
"""

from __future__ import annotations

from datetime import UTC, datetime, timedelta
from typing import Any, Literal

import jwt

from app.core.config import get_settings
from app.core.exceptions import AuthError

TokenType = Literal["access", "refresh"]


def _create_token(
    user_id: str,
    token_type: TokenType,
    ttl: timedelta,
) -> str:
    settings = get_settings()
    now = datetime.now(UTC)
    payload: dict[str, Any] = {
        "sub": user_id,
        "type": token_type,
        "iat": int(now.timestamp()),
        "exp": int((now + ttl).timestamp()),
    }
    return jwt.encode(payload, settings.jwt_secret, algorithm=settings.jwt_alg)


def create_access_token(user_id: str, ttl: timedelta | None = None) -> str:
    settings = get_settings()
    effective_ttl = ttl if ttl is not None else timedelta(seconds=settings.jwt_access_ttl_seconds)
    return _create_token(user_id, "access", effective_ttl)


def create_refresh_token(user_id: str, ttl: timedelta | None = None) -> str:
    settings = get_settings()
    effective_ttl = ttl if ttl is not None else timedelta(seconds=settings.jwt_refresh_ttl_seconds)
    return _create_token(user_id, "refresh", effective_ttl)


def decode_token(token: str) -> dict[str, Any]:
    """Decode and verify a JWT. Raises AuthError on any failure."""
    settings = get_settings()
    try:
        payload: dict[str, Any] = jwt.decode(
            token,
            settings.jwt_secret,
            algorithms=[settings.jwt_alg],
        )
    except jwt.ExpiredSignatureError as exc:
        raise AuthError("token expired", code="TOKEN_EXPIRED") from exc
    except jwt.InvalidTokenError as exc:
        raise AuthError("invalid token", code="TOKEN_INVALID") from exc
    return payload

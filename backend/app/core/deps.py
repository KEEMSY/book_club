"""Shared FastAPI dependencies — auth resolution.

Three flavours are exposed so routes pick the right strictness:

- ``get_current_user_id_optional`` — returns ``None`` when the header is
  missing or malformed. For endpoints that support anonymous access (we
  have none in M1, but M5 may introduce browsing flows that do).
- ``get_current_user_id`` — requires a valid *access* token. Raises
  :class:`AuthError` otherwise, which the registered handler turns into
  HTTP 401.
- ``get_current_user`` — resolves a ``User`` ORM object via the repository
  port. Soft-deleted users are treated as unauthenticated.

The strict variants also enforce ``token_type == "access"`` so a refresh
token cannot be swapped for a session.
"""

from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import Depends, Header
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.core.exceptions import AuthError
from app.core.security import decode_token
from app.domains.auth.models import User
from app.domains.auth.repository import UserRepository


def _extract_bearer(authorization: str | None) -> str | None:
    if authorization is None:
        return None
    scheme, _, token = authorization.partition(" ")
    if scheme.lower() != "bearer" or not token:
        return None
    return token


async def get_current_user_id_optional(
    authorization: str | None = Header(default=None),
) -> str | None:
    """Return the access-token ``sub`` or ``None`` when unauthenticated.

    Malformed or non-access tokens return ``None`` rather than raising so
    callers can decide whether to 401 themselves.
    """
    token = _extract_bearer(authorization)
    if token is None:
        return None
    try:
        payload = decode_token(token)
    except AuthError:
        return None
    if payload.get("type") != "access":
        return None
    sub = payload.get("sub")
    return sub if isinstance(sub, str) else None


async def get_current_user_id(
    authorization: str | None = Header(default=None),
) -> str:
    """Require a valid access token; raise AuthError -> 401 otherwise."""
    token = _extract_bearer(authorization)
    if token is None:
        raise AuthError("missing bearer token", code="MISSING_BEARER")

    payload = decode_token(token)  # raises AuthError on expiry / tamper
    if payload.get("type") != "access":
        raise AuthError("expected an access token", code="TOKEN_TYPE_MISMATCH")
    sub = payload.get("sub")
    if not isinstance(sub, str) or not sub:
        raise AuthError("token missing sub", code="TOKEN_INVALID")
    return sub


async def get_current_user(
    user_id: Annotated[str, Depends(get_current_user_id)],
    session: Annotated[AsyncSession, Depends(get_session)],
) -> User:
    """Resolve the ``User`` for the current access token.

    Soft-deleted users surface as 401 — by the time the token was issued the
    user existed, but we must reject requests from deleted accounts.
    """
    try:
        parsed = UUID(user_id)
    except ValueError as exc:
        raise AuthError("token sub is not a uuid", code="TOKEN_INVALID") from exc

    repo = UserRepository(session)
    user = await repo.get_by_id(parsed)
    if user is None:
        raise AuthError("user no longer exists", code="USER_GONE")
    return user

"""Custom ASGI middleware for the Book Club API.

``LastActiveMiddleware`` updates ``users.last_active_at`` for every
authenticated request. A Redis key with TTL 60 s is used as a debounce so
the DB write only happens when the TTL expires — not on every request.

Key format: ``last_active:{user_id}``
"""

from __future__ import annotations

import logging
from datetime import UTC, datetime

from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import Response
from starlette.types import ASGIApp

from app.core.cache import get_redis
from app.core.security import decode_token
from app.shared.i18n import DEFAULT_LANG, SUPPORTED_LANGS

logger = logging.getLogger(__name__)

# How long (seconds) before the DB write is re-triggered.
_DEBOUNCE_TTL_SECONDS = 60
_REDIS_KEY_PREFIX = "last_active:"


def _extract_user_id(authorization: str | None) -> str | None:
    """Pull the ``sub`` from a Bearer access token without raising on failure."""
    if authorization is None:
        return None
    scheme, _, token = authorization.partition(" ")
    if scheme.lower() != "bearer" or not token:
        return None
    try:
        payload = decode_token(token)
    except Exception:
        return None
    if payload.get("type") != "access":
        return None
    sub = payload.get("sub")
    return sub if isinstance(sub, str) and sub else None


class LanguageMiddleware(BaseHTTPMiddleware):
    """Resolve the request language into ``request.state.lang`` (M72).

    Parses only the highest-priority tag of ``Accept-Language`` (q-values are
    ignored — the mobile client sends a single tag matching the in-app language
    toggle) and normalizes ``en-US`` → ``en``. Unsupported or missing languages
    fall back to Korean, matching :data:`app.shared.i18n.DEFAULT_LANG`.
    """

    async def dispatch(self, request: Request, call_next: object) -> Response:
        accept_lang = request.headers.get("Accept-Language", DEFAULT_LANG)
        lang = accept_lang.split(",")[0].split("-")[0].strip().lower()
        request.state.lang = lang if lang in SUPPORTED_LANGS else DEFAULT_LANG
        response: Response = await call_next(request)  # type: ignore[operator]
        return response


class LastActiveMiddleware(BaseHTTPMiddleware):
    """Update users.last_active_at after each authenticated response.

    Uses Redis as a debounce gate: a key is SET with TTL 60 s on the first
    request; the DB write is skipped until the key expires. This keeps the
    per-request cost to a single Redis GET/SET rather than a DB UPDATE on
    every request.

    The DB write runs after the response is sent (post-response hook inside
    ``dispatch``) so it cannot delay the response to the client.
    """

    def __init__(self, app: ASGIApp) -> None:
        super().__init__(app)

    async def dispatch(self, request: Request, call_next: object) -> Response:
        response: Response = await call_next(request)  # type: ignore[operator]

        user_id = _extract_user_id(request.headers.get("authorization"))
        if user_id is None:
            return response

        # Fire-and-forget: errors must not bubble up to the client.
        try:
            await self._maybe_update_last_active(user_id)
        except Exception:
            logger.exception("last_active_middleware_error user_id=%s", user_id)

        return response

    async def _maybe_update_last_active(self, user_id: str) -> None:
        redis = get_redis()
        key = f"{_REDIS_KEY_PREFIX}{user_id}"

        # SET NX (only set if not exists) with TTL — returns True when the key
        # was newly created, False when it was already present.
        was_set = await redis.set(key, "1", ex=_DEBOUNCE_TTL_SECONDS, nx=True)
        if not was_set:
            # Key already present → DB update not due yet.
            return

        # TTL expired (or first request) — write to DB.
        await self._write_last_active_to_db(user_id)

    @staticmethod
    async def _write_last_active_to_db(user_id: str) -> None:
        """Open a short-lived session and stamp last_active_at = now()."""
        from uuid import UUID

        from app.core.db import get_sessionmaker

        try:
            parsed = UUID(user_id)
        except ValueError:
            return

        sessionmaker = get_sessionmaker()
        async with sessionmaker() as session:
            from sqlalchemy import update

            from app.domains.auth.models import User

            now = datetime.now(tz=UTC)
            stmt = (
                update(User)
                .where(User.id == parsed, User.deleted_at.is_(None))
                .values(last_active_at=now)
            )
            await session.execute(stmt)
            await session.commit()

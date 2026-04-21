"""Shared FastAPI dependencies (auth helpers, etc.).

`get_current_user_id` is a lightweight placeholder: it reads the Authorization
header, decodes the JWT, and returns the `sub` claim. Returns None when the
header is missing so routes can remain anonymous-friendly during M0. Milestone 1
will add a required variant that raises AuthError for protected routes.
"""

from __future__ import annotations

from fastapi import Header

from app.core.security import decode_token


async def get_current_user_id(
    authorization: str | None = Header(default=None),
) -> str | None:
    if authorization is None:
        return None

    scheme, _, token = authorization.partition(" ")
    if scheme.lower() != "bearer" or not token:
        return None

    payload = decode_token(token)
    sub = payload.get("sub")
    return sub if isinstance(sub, str) else None

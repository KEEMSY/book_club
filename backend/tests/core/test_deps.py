"""Unit tests for the auth dependencies — token-type strictness, optional vs required."""

from __future__ import annotations

from datetime import timedelta

import pytest
from app.core.deps import get_current_user_id, get_current_user_id_optional
from app.core.exceptions import AuthError
from app.core.security import create_access_token, create_refresh_token


async def test_optional_returns_none_for_missing_header() -> None:
    assert await get_current_user_id_optional(authorization=None) is None


async def test_optional_returns_none_for_non_bearer_scheme() -> None:
    assert await get_current_user_id_optional(authorization="Basic abc") is None


async def test_optional_returns_none_for_refresh_token() -> None:
    refresh = create_refresh_token("user-1")
    assert await get_current_user_id_optional(authorization=f"Bearer {refresh}") is None


async def test_optional_returns_sub_for_valid_access_token() -> None:
    access = create_access_token("user-abc")
    assert await get_current_user_id_optional(authorization=f"Bearer {access}") == "user-abc"


async def test_required_raises_on_missing_header() -> None:
    with pytest.raises(AuthError) as exc_info:
        await get_current_user_id(authorization=None)
    assert exc_info.value.code == "MISSING_BEARER"


async def test_required_raises_on_refresh_token() -> None:
    refresh = create_refresh_token("user-1")
    with pytest.raises(AuthError) as exc_info:
        await get_current_user_id(authorization=f"Bearer {refresh}")
    assert exc_info.value.code == "TOKEN_TYPE_MISMATCH"


async def test_required_raises_on_expired_access_token() -> None:
    expired = create_access_token("user-1", ttl=timedelta(seconds=-1))
    with pytest.raises(AuthError):
        await get_current_user_id(authorization=f"Bearer {expired}")


async def test_required_returns_sub_for_valid_access_token() -> None:
    access = create_access_token("user-xyz")
    assert await get_current_user_id(authorization=f"Bearer {access}") == "user-xyz"

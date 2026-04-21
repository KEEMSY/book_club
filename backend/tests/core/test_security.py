"""Unit tests for JWT access / refresh token helpers."""

from __future__ import annotations

from datetime import timedelta

import pytest
from app.core.exceptions import AuthError
from app.core.security import (
    create_access_token,
    create_refresh_token,
    decode_token,
)


def test_access_token_roundtrip() -> None:
    token = create_access_token(user_id="user-42")

    payload = decode_token(token)

    assert payload["sub"] == "user-42"
    assert payload["type"] == "access"
    assert "exp" in payload
    assert "iat" in payload


def test_refresh_token_roundtrip() -> None:
    token = create_refresh_token(user_id="user-99")

    payload = decode_token(token)

    assert payload["sub"] == "user-99"
    assert payload["type"] == "refresh"


def test_decode_rejects_expired_token() -> None:
    expired = create_access_token(user_id="user-1", ttl=timedelta(seconds=-1))

    with pytest.raises(AuthError):
        decode_token(expired)


def test_decode_rejects_tampered_token() -> None:
    token = create_access_token(user_id="user-1")
    # Flip the final character of the signature segment.
    tampered = token[:-1] + ("a" if token[-1] != "a" else "b")

    with pytest.raises(AuthError):
        decode_token(tampered)

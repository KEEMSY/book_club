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
    # Swap the middle byte of the signature so the HMAC no longer matches.
    # Flipping only the last base64url character can decode to the same bytes
    # under some backends, so mutate a character well inside the signature.
    header_body, _, signature = token.rpartition(".")
    mid = len(signature) // 2
    swapped = "A" if signature[mid] != "A" else "B"
    tampered = f"{header_body}.{signature[:mid]}{swapped}{signature[mid + 1 :]}"

    with pytest.raises(AuthError):
        decode_token(tampered)

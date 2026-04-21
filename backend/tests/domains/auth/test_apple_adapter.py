"""Contract tests for the Apple OAuth (Sign In) identity_token verifier.

Tests generate an RSA keypair in-process, expose the public half as a JWKS
document the adapter can consume, and sign identity_tokens inline. No real
Apple material ships with the repo — see ``tests/fixtures/apple/README.md``.

PyJWKClient fetches JWKS via urllib, not httpx, so respx cannot intercept
it. Instead we monkeypatch ``PyJWKClient.fetch_data`` with a stub that also
primes the client's internal cache, matching real behaviour.
"""

from __future__ import annotations

import json
import os
import time
from typing import Any

import jwt
import pytest
from app.core.config import get_settings
from app.core.exceptions import AppleAuthError
from app.domains.auth.adapters.apple_oauth_adapter import (
    AppleOAuthAdapter,
    _JWKSCache,
)
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa

_APPLE_CLIENT_ID = "kr.mission-driven.bookclub"
_APPLE_ISSUER = "https://appleid.apple.com"
_APPLE_KEYS_URL = "https://appleid.apple.com/auth/keys"


class _RSAFactory:
    """Generate an RSA keypair + matching JWKS dict for a given ``kid``."""

    def __init__(self, kid: str) -> None:
        self.kid = kid
        self.private_key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
        self.public_key = self.private_key.public_key()

    def jwks(self) -> dict[str, Any]:
        from jwt.algorithms import RSAAlgorithm

        jwk_json = RSAAlgorithm.to_jwk(self.public_key)
        jwk = json.loads(jwk_json)
        jwk["kid"] = self.kid
        jwk["alg"] = "RS256"
        jwk["use"] = "sig"
        return {"keys": [jwk]}

    def private_pem(self) -> bytes:
        return self.private_key.private_bytes(
            encoding=serialization.Encoding.PEM,
            format=serialization.PrivateFormat.PKCS8,
            encryption_algorithm=serialization.NoEncryption(),
        )


def _encode_apple_token(
    factory: _RSAFactory,
    *,
    sub: str = "001234.abc.def",
    email: str | None = "apple-user@privaterelay.appleid.com",
    aud: str = _APPLE_CLIENT_ID,
    iss: str = _APPLE_ISSUER,
    exp_offset: int = 600,
) -> str:
    now = int(time.time())
    payload: dict[str, Any] = {
        "iss": iss,
        "aud": aud,
        "exp": now + exp_offset,
        "iat": now,
        "sub": sub,
    }
    if email is not None:
        payload["email"] = email
    return jwt.encode(
        payload,
        factory.private_pem(),
        algorithm="RS256",
        headers={"kid": factory.kid},
    )


@pytest.fixture(autouse=True)
def _apple_settings(monkeypatch: pytest.MonkeyPatch) -> Any:
    monkeypatch.setenv("APPLE_CLIENT_ID", _APPLE_CLIENT_ID)
    monkeypatch.setenv("APPLE_ISSUER", _APPLE_ISSUER)
    monkeypatch.setenv("APPLE_KEYS_URL", _APPLE_KEYS_URL)
    get_settings.cache_clear()
    yield
    get_settings.cache_clear()


@pytest.fixture
def apple_factory() -> _RSAFactory:
    return _RSAFactory(kid=f"test-kid-{os.getpid()}")


@pytest.fixture
def fresh_apple_adapter() -> AppleOAuthAdapter:
    return AppleOAuthAdapter(jwks_cache=_JWKSCache())


class _FetchCounter:
    """Wraps the JWKS dict so tests can assert how many times fetch_data ran."""

    def __init__(self, jwks: dict[str, Any]) -> None:
        self.jwks = jwks
        self.call_count = 0

    def __call__(self) -> dict[str, Any]:
        self.call_count += 1
        return self.jwks


@pytest.fixture
def patch_jwks(monkeypatch: pytest.MonkeyPatch) -> Any:
    def install(jwks: dict[str, Any]) -> _FetchCounter:
        counter = _FetchCounter(jwks)

        def _fake_fetch(self: Any) -> dict[str, Any]:
            data = counter()
            # Match real fetch_data's finally-block: prime jwk_set_cache so
            # subsequent get_jwk_set calls read cache, not network.
            if self.jwk_set_cache is not None:
                self.jwk_set_cache.put(data)
            return data

        monkeypatch.setattr(
            "jwt.jwks_client.PyJWKClient.fetch_data",
            _fake_fetch,
            raising=True,
        )
        return counter

    return install


@pytest.mark.asyncio
async def test_apple_happy_path(
    apple_factory: _RSAFactory,
    fresh_apple_adapter: AppleOAuthAdapter,
    patch_jwks: Any,
) -> None:
    patch_jwks(apple_factory.jwks())
    token = _encode_apple_token(apple_factory)

    profile = await fresh_apple_adapter.verify_identity_token(token)

    assert profile.sub == "001234.abc.def"
    assert profile.email == "apple-user@privaterelay.appleid.com"


@pytest.mark.asyncio
async def test_apple_expired_token_raises(
    apple_factory: _RSAFactory,
    fresh_apple_adapter: AppleOAuthAdapter,
    patch_jwks: Any,
) -> None:
    patch_jwks(apple_factory.jwks())
    token = _encode_apple_token(apple_factory, exp_offset=-10)

    with pytest.raises(AppleAuthError) as exc_info:
        await fresh_apple_adapter.verify_identity_token(token)

    assert exc_info.value.code == "APPLE_TOKEN_EXPIRED"


@pytest.mark.asyncio
async def test_apple_wrong_audience_raises(
    apple_factory: _RSAFactory,
    fresh_apple_adapter: AppleOAuthAdapter,
    patch_jwks: Any,
) -> None:
    patch_jwks(apple_factory.jwks())
    token = _encode_apple_token(apple_factory, aud="com.example.other")

    with pytest.raises(AppleAuthError) as exc_info:
        await fresh_apple_adapter.verify_identity_token(token)

    assert exc_info.value.code == "APPLE_BAD_AUDIENCE"


@pytest.mark.asyncio
async def test_apple_wrong_issuer_raises(
    apple_factory: _RSAFactory,
    fresh_apple_adapter: AppleOAuthAdapter,
    patch_jwks: Any,
) -> None:
    patch_jwks(apple_factory.jwks())
    token = _encode_apple_token(apple_factory, iss="https://evil.example.com")

    with pytest.raises(AppleAuthError) as exc_info:
        await fresh_apple_adapter.verify_identity_token(token)

    assert exc_info.value.code == "APPLE_BAD_ISSUER"


@pytest.mark.asyncio
async def test_apple_unknown_kid_raises(
    apple_factory: _RSAFactory,
    fresh_apple_adapter: AppleOAuthAdapter,
    patch_jwks: Any,
) -> None:
    # JWKS published is for a different kid than the token header claims.
    other_factory = _RSAFactory(kid="other-kid")
    patch_jwks(other_factory.jwks())
    token = _encode_apple_token(apple_factory)

    with pytest.raises(AppleAuthError) as exc_info:
        await fresh_apple_adapter.verify_identity_token(token)

    assert exc_info.value.code in {"APPLE_KID_UNKNOWN", "APPLE_JWKS_UNAVAILABLE"}


@pytest.mark.asyncio
async def test_apple_jwks_cache_reused_within_ttl(
    apple_factory: _RSAFactory,
    fresh_apple_adapter: AppleOAuthAdapter,
    patch_jwks: Any,
) -> None:
    # Two consecutive verifies should result in exactly one JWKS fetch because
    # PyJWKClient caches the JWK set and the adapter reuses the same instance.
    counter = patch_jwks(apple_factory.jwks())
    first = _encode_apple_token(apple_factory, sub="sub-1")
    second = _encode_apple_token(apple_factory, sub="sub-2")

    profile_one = await fresh_apple_adapter.verify_identity_token(first)
    profile_two = await fresh_apple_adapter.verify_identity_token(second)

    assert profile_one.sub == "sub-1"
    assert profile_two.sub == "sub-2"
    assert counter.call_count == 1

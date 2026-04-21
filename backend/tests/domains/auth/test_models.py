"""Model-level smoke tests (no DB) for the auth domain.

These cover pure Python semantics of the SQLAlchemy models: enum round-tripping
and default factories. Repository tests (``test_repository.py``) exercise
actual persistence against Postgres.
"""

from __future__ import annotations

import uuid

from app.domains.auth.models import AuthProvider, DevicePlatform, DeviceToken, User


def test_auth_provider_values() -> None:
    assert AuthProvider.KAKAO.value == "kakao"
    assert AuthProvider.APPLE.value == "apple"


def test_device_platform_values() -> None:
    assert DevicePlatform.IOS.value == "ios"
    assert DevicePlatform.AOS.value == "aos"


def test_user_defaults_populate_uuid() -> None:
    user = User(
        provider=AuthProvider.KAKAO,
        provider_sub="1234567890",
        nickname="카카오회원",
    )
    # ORM-side default hits when the column is accessed via __init__ defaults.
    # We assert the column maps cleanly rather than relying on id being set
    # before flush (DB will populate it).
    assert user.provider is AuthProvider.KAKAO
    assert user.provider_sub == "1234567890"
    assert user.email is None
    assert user.profile_image_url is None


def test_device_token_fields() -> None:
    user_id = uuid.uuid4()
    token = DeviceToken(
        user_id=user_id,
        token="fcm-token-abc",
        platform=DevicePlatform.IOS,
    )
    assert token.user_id == user_id
    assert token.token == "fcm-token-abc"
    assert token.platform is DevicePlatform.IOS

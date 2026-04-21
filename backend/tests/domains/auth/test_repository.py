"""Integration tests for the auth repository adapters (async Postgres)."""

from __future__ import annotations

from datetime import UTC, datetime, timedelta

import pytest
from app.core.exceptions import ConflictError
from app.domains.auth.models import AuthProvider, DevicePlatform
from app.domains.auth.repository import DeviceTokenRepository, UserRepository
from sqlalchemy.ext.asyncio import AsyncSession


@pytest.mark.asyncio
async def test_get_by_provider_sub_returns_none_when_absent(session: AsyncSession) -> None:
    repo = UserRepository(session)

    user = await repo.get_by_provider_sub(AuthProvider.KAKAO, "missing-sub")

    assert user is None


@pytest.mark.asyncio
async def test_create_persists_and_enforces_unique(session: AsyncSession) -> None:
    repo = UserRepository(session)

    created = await repo.create(
        provider=AuthProvider.KAKAO,
        sub="k-1",
        email="user@example.com",
        nickname="책벌레",
        profile_image_url=None,
    )

    assert created.id is not None
    fetched = await repo.get_by_provider_sub(AuthProvider.KAKAO, "k-1")
    assert fetched is not None
    assert fetched.id == created.id
    assert fetched.nickname == "책벌레"

    # second create with same (provider, sub) must collide.
    with pytest.raises(ConflictError):
        await repo.create(
            provider=AuthProvider.KAKAO,
            sub="k-1",
            email=None,
            nickname="다른닉네임",
            profile_image_url=None,
        )


@pytest.mark.asyncio
async def test_update_last_login_moves_field_forward(session: AsyncSession) -> None:
    repo = UserRepository(session)
    user = await repo.create(
        provider=AuthProvider.APPLE,
        sub="a-1",
        email=None,
        nickname="애플회원",
        profile_image_url=None,
    )
    assert user.last_login_at is None

    now = datetime.now(tz=UTC)
    await repo.update_last_login(user.id, now)
    await session.refresh(user)

    assert user.last_login_at is not None
    assert user.last_login_at.replace(microsecond=0) == now.replace(microsecond=0)


@pytest.mark.asyncio
async def test_soft_delete_hides_user(session: AsyncSession) -> None:
    repo = UserRepository(session)
    user = await repo.create(
        provider=AuthProvider.KAKAO,
        sub="k-delete",
        email=None,
        nickname="탈퇴예정",
        profile_image_url=None,
    )

    await repo.soft_delete(user.id, datetime.now(tz=UTC))

    assert await repo.get_by_provider_sub(AuthProvider.KAKAO, "k-delete") is None
    assert await repo.get_by_id(user.id) is None


@pytest.mark.asyncio
async def test_device_token_upsert_creates_then_updates(session: AsyncSession) -> None:
    user_repo = UserRepository(session)
    token_repo = DeviceTokenRepository(session)
    user = await user_repo.create(
        provider=AuthProvider.KAKAO,
        sub="k-dev",
        email=None,
        nickname="디바이스",
        profile_image_url=None,
    )

    first = await token_repo.upsert(user.id, "fcm-xyz", DevicePlatform.IOS)
    first_seen = first.last_seen_at

    # Call again with the same token but a different platform — expect the same
    # row updated in place, not a duplicate.
    second = await token_repo.upsert(user.id, "fcm-xyz", DevicePlatform.AOS)

    assert second.id == first.id
    assert second.platform is DevicePlatform.AOS
    assert second.last_seen_at >= first_seen

    all_tokens = await token_repo.get_active_tokens_for_user(user.id)
    assert len(all_tokens) == 1


@pytest.mark.asyncio
async def test_device_token_touch_updates_last_seen(session: AsyncSession) -> None:
    user_repo = UserRepository(session)
    token_repo = DeviceTokenRepository(session)
    user = await user_repo.create(
        provider=AuthProvider.KAKAO,
        sub="k-touch",
        email=None,
        nickname="터치",
        profile_image_url=None,
    )
    inserted = await token_repo.upsert(user.id, "fcm-touch", DevicePlatform.IOS)
    # Force the subsequent touch to produce a strictly later timestamp even
    # on fast test machines that tick at microsecond resolution.
    original_seen = inserted.last_seen_at - timedelta(seconds=1)
    inserted.last_seen_at = original_seen
    await session.flush()

    await token_repo.touch("fcm-touch")
    await session.refresh(inserted)

    assert inserted.last_seen_at > original_seen

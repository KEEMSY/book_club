"""Integration tests for BC-91 notification preferences (real async Postgres).

Verifies:
- ``NotificationPreferenceRepository`` persists and round-trips the sparse
  override map.
- ``NotificationRouterService.get/update_notification_preferences`` merge
  stored overrides with defaults (unset = on) and merge partial updates
  without clobbering unrelated keys, silently dropping unknown/required keys.
- ``NotificationService`` — end to end, with a real sessionmaker rather than
  the request-scoped ``session`` fixture (module docstring in ``service.py``:
  event handlers open their own sessions) — actually skips both the in-app row
  and the push when the recipient turned the type off, and still delivers
  when no preference row exists at all (default on).
"""

from __future__ import annotations

from typing import Any
from uuid import UUID, uuid4

import pytest
from app.domains.auth.models import AuthProvider, DeviceToken
from app.domains.auth.repository import UserRepository
from app.domains.feed.events import ReactionAdded
from app.domains.notification.models import NotificationType
from app.domains.notification.repository import (
    NotificationPreferenceRepository,
    NotificationRepository,
    WeeklyReportRepository,
)
from app.domains.notification.service import NotificationService
from app.domains.notification.service_router import NotificationRouterService
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker


class _FakePushAdapter:
    """Records push calls for assertion (no real FCM call)."""

    def __init__(self) -> None:
        self.calls: list[dict[str, Any]] = []

    async def send_to_tokens(
        self, tokens: list[str], title: str, body: str, data: dict[str, str]
    ) -> None:
        self.calls.append({"tokens": tokens, "title": title, "body": body, "data": data})


class _DeviceTokenAdapter:
    """Reads FCM tokens from the real auth.device_tokens table."""

    def __init__(self, sessionmaker: async_sessionmaker[AsyncSession]) -> None:
        self._sessionmaker = sessionmaker

    async def get_active_tokens(self, user_id: UUID) -> list[str]:
        async with self._sessionmaker() as s:
            result = await s.execute(
                select(DeviceToken.token).where(DeviceToken.user_id == user_id)
            )
            return list(result.scalars().all())


class _NoopActiveUserAdapter:
    async def get_all_active_user_ids(self) -> list[UUID]:
        return []


class _NoopDailyStatAdapter:
    async def get_stats_for_week(self, user_id: UUID, week_start: Any, week_end: Any) -> list[Any]:
        return []


class _NoopSessionQueryAdapter:
    async def get_longest_in_range(self, user_id: UUID, from_date: Any, to_date: Any) -> int:
        return 0


async def _create_user(session: AsyncSession, *, sub: str) -> UUID:
    user_repo = UserRepository(session)
    user = await user_repo.create(
        provider=AuthProvider.KAKAO,
        sub=sub,
        email=None,
        nickname=f"user-{sub}",
        profile_image_url=None,
    )
    return user.id


async def _add_device_token(session: AsyncSession, *, user_id: UUID, token: str) -> None:
    from app.domains.auth.models import DevicePlatform

    session.add(DeviceToken(user_id=user_id, token=token, platform=DevicePlatform.AOS))
    await session.flush()


# ---------------------------------------------------------------------------
# Repository round-trip
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_repository_get_overrides_returns_empty_when_unset(session: AsyncSession) -> None:
    user_id = await _create_user(session, sub="pref-1")
    repo = NotificationPreferenceRepository(session)

    overrides = await repo.get_overrides(user_id)

    assert overrides == {}


@pytest.mark.asyncio
async def test_repository_upsert_overrides_round_trip(session: AsyncSession) -> None:
    user_id = await _create_user(session, sub="pref-2")
    repo = NotificationPreferenceRepository(session)

    saved = await repo.upsert_overrides(
        user_id, {NotificationType.REACTION.value: False, NotificationType.COMMENT.value: True}
    )
    assert saved == {NotificationType.REACTION.value: False, NotificationType.COMMENT.value: True}

    # A second upsert wholesale-replaces — the repository does not merge.
    replaced = await repo.upsert_overrides(user_id, {NotificationType.FOLLOW_RECEIVED.value: False})
    assert replaced == {NotificationType.FOLLOW_RECEIVED.value: False}

    reloaded = await repo.get_overrides(user_id)
    assert reloaded == {NotificationType.FOLLOW_RECEIVED.value: False}


# ---------------------------------------------------------------------------
# NotificationRouterService — merge-with-default + partial update
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_router_service_get_preferences_defaults_all_toggleable_types_on(
    session: AsyncSession,
) -> None:
    user_id = await _create_user(session, sub="pref-3")
    svc = NotificationRouterService(
        notifications=NotificationRepository(session),
        weekly_reports=WeeklyReportRepository(session),
        preferences=NotificationPreferenceRepository(session),
    )

    prefs = await svc.get_notification_preferences(user_id)

    assert prefs[NotificationType.REACTION.value] is True
    assert prefs[NotificationType.AGENDA_PUBLISHED.value] is True
    # Required types never appear in the toggleable preferences map.
    assert NotificationType.SUBSCRIPTION_REMINDER.value not in prefs


@pytest.mark.asyncio
async def test_router_service_update_preferences_partial_merge(session: AsyncSession) -> None:
    user_id = await _create_user(session, sub="pref-4")
    svc = NotificationRouterService(
        notifications=NotificationRepository(session),
        weekly_reports=WeeklyReportRepository(session),
        preferences=NotificationPreferenceRepository(session),
    )

    first = await svc.update_notification_preferences(
        user_id, {NotificationType.REACTION.value: False}
    )
    assert first[NotificationType.REACTION.value] is False
    assert first[NotificationType.COMMENT.value] is True  # untouched, still default on

    # A second partial update must not clobber the REACTION=False set earlier.
    second = await svc.update_notification_preferences(
        user_id, {NotificationType.COMMENT.value: False}
    )
    assert second[NotificationType.REACTION.value] is False
    assert second[NotificationType.COMMENT.value] is False


@pytest.mark.asyncio
async def test_router_service_update_preferences_ignores_unknown_and_required_keys(
    session: AsyncSession,
) -> None:
    user_id = await _create_user(session, sub="pref-5")
    svc = NotificationRouterService(
        notifications=NotificationRepository(session),
        weekly_reports=WeeklyReportRepository(session),
        preferences=NotificationPreferenceRepository(session),
    )

    result = await svc.update_notification_preferences(
        user_id,
        {
            "not_a_real_type": False,
            NotificationType.SUBSCRIPTION_REMINDER.value: False,  # required — must not persist
            NotificationType.REACTION.value: False,  # the one real, toggleable change
        },
    )

    assert result[NotificationType.REACTION.value] is False
    assert "not_a_real_type" not in result
    assert NotificationType.SUBSCRIPTION_REMINDER.value not in result

    stored = await NotificationPreferenceRepository(session).get_overrides(user_id)
    assert stored == {NotificationType.REACTION.value: False}


# ---------------------------------------------------------------------------
# NotificationService — end-to-end delivery gating
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_notification_service_skips_delivery_when_preference_off(
    session: AsyncSession, db_sessionmaker: async_sessionmaker[AsyncSession]
) -> None:
    post_author = await _create_user(session, sub="e2e-off-author")
    reactor = await _create_user(session, sub="e2e-off-reactor")
    await _add_device_token(session, user_id=post_author, token="tok-e2e-off")
    await NotificationPreferenceRepository(session).upsert_overrides(
        post_author, {NotificationType.REACTION.value: False}
    )
    await session.commit()

    push = _FakePushAdapter()
    svc = NotificationService(
        sessionmaker=db_sessionmaker,
        push=push,  # type: ignore[arg-type]
        device_tokens=_DeviceTokenAdapter(db_sessionmaker),
        daily_stats=_NoopDailyStatAdapter(),  # type: ignore[arg-type]
        session_query=_NoopSessionQueryAdapter(),  # type: ignore[arg-type]
        active_users=_NoopActiveUserAdapter(),  # type: ignore[arg-type]
    )

    await svc.on_reaction_added(
        ReactionAdded(
            post_id=uuid4(),
            reactor_id=reactor,
            post_author_id=post_author,
            reaction_type="heart",
        )
    )

    assert push.calls == []
    async with db_sessionmaker() as check:
        count = await NotificationRepository(check).unread_count(post_author)
    assert count == 0


@pytest.mark.asyncio
async def test_notification_service_sends_when_no_preference_row_exists(
    session: AsyncSession, db_sessionmaker: async_sessionmaker[AsyncSession]
) -> None:
    """No NotificationPreference row at all: the default (on) applies."""
    post_author = await _create_user(session, sub="e2e-on-author")
    reactor = await _create_user(session, sub="e2e-on-reactor")
    await _add_device_token(session, user_id=post_author, token="tok-e2e-on")
    await session.commit()

    push = _FakePushAdapter()
    svc = NotificationService(
        sessionmaker=db_sessionmaker,
        push=push,  # type: ignore[arg-type]
        device_tokens=_DeviceTokenAdapter(db_sessionmaker),
        daily_stats=_NoopDailyStatAdapter(),  # type: ignore[arg-type]
        session_query=_NoopSessionQueryAdapter(),  # type: ignore[arg-type]
        active_users=_NoopActiveUserAdapter(),  # type: ignore[arg-type]
    )

    await svc.on_reaction_added(
        ReactionAdded(
            post_id=uuid4(),
            reactor_id=reactor,
            post_author_id=post_author,
            reaction_type="heart",
        )
    )

    assert len(push.calls) == 1
    assert push.calls[0]["tokens"] == ["tok-e2e-on"]
    async with db_sessionmaker() as check:
        count = await NotificationRepository(check).unread_count(post_author)
    assert count == 1

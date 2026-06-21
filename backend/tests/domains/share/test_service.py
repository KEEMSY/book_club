"""Unit tests for ShareService — in-memory fakes, no DB (CLAUDE.md §5)."""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import UTC, datetime
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError, NotFoundError
from app.domains.share.repository import ShareCardContext, ShareStatRow
from app.domains.share.service import ShareService


# ---------------------------------------------------------------------------
# Fakes
# ---------------------------------------------------------------------------


@dataclass
class _FakeEvent:
    id: UUID
    user_id: UUID
    card_type: str
    platform: str | None
    referral_code: str | None
    created_at: datetime


@dataclass
class FakeShareRepository:
    events: list[_FakeEvent] = field(default_factory=list)

    async def record_event(
        self,
        *,
        user_id: UUID,
        card_type: str,
        platform: str | None,
        referral_code: str | None,
    ) -> _FakeEvent:
        event = _FakeEvent(
            id=uuid4(),
            user_id=user_id,
            card_type=card_type,
            platform=platform,
            referral_code=referral_code,
            created_at=datetime.now(tz=UTC),
        )
        self.events.append(event)
        return event

    async def get_share_stats(self) -> list[ShareStatRow]:
        buckets: dict[tuple[str, str | None], int] = {}
        for e in self.events:
            buckets[(e.card_type, e.platform)] = buckets.get((e.card_type, e.platform), 0) + 1
        rows = [
            ShareStatRow(card_type=ct, platform=pf, count=n)
            for (ct, pf), n in buckets.items()
        ]
        rows.sort(key=lambda r: r.count, reverse=True)
        return rows


@dataclass
class FakeShareCardMetaRepository:
    nickname: str = "도서왕"
    profile_image_url: str | None = None
    referral_code: str = "ABC123"

    async def get_card_context(self, user_id: UUID) -> ShareCardContext:
        return ShareCardContext(
            nickname=self.nickname,
            profile_image_url=self.profile_image_url,
            referral_code=self.referral_code,
        )


def _svc(
    repo: FakeShareRepository | None = None,
    meta: FakeShareCardMetaRepository | None = None,
) -> tuple[ShareService, FakeShareRepository, FakeShareCardMetaRepository]:
    r = repo or FakeShareRepository()
    m = meta or FakeShareCardMetaRepository()
    return ShareService(repo=r, meta=m), r, m  # type: ignore[arg-type]


# ---------------------------------------------------------------------------
# get_card_meta
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_get_card_meta_builds_join_url_and_copy() -> None:
    svc, _, _ = _svc()
    result = await svc.get_card_meta(uuid4(), "book_completed")
    assert result.card_type == "book_completed"
    assert result.nickname == "도서왕"
    assert result.referral_code == "ABC123"
    assert result.join_url == "https://bookclub.app/join?ref=ABC123"
    assert result.headline  # template headline present
    assert "#북클럽" in result.caption


@pytest.mark.asyncio
async def test_get_card_meta_all_five_templates_supported() -> None:
    svc, _, _ = _svc()
    for card_type in (
        "book_completed",
        "reading_streak",
        "challenge_badge",
        "monthly_recap",
        "progress_checkin",
    ):
        meta = await svc.get_card_meta(uuid4(), card_type)
        assert meta.card_type == card_type
        assert meta.headline


@pytest.mark.asyncio
async def test_get_card_meta_unknown_type_raises_not_found() -> None:
    svc, _, _ = _svc()
    with pytest.raises(NotFoundError) as exc:
        await svc.get_card_meta(uuid4(), "bogus_card")
    assert exc.value.code == "CARD_TYPE_NOT_FOUND"


# ---------------------------------------------------------------------------
# record_event
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_record_event_persists_and_echoes() -> None:
    svc, repo, _ = _svc()
    user = uuid4()
    result = await svc.record_event(
        user_id=user,
        card_type="reading_streak",
        platform="instagram",
        referral_code="ABC123",
    )
    assert result.card_type == "reading_streak"
    assert result.platform == "instagram"
    assert len(repo.events) == 1
    assert repo.events[0].user_id == user


@pytest.mark.asyncio
async def test_record_event_allows_null_platform() -> None:
    svc, repo, _ = _svc()
    result = await svc.record_event(
        user_id=uuid4(),
        card_type="monthly_recap",
        platform=None,
        referral_code=None,
    )
    assert result.platform is None
    assert len(repo.events) == 1


@pytest.mark.asyncio
async def test_record_event_unknown_card_type_raises_conflict() -> None:
    svc, repo, _ = _svc()
    with pytest.raises(ConflictError) as exc:
        await svc.record_event(
            user_id=uuid4(), card_type="nope", platform="copy", referral_code=None
        )
    assert exc.value.code == "CARD_TYPE_INVALID"
    assert repo.events == []


@pytest.mark.asyncio
async def test_record_event_unknown_platform_raises_conflict() -> None:
    svc, repo, _ = _svc()
    with pytest.raises(ConflictError) as exc:
        await svc.record_event(
            user_id=uuid4(),
            card_type="book_completed",
            platform="myspace",
            referral_code=None,
        )
    assert exc.value.code == "PLATFORM_INVALID"
    assert repo.events == []


# ---------------------------------------------------------------------------
# get_share_stats
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_get_share_stats_aggregates_and_totals() -> None:
    svc, _, _ = _svc()
    user = uuid4()
    await svc.record_event(
        user_id=user, card_type="book_completed", platform="instagram", referral_code=None
    )
    await svc.record_event(
        user_id=user, card_type="book_completed", platform="instagram", referral_code=None
    )
    await svc.record_event(
        user_id=user, card_type="reading_streak", platform="kakaotalk", referral_code=None
    )

    stats = await svc.get_share_stats()
    assert stats.total == 3
    # Busiest bucket first.
    assert stats.items[0].card_type == "book_completed"
    assert stats.items[0].count == 2


@pytest.mark.asyncio
async def test_get_share_stats_empty() -> None:
    svc, _, _ = _svc()
    stats = await svc.get_share_stats()
    assert stats.total == 0
    assert stats.items == []

"""Share domain service — SNS certification cards & viral tracking (M62).

Depends only on the Protocols in ``ports.py`` (CLAUDE.md §3.2). Concrete
repositories are injected by ``providers.py`` for HTTP traffic, or by test
fakes for unit tests.

Business rules:
- ``get_card_meta``: validate the template, then return the owner's identity,
  a referral deep link, and template-specific Korean copy. An unknown
  ``card_type`` raises NotFoundError.
- ``record_event``: validate the template and (when present) the platform,
  then persist one share event. An unknown ``card_type`` or ``platform``
  raises ConflictError so the client surfaces a clear error rather than
  silently logging garbage analytics.
- ``get_share_stats``: aggregate counts for the admin dashboard.
"""

from __future__ import annotations

from dataclasses import dataclass
from uuid import UUID

from app.core.exceptions import ConflictError, NotFoundError
from app.domains.share.ports import ShareCardMetaPort, ShareRepositoryPort
from app.domains.share.schemas import (
    ShareCardMetaResponse,
    ShareEventResponse,
    ShareStatItem,
    ShareStatsResponse,
)

# Deep-link base baked into each card's QR; ``?ref=`` carries the inviter code.
_JOIN_URL_BASE = "https://bookclub.app/join"

# The five card templates (CLAUDE.md M62 §4.2).
VALID_CARD_TYPES: frozenset[str] = frozenset(
    {
        "book_completed",
        "reading_streak",
        "challenge_badge",
        "monthly_recap",
        "progress_checkin",
    }
)

# Share targets the client may report.
VALID_PLATFORMS: frozenset[str] = frozenset({"instagram", "twitter", "kakaotalk", "copy"})

# Per-template Korean headline + caption. ``{nickname}`` is interpolated; the
# numeric specifics live on the client-rendered card, so copy stays evergreen.
_CARD_COPY: dict[str, tuple[str, str]] = {
    "book_completed": (
        "한 권 완독 🎉",
        "방금 책 한 권을 완독했어요! 함께 읽어요 📚\n#북클럽 #완독 #책스타그램",
    ),
    "reading_streak": (
        "독서 스트릭 달성 🔥",
        "꾸준한 독서 습관, 오늘도 이어갑니다 🔥\n#북클럽 #독서습관 #책스타그램",
    ),
    "challenge_badge": (
        "챌린지 배지 획득 🏅",
        "독서 챌린지 배지를 땄어요! 🏅\n#북클럽 #독서챌린지 #책스타그램",
    ),
    "monthly_recap": (
        "이달의 독서 결산 📖",
        "이번 달 나의 독서 기록을 공유해요 📖\n#북클럽 #월간독서 #책스타그램",
    ),
    "progress_checkin": (
        "읽는 중 📕",
        "지금 이 책을 읽고 있어요. 같이 읽을래요? 📕\n#북클럽 #독서중 #책스타그램",
    ),
}


def _join_url(referral_code: str) -> str:
    """Build the referral deep link encoded into the card QR."""
    return f"{_JOIN_URL_BASE}?ref={referral_code}"


@dataclass(slots=True)
class ShareService:
    """Orchestrates share-card metadata and viral-loop event tracking."""

    repo: ShareRepositoryPort
    meta: ShareCardMetaPort

    async def get_card_meta(self, user_id: UUID, card_type: str) -> ShareCardMetaResponse:
        """Return owner identity, deep link, and copy for ``card_type``."""
        if card_type not in VALID_CARD_TYPES:
            raise NotFoundError(f"unknown card type '{card_type}'", code="CARD_TYPE_NOT_FOUND")

        ctx = await self.meta.get_card_context(user_id)
        headline, caption = _CARD_COPY[card_type]
        return ShareCardMetaResponse(
            card_type=card_type,
            nickname=ctx.nickname,
            profile_image_url=ctx.profile_image_url,
            referral_code=ctx.referral_code,
            join_url=_join_url(ctx.referral_code),
            headline=headline,
            caption=caption,
        )

    async def record_event(
        self,
        *,
        user_id: UUID,
        card_type: str,
        platform: str | None,
        referral_code: str | None,
    ) -> ShareEventResponse:
        """Persist one share event after validating the template and platform."""
        if card_type not in VALID_CARD_TYPES:
            raise ConflictError(f"unknown card type '{card_type}'", code="CARD_TYPE_INVALID")
        if platform is not None and platform not in VALID_PLATFORMS:
            raise ConflictError(f"unknown platform '{platform}'", code="PLATFORM_INVALID")

        event = await self.repo.record_event(
            user_id=user_id,
            card_type=card_type,
            platform=platform,
            referral_code=referral_code,
        )
        return ShareEventResponse(
            id=event.id,
            card_type=event.card_type,
            platform=event.platform,
            created_at=event.created_at,
        )

    async def get_share_stats(self) -> ShareStatsResponse:
        """Aggregate share counts for the admin dashboard."""
        rows = await self.repo.get_share_stats()
        items = [
            ShareStatItem(card_type=r.card_type, platform=r.platform, count=r.count) for r in rows
        ]
        return ShareStatsResponse(total=sum(r.count for r in rows), items=items)

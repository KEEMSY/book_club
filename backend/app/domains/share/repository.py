"""SQLAlchemy async repositories for the share domain (M62).

Two concrete implementations live here:

- ``ShareRepository`` — owns the ``share_card_events`` table (record + stats).
- ``ShareCardMetaRepository`` — assembles the read-only cross-domain context a
  card needs (nickname, avatar, referral code). It is the *only* place share
  reaches into other domains; ``ShareService`` sees it solely through
  ``ShareCardMetaPort`` so the service stays unit-testable (CLAUDE.md §3.2/§3.3).
"""

from __future__ import annotations

from dataclasses import dataclass
from uuid import UUID

from sqlalchemy import func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.exceptions import NotFoundError
from app.domains.auth.models import User
from app.domains.referral.repository import ReferralRepository
from app.domains.share.models import ShareCardEvent


@dataclass(slots=True)
class ShareCardContext:
    """Read-only data a share card needs about its owner."""

    nickname: str
    profile_image_url: str | None
    referral_code: str


@dataclass(slots=True)
class ShareStatRow:
    """Aggregated share count for one (card_type, platform) bucket."""

    card_type: str
    platform: str | None
    count: int


@dataclass(slots=True)
class ShareRepository:
    """All persistence for ``share_card_events``."""

    session: AsyncSession

    async def record_event(
        self,
        *,
        user_id: UUID,
        card_type: str,
        platform: str | None,
        referral_code: str | None,
    ) -> ShareCardEvent:
        """Insert one share event row and return the persisted entity."""
        event = ShareCardEvent(
            user_id=user_id,
            card_type=card_type,
            platform=platform,
            referral_code=referral_code,
        )
        self.session.add(event)
        await self.session.flush()
        return event

    async def get_share_stats(self) -> list[ShareStatRow]:
        """Return share counts grouped by (card_type, platform), busiest first."""
        result = await self.session.execute(
            select(
                ShareCardEvent.card_type,
                ShareCardEvent.platform,
                func.count().label("share_count"),
            )
            .group_by(ShareCardEvent.card_type, ShareCardEvent.platform)
            .order_by(func.count().desc())
        )
        return [
            ShareStatRow(card_type=row.card_type, platform=row.platform, count=row.share_count)
            for row in result.all()
        ]


@dataclass(slots=True)
class ShareCardMetaRepository:
    """Assembles a card's owner context from the auth + referral domains.

    Kept deliberately thin: it reads only the fields a card renders and lazily
    mints the referral code via the referral domain's own repository so the
    code space and collision handling stay owned by referral (CLAUDE.md §3.3).
    """

    session: AsyncSession

    async def get_card_context(self, user_id: UUID) -> ShareCardContext:
        """Return nickname, avatar, and (lazily generated) referral code."""
        result = await self.session.execute(
            select(User.nickname, User.profile_image_url).where(User.id == user_id)
        )
        row = result.one_or_none()
        if row is None:
            raise NotFoundError("user not found", code="USER_NOT_FOUND")

        referral_code = await ReferralRepository(self.session).get_or_create_code(user_id)
        return ShareCardContext(
            nickname=row.nickname,
            profile_image_url=row.profile_image_url,
            referral_code=referral_code,
        )

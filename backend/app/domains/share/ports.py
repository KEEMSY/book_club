"""Share domain ports — the only contracts ``service.py`` may import.

Per CLAUDE.md §3.2 the Port/Adapter boundary lets ``ShareService`` run against
in-memory fakes without a database, and keeps the service from importing the
auth/referral repositories directly (§3.3).
"""

from __future__ import annotations

from typing import Protocol
from uuid import UUID

from app.domains.share.models import ShareCardEvent
from app.domains.share.repository import ShareCardContext, ShareStatRow


class ShareRepositoryPort(Protocol):
    """Persistence operations for share events."""

    async def record_event(
        self,
        *,
        user_id: UUID,
        card_type: str,
        platform: str | None,
        referral_code: str | None,
    ) -> ShareCardEvent: ...

    async def get_share_stats(self) -> list[ShareStatRow]:
        """Share counts grouped by (card_type, platform)."""
        ...


class ShareCardMetaPort(Protocol):
    """Read-only cross-domain context provider for card rendering."""

    async def get_card_context(self, user_id: UUID) -> ShareCardContext:
        """Owner nickname, avatar, and referral code for the card."""
        ...

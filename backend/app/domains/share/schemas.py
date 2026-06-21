"""Pydantic v2 DTOs for the share router (M62).

These are the only types the mobile client sees at the HTTP boundary; the
router never leaks ORM models (CLAUDE.md §3.1).
"""

from __future__ import annotations

from datetime import datetime
from uuid import UUID

from pydantic import BaseModel, Field


class ShareCardMetaResponse(BaseModel):
    """Everything the client needs to render and caption a share card.

    Numeric stats (streak count, book title, ...) are supplied by the client
    from the context that triggered the share; the backend contributes the
    owner identity, deep-link target, and suggested copy (CLAUDE.md M62 scope).
    """

    card_type: str
    nickname: str
    profile_image_url: str | None
    referral_code: str
    # Deep link encoded into the card's QR — drives referral attribution.
    join_url: str
    # Korean headline rendered on the card for this template.
    headline: str
    # Suggested SNS caption (hashtags included) the client pre-fills on share.
    caption: str


class ShareEventRequest(BaseModel):
    """Body for POST /me/share-events."""

    card_type: str = Field(min_length=1, max_length=32)
    platform: str | None = Field(default=None, max_length=32)
    referral_code: str | None = Field(default=None, max_length=16)


class ShareEventResponse(BaseModel):
    """Persisted share event echoed back to the client."""

    id: UUID
    card_type: str
    platform: str | None
    created_at: datetime


class ShareStatItem(BaseModel):
    """One (card_type, platform) bucket in the admin share-stats report."""

    card_type: str
    platform: str | None
    count: int


class ShareStatsResponse(BaseModel):
    """Aggregate share metrics for the admin dashboard."""

    total: int
    items: list[ShareStatItem]

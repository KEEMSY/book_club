"""Pydantic v2 request / response schemas for the subscription domain."""

from __future__ import annotations

from datetime import datetime
from typing import Any, Literal

from pydantic import BaseModel


class SubscriptionStatus(BaseModel):
    """Current Pro subscription state for the authenticated user."""

    is_pro: bool
    pro_expires_at: datetime | None
    pro_product_id: str | None


class VerifyReceiptRequest(BaseModel):
    """Body for POST /me/subscription/verify."""

    platform: Literal["ios", "android"]
    # Base64-encoded receipt for iOS; purchase token string for Android.
    receipt_data: str
    product_id: str


class SubscriptionVerifyResponse(BaseModel):
    """Result returned after receipt verification and subscription activation."""

    is_pro: bool
    expires_at: datetime | None
    message: str


class PromoResponse(BaseModel):
    """Currently active early-bird promo, as served to the paywall banner.

    The endpoint returns ``null`` (not this model) when no promo is live, so
    the client only renders the banner when there is something to show.
    """

    promo_code: str
    discount_pct: int
    valid_until: datetime


class RevenueCatWebhookBody(BaseModel):
    """Minimal representation of a RevenueCat webhook payload.

    RevenueCat wraps the actual event inside an ``event`` key.  Only the
    fields the service layer acts on are declared; the rest are captured in
    ``model_config`` with ``extra="ignore"`` so future RevenueCat additions
    do not break parsing.
    """

    model_config = {"extra": "ignore"}

    event: dict[str, Any]

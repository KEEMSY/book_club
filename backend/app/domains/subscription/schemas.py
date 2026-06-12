"""Pydantic v2 request / response schemas for the subscription domain."""

from __future__ import annotations

from datetime import datetime
from typing import Literal

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

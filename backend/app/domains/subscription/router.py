"""HTTP surface for the subscription domain.

Routes:
  GET  /me/subscription           — current Pro status
  POST /me/subscription/verify    — verify a purchase receipt
  POST /webhooks/revenuecat       — RevenueCat server-to-server events

Thin DTO → service → DTO adapters per CLAUDE.md §3.1.
"""

from __future__ import annotations

import hashlib
import hmac
import logging
import os
from datetime import UTC, datetime
from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, Header, HTTPException, Request, status

from app.core.deps import get_current_user_id
from app.domains.subscription.providers import (
    get_promo_service,
    get_subscription_service,
)
from app.domains.subscription.schemas import (
    PromoResponse,
    RevenueCatWebhookBody,
    SubscriptionStatus,
    SubscriptionVerifyResponse,
    VerifyReceiptRequest,
)
from app.domains.subscription.service import PromoService, SubscriptionService

logger = logging.getLogger(__name__)

router = APIRouter(tags=["subscription"])


@router.get("/me/subscription", response_model=SubscriptionStatus)
async def get_my_subscription(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[SubscriptionService, Depends(get_subscription_service)],
) -> SubscriptionStatus:
    """Return the authenticated user's current Pro subscription status."""
    return await service.get_status(UUID(user_id))


@router.get("/subscriptions/promo", response_model=PromoResponse | None)
async def get_active_promo(
    service: Annotated[PromoService, Depends(get_promo_service)],
) -> PromoResponse | None:
    """Return the currently active promo, or ``null`` when none is live.

    Public (no auth): the early-bird banner is shown on the paywall before a
    purchase decision, and the payload carries no user-specific data.
    """
    return await service.get_active_promo()


@router.post("/me/subscription/verify", response_model=SubscriptionVerifyResponse)
async def verify_subscription(
    body: VerifyReceiptRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[SubscriptionService, Depends(get_subscription_service)],
) -> SubscriptionVerifyResponse:
    """Verify a purchase receipt and activate Pro for the authenticated user."""
    return await service.verify_and_activate(user_id=UUID(user_id), req=body)


@router.post(
    "/webhooks/revenuecat",
    status_code=status.HTTP_200_OK,
    include_in_schema=False,  # internal endpoint — omit from public docs
)
async def revenuecat_webhook(
    request: Request,
    body: RevenueCatWebhookBody,
    service: Annotated[SubscriptionService, Depends(get_subscription_service)],
    x_revenuecat_signature: Annotated[str | None, Header()] = None,
) -> dict[str, str]:
    """Receive RevenueCat server-to-server webhook events.

    Signature verification is performed when ``REVENUECAT_WEBHOOK_SECRET`` is
    set.  In development (secret absent) the check is skipped so the endpoint
    can be exercised with plain HTTP without a real RevenueCat account.

    Supported event types:
      INITIAL_PURCHASE, RENEWAL      → grant Pro
      CANCELLATION, EXPIRATION       → revoke Pro

    Unknown event types are acknowledged (200) but produce no state change.
    """
    webhook_secret = os.getenv("REVENUECAT_WEBHOOK_SECRET")
    if webhook_secret:
        if not x_revenuecat_signature:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Missing X-RevenueCat-Signature header",
            )
        raw_body = await request.body()
        expected = hmac.new(
            webhook_secret.encode(),
            raw_body,
            hashlib.sha256,
        ).hexdigest()
        if not hmac.compare_digest(expected, x_revenuecat_signature):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Invalid webhook signature",
            )

    event = body.event
    event_type: str = event.get("type", "")
    app_user_id: str = event.get("app_user_id", "")
    product_id: str = event.get("product_id", "")
    expiration_at_ms: int | None = event.get("expiration_at_ms")

    expires_at: datetime | None = None
    if expiration_at_ms is not None:
        expires_at = datetime.fromtimestamp(expiration_at_ms / 1000, tz=UTC)

    logger.info(
        "revenuecat_webhook event_type=%s app_user_id=%s product_id=%s expires_at=%s",
        event_type,
        app_user_id,
        product_id,
        expires_at,
    )

    try:
        user_uuid = UUID(app_user_id)
    except ValueError:
        logger.warning(
            "revenuecat_webhook invalid app_user_id=%s — ignoring", app_user_id
        )
        return {"status": "ignored", "reason": "invalid_app_user_id"}

    await service.apply_webhook_event(
        event_type=event_type,
        user_id=user_uuid,
        product_id=product_id,
        expires_at=expires_at,
    )
    return {"status": "ok"}

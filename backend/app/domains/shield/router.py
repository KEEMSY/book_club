"""HTTP surface for the shield purchase domain.

Routes:
  POST /me/shields/purchase       — purchase shields (authenticated user)
  POST /webhooks/shield-refund    — refund webhook (internal, secret-header guarded)
  GET  /me/shields                — current shield balance

The refund webhook is not listed in public API docs (``include_in_schema=False``)
and requires a ``X-Shield-Webhook-Secret`` header matching ``SHIELD_WEBHOOK_SECRET``
env var.  In development (env var absent) the check is skipped.
"""

from __future__ import annotations

import logging
import os
from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, Header, HTTPException, status
from pydantic import BaseModel

from app.core.deps import get_current_user_id
from app.domains.shield.providers import get_shield_service
from app.domains.shield.schemas import (
    PurchaseShieldRequest,
    ShieldBalanceResponse,
    ShieldPurchaseResult,
)
from app.domains.shield.service import ShieldPurchaseService

logger = logging.getLogger(__name__)

router = APIRouter(tags=["shield"])


class _RefundWebhookBody(BaseModel):
    purchase_id: UUID


@router.post("/me/shields/purchase", response_model=ShieldPurchaseResult, status_code=201)
async def purchase_shields(
    body: PurchaseShieldRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ShieldPurchaseService, Depends(get_shield_service)],
) -> ShieldPurchaseResult:
    """Verify a consumable IAP receipt and credit streak shields to the user."""
    return await service.purchase_shields(
        user_id=UUID(user_id),
        product_id=body.product_id,
        receipt_data=body.receipt_data,
    )


@router.post(
    "/webhooks/shield-refund",
    status_code=status.HTTP_200_OK,
    include_in_schema=False,
)
async def shield_refund_webhook(
    body: _RefundWebhookBody,
    service: Annotated[ShieldPurchaseService, Depends(get_shield_service)],
    x_shield_webhook_secret: Annotated[str | None, Header()] = None,
) -> dict[str, str]:
    """Process a store refund for a shield purchase.

    Verifies ``X-Shield-Webhook-Secret`` against the ``SHIELD_WEBHOOK_SECRET``
    env var when set.  Skipped in development (env var absent) so the endpoint
    can be exercised with plain HTTP.
    """
    expected_secret = os.getenv("SHIELD_WEBHOOK_SECRET")
    if expected_secret and x_shield_webhook_secret != expected_secret:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or missing X-Shield-Webhook-Secret header",
        )

    logger.info("shield_refund_webhook purchase_id=%s", body.purchase_id)
    await service.handle_refund_webhook(purchase_id=body.purchase_id)
    return {"status": "ok"}


@router.get("/me/shields", response_model=ShieldBalanceResponse)
async def get_my_shields(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ShieldPurchaseService, Depends(get_shield_service)],
) -> ShieldBalanceResponse:
    """Return the authenticated user's current streak shield balance."""
    grade = await service.grade_repo.get_or_init(UUID(user_id))
    return ShieldBalanceResponse(streak_shields=grade.streak_shields)

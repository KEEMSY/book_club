"""HTTP surface for the subscription domain — /me/subscription.

Thin DTO → service → DTO adapters per CLAUDE.md §3.1.
"""

from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends

from app.core.deps import get_current_user_id
from app.domains.subscription.providers import get_subscription_service
from app.domains.subscription.schemas import (
    SubscriptionStatus,
    SubscriptionVerifyResponse,
    VerifyReceiptRequest,
)
from app.domains.subscription.service import SubscriptionService

router = APIRouter(tags=["subscription"])


@router.get("/me/subscription", response_model=SubscriptionStatus)
async def get_my_subscription(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[SubscriptionService, Depends(get_subscription_service)],
) -> SubscriptionStatus:
    """Return the authenticated user's current Pro subscription status."""
    return await service.get_status(UUID(user_id))


@router.post("/me/subscription/verify", response_model=SubscriptionVerifyResponse)
async def verify_subscription(
    body: VerifyReceiptRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[SubscriptionService, Depends(get_subscription_service)],
) -> SubscriptionVerifyResponse:
    """Verify a purchase receipt and activate Pro for the authenticated user."""
    return await service.verify_and_activate(user_id=UUID(user_id), req=body)

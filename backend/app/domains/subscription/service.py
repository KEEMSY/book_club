"""Domain service for Pro subscription management."""

from __future__ import annotations

from dataclasses import dataclass
from datetime import UTC, datetime
from uuid import UUID

from app.core.exceptions import ConflictError
from app.domains.subscription.ports import PurchaseVerifierPort
from app.domains.subscription.repository import SubscriptionRepository
from app.domains.subscription.schemas import (
    SubscriptionStatus,
    SubscriptionVerifyResponse,
    VerifyReceiptRequest,
)


@dataclass(slots=True)
class SubscriptionService:
    """Orchestrates Pro subscription state transitions."""

    repo: SubscriptionRepository
    verifier: PurchaseVerifierPort

    async def get_status(self, user_id: UUID) -> SubscriptionStatus:
        """Return the current subscription status, auto-expiring if needed."""
        row = await self.repo.get_subscription_status(user_id)
        is_pro: bool = bool(row["is_pro"])
        expires_at: datetime | None = row["pro_expires_at"]  # type: ignore[assignment]
        product_id: str | None = row["pro_product_id"]  # type: ignore[assignment]

        # Auto-expire: if the stored flag is True but the period has passed,
        # clear the subscription so the client sees the correct state immediately.
        if is_pro and expires_at is not None and expires_at < datetime.now(tz=UTC):
            await self.repo.update_subscription(
                user_id, is_pro=False, expires_at=None, product_id=None
            )
            is_pro = False
            expires_at = None
            product_id = None

        return SubscriptionStatus(
            is_pro=is_pro,
            pro_expires_at=expires_at,
            pro_product_id=product_id,
        )

    async def verify_and_activate(
        self,
        *,
        user_id: UUID,
        req: VerifyReceiptRequest,
    ) -> SubscriptionVerifyResponse:
        """Verify a purchase receipt via the injected verifier and activate Pro."""
        result = await self.verifier.verify(
            platform=req.platform,
            receipt_data=req.receipt_data,
            product_id=req.product_id,
        )
        if not result.is_valid:
            raise ConflictError(
                result.error_message or "결제 검증에 실패했어요.",
                code="RECEIPT_INVALID",
            )
        await self.repo.update_subscription(
            user_id,
            is_pro=True,
            expires_at=result.expires_at,
            product_id=result.product_id,
        )
        return SubscriptionVerifyResponse(
            is_pro=True,
            expires_at=result.expires_at,
            message="구독이 활성화되었어요.",
        )

    async def apply_webhook_event(
        self,
        *,
        event_type: str,
        user_id: UUID,
        product_id: str,
        expires_at: datetime | None,
    ) -> None:
        """Apply a RevenueCat webhook event to the subscription state.

        INITIAL_PURCHASE / RENEWAL grant Pro; CANCELLATION / EXPIRATION revoke it.
        Unknown event types are silently ignored so new RevenueCat events don't
        break the webhook endpoint before they are explicitly handled.
        """
        if event_type in ("INITIAL_PURCHASE", "RENEWAL"):
            await self.repo.update_subscription(
                user_id,
                is_pro=True,
                expires_at=expires_at,
                product_id=product_id,
            )
        elif event_type in ("CANCELLATION", "EXPIRATION"):
            await self.repo.update_subscription(
                user_id,
                is_pro=False,
                expires_at=None,
                product_id=product_id,
            )

"""Domain service for Pro subscription management.

Phase 8 stub: receipt verification always succeeds and grants a 1-year Pro
subscription.  The data model is complete so wiring the real RevenueCat SDK
later requires only replacing the stub body of ``verify_and_activate``.

TODO(subscription): replace stub with RevenueCat webhook / server-side
  receipt verification before production launch.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import UTC, datetime, timedelta
from uuid import UUID

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
        """Verify a purchase receipt and activate Pro for the user.

        Stub implementation (Phase 8): any well-formed request grants 1 year
        of Pro access so QA and development can exercise the full flow without
        a live RevenueCat account.
        """
        # TODO(subscription): call RevenueCat REST API with req.receipt_data
        #   and req.platform; map the response to expires_at before writing.
        expires = datetime.now(tz=UTC) + timedelta(days=365)
        await self.repo.update_subscription(
            user_id,
            is_pro=True,
            expires_at=expires,
            product_id=req.product_id,
        )
        return SubscriptionVerifyResponse(
            is_pro=True,
            expires_at=expires,
            message="구독이 활성화되었어요.",
        )

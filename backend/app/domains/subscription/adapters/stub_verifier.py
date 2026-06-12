"""Stub purchase verifier for development and test environments.

Always grants 1 year of Pro access for any well-formed request so QA and
local development can exercise the full subscription flow without a live
RevenueCat account or valid store receipts.
"""

from __future__ import annotations

import logging
from datetime import UTC, datetime, timedelta

from app.domains.subscription.ports import PurchaseVerificationResult

logger = logging.getLogger(__name__)


class StubPurchaseVerifier:
    """Satisfies PurchaseVerifierPort without calling RevenueCat."""

    async def verify(
        self,
        *,
        platform: str,
        receipt_data: str,
        product_id: str,
    ) -> PurchaseVerificationResult:
        expires_at = datetime.now(tz=UTC) + timedelta(days=365)
        logger.debug(
            "stub_verifier: granting 1-year Pro platform=%s product_id=%s expires_at=%s",
            platform,
            product_id,
            expires_at,
        )
        return PurchaseVerificationResult(
            is_valid=True,
            product_id=product_id,
            expires_at=expires_at,
        )

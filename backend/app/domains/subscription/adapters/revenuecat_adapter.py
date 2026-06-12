"""RevenueCat REST API v1 adapter for purchase receipt verification.

Calls POST /v1/receipts and maps the subscriber entitlement payload to a
PurchaseVerificationResult.  5xx responses are retried automatically by the
underlying AsyncHttpClient; 4xx responses are treated as invalid receipts and
returned as is_valid=False rather than raising so the service layer can surface
a clean RECEIPT_INVALID domain error.
"""

from __future__ import annotations

import logging
from datetime import datetime

from app.core.http.base_client import AsyncHttpClient
from app.domains.subscription.ports import PurchaseVerificationResult

logger = logging.getLogger(__name__)

_BASE_URL = "https://api.revenuecat.com/v1"


class RevenueCatAdapter:
    """Verifies iOS / Android purchases via the RevenueCat server-side API."""

    def __init__(self, api_key: str) -> None:
        self._api_key = api_key

    async def verify(
        self,
        *,
        platform: str,
        receipt_data: str,
        product_id: str,
    ) -> PurchaseVerificationResult:
        """POST receipt to RevenueCat and return structured verification result.

        Returns is_valid=False (instead of raising) for 4xx so the service
        layer converts the outcome to a RECEIPT_INVALID ConflictError.
        5xx and network failures propagate as ExternalServiceError from the
        base client after retries are exhausted.
        """
        async with AsyncHttpClient(base_url=_BASE_URL, timeout=10.0) as client:
            resp = await client.post(
                "/receipts",
                headers={
                    "Authorization": f"Bearer {self._api_key}",
                    "X-Platform": platform,
                    "Content-Type": "application/json",
                },
                json={"fetch_token": receipt_data, "product_id": product_id},
            )

        if resp.status_code not in (200, 201):
            logger.warning(
                "revenuecat_verify failed status=%d body=%s",
                resp.status_code,
                resp.text[:200],
            )
            return PurchaseVerificationResult(
                is_valid=False,
                product_id=product_id,
                expires_at=None,
                error_message=f"RevenueCat error: {resp.status_code}",
            )

        data = resp.json()
        entitlements = data.get("subscriber", {}).get("entitlements", {})
        pro = entitlements.get("pro", {})
        expires_str: str | None = pro.get("expires_date")
        expires_at = datetime.fromisoformat(expires_str) if expires_str else None
        is_valid: bool = bool(pro.get("is_active", False))

        logger.info(
            "revenuecat_verify ok platform=%s product_id=%s is_active=%s expires_at=%s",
            platform,
            product_id,
            is_valid,
            expires_at,
        )
        return PurchaseVerificationResult(
            is_valid=is_valid,
            product_id=product_id,
            expires_at=expires_at,
        )

"""Port Protocols for the subscription domain (CLAUDE.md §3.2).

PurchaseVerifierPort is an external-boundary port with two concrete
implementations: RevenueCatAdapter (production) and StubPurchaseVerifier
(development / test).
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
from typing import Protocol


@dataclass
class PurchaseVerificationResult:
    """Value object returned by any PurchaseVerifierPort implementation."""

    is_valid: bool
    product_id: str
    expires_at: datetime | None
    error_message: str | None = None


class PurchaseVerifierPort(Protocol):
    """External-boundary port for purchase receipt / token verification."""

    async def verify(
        self,
        *,
        platform: str,
        receipt_data: str,
        product_id: str,
    ) -> PurchaseVerificationResult: ...

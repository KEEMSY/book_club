"""Domain service for consumable shield IAP purchases."""

from __future__ import annotations

from dataclasses import dataclass
from uuid import UUID

from app.core.exceptions import ConflictError, NotFoundError
from app.domains.reading.repository import UserGradeRepository
from app.domains.shield.repository import ShieldPurchaseRepository
from app.domains.shield.schemas import SHIELD_PRODUCTS, ShieldPurchaseResult
from app.domains.subscription.ports import PurchaseVerifierPort


@dataclass(slots=True)
class ShieldPurchaseService:
    """Orchestrates shield IAP: verification, persistence, and balance update."""

    repo: ShieldPurchaseRepository
    verifier: PurchaseVerifierPort
    grade_repo: UserGradeRepository

    async def purchase_shields(
        self,
        *,
        user_id: UUID,
        product_id: str,
        receipt_data: str,
    ) -> ShieldPurchaseResult:
        """Verify the receipt, persist the purchase, and credit shields.

        Steps:
          1. Validate product_id against the known catalogue.
          2. Verify the receipt via the injected verifier port.
          3. Record the ShieldPurchase row.
          4. Increment UserGrade.streak_shields by the product's shield count.
          5. Return the granted count and updated balance.
        """
        product = SHIELD_PRODUCTS.get(product_id)
        if product is None:
            raise ConflictError(f"알 수 없는 상품입니다: {product_id}", code="INVALID_PRODUCT")

        # Platform is not passed by the client for consumable IAPs — we use a
        # fixed sentinel so the verifier can route correctly.  RevenueCat's
        # server-side validation does not require a platform hint for one-time
        # purchases (unlike subscriptions); the stub always returns is_valid=True.
        result = await self.verifier.verify(
            platform="ios",
            receipt_data=receipt_data,
            product_id=product_id,
        )
        if not result.is_valid:
            raise ConflictError(
                result.error_message or "결제 검증에 실패했어요.",
                code="INVALID_RECEIPT",
            )

        shields_granted = product["shields"]

        await self.repo.create(
            user_id=user_id,
            product_id=product_id,
            shields_granted=shields_granted,
            receipt_data=receipt_data,
        )

        grade = await self.grade_repo.get_or_init(user_id)
        new_balance = grade.streak_shields + shields_granted
        await self.grade_repo.update_streak_shields(user_id, shields=new_balance)

        return ShieldPurchaseResult(
            shields_granted=shields_granted,
            total_shields=new_balance,
        )

    async def handle_refund_webhook(self, *, purchase_id: UUID) -> None:
        """Process a store refund: mark the purchase refunded and decrement balance.

        Decrement is clamped to 0 — the user may have already consumed some
        shields, so we never go negative.
        """
        purchase = await self.repo.get_by_id(purchase_id)
        if purchase is None:
            raise NotFoundError("구매 내역을 찾을 수 없어요.", code="PURCHASE_NOT_FOUND")

        await self.repo.refund(purchase_id)

        grade = await self.grade_repo.get_or_init(purchase.user_id)
        new_balance = max(0, grade.streak_shields - purchase.shields_granted)
        await self.grade_repo.update_streak_shields(purchase.user_id, shields=new_balance)

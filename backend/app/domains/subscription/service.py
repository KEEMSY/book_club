"""Domain service for Pro subscription management."""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import UTC, datetime
from typing import Protocol
from uuid import UUID

from app.core.exceptions import ConflictError, NotFoundError
from app.domains.subscription.ports import PurchaseVerifierPort
from app.domains.subscription.repository import (
    CouponRepository,
    PromoRepository,
    SubscriptionRepository,
)
from app.domains.subscription.schemas import (
    ApplyCouponResponse,
    CouponResponse,
    PromoResponse,
    SubscriptionStatus,
    SubscriptionVerifyResponse,
    VerifyReceiptRequest,
)

# Imported lazily to avoid a circular dependency at module load time.
# ``ExperimentService`` is optional — when absent, conversion tracking is skipped.
_ExperimentServiceT = object  # placeholder for type annotations only

# Annual Pro plan: a first-time purchase ships with a welcome gift of shields.
ANNUAL_PRO_PRODUCT_ID = "annual_pro_59000"
ANNUAL_WELCOME_SHIELDS = 3


class ShieldGrantPort(Protocol):
    """Minimal cross-domain port for crediting welcome shields.

    Defined here so the subscription service depends only on this narrow
    contract (CLAUDE.md §3.2); the concrete adapter wraps the reading
    domain's ``UserGradeRepository`` and is wired in ``providers.py``.
    """

    async def grant_shields(self, *, user_id: UUID, count: int) -> None: ...


@dataclass(slots=True)
class SubscriptionService:
    """Orchestrates Pro subscription state transitions."""

    repo: SubscriptionRepository
    verifier: PurchaseVerifierPort
    # Optional: when provided, Pro activations are forwarded as experiment
    # conversion events.  Use ``field(default=None)`` so callers that do not
    # care about experiments can omit the argument.
    experiment_service: _ExperimentServiceT | None = field(default=None)
    # Optional: credits welcome shields on the first annual-Pro purchase.
    # When absent the gift is skipped (e.g. callers that don't wire reading).
    shield_grant: ShieldGrantPort | None = field(default=None)

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

        # Forward conversion event to the experiment layer when wired in.
        if self.experiment_service is not None:
            from app.domains.experiment.service import ExperimentService

            if isinstance(self.experiment_service, ExperimentService):
                await self.experiment_service.record_conversion(
                    user_id=user_id,
                    experiment_key="paywall_entry_v1",
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
            # Welcome gift: only on the FIRST purchase of the annual plan, so
            # renewals don't repeatedly top up shields.
            if (
                event_type == "INITIAL_PURCHASE"
                and product_id == ANNUAL_PRO_PRODUCT_ID
                and self.shield_grant is not None
            ):
                await self.shield_grant.grant_shields(user_id=user_id, count=ANNUAL_WELCOME_SHIELDS)
        elif event_type in ("CANCELLATION", "EXPIRATION"):
            await self.repo.update_subscription(
                user_id,
                is_pro=False,
                expires_at=None,
                product_id=product_id,
            )


@dataclass(slots=True)
class PromoService:
    """Serves the currently active promotional campaign to the paywall."""

    repo: PromoRepository

    async def get_active_promo(self) -> PromoResponse | None:
        """Return the live promo as a DTO, or ``None`` when none is active."""
        promo = await self.repo.get_active_promo()
        if promo is None:
            return None
        return PromoResponse(
            promo_code=promo.promo_code,
            discount_pct=promo.discount_pct,
            valid_until=promo.valid_until,
        )


@dataclass(slots=True)
class CouponService:
    """Redeems and issues single-use discount coupons (M70)."""

    repo: CouponRepository

    async def apply_coupon(self, *, user_id: UUID, code: str) -> ApplyCouponResponse:
        """Redeem a coupon for the user, marking it used.

        The redeemed discount is returned for the client to apply at the next
        purchase; this MVP only records the redemption (no price mutation here).
        """
        coupon = await self.repo.get_by_code(code)
        if coupon is None:
            raise NotFoundError("쿠폰을 찾을 수 없어요.", code="COUPON_NOT_FOUND")
        if coupon.used_by is not None:
            raise ConflictError("이미 사용된 쿠폰이에요.", code="COUPON_ALREADY_USED")
        await self.repo.mark_used(code=code, user_id=user_id, used_at=datetime.now(tz=UTC))
        return ApplyCouponResponse(discount_pct=coupon.discount_pct, valid_days=coupon.valid_days)

    async def create_coupon(
        self, *, code: str, discount_pct: int, valid_days: int
    ) -> CouponResponse:
        """Create a new coupon (admin). Rejects a duplicate code."""
        if await self.repo.get_by_code(code) is not None:
            raise ConflictError("이미 존재하는 쿠폰 코드예요.", code="COUPON_EXISTS")
        coupon = await self.repo.create(code=code, discount_pct=discount_pct, valid_days=valid_days)
        return CouponResponse(
            code=coupon.code, discount_pct=coupon.discount_pct, valid_days=coupon.valid_days
        )

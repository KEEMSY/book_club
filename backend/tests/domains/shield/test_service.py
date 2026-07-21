"""Unit tests for ShieldPurchaseService — in-memory fakes, no DB, no HTTP.

Covers:
- purchase_shields: happy path (shield_1 / shield_3), unknown product_id,
  receipt verification failure, cumulative balance after multiple purchases
- handle_refund_webhook: happy path, clamping to zero, unknown purchase_id,
  double-refund guard
- get_shield_balance: delegates to grade_repo.get_or_init
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import UTC, datetime
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError, NotFoundError
from app.domains.shield.service import ShieldPurchaseService
from app.domains.subscription.ports import PurchaseVerificationResult

# ---------------------------------------------------------------------------
# Fake domain objects
# ---------------------------------------------------------------------------


@dataclass
class _FakeShieldPurchase:
    """Minimal in-memory representation of a ShieldPurchase ORM row."""

    id: UUID
    user_id: UUID
    product_id: str
    shields_granted: int
    receipt_data: str
    purchased_at: datetime = field(default_factory=lambda: datetime.now(tz=UTC))
    refunded_at: datetime | None = None


@dataclass
class _FakeGrade:
    """Minimal in-memory representation of a UserGrade row."""

    streak_shields: int = 0


# ---------------------------------------------------------------------------
# Fake repositories
# ---------------------------------------------------------------------------


class FakeShieldPurchaseRepository:
    """In-memory stand-in for ShieldPurchaseRepository."""

    def __init__(self) -> None:
        self._purchases: dict[UUID, _FakeShieldPurchase] = {}
        # Track create calls for assertion convenience.
        self.create_calls: list[dict] = []

    # --- helpers for test setup ---

    def seed_purchase(
        self,
        *,
        user_id: UUID,
        product_id: str,
        shields_granted: int,
        receipt_data: str = "dummy-receipt",
        refunded_at: datetime | None = None,
    ) -> _FakeShieldPurchase:
        purchase = _FakeShieldPurchase(
            id=uuid4(),
            user_id=user_id,
            product_id=product_id,
            shields_granted=shields_granted,
            receipt_data=receipt_data,
            refunded_at=refunded_at,
        )
        self._purchases[purchase.id] = purchase
        return purchase

    # --- repository interface ---

    async def create(
        self,
        *,
        user_id: UUID,
        product_id: str,
        shields_granted: int,
        receipt_data: str,
    ) -> _FakeShieldPurchase:
        purchase = _FakeShieldPurchase(
            id=uuid4(),
            user_id=user_id,
            product_id=product_id,
            shields_granted=shields_granted,
            receipt_data=receipt_data,
        )
        self._purchases[purchase.id] = purchase
        self.create_calls.append(
            {
                "user_id": user_id,
                "product_id": product_id,
                "shields_granted": shields_granted,
                "receipt_data": receipt_data,
            }
        )
        return purchase

    async def get_by_id(self, purchase_id: UUID) -> _FakeShieldPurchase | None:
        return self._purchases.get(purchase_id)

    async def refund(self, purchase_id: UUID) -> None:
        row = self._purchases.get(purchase_id)
        if row is None:
            raise NotFoundError("구매 내역을 찾을 수 없어요.", code="PURCHASE_NOT_FOUND")
        if row.refunded_at is not None:
            raise ConflictError("이미 환불된 구매입니다.", code="ALREADY_REFUNDED")
        row.refunded_at = datetime.now(tz=UTC)


class FakeUserGradeRepository:
    """In-memory stand-in for the UserGradeRepository duck-type."""

    def __init__(self) -> None:
        self._grades: dict[UUID, _FakeGrade] = {}
        self.get_or_init_calls: list[UUID] = []

    # --- helper for test setup ---

    def seed_grade(self, user_id: UUID, *, streak_shields: int) -> _FakeGrade:
        grade = _FakeGrade(streak_shields=streak_shields)
        self._grades[user_id] = grade
        return grade

    # --- repository interface ---

    async def get_or_init(self, user_id: UUID) -> _FakeGrade:
        self.get_or_init_calls.append(user_id)
        if user_id not in self._grades:
            self._grades[user_id] = _FakeGrade(streak_shields=0)
        return self._grades[user_id]

    async def update_streak_shields(self, user_id: UUID, *, shields: int) -> _FakeGrade:
        grade = await self.get_or_init(user_id)
        grade.streak_shields = shields
        return grade


# ---------------------------------------------------------------------------
# Fake verifier port
# ---------------------------------------------------------------------------


class FakePurchaseVerifier:
    """Configurable stub for PurchaseVerifierPort."""

    def __init__(self, *, is_valid: bool = True, error_message: str | None = None) -> None:
        self._is_valid = is_valid
        self._error_message = error_message
        self.verify_calls: list[dict] = []

    async def verify(
        self,
        *,
        platform: str,
        receipt_data: str,
        product_id: str,
    ) -> PurchaseVerificationResult:
        self.verify_calls.append(
            {"platform": platform, "receipt_data": receipt_data, "product_id": product_id}
        )
        return PurchaseVerificationResult(
            is_valid=self._is_valid,
            product_id=product_id,
            expires_at=None,
            error_message=self._error_message,
        )


# ---------------------------------------------------------------------------
# Factory
# ---------------------------------------------------------------------------


def _build_service(
    *,
    verifier_valid: bool = True,
    verifier_error: str | None = None,
) -> tuple[
    ShieldPurchaseService,
    FakeShieldPurchaseRepository,
    FakePurchaseVerifier,
    FakeUserGradeRepository,
]:
    repo = FakeShieldPurchaseRepository()
    grade_repo = FakeUserGradeRepository()
    verifier = FakePurchaseVerifier(is_valid=verifier_valid, error_message=verifier_error)
    svc = ShieldPurchaseService(repo=repo, verifier=verifier, grade_repo=grade_repo)  # type: ignore[arg-type]
    return svc, repo, verifier, grade_repo


# ---------------------------------------------------------------------------
# purchase_shields — happy paths
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_purchase_shield_1_grants_one_shield() -> None:
    """shield_1 product credits exactly 1 shield and returns total_shields."""
    svc, repo, _verifier, grade_repo = _build_service()
    user_id = uuid4()

    result = await svc.purchase_shields(
        user_id=user_id,
        product_id="shield_1",
        receipt_data="receipt-abc",
    )

    assert result.shields_granted == 1
    assert result.total_shields == 1
    # Exactly one purchase row created.
    assert len(repo.create_calls) == 1
    assert repo.create_calls[0]["shields_granted"] == 1
    # Grade balance persisted correctly.
    grade = await grade_repo.get_or_init(user_id)
    assert grade.streak_shields == 1


@pytest.mark.asyncio
async def test_purchase_shield_3_grants_three_shields() -> None:
    """shield_3 product credits 3 shields."""
    svc, _repo, _, grade_repo = _build_service()
    user_id = uuid4()

    result = await svc.purchase_shields(
        user_id=user_id,
        product_id="shield_3",
        receipt_data="receipt-xyz",
    )

    assert result.shields_granted == 3
    assert result.total_shields == 3
    grade = await grade_repo.get_or_init(user_id)
    assert grade.streak_shields == 3


# ---------------------------------------------------------------------------
# purchase_shields — error cases
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_purchase_unknown_product_raises_conflict_error() -> None:
    """Requesting a product_id not in SHIELD_PRODUCTS raises ConflictError."""
    svc, repo, _, _ = _build_service()
    user_id = uuid4()

    with pytest.raises(ConflictError) as exc_info:
        await svc.purchase_shields(
            user_id=user_id,
            product_id="shield_99",
            receipt_data="receipt-bad",
        )

    assert exc_info.value.code == "INVALID_PRODUCT"
    # No purchase row must be created.
    assert len(repo.create_calls) == 0


@pytest.mark.asyncio
async def test_purchase_invalid_receipt_raises_conflict_error() -> None:
    """A failed verifier result raises ConflictError with INVALID_RECEIPT code."""
    svc, repo, verifier, grade_repo = _build_service(
        verifier_valid=False,
        verifier_error="영수증이 위조되었어요.",
    )
    user_id = uuid4()

    with pytest.raises(ConflictError) as exc_info:
        await svc.purchase_shields(
            user_id=user_id,
            product_id="shield_1",
            receipt_data="forged-receipt",
        )

    assert exc_info.value.code == "INVALID_RECEIPT"
    # Verifier was called but DB must not be touched.
    assert len(verifier.verify_calls) == 1
    assert len(repo.create_calls) == 0
    # Grade balance must remain untouched (no grade row created via purchase path).
    assert user_id not in grade_repo._grades


@pytest.mark.asyncio
async def test_purchase_receipt_verification_failure_error_message_propagated() -> None:
    """The verifier's error_message is embedded in the ConflictError when present."""
    error_msg = "App Store 영수증 만료"
    svc, _, _, _ = _build_service(verifier_valid=False, verifier_error=error_msg)
    user_id = uuid4()

    with pytest.raises(ConflictError) as exc_info:
        await svc.purchase_shields(
            user_id=user_id,
            product_id="shield_3",
            receipt_data="expired-receipt",
        )

    assert error_msg in str(exc_info.value)


# ---------------------------------------------------------------------------
# handle_refund_webhook — happy path and clamping
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_refund_sets_refunded_at_and_decrements_balance() -> None:
    """Refund marks purchase refunded and subtracts shields from user balance."""
    svc, repo, _, grade_repo = _build_service()
    user_id = uuid4()
    grade_repo.seed_grade(user_id, streak_shields=3)
    purchase = repo.seed_purchase(
        user_id=user_id,
        product_id="shield_3",
        shields_granted=3,
    )

    await svc.handle_refund_webhook(purchase_id=purchase.id)

    # Purchase row must be marked as refunded.
    assert purchase.refunded_at is not None
    # Balance decremented by 3 → 0.
    grade = await grade_repo.get_or_init(user_id)
    assert grade.streak_shields == 0


@pytest.mark.asyncio
async def test_refund_clamps_balance_to_zero() -> None:
    """When balance < shields_granted, decrement is clamped — never goes negative."""
    svc, repo, _, grade_repo = _build_service()
    user_id = uuid4()
    # User only has 1 shield left but the purchase was for 3 (already consumed 2).
    grade_repo.seed_grade(user_id, streak_shields=1)
    purchase = repo.seed_purchase(
        user_id=user_id,
        product_id="shield_3",
        shields_granted=3,
    )

    await svc.handle_refund_webhook(purchase_id=purchase.id)

    grade = await grade_repo.get_or_init(user_id)
    assert grade.streak_shields == 0


@pytest.mark.asyncio
async def test_refund_balance_already_zero_stays_zero() -> None:
    """Refund when balance is already 0 must not produce a negative value."""
    svc, repo, _, grade_repo = _build_service()
    user_id = uuid4()
    grade_repo.seed_grade(user_id, streak_shields=0)
    purchase = repo.seed_purchase(
        user_id=user_id,
        product_id="shield_1",
        shields_granted=1,
    )

    await svc.handle_refund_webhook(purchase_id=purchase.id)

    grade = await grade_repo.get_or_init(user_id)
    assert grade.streak_shields == 0


# ---------------------------------------------------------------------------
# handle_refund_webhook — error cases
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_refund_nonexistent_purchase_raises_not_found() -> None:
    """Passing an unknown purchase_id raises NotFoundError."""
    svc, _, _, _ = _build_service()
    unknown_id = uuid4()

    with pytest.raises(NotFoundError) as exc_info:
        await svc.handle_refund_webhook(purchase_id=unknown_id)

    assert exc_info.value.code == "PURCHASE_NOT_FOUND"


@pytest.mark.asyncio
async def test_refund_already_refunded_purchase_raises_conflict() -> None:
    """Attempting to refund a purchase that was already refunded raises ConflictError."""
    svc, repo, _, grade_repo = _build_service()
    user_id = uuid4()
    grade_repo.seed_grade(user_id, streak_shields=3)
    purchase = repo.seed_purchase(
        user_id=user_id,
        product_id="shield_3",
        shields_granted=3,
        refunded_at=datetime.now(tz=UTC),  # pre-set as already refunded
    )

    with pytest.raises(ConflictError) as exc_info:
        await svc.handle_refund_webhook(purchase_id=purchase.id)

    assert exc_info.value.code == "ALREADY_REFUNDED"


# ---------------------------------------------------------------------------
# grade_repo.get_or_init is called (balance enquiry path)
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_purchase_calls_grade_repo_get_or_init() -> None:
    """purchase_shields must call grade_repo.get_or_init to fetch the current balance."""
    svc, _, _, grade_repo = _build_service()
    user_id = uuid4()

    await svc.purchase_shields(
        user_id=user_id,
        product_id="shield_1",
        receipt_data="r1",
    )

    # get_or_init is called at least once during the purchase flow.
    assert user_id in grade_repo.get_or_init_calls


# ---------------------------------------------------------------------------
# Cumulative balance — two sequential purchases
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_two_sequential_purchases_accumulate_balance() -> None:
    """Buying shield_1 twice results in a total balance of 2 shields."""
    svc, repo, _, grade_repo = _build_service()
    user_id = uuid4()

    result_1 = await svc.purchase_shields(
        user_id=user_id,
        product_id="shield_1",
        receipt_data="receipt-1",
    )
    result_2 = await svc.purchase_shields(
        user_id=user_id,
        product_id="shield_1",
        receipt_data="receipt-2",
    )

    assert result_1.total_shields == 1
    assert result_2.total_shields == 2
    assert len(repo.create_calls) == 2
    grade = await grade_repo.get_or_init(user_id)
    assert grade.streak_shields == 2

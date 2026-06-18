"""Unit tests for SubscriptionService — in-memory fakes, no DB."""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import UTC, datetime, timedelta
from uuid import UUID, uuid4

import pytest
from app.domains.subscription.adapters.stub_verifier import StubPurchaseVerifier
from app.domains.subscription.schemas import VerifyReceiptRequest
from app.domains.subscription.service import SubscriptionService


# ---------------------------------------------------------------------------
# Fake repository
# ---------------------------------------------------------------------------


@dataclass
class FakeSubscriptionRepository:
    _store: dict[UUID, dict] = field(default_factory=dict)

    def _row(self, user_id: UUID) -> dict:
        return self._store.setdefault(
            user_id,
            {"is_pro": False, "pro_expires_at": None, "pro_product_id": None},
        )

    async def get_subscription_status(self, user_id: UUID) -> dict:
        return dict(self._row(user_id))

    async def update_subscription(
        self,
        user_id: UUID,
        *,
        is_pro: bool,
        expires_at: datetime | None,
        product_id: str | None,
    ) -> None:
        row = self._row(user_id)
        row["is_pro"] = is_pro
        row["pro_expires_at"] = expires_at
        row["pro_product_id"] = product_id


def _svc() -> tuple[SubscriptionService, FakeSubscriptionRepository]:
    repo = FakeSubscriptionRepository()
    return SubscriptionService(repo=repo, verifier=StubPurchaseVerifier()), repo  # type: ignore[arg-type]


@dataclass
class FakeShieldGrant:
    """Records welcome-shield grants instead of touching the reading domain."""

    grants: list[tuple[UUID, int]] = field(default_factory=list)

    async def grant_shields(self, *, user_id: UUID, count: int) -> None:
        self.grants.append((user_id, count))


def _verify_req(platform: str = "ios") -> VerifyReceiptRequest:
    return VerifyReceiptRequest(
        platform=platform,  # type: ignore[arg-type]
        receipt_data="test_receipt",
        product_id="bookclub_pro_monthly",
    )


# ---------------------------------------------------------------------------
# get_status
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_get_status_default_is_not_pro() -> None:
    svc, _ = _svc()
    status = await svc.get_status(uuid4())
    assert status.is_pro is False
    assert status.pro_expires_at is None


@pytest.mark.asyncio
async def test_get_status_active_pro_returned_as_is() -> None:
    svc, repo = _svc()
    user = uuid4()
    future = datetime.now(tz=UTC) + timedelta(days=365)
    await repo.update_subscription(
        user, is_pro=True, expires_at=future, product_id="bookclub_pro_monthly"
    )
    status = await svc.get_status(user)
    assert status.is_pro is True
    assert status.pro_expires_at == future


@pytest.mark.asyncio
async def test_get_status_expired_pro_auto_revoked() -> None:
    svc, repo = _svc()
    user = uuid4()
    past = datetime.now(tz=UTC) - timedelta(seconds=1)
    await repo.update_subscription(
        user, is_pro=True, expires_at=past, product_id="bookclub_pro_monthly"
    )

    status = await svc.get_status(user)
    assert status.is_pro is False
    assert status.pro_expires_at is None
    # The row in the store should also be cleared
    row = await repo.get_subscription_status(user)
    assert row["is_pro"] is False


# ---------------------------------------------------------------------------
# verify_and_activate
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_verify_and_activate_sets_pro() -> None:
    svc, _ = _svc()
    user = uuid4()
    result = await svc.verify_and_activate(user_id=user, req=_verify_req())
    assert result.is_pro is True
    assert result.expires_at is not None
    assert "활성화" in result.message


@pytest.mark.asyncio
async def test_verify_and_activate_persists_in_store() -> None:
    svc, repo = _svc()
    user = uuid4()
    await svc.verify_and_activate(user_id=user, req=_verify_req("android"))

    row = await repo.get_subscription_status(user)
    assert row["is_pro"] is True
    assert row["pro_product_id"] == "bookclub_pro_monthly"


@pytest.mark.asyncio
async def test_verify_and_activate_expires_roughly_one_year_from_now() -> None:
    svc, _ = _svc()
    user = uuid4()
    before = datetime.now(tz=UTC)
    result = await svc.verify_and_activate(user_id=user, req=_verify_req())
    after = datetime.now(tz=UTC)

    assert result.expires_at is not None
    # Should be ~365 days from now (allow 1-second window)
    expected_min = before + timedelta(days=364)
    expected_max = after + timedelta(days=366)
    assert expected_min <= result.expires_at <= expected_max


# ---------------------------------------------------------------------------
# apply_webhook_event — annual Pro welcome shields
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_annual_initial_purchase_grants_three_welcome_shields() -> None:
    repo = FakeSubscriptionRepository()
    shield_grant = FakeShieldGrant()
    svc = SubscriptionService(
        repo=repo,  # type: ignore[arg-type]
        verifier=StubPurchaseVerifier(),
        shield_grant=shield_grant,
    )
    user = uuid4()

    await svc.apply_webhook_event(
        event_type="INITIAL_PURCHASE",
        user_id=user,
        product_id="annual_pro_59000",
        expires_at=datetime.now(tz=UTC) + timedelta(days=365),
    )

    assert repo._store[user]["is_pro"] is True
    assert shield_grant.grants == [(user, 3)]


@pytest.mark.asyncio
async def test_annual_renewal_does_not_grant_welcome_shields() -> None:
    repo = FakeSubscriptionRepository()
    shield_grant = FakeShieldGrant()
    svc = SubscriptionService(
        repo=repo,  # type: ignore[arg-type]
        verifier=StubPurchaseVerifier(),
        shield_grant=shield_grant,
    )

    await svc.apply_webhook_event(
        event_type="RENEWAL",
        user_id=uuid4(),
        product_id="annual_pro_59000",
        expires_at=datetime.now(tz=UTC) + timedelta(days=365),
    )

    assert shield_grant.grants == []


@pytest.mark.asyncio
async def test_monthly_initial_purchase_grants_no_welcome_shields() -> None:
    repo = FakeSubscriptionRepository()
    shield_grant = FakeShieldGrant()
    svc = SubscriptionService(
        repo=repo,  # type: ignore[arg-type]
        verifier=StubPurchaseVerifier(),
        shield_grant=shield_grant,
    )

    await svc.apply_webhook_event(
        event_type="INITIAL_PURCHASE",
        user_id=uuid4(),
        product_id="bookclub_pro_monthly",
        expires_at=datetime.now(tz=UTC) + timedelta(days=30),
    )

    assert shield_grant.grants == []

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

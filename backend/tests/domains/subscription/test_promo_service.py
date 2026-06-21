"""Unit tests for PromoService — in-memory fake repository, no DB."""

from __future__ import annotations

from dataclasses import dataclass
from datetime import UTC, datetime, timedelta

import pytest
from app.domains.subscription.models import SubscriptionPromo
from app.domains.subscription.service import PromoService


@dataclass
class FakePromoRepository:
    """Returns a pre-seeded promo (or None) without touching the database."""

    promo: SubscriptionPromo | None = None

    async def get_active_promo(self) -> SubscriptionPromo | None:
        return self.promo


def _svc(promo: SubscriptionPromo | None) -> PromoService:
    return PromoService(repo=FakePromoRepository(promo=promo))  # type: ignore[arg-type]


@pytest.mark.asyncio
async def test_returns_none_when_no_active_promo() -> None:
    service = _svc(None)
    assert await service.get_active_promo() is None


@pytest.mark.asyncio
async def test_maps_active_promo_to_dto() -> None:
    valid_until = datetime.now(tz=UTC) + timedelta(days=10)
    promo = SubscriptionPromo(
        promo_code="EARLYBIRD",
        discount_pct=10,
        valid_from=datetime.now(tz=UTC) - timedelta(days=1),
        valid_until=valid_until,
        is_active=True,
    )

    result = await _svc(promo).get_active_promo()

    assert result is not None
    assert result.promo_code == "EARLYBIRD"
    assert result.discount_pct == 10
    assert result.valid_until == valid_until

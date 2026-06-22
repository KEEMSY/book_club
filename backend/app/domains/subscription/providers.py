"""FastAPI dependency factories for the subscription domain.

Keeps router wiring code out of the business layer (CLAUDE.md §3.1).
Tests can override ``get_subscription_service`` via
``app.dependency_overrides``.

Verifier selection:
  - REVENUECAT_API_KEY env var present → RevenueCatAdapter (production)
  - absent → StubPurchaseVerifier (development / test)
"""

from __future__ import annotations

import os
from typing import Annotated
from uuid import UUID

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.experiment.providers import get_experiment_service
from app.domains.experiment.service import ExperimentService
from app.domains.reading.repository import UserGradeRepository
from app.domains.subscription.adapters.revenuecat_adapter import RevenueCatAdapter
from app.domains.subscription.adapters.stub_verifier import StubPurchaseVerifier
from app.domains.subscription.ports import PurchaseVerifierPort
from app.domains.subscription.repository import (
    CouponRepository,
    PromoRepository,
    SubscriptionRepository,
)
from app.domains.subscription.service import CouponService, PromoService, SubscriptionService


class GradeShieldGrantAdapter:
    """Implements ``ShieldGrantPort`` by crediting ``UserGrade.streak_shields``.

    Welcome shields stack on the existing balance (matching the IAP purchase
    path); they are not capped here because the gift is a one-time event.
    """

    def __init__(self, session: AsyncSession) -> None:
        self._repo = UserGradeRepository(session)

    async def grant_shields(self, *, user_id: UUID, count: int) -> None:
        grade = await self._repo.get_or_init(user_id)
        await self._repo.update_streak_shields(user_id, shields=grade.streak_shields + count)


def get_verifier() -> PurchaseVerifierPort:
    """Return a real RevenueCat adapter or the dev stub based on env config."""
    api_key = os.getenv("REVENUECAT_API_KEY")
    if api_key:
        return RevenueCatAdapter(api_key=api_key)
    return StubPurchaseVerifier()


def get_subscription_service(
    session: Annotated[AsyncSession, Depends(get_session)],
    experiment_svc: Annotated[ExperimentService, Depends(get_experiment_service)],
) -> SubscriptionService:
    """Construct a SubscriptionService wired with a live repository, verifier, and
    experiment service for Pro conversion tracking."""
    return SubscriptionService(
        repo=SubscriptionRepository(session),
        verifier=get_verifier(),
        experiment_service=experiment_svc,
        shield_grant=GradeShieldGrantAdapter(session),
    )


def get_promo_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> PromoService:
    """Construct a ``PromoService`` wired with a live promo repository."""
    return PromoService(repo=PromoRepository(session))


def get_coupon_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> CouponService:
    """Construct a ``CouponService`` wired with a live coupon repository."""
    return CouponService(repo=CouponRepository(session))

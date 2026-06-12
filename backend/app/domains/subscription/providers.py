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

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.subscription.adapters.revenuecat_adapter import RevenueCatAdapter
from app.domains.subscription.adapters.stub_verifier import StubPurchaseVerifier
from app.domains.subscription.ports import PurchaseVerifierPort
from app.domains.subscription.repository import SubscriptionRepository
from app.domains.subscription.service import SubscriptionService


def get_verifier() -> PurchaseVerifierPort:
    """Return a real RevenueCat adapter or the dev stub based on env config."""
    api_key = os.getenv("REVENUECAT_API_KEY")
    if api_key:
        return RevenueCatAdapter(api_key=api_key)
    return StubPurchaseVerifier()


def get_subscription_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> SubscriptionService:
    """Construct a SubscriptionService wired with a live repository and verifier."""
    return SubscriptionService(
        repo=SubscriptionRepository(session),
        verifier=get_verifier(),
    )

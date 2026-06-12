"""FastAPI dependency factories for the subscription domain.

Keeps router wiring code out of the business layer (CLAUDE.md §3.1).
Tests can override ``get_subscription_service`` via
``app.dependency_overrides``.
"""

from __future__ import annotations

from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.subscription.repository import SubscriptionRepository
from app.domains.subscription.service import SubscriptionService


def get_subscription_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> SubscriptionService:
    """Construct a SubscriptionService wired with a live repository."""
    return SubscriptionService(repo=SubscriptionRepository(session))

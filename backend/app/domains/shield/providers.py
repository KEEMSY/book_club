"""FastAPI dependency factories for the shield purchase domain.

Reuses the existing PurchaseVerifierPort wiring from the subscription
domain (same RevenueCat key; same stub in development).
"""

from __future__ import annotations

from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.reading.repository import UserGradeRepository
from app.domains.shield.repository import ShieldPurchaseRepository
from app.domains.shield.service import ShieldPurchaseService
from app.domains.subscription.providers import get_verifier


def get_shield_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> ShieldPurchaseService:
    """Construct a request-scoped ShieldPurchaseService."""
    return ShieldPurchaseService(
        repo=ShieldPurchaseRepository(session),
        verifier=get_verifier(),
        grade_repo=UserGradeRepository(session),
    )

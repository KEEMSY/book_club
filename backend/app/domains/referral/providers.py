"""FastAPI dependency factories for the referral domain.

Keeps the router free of wiring code (CLAUDE.md §3.1).  Tests can override
``get_referral_service`` via ``app.dependency_overrides``.
"""

from __future__ import annotations

from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.referral.repository import ReferralRepository
from app.domains.referral.service import ReferralService


def get_referral_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> ReferralService:
    """Construct a ReferralService wired with a live repository."""
    return ReferralService(repo=ReferralRepository(session))

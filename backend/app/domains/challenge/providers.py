"""FastAPI dependency factories for the challenge domain.

Keeps the router file free of wiring code (CLAUDE.md §3.1). Tests can
override ``get_challenge_service`` via ``app.dependency_overrides`` to
inject an in-memory fake.
"""

from __future__ import annotations

from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.challenge.repository import ChallengeRepository
from app.domains.challenge.service import ChallengeService


def get_challenge_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> ChallengeService:
    """Construct a ChallengeService wired with a live repository."""
    return ChallengeService(repo=ChallengeRepository(session))

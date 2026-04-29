"""FastAPI dependency factories for the challenge domain.

Keeps the router file free of wiring code (CLAUDE.md §3.1). Tests can
override ``get_challenge_service`` via ``app.dependency_overrides`` to
inject an in-memory fake.
"""

from __future__ import annotations

from functools import lru_cache
from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session, get_sessionmaker
from app.domains.challenge.repository import ChallengeRepository
from app.domains.challenge.service import ChallengeService
from app.domains.reading.providers import get_event_bus
from app.shared.event_bus import commit_and_publish, stage_event


def get_challenge_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> ChallengeService:
    """Construct a request-scoped ChallengeService for HTTP endpoints."""
    bus = get_event_bus()

    def _stage(event: object) -> None:
        stage_event(session, event)

    commit_and_publish(session, bus)

    return ChallengeService(repo=ChallengeRepository(session), stage_event=_stage)


@lru_cache(maxsize=1)
def get_challenge_service_singleton() -> ChallengeService:
    """Process-wide ChallengeService for event handler subscriptions.

    Uses a sessionmaker so each event handler opens a fresh session;
    the repo field is a placeholder (not used by handler methods).
    """
    sessionmaker = get_sessionmaker()
    bus = get_event_bus()
    return ChallengeService(
        repo=None,
        sessionmaker=sessionmaker,
        bus=bus,
    )

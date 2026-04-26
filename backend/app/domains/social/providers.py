"""FastAPI dependency factories for the social domain.

Keeps the router file free of wiring code (CLAUDE.md §3.1) and gives
tests a stable seam: override ``get_social_service`` with
``app.dependency_overrides`` to inject an in-memory fake.
"""

from __future__ import annotations

from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.reading.providers import get_event_bus
from app.domains.social.repository import SocialRepository
from app.domains.social.service import SocialService
from app.shared.event_bus import commit_and_publish, stage_event


def get_social_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> SocialService:
    """Construct a SocialService wired with a live repository and the event bus."""
    bus = get_event_bus()

    def _stage(event: object) -> None:
        stage_event(session, event)

    commit_and_publish(session, bus)

    return SocialService(
        repo=SocialRepository(session),
        bus=bus,
        stage_event=_stage,
    )

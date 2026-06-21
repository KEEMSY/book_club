"""FastAPI dependency factories for the event domain.

Keeps the router free of wiring code (CLAUDE.md §3.1). Tests override
``get_event_service`` via ``app.dependency_overrides`` to inject fakes.
"""

from __future__ import annotations

from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.event.repository import EventRepository
from app.domains.event.service import EventService


def get_event_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> EventService:
    """Construct an EventService wired with a live repository."""
    return EventService(repo=EventRepository(session))

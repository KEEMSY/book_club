"""FastAPI dependency factories for the reminder domain.

Keeps the router free of wiring code (CLAUDE.md §3.1).  Tests can override
``get_reminder_service`` via ``app.dependency_overrides``.
"""

from __future__ import annotations

from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.reminder.repository import ReminderRepository
from app.domains.reminder.service import ReminderService


def get_reminder_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> ReminderService:
    """Construct a ReminderService wired with a live repository."""
    return ReminderService(repo=ReminderRepository(session))

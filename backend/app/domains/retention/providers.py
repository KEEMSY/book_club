"""FastAPI dependency factories for the retention domain."""

from __future__ import annotations

from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.notification.providers import get_notification_service
from app.domains.reading.repository import UserGradeRepository
from app.domains.retention.repository import RetentionRepository
from app.domains.retention.service import RetentionService


def get_retention_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> RetentionService:
    """Build a request-scoped RetentionService.

    ``UserGradeRepository`` is injected directly because the retention service
    only performs a single narrow update (streak_days += 1) and there is no
    second concrete implementation to abstract over (CLAUDE.md §3.2 — avoid
    over-engineering single-implementation ports).
    """
    return RetentionService(
        repo=RetentionRepository(session),
        user_grades=UserGradeRepository(session),
        notification_service=get_notification_service(),
    )

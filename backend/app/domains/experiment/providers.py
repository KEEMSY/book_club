"""FastAPI dependency factories for the experiment domain.

Keeps router wiring code out of the business layer (CLAUDE.md §3.1).
Tests can override ``get_experiment_service`` via ``app.dependency_overrides``.
"""

from __future__ import annotations

from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.experiment.repository import ExperimentRepository
from app.domains.experiment.service import ExperimentService


def get_experiment_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> ExperimentService:
    """Construct an ``ExperimentService`` wired with a live repository."""
    return ExperimentService(repo=ExperimentRepository(session))

"""FastAPI dependency factories for the curation domain.

Keeps the router free of wiring code (CLAUDE.md §3.1). Tests can override
``get_curation_service`` via ``app.dependency_overrides``.
"""

from __future__ import annotations

from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.curation.repository import CurationRepository
from app.domains.curation.service import CurationService


def get_curation_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> CurationService:
    """Construct a CurationService wired with a live repository."""
    return CurationService(repo=CurationRepository(session))

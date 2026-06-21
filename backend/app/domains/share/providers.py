"""FastAPI dependency factories for the share domain.

Keeps the router free of wiring code (CLAUDE.md §3.1). Tests override
``get_share_service`` via ``app.dependency_overrides`` to inject fakes.
"""

from __future__ import annotations

from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.share.repository import ShareCardMetaRepository, ShareRepository
from app.domains.share.service import ShareService


def get_share_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> ShareService:
    """Construct a ShareService wired with live repositories."""
    return ShareService(
        repo=ShareRepository(session),
        meta=ShareCardMetaRepository(session),
    )

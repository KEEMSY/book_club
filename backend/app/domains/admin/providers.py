"""FastAPI dependency factories for the admin domain.

Keeps the router free of wiring code (CLAUDE.md §3.1).  Tests can override
``get_admin_service`` via ``app.dependency_overrides``.
"""

from __future__ import annotations

from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.admin.repository import AdminRepository
from app.domains.admin.service import AdminService


def get_admin_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> AdminService:
    """Construct an ``AdminService`` wired with a live repository."""
    return AdminService(repo=AdminRepository(session))

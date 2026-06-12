"""FastAPI dependency providers for the search domain."""

from __future__ import annotations

from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.search.repository import SearchRepository
from app.domains.search.service import SearchService


def get_search_service(session: Annotated[AsyncSession, Depends(get_session)]) -> SearchService:
    return SearchService(repo=SearchRepository(session))

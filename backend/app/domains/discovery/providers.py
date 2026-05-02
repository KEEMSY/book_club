from __future__ import annotations

from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.discovery.repository import DiscoveryRepository
from app.domains.discovery.service import DiscoveryService


def get_discovery_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> DiscoveryService:
    return DiscoveryService(repo=DiscoveryRepository(session))

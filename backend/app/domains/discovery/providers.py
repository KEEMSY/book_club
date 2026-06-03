"""FastAPI dependency factories and scheduler wiring for the discovery domain."""

from __future__ import annotations

from functools import lru_cache
from typing import Annotated

import redis.asyncio as aioredis
from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import get_settings
from app.core.db import get_session, get_sessionmaker
from app.domains.discovery.ml.recommender import CollaborativeFilteringRecommender
from app.domains.discovery.repository import DiscoveryRepository
from app.domains.discovery.service import DiscoveryService


@lru_cache(maxsize=1)
def get_redis_client() -> aioredis.Redis:
    """Return the process-wide async Redis client (lazy singleton)."""
    settings = get_settings()
    return aioredis.from_url(settings.redis_url, decode_responses=False)


@lru_cache(maxsize=1)
def get_cf_recommender() -> CollaborativeFilteringRecommender:
    """Return the process-wide CollaborativeFilteringRecommender singleton."""
    return CollaborativeFilteringRecommender(_redis=get_redis_client())


def get_discovery_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> DiscoveryService:
    return DiscoveryService(
        repo=DiscoveryRepository(session),
        ml=get_cf_recommender(),
    )


async def run_cf_retrain() -> None:
    """APScheduler job: open a fresh session and retrain the CF model."""
    sessionmaker = get_sessionmaker()
    recommender = get_cf_recommender()
    async with sessionmaker() as session:
        await recommender.retrain(session)

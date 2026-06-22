"""FastAPI dependency factories and scheduler wiring for the discovery domain."""

from __future__ import annotations

from functools import lru_cache
from typing import Annotated

import redis.asyncio as aioredis
from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import get_settings
from app.core.db import get_session, get_sessionmaker
from app.domains.book.taste_profile_repository import (
    OnboardingInterestRepository,
    TasteProfileRepository,
)
from app.domains.discovery.adapters.claude_recommender_adapter import (
    ClaudeBookRecommenderAdapter,
)
from app.domains.discovery.adapters.stub_recommender_adapter import (
    StubBookRecommenderAdapter,
)
from app.domains.discovery.ai_port import AIBookRecommenderPort
from app.domains.discovery.ml.recommender import CollaborativeFilteringRecommender
from app.domains.discovery.onboarding_service import OnboardingService
from app.domains.discovery.repository import DiscoveryRepository
from app.domains.discovery.service import DiscoveryService
from app.domains.discovery.taste_profile_service import TasteProfileService


@lru_cache(maxsize=1)
def get_redis_client() -> aioredis.Redis:
    """Return the process-wide async Redis client (lazy singleton)."""
    settings = get_settings()
    return aioredis.from_url(settings.redis_url, decode_responses=False)


@lru_cache(maxsize=1)
def get_cf_recommender() -> CollaborativeFilteringRecommender:
    """Return the process-wide CollaborativeFilteringRecommender singleton."""
    return CollaborativeFilteringRecommender(_redis=get_redis_client())


@lru_cache(maxsize=1)
def get_ai_book_recommender() -> AIBookRecommenderPort:
    """Return the process-wide ai_picks recommender (live SDK client reused).

    Selects the live ``ClaudeBookRecommenderAdapter`` when ``ANTHROPIC_API_KEY``
    is set, otherwise the deterministic stub so dev/test run without a key.
    """
    settings = get_settings()
    if settings.anthropic_api_key:
        return ClaudeBookRecommenderAdapter(
            api_key=settings.anthropic_api_key, model=settings.anthropic_model
        )
    return StubBookRecommenderAdapter()


def get_discovery_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> DiscoveryService:
    return DiscoveryService(
        repo=DiscoveryRepository(session),
        ml=get_cf_recommender(),
        ai_recommender=get_ai_book_recommender(),
    )


def get_taste_profile_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> TasteProfileService:
    return TasteProfileService(taste_profiles=TasteProfileRepository(session))


def get_onboarding_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> OnboardingService:
    return OnboardingService(interests_repo=OnboardingInterestRepository(session))


async def run_cf_retrain() -> None:
    """APScheduler job: open a fresh session and retrain the CF model."""
    sessionmaker = get_sessionmaker()
    recommender = get_cf_recommender()
    async with sessionmaker() as session:
        await recommender.retrain(session)


async def recompute_taste_profile(user_id: str) -> None:
    """Scheduler / fire-and-forget job: recompute a user's taste profile.

    Opens its own session so it can be called from outside a request context
    (e.g. from the reading domain's book-completion hook).
    """
    import uuid

    sessionmaker = get_sessionmaker()
    async with sessionmaker() as session:
        svc = TasteProfileService(taste_profiles=TasteProfileRepository(session))
        await svc.recompute(uuid.UUID(user_id))
        await session.commit()

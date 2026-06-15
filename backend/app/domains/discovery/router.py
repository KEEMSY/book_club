"""HTTP surface for the discovery domain — recommendations and onboarding.

Keeps this file thin: every handler is a DTO -> service -> DTO adapter.
Business logic lives in service.py (CLAUDE.md §3.1).
"""

from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, Query, status

from app.core.deps import get_current_user_id
from app.domains.discovery.onboarding_service import OnboardingService
from app.domains.discovery.providers import get_discovery_service, get_onboarding_service
from app.domains.discovery.schemas import (
    OnboardingInterestPublic,
    OnboardingInterestsResponse,
    RecommendationResponse,
    RecommendedBookPublic,
    SaveOnboardingInterestsRequest,
)
from app.domains.discovery.service import DiscoveryService
from app.domains.discovery.strategies import RecommendationStrategy

router = APIRouter(tags=["discovery"])


@router.get("/me/recommendations", response_model=RecommendationResponse)
async def get_recommendations(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[DiscoveryService, Depends(get_discovery_service)],
    strategy: Annotated[
        RecommendationStrategy, Query(description="Recommendation strategy")
    ] = RecommendationStrategy.COLLABORATIVE,
    limit: Annotated[int, Query(ge=1, le=30)] = 10,
) -> RecommendationResponse:
    items = await service.get_recommendations(UUID(user_id), strategy=strategy, limit=limit)
    return RecommendationResponse(
        items=[RecommendedBookPublic(**item) for item in items]  # type: ignore[arg-type]
    )


@router.post(
    "/me/onboarding/interests",
    response_model=OnboardingInterestsResponse,
    status_code=status.HTTP_200_OK,
)
async def save_onboarding_interests(
    body: SaveOnboardingInterestsRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    svc: Annotated[OnboardingService, Depends(get_onboarding_service)],
) -> OnboardingInterestsResponse:
    saved = await svc.replace_interests(
        UUID(user_id),
        [(i.category, i.value) for i in body.interests],
    )
    return OnboardingInterestsResponse(
        items=[OnboardingInterestPublic(category=r.category, value=r.value) for r in saved]
    )


@router.get("/me/onboarding/interests", response_model=OnboardingInterestsResponse)
async def list_onboarding_interests(
    user_id: Annotated[str, Depends(get_current_user_id)],
    svc: Annotated[OnboardingService, Depends(get_onboarding_service)],
) -> OnboardingInterestsResponse:
    rows = await svc.list_interests(UUID(user_id))
    return OnboardingInterestsResponse(
        items=[OnboardingInterestPublic(category=r.category, value=r.value) for r in rows]
    )

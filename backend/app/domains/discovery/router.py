from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends

from app.core.deps import get_current_user_id
from app.domains.discovery.providers import get_discovery_service
from app.domains.discovery.schemas import RecommendationResponse, RecommendedBookPublic
from app.domains.discovery.service import DiscoveryService

router = APIRouter(tags=["discovery"])


@router.get("/me/recommendations", response_model=RecommendationResponse)
async def get_recommendations(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[DiscoveryService, Depends(get_discovery_service)],
) -> RecommendationResponse:
    items = await service.get_recommendations(UUID(user_id))
    return RecommendationResponse(items=[RecommendedBookPublic(**item) for item in items])

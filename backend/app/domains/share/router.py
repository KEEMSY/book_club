"""HTTP surface for the share domain (M62).

Thin DTO → service → DTO adapters per CLAUDE.md §3.1. The router never catches
domain exceptions; the global handler maps them to HTTP responses.

Endpoints:
  * GET  /me/share-cards/{card_type} — card metadata for a template
  * POST /me/share-events            — record a share event
  * GET  /admin/share-stats          — (admin) aggregate share metrics
"""

from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends

from app.core.deps import get_current_admin_id, get_current_user_id
from app.domains.share.providers import get_share_service
from app.domains.share.schemas import (
    ShareCardMetaResponse,
    ShareEventRequest,
    ShareEventResponse,
    ShareStatsResponse,
)
from app.domains.share.service import ShareService

router = APIRouter(tags=["share"])


@router.get("/me/share-cards/{card_type}", response_model=ShareCardMetaResponse)
async def get_share_card_meta(
    card_type: str,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ShareService, Depends(get_share_service)],
) -> ShareCardMetaResponse:
    """Return identity, referral deep link, and copy for a card template.

    Returns 404 when ``card_type`` is not one of the five known templates.
    """
    return await service.get_card_meta(UUID(user_id), card_type)


@router.post("/me/share-events", response_model=ShareEventResponse)
async def record_share_event(
    body: ShareEventRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ShareService, Depends(get_share_service)],
) -> ShareEventResponse:
    """Record a share for the viral-loop analytics.

    Returns 409 when ``card_type`` or ``platform`` is unrecognised.
    """
    return await service.record_event(
        user_id=UUID(user_id),
        card_type=body.card_type,
        platform=body.platform,
        referral_code=body.referral_code,
    )


@router.get("/admin/share-stats", response_model=ShareStatsResponse)
async def get_share_stats(
    _: Annotated[str, Depends(get_current_admin_id)],
    service: Annotated[ShareService, Depends(get_share_service)],
) -> ShareStatsResponse:
    """Aggregate share counts grouped by (card_type, platform)."""
    return await service.get_share_stats()

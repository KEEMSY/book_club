"""HTTP routes for the retention domain.

User-facing:
  POST /me/streak/recover           — spend a recovery slot (+1 streak day)
  GET  /me/streak/recovery-status   — check used/remaining slots this month

Admin-only:
  POST /admin/retention/run-campaign — trigger the re-engagement push batch
  GET  /admin/retention/stats        — aggregate retention metrics

Router keeps handlers thin: DTO → service → DTO. No business logic here.
"""

from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends

from app.core.deps import get_current_admin_id, get_current_user_id
from app.domains.retention.providers import get_retention_service
from app.domains.retention.schemas import (
    CampaignRunResponse,
    RetentionStatsResponse,
    StreakRecoverResponse,
    StreakRecoveryStatusResponse,
)
from app.domains.retention.service import RetentionService

router = APIRouter(tags=["retention"])


# ---------------------------------------------------------------------------
# User endpoints
# ---------------------------------------------------------------------------


@router.post("/me/streak/recover", response_model=StreakRecoverResponse)
async def recover_streak(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[RetentionService, Depends(get_retention_service)],
) -> StreakRecoverResponse:
    """Spend one recovery slot to add 1 day to the caller's streak.

    Returns the number of recovery slots remaining in the current 30-day window.
    Raises 409 STREAK_RECOVERY_LIMIT when the monthly cap (2) is exhausted.
    """
    result = await service.recover_streak(UUID(user_id))
    return StreakRecoverResponse(**result)


@router.get("/me/streak/recovery-status", response_model=StreakRecoveryStatusResponse)
async def get_recovery_status(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[RetentionService, Depends(get_retention_service)],
) -> StreakRecoveryStatusResponse:
    """Return how many recovery slots the caller has used and has remaining."""
    result = await service.get_recovery_status(UUID(user_id))
    return StreakRecoveryStatusResponse(**result)


# ---------------------------------------------------------------------------
# Admin endpoints
# ---------------------------------------------------------------------------


@router.post(
    "/admin/retention/run-campaign",
    response_model=CampaignRunResponse,
    dependencies=[Depends(get_current_admin_id)],
)
async def run_reengagement_campaign(
    service: Annotated[RetentionService, Depends(get_retention_service)],
) -> CampaignRunResponse:
    """Trigger the 7-day-inactive re-engagement push campaign.

    Skips users who already received the push today. Returns the total number
    of pushes dispatched in this run.
    """
    sent = await service.run_reengagement_campaign()
    return CampaignRunResponse(pushes_sent=sent)


@router.get(
    "/admin/retention/stats",
    response_model=RetentionStatsResponse,
    dependencies=[Depends(get_current_admin_id)],
)
async def get_retention_stats(
    service: Annotated[RetentionService, Depends(get_retention_service)],
) -> RetentionStatsResponse:
    """Return aggregate retention metrics for the admin dashboard."""
    stats = await service.get_campaign_stats()
    return RetentionStatsResponse(**stats)

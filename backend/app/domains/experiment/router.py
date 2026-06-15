"""HTTP surface for the experiment domain.

Routes:
  GET  /me/experiments                      — current user's experiment assignments
  POST /me/experiments/conversion           — record Pro conversion for an experiment
  GET  /admin/experiments/{key}/stats       — per-variant stats (admin only)

Thin DTO → service → DTO adapters per CLAUDE.md §3.1.
"""

from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, status

from app.core.deps import get_current_admin_id, get_current_user_id
from app.domains.experiment.providers import get_experiment_service
from app.domains.experiment.schemas import (
    ExperimentStatsResponse,
    RecordConversionRequest,
    UserExperimentsResponse,
)
from app.domains.experiment.service import ExperimentService

router = APIRouter(tags=["experiment"])


@router.get("/me/experiments", response_model=UserExperimentsResponse)
async def get_my_experiments(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ExperimentService, Depends(get_experiment_service)],
) -> UserExperimentsResponse:
    """Return the authenticated user's assignment for every active experiment."""
    return await service.get_user_assignments(UUID(user_id))


@router.post(
    "/me/experiments/conversion",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def record_conversion(
    body: RecordConversionRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ExperimentService, Depends(get_experiment_service)],
) -> None:
    """Record a Pro conversion event for the given experiment key.

    Called by the mobile client immediately after a successful Pro subscription
    purchase.  Idempotent: a second call for the same user/key is a no-op.
    """
    await service.record_conversion(
        user_id=UUID(user_id),
        experiment_key=body.experiment_key,
    )


@router.get(
    "/admin/experiments/{experiment_key}/stats",
    response_model=ExperimentStatsResponse,
)
async def get_experiment_stats(
    experiment_key: str,
    _: Annotated[str, Depends(get_current_admin_id)],
    service: Annotated[ExperimentService, Depends(get_experiment_service)],
) -> ExperimentStatsResponse:
    """Return per-variant conversion statistics for the given experiment.

    Restricted to admin users.  Returns empty stats when no assignments exist
    yet rather than 404, so dashboards can render a blank state gracefully.
    """
    return await service.get_experiment_stats(experiment_key)

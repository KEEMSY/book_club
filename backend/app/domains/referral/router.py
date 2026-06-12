"""HTTP surface for the referral domain — /me/referral.

Thin DTO → service → DTO adapters per CLAUDE.md §3.1.
"""

from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, Response, status

from app.core.deps import get_current_user_id
from app.domains.referral.providers import get_referral_service
from app.domains.referral.schemas import ApplyReferralRequest, ReferralStatsResponse
from app.domains.referral.service import ReferralService

router = APIRouter(tags=["referral"])


@router.get("/me/referral", response_model=ReferralStatsResponse)
async def get_my_referral(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReferralService, Depends(get_referral_service)],
) -> ReferralStatsResponse:
    """Return the authenticated user's invite code and conversion statistics."""
    return await service.get_my_referral(UUID(user_id))


@router.post("/me/referral/apply", status_code=status.HTTP_204_NO_CONTENT)
async def apply_referral(
    body: ApplyReferralRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReferralService, Depends(get_referral_service)],
) -> Response:
    """Apply a friend's referral code.

    Returns 204 on success.  Returns 404 when the code is not recognised,
    409 when the user tries to apply their own code or already applied one.
    """
    await service.apply_referral(referee_id=UUID(user_id), code=body.code)
    return Response(status_code=status.HTTP_204_NO_CONTENT)

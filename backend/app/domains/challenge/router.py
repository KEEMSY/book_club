"""HTTP surface for the challenge domain.

Prefix: /challenges (challenges) and /badges (badges).
All endpoints require a valid access token (get_current_user_id).

Routes are kept thin: handler = DTO → service → DTO. Business rules live in
``service.py``. Domain exceptions bubble up to the global handler (CLAUDE.md §3.1).

Route ordering note: GET /challenges/my is declared before GET /challenges/{id}
to prevent FastAPI from interpreting "my" as a UUID path parameter.
"""

from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, Query, Response, status

from app.core.deps import get_current_user_id
from app.domains.challenge.providers import get_challenge_service
from app.domains.challenge.schemas import (
    BadgeListResponse,
    BadgeReorderRequest,
    ChallengeDetailView,
    ChallengePage,
    ChallengePublic,
    LeaderboardResponse,
    MyBadgeResponse,
    MyChallengeResponse,
)
from app.domains.challenge.service import ChallengeService

router = APIRouter(tags=["challenges"])


# ---------------------------------------------------------------------------
# Challenges
# ---------------------------------------------------------------------------


@router.get("/challenges", response_model=ChallengePage)
async def list_challenges(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ChallengeService, Depends(get_challenge_service)],
    status_filter: Annotated[str | None, Query(alias="status")] = None,
    limit: Annotated[int, Query(ge=1, le=50)] = 20,
    cursor: Annotated[str | None, Query()] = None,
) -> ChallengePage:
    return await service.list_challenges(UUID(user_id), status_filter, limit, cursor)


@router.get("/challenges/my", response_model=MyChallengeResponse)
async def my_challenges(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ChallengeService, Depends(get_challenge_service)],
) -> MyChallengeResponse:
    items = await service.my_challenges(UUID(user_id))
    return MyChallengeResponse(items=items)


@router.get("/challenges/{challenge_id}", response_model=ChallengeDetailView)
async def get_challenge_detail(
    challenge_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ChallengeService, Depends(get_challenge_service)],
) -> ChallengePublic:
    return await service.get_challenge_detail(challenge_id, UUID(user_id))


@router.post(
    "/challenges/{challenge_id}/join",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def join_challenge(
    challenge_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ChallengeService, Depends(get_challenge_service)],
) -> Response:
    await service.join(challenge_id, UUID(user_id))
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@router.delete(
    "/challenges/{challenge_id}/join",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def leave_challenge(
    challenge_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ChallengeService, Depends(get_challenge_service)],
) -> Response:
    await service.leave(challenge_id, UUID(user_id))
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@router.get("/challenges/{challenge_id}/leaderboard", response_model=LeaderboardResponse)
async def leaderboard(
    challenge_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ChallengeService, Depends(get_challenge_service)],
    limit: Annotated[int, Query(ge=1, le=100)] = 50,
) -> LeaderboardResponse:
    entries = await service.leaderboard(challenge_id, limit)
    return LeaderboardResponse(items=entries)


# ---------------------------------------------------------------------------
# Badges
# ---------------------------------------------------------------------------


@router.get("/badges", response_model=BadgeListResponse)
async def list_badges(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ChallengeService, Depends(get_challenge_service)],
    category: Annotated[str | None, Query()] = None,
) -> BadgeListResponse:
    items = await service.list_badges(category)
    return BadgeListResponse(items=items)


@router.get("/badges/my", response_model=MyBadgeResponse)
async def my_badges(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ChallengeService, Depends(get_challenge_service)],
) -> MyBadgeResponse:
    items = await service.my_badges(UUID(user_id))
    return MyBadgeResponse(items=items)


@router.patch(
    "/me/badges/reorder",
    status_code=status.HTTP_204_NO_CONTENT,
    summary="배지 핀 순서 변경",
)
async def reorder_badges(
    body: BadgeReorderRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ChallengeService, Depends(get_challenge_service)],
) -> Response:
    await service.reorder_pinned_badges(UUID(user_id), body.badge_ids)
    return Response(status_code=status.HTTP_204_NO_CONTENT)

"""HTTP surface for the team domain (M70).

Thin DTO → service → DTO adapters per CLAUDE.md §3.1. Domain exceptions bubble
up to the global handler.

Endpoints:
  * POST   /teams                          — create a team (caller becomes admin)
  * GET    /teams/{team_id}                 — team details + roster (members only)
  * POST   /teams/{team_id}/members         — add a member (admin only)
  * DELETE /teams/{team_id}/members/{uid}   — remove a member (admin only)
"""

from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, status

from app.core.deps import get_current_user_id
from app.domains.team.providers import get_team_service
from app.domains.team.schemas import AddMemberRequest, CreateTeamRequest, TeamResponse
from app.domains.team.service import TeamService

router = APIRouter(prefix="/teams", tags=["team"])


@router.post("", response_model=TeamResponse, status_code=status.HTTP_201_CREATED)
async def create_team(
    body: CreateTeamRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[TeamService, Depends(get_team_service)],
) -> TeamResponse:
    """Create a team plan; the authenticated user becomes its admin and first seat."""
    return await service.create_team(
        admin_user_id=UUID(user_id),
        team_name=body.team_name,
        seat_count=body.seat_count,
        valid_months=body.valid_months,
    )


@router.get("/{team_id}", response_model=TeamResponse)
async def get_team(
    team_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[TeamService, Depends(get_team_service)],
) -> TeamResponse:
    """Return team details and the seat roster (admin and members only)."""
    return await service.get_team(team_id=team_id, user_id=UUID(user_id))


@router.post("/{team_id}/members", response_model=TeamResponse, status_code=status.HTTP_201_CREATED)
async def add_member(
    team_id: UUID,
    body: AddMemberRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[TeamService, Depends(get_team_service)],
) -> TeamResponse:
    """Add a member to the team (admin only). Grants the member Pro."""
    return await service.add_member(
        team_id=team_id, admin_user_id=UUID(user_id), user_id=body.user_id
    )


@router.delete("/{team_id}/members/{member_id}", response_model=TeamResponse)
async def remove_member(
    team_id: UUID,
    member_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[TeamService, Depends(get_team_service)],
) -> TeamResponse:
    """Remove a member from the team (admin only). Revokes the member's Pro."""
    return await service.remove_member(
        team_id=team_id, admin_user_id=UUID(user_id), user_id=member_id
    )

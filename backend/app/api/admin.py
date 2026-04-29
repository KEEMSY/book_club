"""Admin endpoints for privileged management operations.

Authentication: ``X-Admin-Key`` header must match the ``ADMIN_KEY`` env var.
When ``ADMIN_KEY`` is unset (empty string), all admin endpoints return 404
so the surface is invisible in dev unless explicitly configured.
"""

from __future__ import annotations

from datetime import datetime
from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, Header, HTTPException
from pydantic import BaseModel, Field
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import get_settings
from app.core.db import get_session
from app.domains.challenge.models import BadgeCategory, ChallengeType
from app.domains.challenge.repository import ChallengeRepository

router = APIRouter(prefix="/admin", tags=["admin"])


def _require_admin_key(x_admin_key: Annotated[str | None, Header()] = None) -> None:
    """Dependency: validate X-Admin-Key header; 404 when ADMIN_KEY is not configured."""
    key = get_settings().admin_key
    if not key:
        raise HTTPException(status_code=404)
    if x_admin_key != key:
        raise HTTPException(status_code=403, detail="invalid admin key")


AdminAuth = Annotated[None, Depends(_require_admin_key)]


# ---------------------------------------------------------------------------
# Badge creation
# ---------------------------------------------------------------------------


class CreateBadgeRequest(BaseModel):
    name: str = Field(max_length=100)
    description: str
    category: BadgeCategory
    icon_key: str = Field(max_length=500)


class BadgeCreatedResponse(BaseModel):
    id: UUID
    name: str
    description: str
    category: str
    icon_key: str
    created_at: datetime


@router.post("/badges", status_code=201, response_model=BadgeCreatedResponse)
async def create_badge(
    body: CreateBadgeRequest,
    _: AdminAuth,
    session: Annotated[AsyncSession, Depends(get_session)],
) -> BadgeCreatedResponse:
    """Create a new badge. Returns 201 with the created badge."""
    repo = ChallengeRepository(session)
    badge = await repo.create_badge(
        name=body.name,
        description=body.description,
        category=body.category.value,
        icon_key=body.icon_key,
    )
    await session.commit()
    return BadgeCreatedResponse(
        id=badge.id,
        name=badge.name,
        description=badge.description,
        category=badge.category.value,
        icon_key=badge.icon_key,
        created_at=badge.created_at,
    )


# ---------------------------------------------------------------------------
# Challenge creation
# ---------------------------------------------------------------------------


class CreateChallengeRequest(BaseModel):
    title: str = Field(max_length=100)
    description: str | None = None
    challenge_type: ChallengeType
    target_value: int = Field(gt=0)
    genre_filter: str | None = Field(default=None, max_length=50)
    starts_at: datetime
    ends_at: datetime
    badge_id: UUID | None = None


class ChallengeCreatedResponse(BaseModel):
    id: UUID
    title: str
    description: str | None
    challenge_type: str
    target_value: int
    genre_filter: str | None
    starts_at: datetime
    ends_at: datetime
    badge_id: UUID | None
    created_at: datetime


@router.post("/challenges", status_code=201, response_model=ChallengeCreatedResponse)
async def create_challenge(
    body: CreateChallengeRequest,
    _: AdminAuth,
    session: Annotated[AsyncSession, Depends(get_session)],
) -> ChallengeCreatedResponse:
    """Create a new challenge. Returns 201 with the created challenge."""
    repo = ChallengeRepository(session)
    ch = await repo.create_challenge(
        title=body.title,
        description=body.description,
        challenge_type=body.challenge_type.value,
        target_value=body.target_value,
        genre_filter=body.genre_filter,
        starts_at=body.starts_at,
        ends_at=body.ends_at,
        badge_id=body.badge_id,
    )
    await session.commit()
    return ChallengeCreatedResponse(
        id=ch.id,
        title=ch.title,
        description=ch.description,
        challenge_type=ch.challenge_type.value,
        target_value=ch.target_value,
        genre_filter=ch.genre_filter,
        starts_at=ch.starts_at,
        ends_at=ch.ends_at,
        badge_id=ch.badge_id,
        created_at=ch.created_at,
    )

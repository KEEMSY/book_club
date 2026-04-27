"""FastAPI dependency factories for the community domain."""

from __future__ import annotations

from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.auth.repository import UserRepository
from app.domains.community.repository import CommunityRepository
from app.domains.community.service import CommunityService
from app.domains.feed.adapters.r2_image_storage_adapter import R2ImageStorageAdapter
from app.domains.feed.repository import PostRepository, ReactionRepository


def get_community_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> CommunityService:
    return CommunityService(
        community_repo=CommunityRepository(session),
        post_repo=PostRepository(session),
        reactions=ReactionRepository(session),
        image_storage=R2ImageStorageAdapter(),
        user_repo=UserRepository(session),
    )

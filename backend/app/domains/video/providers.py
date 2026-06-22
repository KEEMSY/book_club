from __future__ import annotations

from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.video.adapters import StubAgoraTokenAdapter
from app.domains.video.repository import VideoSessionRepository
from app.domains.video.service import VideoSessionService


def get_video_session_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> VideoSessionService:
    return VideoSessionService(
        repo=VideoSessionRepository(session),
        token_provider=StubAgoraTokenAdapter(),
    )

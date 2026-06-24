from __future__ import annotations

from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import get_settings
from app.core.db import get_session
from app.domains.video.adapters import AgoraRtcTokenAdapter, StubAgoraTokenAdapter
from app.domains.video.ports import AgoraTokenPort
from app.domains.video.repository import VideoSessionRepository
from app.domains.video.service import VideoSessionService


def _token_provider() -> AgoraTokenPort:
    """Real Agora adapter when credentials are configured, else the stub."""
    settings = get_settings()
    if settings.agora_app_id and settings.agora_app_certificate:
        return AgoraRtcTokenAdapter(
            app_id=settings.agora_app_id,
            app_certificate=settings.agora_app_certificate,
        )
    return StubAgoraTokenAdapter()


def get_video_session_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> VideoSessionService:
    return VideoSessionService(
        repo=VideoSessionRepository(session),
        token_provider=_token_provider(),
    )

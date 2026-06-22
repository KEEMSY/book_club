"""HTTP surface for the video domain (M68).

Thin DTO → service → DTO adapters per CLAUDE.md §3.1. The router never catches
domain exceptions; the global handler maps them to HTTP responses.

Endpoints (nested under a club):
  * POST   /clubs/{club_id}/video-sessions             — start/join (Pro owner)
  * DELETE /clubs/{club_id}/video-sessions/{id}         — end (host only)
  * GET    /clubs/{club_id}/video-sessions/active       — active session or 404
"""

from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, Response, status

from app.core.deps import get_current_user_id
from app.domains.video.providers import get_video_session_service
from app.domains.video.schemas import VideoSessionResponse, VideoSessionTokenResponse
from app.domains.video.service import VideoSessionService

router = APIRouter(prefix="/clubs/{club_id}/video-sessions", tags=["video"])


@router.post("", response_model=VideoSessionTokenResponse, status_code=status.HTTP_201_CREATED)
async def start_video_session(
    club_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[VideoSessionService, Depends(get_video_session_service)],
) -> VideoSessionTokenResponse:
    """Open the club video call and return Agora join credentials."""
    return await service.start_session(club_id=club_id, host_id=UUID(user_id))


@router.get("/active", response_model=VideoSessionResponse)
async def get_active_video_session(
    club_id: UUID,
    _: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[VideoSessionService, Depends(get_video_session_service)],
) -> VideoSessionResponse:
    """Return the club's live video session, or 404 when none is active."""
    return await service.get_active_session(club_id=club_id)


@router.delete("/{session_id}", status_code=status.HTTP_204_NO_CONTENT)
async def end_video_session(
    club_id: UUID,
    session_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[VideoSessionService, Depends(get_video_session_service)],
) -> Response:
    """End the session (host only)."""
    await service.end_session(club_id=club_id, session_id=session_id, user_id=UUID(user_id))
    return Response(status_code=status.HTTP_204_NO_CONTENT)

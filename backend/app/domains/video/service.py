"""Video domain service — reading-club video-call MVP (M68).

Depends only on ``VideoSessionRepositoryPort`` and ``AgoraTokenPort``
(CLAUDE.md §3.2) so the gating and lifecycle logic runs against in-memory fakes
without a database (§5).

Rules:
- Starting a session is gated to the **Pro club owner**. A non-owner is denied;
  an owner without an active Pro subscription gets ``PRO_REQUIRED``.
- One live session per club: starting again returns the existing active session
  (the host re-entering) rather than opening a second one.
- Ending a session is host-only and idempotent.
"""

from __future__ import annotations

from dataclasses import dataclass
from uuid import UUID

from app.core.exceptions import ConflictError, NotFoundError, PermissionDeniedError
from app.domains.video.models import VideoSession
from app.domains.video.ports import AgoraTokenPort, VideoSessionRepositoryPort
from app.domains.video.schemas import VideoSessionResponse, VideoSessionTokenResponse

# Hard ceiling for a club video call (mirrors the migration default).
_MAX_PARTICIPANTS = 10


@dataclass(slots=True)
class VideoSessionService:
    """Orchestrates club video-session start/end and join-token issuance."""

    repo: VideoSessionRepositoryPort
    token_provider: AgoraTokenPort

    async def start_session(self, *, club_id: UUID, host_id: UUID) -> VideoSessionTokenResponse:
        """Open (or re-join) the club's video call. Pro club owner only."""
        await self._require_pro_owner(club_id=club_id, user_id=host_id)

        session = await self.repo.get_active_session(club_id)
        if session is None:
            session = await self.repo.create_session(
                club_id=club_id,
                host_id=host_id,
                agora_channel=_channel_name(club_id),
                max_participants=_MAX_PARTICIPANTS,
            )

        token = self.token_provider.issue_token(
            club_id=club_id, session_id=session.id, channel=session.agora_channel
        )
        return _token_response(session, token)

    async def end_session(self, *, club_id: UUID, session_id: UUID, user_id: UUID) -> None:
        """End a live session. Only the host may end it."""
        session = await self.repo.get_session(session_id)
        if session is None or session.club_id != club_id:
            raise NotFoundError("video session not found", code="VIDEO_SESSION_NOT_FOUND")
        if session.host_id != user_id:
            raise PermissionDeniedError(
                "only the host can end the session", code="PERMISSION_DENIED"
            )
        await self.repo.end_session(session_id)

    async def get_active_session(self, *, club_id: UUID) -> VideoSessionResponse:
        """The club's live session, or 404 when none is active."""
        session = await self.repo.get_active_session(club_id)
        if session is None:
            raise NotFoundError("no active video session", code="NO_ACTIVE_VIDEO_SESSION")
        return _session_response(session)

    async def _require_pro_owner(self, *, club_id: UUID, user_id: UUID) -> None:
        owner_id = await self.repo.get_club_owner_id(club_id)
        if owner_id is None:
            raise NotFoundError("club not found", code="CLUB_NOT_FOUND")
        if owner_id != user_id:
            raise PermissionDeniedError(
                "only the club owner can host a video session", code="PERMISSION_DENIED"
            )
        if not await self.repo.get_user_is_pro(user_id):
            raise ConflictError("Pro subscription required", code="PRO_REQUIRED")


def _channel_name(club_id: UUID) -> str:
    """Deterministic per-club channel; fits the 64-char column."""
    return f"club-{club_id.hex}"


def _session_response(session: VideoSession) -> VideoSessionResponse:
    return VideoSessionResponse(
        id=session.id,
        club_id=session.club_id,
        host_id=session.host_id,
        agora_channel=session.agora_channel,
        started_at=session.started_at,
        ended_at=session.ended_at,
        max_participants=session.max_participants,
    )


def _token_response(session: VideoSession, token: str) -> VideoSessionTokenResponse:
    return VideoSessionTokenResponse(
        **_session_response(session).model_dump(),
        agora_token=token,
        channel=session.agora_channel,
    )

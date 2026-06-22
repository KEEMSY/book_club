"""Video domain ports — the only contracts ``service.py`` imports.

Per CLAUDE.md §3.2 these Protocols let ``VideoSessionService`` run against
in-memory fakes without a database, keeping the gating and lifecycle logic
unit-testable (§5).

Two boundaries are modelled:

- ``VideoSessionRepositoryPort`` — persistence for ``video_sessions`` plus the
  read-only club-owner / Pro-status lookups the Pro-club-owner gate needs.
- ``AgoraTokenPort`` — the external video-provider boundary. The MVP ships a
  stub adapter; a real Agora token builder is a drop-in replacement (§3.2).
"""

from __future__ import annotations

from typing import Protocol
from uuid import UUID

from app.domains.video.models import VideoSession


class VideoSessionRepositoryPort(Protocol):
    """Persistence for video sessions and the gate's club/user lookups."""

    async def get_club_owner_id(self, club_id: UUID) -> UUID | None: ...

    async def get_user_is_pro(self, user_id: UUID) -> bool: ...

    async def get_active_session(self, club_id: UUID) -> VideoSession | None: ...

    async def get_session(self, session_id: UUID) -> VideoSession | None: ...

    async def create_session(
        self, *, club_id: UUID, host_id: UUID, agora_channel: str, max_participants: int
    ) -> VideoSession: ...

    async def end_session(self, session_id: UUID) -> VideoSession | None: ...


class AgoraTokenPort(Protocol):
    """Issues a join token for a video channel (external provider boundary)."""

    def issue_token(self, *, club_id: UUID, session_id: UUID, channel: str) -> str: ...

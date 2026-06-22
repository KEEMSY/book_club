"""Pydantic v2 DTOs for the video router (M68).

The HTTP boundary types for the reading-club video-call MVP; the router never
leaks ORM models (CLAUDE.md §3.1).
"""

from __future__ import annotations

from datetime import datetime
from uuid import UUID

from pydantic import BaseModel


class VideoSessionResponse(BaseModel):
    """An active or ended video session."""

    id: UUID
    club_id: UUID
    host_id: UUID
    agora_channel: str
    started_at: datetime
    ended_at: datetime | None
    max_participants: int


class VideoSessionTokenResponse(VideoSessionResponse):
    """Session payload plus the credentials a client needs to join the call.

    ``channel`` mirrors ``agora_channel`` under the name the Agora client SDK
    expects; ``agora_token`` is the (stubbed) join token.
    """

    agora_token: str
    channel: str

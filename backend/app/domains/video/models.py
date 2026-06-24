"""SQLAlchemy ORM model for the video domain (M68).

``VideoSession`` backs the reading-club video-call MVP. A live call has
``ended_at IS NULL``; leaving/ending the call stamps it. Only one session per
club is expected to be live at a time — the service enforces that by reusing an
existing active session instead of opening a second one.
"""

from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy import ForeignKey, Index, Integer, String, Text, func
from sqlalchemy.dialects.postgresql import TIMESTAMP
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column

from app.core.db import Base


class VideoSession(Base):
    """A reading-club video call hosted by the Pro club owner."""

    __tablename__ = "video_sessions"
    __table_args__ = (Index("idx_video_sessions_club", "club_id"),)

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    club_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("reading_clubs.id", ondelete="CASCADE"),
        nullable=False,
    )
    host_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id"),
        nullable=False,
    )
    agora_channel: Mapped[str] = mapped_column(String(64), nullable=False)
    # The host's Agora RTC uid and the join token issued at session creation
    # (M71). Nullable so rows created before the migration backfill cleanly.
    agora_uid: Mapped[int | None] = mapped_column(Integer, nullable=True)
    agora_token: Mapped[str | None] = mapped_column(Text, nullable=True)
    started_at: Mapped[datetime] = mapped_column(
        TIMESTAMP(timezone=True), nullable=False, server_default=func.now()
    )
    # NULL while the call is live; stamped when the host ends it.
    ended_at: Mapped[datetime | None] = mapped_column(TIMESTAMP(timezone=True), nullable=True)
    max_participants: Mapped[int] = mapped_column(Integer, nullable=False, server_default="10")

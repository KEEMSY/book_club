"""SQLAlchemy async repository for the video domain (M68).

Owns the ``video_sessions`` table. The Pro-club-owner gate also needs the
club's owner and the caller's Pro flag; rather than reach into the club/auth
tables directly (CLAUDE.md §3.3), those two read-only lookups are delegated to
``ClubRepository`` so the club domain stays the single owner of its tables.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import UTC, datetime
from uuid import UUID

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.domains.club.repository import ClubRepository
from app.domains.video.models import VideoSession


@dataclass(slots=True)
class VideoSessionRepository:
    """All persistence for the video domain, plus delegated gate lookups."""

    session: AsyncSession

    @property
    def _clubs(self) -> ClubRepository:
        return ClubRepository(self.session)

    async def get_club_owner_id(self, club_id: UUID) -> UUID | None:
        club = await self._clubs.get_by_id(club_id)
        return club.owner_id if club is not None else None

    async def get_user_is_pro(self, user_id: UUID) -> bool:
        return await self._clubs.get_user_is_pro(user_id)

    async def get_active_session(self, club_id: UUID) -> VideoSession | None:
        """The club's live session (``ended_at IS NULL``), if any."""
        result = await self.session.execute(
            select(VideoSession)
            .where(VideoSession.club_id == club_id, VideoSession.ended_at.is_(None))
            .order_by(VideoSession.started_at.desc())
            .limit(1)
        )
        return result.scalar_one_or_none()

    async def get_session(self, session_id: UUID) -> VideoSession | None:
        return await self.session.get(VideoSession, session_id)

    async def create_session(
        self, *, club_id: UUID, host_id: UUID, agora_channel: str, max_participants: int
    ) -> VideoSession:
        session = VideoSession(
            club_id=club_id,
            host_id=host_id,
            agora_channel=agora_channel,
            max_participants=max_participants,
        )
        self.session.add(session)
        await self.session.flush()
        return session

    async def end_session(self, session_id: UUID) -> VideoSession | None:
        """Stamp ``ended_at`` (idempotent — keeps the first end time)."""
        session = await self.session.get(VideoSession, session_id)
        if session is None:
            return None
        if session.ended_at is None:
            session.ended_at = datetime.now(tz=UTC)
            await self.session.flush()
        return session

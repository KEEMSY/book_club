from __future__ import annotations

import secrets
from datetime import datetime
from uuid import UUID, uuid4

from sqlalchemy import delete, func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.domains.auth.models import User
from app.domains.club.models import (
    ClubEvent,
    ClubMember,
    ClubMessage,
    ClubRole,
    EventRSVP,
    MessageRead,
    ReadingClub,
)


class ClubRepository:
    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def create(
        self,
        *,
        owner_id: UUID,
        name: str,
        description: str | None,
        book_id: UUID | None,
        max_members: int,
    ) -> ReadingClub:
        club = ReadingClub(
            id=uuid4(),
            owner_id=owner_id,
            name=name,
            description=description,
            book_id=book_id,
            max_members=max_members,
            invite_code=secrets.token_urlsafe(6).upper()[:8],
            created_at=datetime.now(),
        )
        self._session.add(club)
        # Add creator as owner member.
        self._session.add(
            ClubMember(
                club_id=club.id,
                user_id=owner_id,
                role=ClubRole.OWNER,
                joined_at=datetime.now(),
            )
        )
        await self._session.flush()
        return club

    async def get_by_id(self, club_id: UUID) -> ReadingClub | None:
        return await self._session.get(ReadingClub, club_id)

    async def get_by_invite_code(self, code: str) -> ReadingClub | None:
        stmt = select(ReadingClub).where(ReadingClub.invite_code == code)
        row = await self._session.execute(stmt)
        return row.scalar_one_or_none()

    async def list_by_user(self, user_id: UUID) -> list[ReadingClub]:
        stmt = (
            select(ReadingClub)
            .join(ClubMember, ClubMember.club_id == ReadingClub.id)
            .where(ClubMember.user_id == user_id)
            .order_by(ReadingClub.created_at.desc())
        )
        rows = await self._session.execute(stmt)
        return list(rows.scalars().all())

    async def member_count(self, club_id: UUID) -> int:
        stmt = select(func.count()).select_from(ClubMember).where(ClubMember.club_id == club_id)
        return (await self._session.execute(stmt)).scalar_one()

    async def is_member(self, club_id: UUID, user_id: UUID) -> bool:
        stmt = select(ClubMember.club_id).where(
            ClubMember.club_id == club_id,
            ClubMember.user_id == user_id,
        )
        row = await self._session.execute(stmt)
        return row.scalar_one_or_none() is not None

    async def join(self, club_id: UUID, user_id: UUID) -> None:
        self._session.add(
            ClubMember(
                club_id=club_id,
                user_id=user_id,
                role=ClubRole.MEMBER,
                joined_at=datetime.now(),
            )
        )
        await self._session.flush()

    async def leave(self, club_id: UUID, user_id: UUID) -> None:
        stmt = delete(ClubMember).where(
            ClubMember.club_id == club_id,
            ClubMember.user_id == user_id,
        )
        await self._session.execute(stmt)

    # --- events ---

    async def create_event(
        self,
        *,
        club_id: UUID,
        created_by: UUID,
        title: str,
        description: str | None,
        event_type: str,
        location: str | None,
        scheduled_at: datetime,
    ) -> ClubEvent:
        event = ClubEvent(
            id=uuid4(),
            club_id=club_id,
            title=title,
            description=description,
            event_type=event_type,
            location=location,
            scheduled_at=scheduled_at,
            created_by=created_by,
            created_at=datetime.now(),
        )
        self._session.add(event)
        await self._session.flush()
        return event

    async def list_events(self, club_id: UUID) -> list[ClubEvent]:
        stmt = (
            select(ClubEvent)
            .where(ClubEvent.club_id == club_id)
            .order_by(ClubEvent.scheduled_at.asc())
        )
        rows = await self._session.execute(stmt)
        return list(rows.scalars().all())

    async def get_event(self, event_id: UUID) -> ClubEvent | None:
        return await self._session.get(ClubEvent, event_id)

    async def upsert_rsvp(self, *, event_id: UUID, user_id: UUID, status: str) -> EventRSVP:
        existing = await self._session.get(EventRSVP, (event_id, user_id))
        if existing:
            existing.status = status
            existing.responded_at = datetime.now()
            return existing
        rsvp = EventRSVP(
            event_id=event_id,
            user_id=user_id,
            status=status,
            responded_at=datetime.now(),
        )
        self._session.add(rsvp)
        await self._session.flush()
        return rsvp

    async def rsvp_counts(self, event_id: UUID) -> dict[str, int]:
        stmt = (
            select(EventRSVP.status, func.count().label("cnt"))
            .where(EventRSVP.event_id == event_id)
            .group_by(EventRSVP.status)
        )
        rows = await self._session.execute(stmt)
        return {r.status: r.cnt for r in rows}

    async def my_rsvp(self, event_id: UUID, user_id: UUID) -> str | None:
        rsvp = await self._session.get(EventRSVP, (event_id, user_id))
        return rsvp.status if rsvp else None

    # --- messages ---

    async def create_message(
        self,
        *,
        club_id: UUID,
        user_id: UUID,
        content: str,
        media_url: str | None,
    ) -> ClubMessage:
        msg = ClubMessage(
            id=uuid4(),
            club_id=club_id,
            user_id=user_id,
            content=content,
            media_url=media_url,
            created_at=datetime.now(),
        )
        self._session.add(msg)
        await self._session.flush()
        return msg

    async def list_messages(
        self,
        club_id: UUID,
        *,
        cursor: datetime | None,
        limit: int,
    ) -> list[tuple[ClubMessage, str, int]]:
        """Return (message, author_nickname, read_count) tuples, newest-first."""
        read_count_subq = (
            select(func.count())
            .select_from(MessageRead)
            .where(MessageRead.message_id == ClubMessage.id)
            .correlate(ClubMessage)
            .scalar_subquery()
        )
        stmt = (
            select(ClubMessage, User.nickname, read_count_subq.label("read_count"))
            .join(User, User.id == ClubMessage.user_id)
            .where(
                ClubMessage.club_id == club_id,
                ClubMessage.deleted_at.is_(None),
            )
            .order_by(ClubMessage.created_at.desc())
            .limit(limit)
        )
        if cursor is not None:
            stmt = stmt.where(ClubMessage.created_at < cursor)
        rows = await self._session.execute(stmt)
        return [(row.ClubMessage, row.nickname, row.read_count) for row in rows]

    async def get_message(self, message_id: UUID) -> ClubMessage | None:
        return await self._session.get(ClubMessage, message_id)

    async def upsert_message_read(self, *, message_id: UUID, user_id: UUID) -> None:
        existing = await self._session.get(MessageRead, (message_id, user_id))
        if existing:
            # Already marked as read; nothing to update — read_at is immutable.
            return
        self._session.add(
            MessageRead(
                message_id=message_id,
                user_id=user_id,
                read_at=datetime.now(),
            )
        )
        await self._session.flush()

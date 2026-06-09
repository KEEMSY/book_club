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
    ClubRoom,
    EventAttendee,
    MessageRead,
    ReadingClub,
)
from app.domains.club.schemas import AttendeeCount, AttendeePublic


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

    async def get_member_role(self, club_id: UUID, user_id: UUID) -> str | None:
        stmt = select(ClubMember.role).where(
            ClubMember.club_id == club_id,
            ClubMember.user_id == user_id,
        )
        row = await self._session.execute(stmt)
        return row.scalar_one_or_none()

    async def set_book(self, club_id: UUID, book_id: UUID | None) -> ReadingClub:
        from sqlalchemy import update

        stmt = (
            update(ReadingClub)
            .where(ReadingClub.id == club_id)
            .values(book_id=book_id)
            .returning(ReadingClub)
        )
        result = await self._session.execute(stmt)
        await self._session.commit()
        return result.scalar_one()

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
        event_at: datetime,
        location: str | None,
        max_attendees: int | None,
    ) -> ClubEvent:
        event = ClubEvent(
            id=uuid4(),
            club_id=club_id,
            title=title,
            description=description,
            event_at=event_at,
            location=location,
            max_attendees=max_attendees,
            created_by=created_by,
            created_at=datetime.now(),
        )
        self._session.add(event)
        await self._session.flush()
        return event

    async def get_events(self, club_id: UUID, *, upcoming_only: bool = True) -> list[ClubEvent]:
        stmt = select(ClubEvent).where(ClubEvent.club_id == club_id)
        if upcoming_only:
            stmt = stmt.where(ClubEvent.event_at >= datetime.now())
        stmt = stmt.order_by(ClubEvent.event_at.asc())
        rows = await self._session.execute(stmt)
        return list(rows.scalars().all())

    async def get_event(self, event_id: UUID) -> ClubEvent | None:
        return await self._session.get(ClubEvent, event_id)

    async def update_event(
        self,
        event_id: UUID,
        *,
        title: str | None = None,
        description: str | None = None,
        event_at: datetime | None = None,
        location: str | None = None,
        max_attendees: int | None = None,
    ) -> ClubEvent | None:
        event = await self._session.get(ClubEvent, event_id)
        if event is None:
            return None
        if title is not None:
            event.title = title
        if description is not None:
            event.description = description
        if event_at is not None:
            event.event_at = event_at
        if location is not None:
            event.location = location
        if max_attendees is not None:
            event.max_attendees = max_attendees
        await self._session.flush()
        return event

    async def delete_event(self, event_id: UUID) -> None:
        stmt = delete(ClubEvent).where(ClubEvent.id == event_id)
        await self._session.execute(stmt)

    async def upsert_rsvp(self, *, event_id: UUID, user_id: UUID, status: str) -> EventAttendee:
        existing = await self._session.get(EventAttendee, (event_id, user_id))
        if existing:
            existing.status = status
            existing.responded_at = datetime.now()
            await self._session.flush()
            return existing
        attendee = EventAttendee(
            event_id=event_id,
            user_id=user_id,
            status=status,
            responded_at=datetime.now(),
        )
        self._session.add(attendee)
        await self._session.flush()
        return attendee

    async def get_attendees(self, event_id: UUID) -> list[AttendeePublic]:
        stmt = (
            select(EventAttendee, User.nickname)
            .join(User, User.id == EventAttendee.user_id)
            .where(EventAttendee.event_id == event_id)
            .order_by(EventAttendee.responded_at.asc())
        )
        rows = await self._session.execute(stmt)
        return [
            AttendeePublic(
                user_id=row.EventAttendee.user_id,
                nickname=row.nickname,
                status=row.EventAttendee.status,
                responded_at=row.EventAttendee.responded_at,
            )
            for row in rows
        ]

    async def get_attendee_counts(self, event_id: UUID) -> AttendeeCount:
        stmt = (
            select(EventAttendee.status, func.count().label("cnt"))
            .where(EventAttendee.event_id == event_id)
            .group_by(EventAttendee.status)
        )
        rows = await self._session.execute(stmt)
        counts: dict[str, int] = {r.status: r.cnt for r in rows}
        return AttendeeCount(
            going=counts.get("going", 0),
            maybe=counts.get("maybe", 0),
            not_going=counts.get("not_going", 0),
        )

    async def get_my_rsvp_status(self, event_id: UUID, user_id: UUID) -> str | None:
        attendee = await self._session.get(EventAttendee, (event_id, user_id))
        return attendee.status if attendee else None

    # Kept for backward compatibility — callers still reference rsvp_counts / my_rsvp.
    async def rsvp_counts(self, event_id: UUID) -> dict[str, int]:
        counts = await self.get_attendee_counts(event_id)
        return {"going": counts.going, "maybe": counts.maybe, "not_going": counts.not_going}

    async def my_rsvp(self, event_id: UUID, user_id: UUID) -> str | None:
        return await self.get_my_rsvp_status(event_id, user_id)

    # --- messages ---

    async def create_message(
        self,
        *,
        club_id: UUID,
        user_id: UUID,
        content: str,
        media_url: str | None,
        room_id: UUID | None = None,
    ) -> ClubMessage:
        msg = ClubMessage(
            id=uuid4(),
            club_id=club_id,
            room_id=room_id,
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
        room_id: UUID | None = None,
    ) -> list[tuple[ClubMessage, str, int]]:
        """Return (message, author_nickname, read_count) tuples, newest-first.

        When *room_id* is provided only messages in that room are returned;
        otherwise only club-wide messages (room_id IS NULL) are returned.
        """
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
        if room_id is not None:
            stmt = stmt.where(ClubMessage.room_id == room_id)
        else:
            stmt = stmt.where(ClubMessage.room_id.is_(None))
        if cursor is not None:
            stmt = stmt.where(ClubMessage.created_at < cursor)
        rows = await self._session.execute(stmt)
        return [(row.ClubMessage, row.nickname, row.read_count) for row in rows]

    async def get_message(self, message_id: UUID) -> ClubMessage | None:
        return await self._session.get(ClubMessage, message_id)

    async def update_message_content(
        self, *, message_id: UUID, content: str, edited_at: datetime
    ) -> None:
        msg = await self._session.get(ClubMessage, message_id)
        if msg is None:
            return
        msg.content = content
        msg.edited_at = edited_at
        await self._session.flush()

    async def soft_delete_message(self, *, message_id: UUID, deleted_at: datetime) -> None:
        msg = await self._session.get(ClubMessage, message_id)
        if msg is None:
            return
        msg.deleted_at = deleted_at
        await self._session.flush()

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

    # --- club rooms ---

    async def create_room(
        self,
        *,
        club_id: UUID,
        name: str,
        progress_gate: int,
        created_by: UUID,
    ) -> ClubRoom:
        room = ClubRoom(
            id=uuid4(),
            club_id=club_id,
            name=name,
            progress_gate=progress_gate,
            created_by=created_by,
            created_at=datetime.now(),
        )
        self._session.add(room)
        await self._session.flush()
        return room

    async def get_rooms(self, club_id: UUID) -> list[ClubRoom]:
        stmt = (
            select(ClubRoom)
            .where(ClubRoom.club_id == club_id)
            .order_by(ClubRoom.progress_gate.asc(), ClubRoom.created_at.asc())
        )
        rows = await self._session.execute(stmt)
        return list(rows.scalars().all())

    async def get_room(self, room_id: UUID) -> ClubRoom | None:
        return await self._session.get(ClubRoom, room_id)

    async def delete_room(self, room_id: UUID) -> None:
        stmt = delete(ClubRoom).where(ClubRoom.id == room_id)
        await self._session.execute(stmt)

    async def get_user_chapter_for_club(self, user_id: UUID, club_id: UUID) -> int:
        """Return the caller's current_chapter for the club's book. Returns 0 if not found."""
        from app.domains.book.models import UserBook

        club = await self._session.get(ReadingClub, club_id)
        if club is None or club.book_id is None:
            return 0

        stmt = select(UserBook.current_chapter).where(
            UserBook.user_id == user_id,
            UserBook.book_id == club.book_id,
        )
        result = await self._session.execute(stmt)
        chapter: int | None = result.scalar_one_or_none()
        return chapter if chapter is not None else 0

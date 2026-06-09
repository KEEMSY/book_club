from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
from uuid import UUID

from app.core.exceptions import ConflictError, NotFoundError, PermissionDeniedError
from app.core.ws_manager import ws_manager
from app.domains.club.models import ClubRole, ReadingClub
from app.domains.club.repository import ClubRepository
from app.domains.club.schemas import (
    AttendeeCount,
    AttendeeListResponse,
    ClubEventCreate,
    ClubEventPublic,
    ClubEventUpdate,
    ClubMessagePublic,
    ClubRoomCreate,
    ClubRoomListResponse,
    ClubRoomPublic,
    CreateClubRequest,
    MessageListResponse,
)


@dataclass(slots=True)
class ClubService:
    repo: ClubRepository

    async def create_club(self, *, user_id: UUID, req: CreateClubRequest) -> ReadingClub:
        return await self.repo.create(
            owner_id=user_id,
            name=req.name,
            description=req.description,
            book_id=req.book_id,
            max_members=req.max_members,
        )

    async def get_club(self, club_id: UUID) -> ReadingClub:
        club = await self.repo.get_by_id(club_id)
        if not club:
            raise NotFoundError("club not found", code="CLUB_NOT_FOUND")
        return club

    async def list_my_clubs(self, user_id: UUID) -> list[ReadingClub]:
        return await self.repo.list_by_user(user_id)

    async def join_by_code(self, *, user_id: UUID, invite_code: str) -> ReadingClub:
        club = await self.repo.get_by_invite_code(invite_code.upper())
        if not club:
            raise NotFoundError("invalid invite code", code="CLUB_NOT_FOUND")
        count = await self.repo.member_count(club.id)
        if count >= club.max_members:
            raise ConflictError("club is full", code="CLUB_FULL")
        if not await self.repo.is_member(club.id, user_id):
            await self.repo.join(club.id, user_id)
        return club

    async def leave_club(self, *, user_id: UUID, club_id: UUID) -> None:
        club = await self.repo.get_by_id(club_id)
        if not club:
            raise NotFoundError("club not found", code="CLUB_NOT_FOUND")
        if club.owner_id == user_id:
            raise ConflictError(
                "owner cannot leave; delete the club instead",
                code="OWNER_CANNOT_LEAVE",
            )
        await self.repo.leave(club_id, user_id)

    async def _is_owner_or_manager(self, club_id: UUID, user_id: UUID) -> bool:
        """Return True when the user is the club owner or has manager role."""
        club = await self.repo.get_by_id(club_id)
        if not club:
            return False
        if club.owner_id == user_id:
            return True
        role = await self.repo.get_member_role(club_id, user_id)
        return role in (ClubRole.OWNER, "manager")

    async def create_event(
        self, *, user_id: UUID, club_id: UUID, data: ClubEventCreate
    ) -> ClubEventPublic:
        if not await self._is_owner_or_manager(club_id, user_id):
            raise PermissionDeniedError(
                "only owner or manager can create events", code="PERMISSION_DENIED"
            )
        event = await self.repo.create_event(
            club_id=club_id,
            created_by=user_id,
            title=data.title,
            description=data.description,
            event_at=data.event_at,
            location=data.location,
            max_attendees=data.max_attendees,
        )
        return ClubEventPublic(
            id=event.id,
            club_id=event.club_id,
            title=event.title,
            description=event.description,
            event_at=event.event_at,
            location=event.location,
            max_attendees=event.max_attendees,
            created_by=event.created_by,
            created_at=event.created_at,
            attendee_counts=AttendeeCount(going=0, maybe=0, not_going=0),
            my_status=None,
        )

    async def list_events(
        self, *, club_id: UUID, caller_user_id: UUID, upcoming_only: bool = True
    ) -> list[ClubEventPublic]:
        if not await self.repo.is_member(club_id, caller_user_id):
            raise PermissionDeniedError("not a member", code="NOT_MEMBER")
        events = await self.repo.get_events(club_id, upcoming_only=upcoming_only)
        result: list[ClubEventPublic] = []
        for event in events:
            counts = await self.repo.get_attendee_counts(event.id)
            my_status = await self.repo.get_my_rsvp_status(event.id, caller_user_id)
            result.append(
                ClubEventPublic(
                    id=event.id,
                    club_id=event.club_id,
                    title=event.title,
                    description=event.description,
                    event_at=event.event_at,
                    location=event.location,
                    max_attendees=event.max_attendees,
                    created_by=event.created_by,
                    created_at=event.created_at,
                    attendee_counts=counts,
                    my_status=my_status,
                )
            )
        return result

    async def get_event(self, *, event_id: UUID, caller_user_id: UUID) -> ClubEventPublic:
        event = await self.repo.get_event(event_id)
        if not event:
            raise NotFoundError("event not found", code="EVENT_NOT_FOUND")
        if not await self.repo.is_member(event.club_id, caller_user_id):
            raise PermissionDeniedError("not a member", code="NOT_MEMBER")
        counts = await self.repo.get_attendee_counts(event.id)
        my_status = await self.repo.get_my_rsvp_status(event.id, caller_user_id)
        return ClubEventPublic(
            id=event.id,
            club_id=event.club_id,
            title=event.title,
            description=event.description,
            event_at=event.event_at,
            location=event.location,
            max_attendees=event.max_attendees,
            created_by=event.created_by,
            created_at=event.created_at,
            attendee_counts=counts,
            my_status=my_status,
        )

    async def update_event(
        self, *, event_id: UUID, user_id: UUID, data: ClubEventUpdate
    ) -> ClubEventPublic:
        event = await self.repo.get_event(event_id)
        if not event:
            raise NotFoundError("event not found", code="EVENT_NOT_FOUND")
        if not await self._is_owner_or_manager(event.club_id, user_id):
            raise PermissionDeniedError(
                "only owner or manager can update events", code="PERMISSION_DENIED"
            )
        updated = await self.repo.update_event(
            event_id,
            title=data.title,
            description=data.description,
            event_at=data.event_at,
            location=data.location,
            max_attendees=data.max_attendees,
        )
        if not updated:
            raise NotFoundError("event not found", code="EVENT_NOT_FOUND")
        counts = await self.repo.get_attendee_counts(event_id)
        my_status = await self.repo.get_my_rsvp_status(event_id, user_id)
        return ClubEventPublic(
            id=updated.id,
            club_id=updated.club_id,
            title=updated.title,
            description=updated.description,
            event_at=updated.event_at,
            location=updated.location,
            max_attendees=updated.max_attendees,
            created_by=updated.created_by,
            created_at=updated.created_at,
            attendee_counts=counts,
            my_status=my_status,
        )

    async def delete_event(self, *, event_id: UUID, user_id: UUID) -> None:
        event = await self.repo.get_event(event_id)
        if not event:
            raise NotFoundError("event not found", code="EVENT_NOT_FOUND")
        if not await self._is_owner_or_manager(event.club_id, user_id):
            raise PermissionDeniedError(
                "only owner or manager can delete events", code="PERMISSION_DENIED"
            )
        await self.repo.delete_event(event_id)

    async def rsvp(self, *, user_id: UUID, event_id: UUID, status: str) -> None:
        event = await self.repo.get_event(event_id)
        if not event:
            raise NotFoundError("event not found", code="EVENT_NOT_FOUND")
        if not await self.repo.is_member(event.club_id, user_id):
            raise PermissionDeniedError("not a member", code="NOT_MEMBER")
        await self.repo.upsert_rsvp(event_id=event_id, user_id=user_id, status=status)

    async def get_attendees(self, *, event_id: UUID, caller_user_id: UUID) -> AttendeeListResponse:
        event = await self.repo.get_event(event_id)
        if not event:
            raise NotFoundError("event not found", code="EVENT_NOT_FOUND")
        if not await self.repo.is_member(event.club_id, caller_user_id):
            raise PermissionDeniedError("not a member", code="NOT_MEMBER")
        attendees = await self.repo.get_attendees(event_id)
        return AttendeeListResponse(items=attendees)

    # --- chat messages ---

    async def send_message(
        self,
        *,
        club_id: UUID,
        user_id: UUID,
        content: str,
        media_url: str | None,
    ) -> ClubMessagePublic:
        if not await self.repo.is_member(club_id, user_id):
            raise PermissionDeniedError("not a member", code="NOT_MEMBER")
        msg = await self.repo.create_message(
            club_id=club_id,
            user_id=user_id,
            content=content,
            media_url=media_url,
        )
        # Fetch author nickname via a single-row message list query.
        rows = await self.repo.list_messages(club_id, cursor=None, limit=1)
        author_nickname = rows[0][1] if rows else ""
        return ClubMessagePublic(
            id=msg.id,
            club_id=msg.club_id,
            user_id=msg.user_id,
            author_nickname=author_nickname,
            content=msg.content,
            media_url=msg.media_url,
            created_at=msg.created_at,
            read_count=0,
        )

    async def list_messages(
        self,
        *,
        club_id: UUID,
        user_id: UUID,
        cursor: datetime | None,
        limit: int = 50,
    ) -> MessageListResponse:
        if not await self.repo.is_member(club_id, user_id):
            raise PermissionDeniedError("not a member", code="NOT_MEMBER")
        # Fetch one extra row to detect whether a next page exists.
        rows = await self.repo.list_messages(club_id, cursor=cursor, limit=limit + 1)
        has_more = len(rows) > limit
        page = rows[:limit]
        items = [
            ClubMessagePublic(
                id=msg.id,
                club_id=msg.club_id,
                user_id=msg.user_id,
                author_nickname=nickname,
                content=msg.content,
                media_url=msg.media_url,
                created_at=msg.created_at,
                read_count=read_count,
            )
            for msg, nickname, read_count in page
        ]
        next_cursor = page[-1][0].created_at.isoformat() if has_more else None
        return MessageListResponse(items=items, next_cursor=next_cursor)

    async def mark_read(
        self,
        *,
        club_id: UUID,
        user_id: UUID,
        message_id: UUID,
    ) -> None:
        msg = await self.repo.get_message(message_id)
        if not msg:
            raise NotFoundError("message not found", code="MESSAGE_NOT_FOUND")
        if msg.club_id != club_id:
            raise NotFoundError("message not found", code="MESSAGE_NOT_FOUND")
        if not await self.repo.is_member(club_id, user_id):
            raise PermissionDeniedError("not a member", code="NOT_MEMBER")
        await self.repo.upsert_message_read(message_id=message_id, user_id=user_id)

    async def edit_message(
        self,
        *,
        club_id: UUID,
        user_id: UUID,
        message_id: UUID,
        content: str,
    ) -> None:
        msg = await self.repo.get_message(message_id)
        if not msg or msg.club_id != club_id or msg.deleted_at is not None:
            raise NotFoundError("message not found", code="MESSAGE_NOT_FOUND")
        if msg.user_id != user_id:
            raise PermissionDeniedError("not the message author", code="PERMISSION_DENIED")
        edited_at = datetime.now()
        await self.repo.update_message_content(
            message_id=message_id, content=content, edited_at=edited_at
        )
        await ws_manager.broadcast_club(
            club_id,
            {
                "type": "chat.message_edited",
                "club_id": str(club_id),
                "message_id": str(message_id),
                "content": content,
                "edited_at": edited_at.isoformat(),
            },
        )

    async def delete_message(
        self,
        *,
        club_id: UUID,
        user_id: UUID,
        message_id: UUID,
    ) -> None:
        msg = await self.repo.get_message(message_id)
        if not msg or msg.club_id != club_id or msg.deleted_at is not None:
            raise NotFoundError("message not found", code="MESSAGE_NOT_FOUND")
        if msg.user_id != user_id:
            raise PermissionDeniedError("not the message author", code="PERMISSION_DENIED")
        deleted_at = datetime.now()
        await self.repo.soft_delete_message(message_id=message_id, deleted_at=deleted_at)
        await ws_manager.broadcast_club(
            club_id,
            {
                "type": "chat.message_deleted",
                "club_id": str(club_id),
                "message_id": str(message_id),
                "deleted_at": deleted_at.isoformat(),
            },
        )

    # --- club rooms ---

    async def create_room(
        self,
        *,
        club_id: UUID,
        user_id: UUID,
        req: ClubRoomCreate,
    ) -> ClubRoomPublic:
        if not await self._is_owner_or_manager(club_id, user_id):
            raise PermissionDeniedError(
                "only owner or manager can create rooms", code="PERMISSION_DENIED"
            )
        room = await self.repo.create_room(
            club_id=club_id,
            name=req.name,
            progress_gate=req.progress_gate,
            created_by=user_id,
        )
        caller_chapter = await self.repo.get_user_chapter_for_club(user_id, club_id)
        return ClubRoomPublic(
            id=room.id,
            club_id=room.club_id,
            name=room.name,
            progress_gate=room.progress_gate,
            created_at=room.created_at,
            can_enter=caller_chapter >= room.progress_gate,
        )

    async def list_rooms(
        self,
        *,
        club_id: UUID,
        caller_user_id: UUID,
    ) -> ClubRoomListResponse:
        if not await self.repo.is_member(club_id, caller_user_id):
            raise PermissionDeniedError("not a member", code="NOT_MEMBER")
        rooms = await self.repo.get_rooms(club_id)
        caller_chapter = await self.repo.get_user_chapter_for_club(caller_user_id, club_id)
        return ClubRoomListResponse(
            rooms=[
                ClubRoomPublic(
                    id=room.id,
                    club_id=room.club_id,
                    name=room.name,
                    progress_gate=room.progress_gate,
                    created_at=room.created_at,
                    can_enter=caller_chapter >= room.progress_gate,
                )
                for room in rooms
            ]
        )

    async def delete_room(
        self,
        *,
        club_id: UUID,
        room_id: UUID,
        user_id: UUID,
    ) -> None:
        room = await self.repo.get_room(room_id)
        if not room or room.club_id != club_id:
            raise NotFoundError("room not found", code="ROOM_NOT_FOUND")
        if not await self._is_owner_or_manager(club_id, user_id):
            raise PermissionDeniedError(
                "only owner or manager can delete rooms", code="PERMISSION_DENIED"
            )
        await self.repo.delete_room(room_id)

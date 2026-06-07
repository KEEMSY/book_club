from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
from uuid import UUID

from app.core.exceptions import ConflictError, NotFoundError, PermissionDeniedError
from app.core.ws_manager import ws_manager
from app.domains.club.models import ClubEvent, ReadingClub
from app.domains.club.repository import ClubRepository
from app.domains.club.schemas import (
    ClubMessagePublic,
    CreateClubRequest,
    CreateEventRequest,
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

    async def create_event(
        self, *, user_id: UUID, club_id: UUID, req: CreateEventRequest
    ) -> ClubEvent:
        if not await self.repo.is_member(club_id, user_id):
            raise PermissionDeniedError("not a member", code="NOT_MEMBER")
        return await self.repo.create_event(
            club_id=club_id,
            created_by=user_id,
            title=req.title,
            description=req.description,
            event_type=req.event_type,
            location=req.location,
            scheduled_at=req.scheduled_at,
        )

    async def list_events(self, *, user_id: UUID, club_id: UUID) -> list[ClubEvent]:
        if not await self.repo.is_member(club_id, user_id):
            raise PermissionDeniedError("not a member", code="NOT_MEMBER")
        return await self.repo.list_events(club_id)

    async def rsvp(self, *, user_id: UUID, event_id: UUID, status: str) -> None:
        event = await self.repo.get_event(event_id)
        if not event:
            raise NotFoundError("event not found", code="EVENT_NOT_FOUND")
        if not await self.repo.is_member(event.club_id, user_id):
            raise PermissionDeniedError("not a member", code="NOT_MEMBER")
        await self.repo.upsert_rsvp(event_id=event_id, user_id=user_id, status=status)

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

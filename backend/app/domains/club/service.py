from __future__ import annotations

from dataclasses import dataclass
from uuid import UUID

from app.core.exceptions import ConflictError, NotFoundError, PermissionDeniedError
from app.domains.club.models import ClubEvent, ReadingClub
from app.domains.club.repository import ClubRepository
from app.domains.club.schemas import CreateClubRequest, CreateEventRequest


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

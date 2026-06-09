from __future__ import annotations

from datetime import datetime
from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, Query, status

from app.core.deps import get_current_user_id
from app.domains.club.models import ReadingClub
from app.domains.club.providers import get_club_service
from app.domains.club.repository import ClubRepository
from app.domains.club.schemas import (
    AttendeeListResponse,
    ClubEventCreate,
    ClubEventListResponse,
    ClubEventPublic,
    ClubEventUpdate,
    ClubListResponse,
    ClubMessagePublic,
    ClubPublic,
    ClubRoomCreate,
    ClubRoomListResponse,
    ClubRoomPublic,
    CreateClubRequest,
    EditMessageRequest,
    MessageListResponse,
    RsvpRequest,
    SendMessageRequest,
    SetClubBookRequest,
)
from app.domains.club.service import ClubService

router = APIRouter(prefix="/clubs", tags=["clubs"])


async def _to_public(club: ReadingClub, repo: ClubRepository) -> ClubPublic:
    count = await repo.member_count(club.id)
    return ClubPublic(
        id=club.id,
        name=club.name,
        description=club.description,
        owner_id=club.owner_id,
        book_id=club.book_id,
        book_title=None,
        invite_code=club.invite_code,
        max_members=club.max_members,
        member_count=count,
        created_at=club.created_at,
    )


@router.post("", response_model=ClubPublic, status_code=status.HTTP_201_CREATED)
async def create_club(
    body: CreateClubRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubPublic:
    club = await service.create_club(user_id=UUID(user_id), req=body)
    return await _to_public(club, service.repo)


@router.get("/me", response_model=ClubListResponse)
async def list_my_clubs(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubListResponse:
    clubs = await service.list_my_clubs(UUID(user_id))
    items = [await _to_public(c, service.repo) for c in clubs]
    return ClubListResponse(items=items)


@router.post("/join", response_model=ClubPublic, status_code=status.HTTP_200_OK)
async def join_club(
    body: dict[str, str],
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubPublic:
    invite_code = body.get("invite_code", "")
    club = await service.join_by_code(user_id=UUID(user_id), invite_code=str(invite_code))
    return await _to_public(club, service.repo)


@router.get("/{club_id}", response_model=ClubPublic)
async def get_club(
    club_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubPublic:
    club = await service.get_club(club_id)
    return await _to_public(club, service.repo)


@router.delete("/{club_id}/leave", status_code=status.HTTP_204_NO_CONTENT)
async def leave_club(
    club_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> None:
    await service.leave_club(user_id=UUID(user_id), club_id=club_id)


@router.post(
    "/{club_id}/events",
    response_model=ClubEventPublic,
    status_code=status.HTTP_201_CREATED,
)
async def create_event(
    club_id: UUID,
    body: ClubEventCreate,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubEventPublic:
    return await service.create_event(user_id=UUID(user_id), club_id=club_id, data=body)


@router.get("/{club_id}/events", response_model=ClubEventListResponse)
async def list_events(
    club_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
    upcoming_only: Annotated[bool, Query(description="Filter to future events only")] = True,
) -> ClubEventListResponse:
    items = await service.list_events(
        club_id=club_id, caller_user_id=UUID(user_id), upcoming_only=upcoming_only
    )
    return ClubEventListResponse(items=items)


@router.get("/{club_id}/events/{event_id}", response_model=ClubEventPublic)
async def get_event(
    club_id: UUID,
    event_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubEventPublic:
    return await service.get_event(event_id=event_id, caller_user_id=UUID(user_id))


@router.patch(
    "/{club_id}/events/{event_id}",
    response_model=ClubEventPublic,
)
async def update_event(
    club_id: UUID,
    event_id: UUID,
    body: ClubEventUpdate,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubEventPublic:
    return await service.update_event(event_id=event_id, user_id=UUID(user_id), data=body)


@router.delete(
    "/{club_id}/events/{event_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def delete_event(
    club_id: UUID,
    event_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> None:
    await service.delete_event(event_id=event_id, user_id=UUID(user_id))


@router.post(
    "/{club_id}/events/{event_id}/rsvp",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def rsvp_event(
    club_id: UUID,
    event_id: UUID,
    body: RsvpRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> None:
    await service.rsvp(user_id=UUID(user_id), event_id=event_id, status=body.status)


@router.get(
    "/{club_id}/events/{event_id}/attendees",
    response_model=AttendeeListResponse,
)
async def list_event_attendees(
    club_id: UUID,
    event_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> AttendeeListResponse:
    return await service.get_attendees(event_id=event_id, caller_user_id=UUID(user_id))


# --- chat messages ---


@router.post(
    "/{club_id}/messages",
    response_model=ClubMessagePublic,
    status_code=status.HTTP_201_CREATED,
)
async def send_message(
    club_id: UUID,
    body: SendMessageRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubMessagePublic:
    return await service.send_message(
        club_id=club_id,
        user_id=UUID(user_id),
        content=body.content,
        media_url=body.media_url,
    )


@router.get("/{club_id}/messages", response_model=MessageListResponse)
async def list_messages(
    club_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
    cursor: Annotated[
        datetime | None,
        Query(description="ISO-8601 created_at of the oldest item on the previous page"),
    ] = None,
    limit: Annotated[int, Query(ge=1, le=100)] = 50,
) -> MessageListResponse:
    return await service.list_messages(
        club_id=club_id,
        user_id=UUID(user_id),
        cursor=cursor,
        limit=limit,
    )


@router.post(
    "/{club_id}/messages/{message_id}/read",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def mark_message_read(
    club_id: UUID,
    message_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> None:
    await service.mark_read(
        club_id=club_id,
        user_id=UUID(user_id),
        message_id=message_id,
    )


@router.patch(
    "/{club_id}/messages/{message_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def edit_message(
    club_id: UUID,
    message_id: UUID,
    body: EditMessageRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> None:
    await service.edit_message(
        club_id=club_id,
        user_id=UUID(user_id),
        message_id=message_id,
        content=body.content,
    )


@router.delete(
    "/{club_id}/messages/{message_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def delete_message(
    club_id: UUID,
    message_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> None:
    await service.delete_message(
        club_id=club_id,
        user_id=UUID(user_id),
        message_id=message_id,
    )


# --- club rooms ---


@router.post(
    "/{club_id}/rooms",
    response_model=ClubRoomPublic,
    status_code=status.HTTP_201_CREATED,
)
async def create_room(
    club_id: UUID,
    body: ClubRoomCreate,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubRoomPublic:
    return await service.create_room(
        club_id=club_id,
        user_id=UUID(user_id),
        req=body,
    )


@router.get("/{club_id}/rooms", response_model=ClubRoomListResponse)
async def list_rooms(
    club_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubRoomListResponse:
    return await service.list_rooms(
        club_id=club_id,
        caller_user_id=UUID(user_id),
    )


@router.delete(
    "/{club_id}/rooms/{room_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def delete_room(
    club_id: UUID,
    room_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> None:
    await service.delete_room(
        club_id=club_id,
        room_id=room_id,
        user_id=UUID(user_id),
    )


@router.patch("/{club_id}/book", response_model=ClubPublic)
async def set_club_book(
    club_id: UUID,
    body: SetClubBookRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ClubService, Depends(get_club_service)],
) -> ClubPublic:
    club = await service.set_book(
        club_id=club_id,
        user_id=UUID(user_id),
        book_id=body.book_id,
    )
    return await _to_public(club, service.repo)

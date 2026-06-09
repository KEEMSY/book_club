from __future__ import annotations

from datetime import datetime
from uuid import UUID

from pydantic import BaseModel, Field


class CreateClubRequest(BaseModel):
    name: str = Field(min_length=1, max_length=100)
    description: str | None = Field(default=None, max_length=500)
    book_id: UUID | None = None
    max_members: int = Field(default=10, ge=2, le=50)


class ClubPublic(BaseModel):
    id: UUID
    name: str
    description: str | None
    owner_id: UUID
    book_id: UUID | None
    book_title: str | None = None
    invite_code: str
    max_members: int
    member_count: int
    created_at: datetime


class ClubEventCreate(BaseModel):
    title: str = Field(min_length=1, max_length=200)
    description: str | None = Field(default=None, max_length=1000)
    event_at: datetime
    location: str | None = Field(default=None, max_length=300)
    max_attendees: int | None = Field(default=None, ge=1, le=32767)


class ClubEventUpdate(BaseModel):
    title: str | None = Field(default=None, min_length=1, max_length=200)
    description: str | None = Field(default=None, max_length=1000)
    event_at: datetime | None = None
    location: str | None = Field(default=None, max_length=300)
    max_attendees: int | None = Field(default=None, ge=1, le=32767)


class AttendeeCount(BaseModel):
    going: int
    maybe: int
    not_going: int


class AttendeePublic(BaseModel):
    user_id: UUID
    nickname: str
    status: str
    responded_at: datetime


class ClubEventPublic(BaseModel):
    id: UUID
    club_id: UUID
    title: str
    description: str | None
    event_at: datetime
    location: str | None
    max_attendees: int | None
    created_by: UUID
    created_at: datetime
    attendee_counts: AttendeeCount
    my_status: str | None = None  # 'going' | 'maybe' | 'not_going' | None


class RsvpRequest(BaseModel):
    status: str = Field(pattern="^(going|maybe|not_going)$")


# Kept for backward compatibility — existing code references RSVPRequest.
RSVPRequest = RsvpRequest


# Kept for backward compatibility — CreateEventRequest was used in older service code.
class CreateEventRequest(BaseModel):
    title: str = Field(min_length=1, max_length=200)
    description: str | None = Field(default=None, max_length=1000)
    event_type: str = Field(pattern="^(online|offline)$")
    location: str | None = None
    scheduled_at: datetime


class ClubListResponse(BaseModel):
    items: list[ClubPublic]


class ClubEventListResponse(BaseModel):
    items: list[ClubEventPublic]


class AttendeeListResponse(BaseModel):
    items: list[AttendeePublic]


# --- chat messages ---


class ClubMessagePublic(BaseModel):
    id: UUID
    club_id: UUID
    user_id: UUID
    author_nickname: str
    content: str
    media_url: str | None
    created_at: datetime
    read_count: int


class SendMessageRequest(BaseModel):
    content: str = Field(min_length=1, max_length=2000)
    media_url: str | None = None


class EditMessageRequest(BaseModel):
    content: str = Field(min_length=1, max_length=2000)


class MessageListResponse(BaseModel):
    items: list[ClubMessagePublic]
    next_cursor: str | None = None


# --- club rooms ---


class ClubRoomCreate(BaseModel):
    name: str = Field(min_length=1, max_length=100)
    progress_gate: int = Field(default=0, ge=0, le=100)


class ClubRoomPublic(BaseModel):
    id: UUID
    club_id: UUID
    name: str
    progress_gate: int
    created_at: datetime
    # True when the caller's current_chapter meets or exceeds progress_gate.
    can_enter: bool


class ClubRoomListResponse(BaseModel):
    rooms: list[ClubRoomPublic]

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


class CreateEventRequest(BaseModel):
    title: str = Field(min_length=1, max_length=200)
    description: str | None = Field(default=None, max_length=1000)
    event_type: str = Field(pattern="^(online|offline)$")
    location: str | None = None
    scheduled_at: datetime


class ClubEventPublic(BaseModel):
    id: UUID
    club_id: UUID
    title: str
    description: str | None
    event_type: str
    location: str | None
    scheduled_at: datetime
    created_by: UUID
    created_at: datetime
    going_count: int = 0
    maybe_count: int = 0
    my_rsvp: str | None = None  # 'going' | 'maybe' | 'not_going' | None


class RSVPRequest(BaseModel):
    status: str = Field(pattern="^(going|maybe|not_going)$")


class ClubListResponse(BaseModel):
    items: list[ClubPublic]


class ClubEventListResponse(BaseModel):
    items: list[ClubEventPublic]


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


class MessageListResponse(BaseModel):
    items: list[ClubMessagePublic]
    next_cursor: str | None = None

from __future__ import annotations

from datetime import date, datetime
from uuid import UUID

from pydantic import BaseModel, Field


class CreateClubRequest(BaseModel):
    name: str = Field(min_length=1, max_length=100)
    description: str | None = Field(default=None, max_length=500)
    book_id: UUID | None = None
    max_members: int = Field(default=10, ge=2, le=50)
    is_public: bool = False
    category: str | None = Field(default=None, max_length=32)
    tags: list[str] = Field(default_factory=list)


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
    is_public: bool
    category: str | None = None
    tags: list[str] = Field(default_factory=list)
    created_at: datetime


class SetClubBookRequest(BaseModel):
    book_id: UUID | None


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


class PublicClubListResponse(BaseModel):
    items: list[ClubPublic]
    next_cursor: str | None = None


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


# --- reading plans (M52) ---


class CreateReadingPlanRequest(BaseModel):
    book_id: UUID
    start_date: date
    end_date: date


class ReadingPlanResponse(BaseModel):
    id: UUID
    club_id: UUID
    book_id: UUID
    start_date: date
    end_date: date
    weekly_pages: int
    created_at: datetime


class UpdateProgressRequest(BaseModel):
    current_page: int = Field(ge=0)


class MemberProgressItem(BaseModel):
    user_id: UUID
    nickname: str
    current_page: int
    last_page_updated_at: datetime | None
    progress_pct: float


class ClubProgressResponse(BaseModel):
    plan: ReadingPlanResponse | None
    members: list[MemberProgressItem]


# --- sessions (BC-44) ---


class ClubSessionCreate(BaseModel):
    book_id: UUID
    title: str = Field(min_length=1, max_length=200)
    scope: str | None = Field(default=None, max_length=2000)
    presenter_id: UUID | None = None
    scheduled_at: datetime | None = None


class ClubSessionPublic(BaseModel):
    id: UUID
    club_id: UUID
    book_id: UUID
    title: str
    scope: str | None
    presenter_id: UUID | None
    scheduled_at: datetime | None
    status: str
    created_by: UUID
    created_at: datetime


class ClubSessionListResponse(BaseModel):
    items: list[ClubSessionPublic]


class SetSessionPresenterRequest(BaseModel):
    presenter_id: UUID | None = None


class UpdateSessionStatusRequest(BaseModel):
    status: str = Field(pattern="^(draft|open|closed)$")


# --- agendas & topics (BC-45) ---


class SessionAgendaCreate(BaseModel):
    body: str = Field(min_length=1, max_length=10000)


class SessionAgendaUpdate(BaseModel):
    body: str = Field(min_length=1, max_length=10000)


class AgendaTopicPublic(BaseModel):
    id: UUID
    agenda_id: UUID
    position: int
    prompt: str
    created_at: datetime


class SessionAgendaPublic(BaseModel):
    id: UUID
    session_id: UUID
    author_id: UUID
    body: str
    status: str
    published_at: datetime | None
    created_at: datetime
    topics: list[AgendaTopicPublic] = Field(default_factory=list)


class SessionAgendaListResponse(BaseModel):
    items: list[SessionAgendaPublic]


class AgendaTopicCreate(BaseModel):
    prompt: str = Field(min_length=1, max_length=2000)


class AgendaTopicUpdate(BaseModel):
    prompt: str = Field(min_length=1, max_length=2000)


class AgendaTopicListResponse(BaseModel):
    items: list[AgendaTopicPublic]


class ReorderTopicsRequest(BaseModel):
    topic_ids: list[UUID] = Field(min_length=1)


# --- topic comments (BC-46) ---


class TopicCommentCreate(BaseModel):
    body: str = Field(min_length=1, max_length=2000)
    # Set to reply to an existing top-level comment. Replying to a reply is
    # rejected by the service layer — single-level threads only (design §2).
    parent_comment_id: UUID | None = None


class TopicCommentUpdate(BaseModel):
    body: str = Field(min_length=1, max_length=2000)


class TopicCommentPublic(BaseModel):
    id: UUID
    topic_id: UUID
    author_id: UUID
    parent_comment_id: UUID | None
    body: str
    created_at: datetime
    edited_at: datetime | None


class TopicCommentThreadPublic(BaseModel):
    """A top-level reply plus its single-level sub-replies (design §2 비목표)."""

    id: UUID
    topic_id: UUID
    author_id: UUID
    body: str
    created_at: datetime
    edited_at: datetime | None
    replies: list[TopicCommentPublic] = Field(default_factory=list)


class TopicCommentThreadListResponse(BaseModel):
    items: list[TopicCommentThreadPublic]

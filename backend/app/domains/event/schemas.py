"""Pydantic v2 DTOs for the event router (M64).

The only types the mobile client sees at the HTTP boundary; the router never
leaks ORM models (CLAUDE.md §3.1).
"""

from __future__ import annotations

from datetime import datetime
from uuid import UUID

from pydantic import BaseModel, Field


class EventCreateRequest(BaseModel):
    """Body for POST /events — create a 번개 모임 (club optional)."""

    title: str = Field(min_length=1, max_length=200)
    description: str | None = Field(default=None)
    address: str | None = Field(default=None)
    lat: float | None = Field(default=None, ge=-90.0, le=90.0)
    lng: float | None = Field(default=None, ge=-180.0, le=180.0)
    category: str | None = Field(default=None, max_length=32)
    event_at: datetime
    max_attendees: int | None = Field(default=None, ge=1)
    is_public: bool = True
    club_id: UUID | None = None
    book_id: UUID | None = None


class EventResponse(BaseModel):
    """An event as returned by create and nearby search.

    ``distance_km`` is populated only by proximity search; it is ``None`` when
    the event is returned outside a location query (e.g. right after creation).
    """

    id: UUID
    title: str
    description: str | None
    address: str | None
    lat: float | None
    lng: float | None
    event_at: datetime
    max_attendees: int | None
    is_public: bool
    club_id: UUID | None
    book_id: UUID | None
    category: str | None
    joined_count: int
    distance_km: float | None = None
    created_at: datetime


class NearbyEventsResponse(BaseModel):
    """Page of events within the requested radius, nearest first."""

    items: list[EventResponse]
    page: int
    has_more: bool


class WaitlistStatusResponse(BaseModel):
    """Caller's standing after joining an event's list."""

    event_id: UUID
    # 1-based position in the join queue (ordered by queued_at).
    position: int
    # True when the position is within ``max_attendees`` (a confirmed seat);
    # False when the caller is queued behind a full event.
    confirmed: bool


class EventReviewRequest(BaseModel):
    """Body for POST /events/{id}/reviews."""

    rating: float = Field(ge=0.5, le=5.0)
    body: str | None = Field(default=None)


class EventReviewResponse(BaseModel):
    """A persisted post-meetup review."""

    id: UUID
    event_id: UUID
    reviewer_id: UUID
    rating: float
    body: str | None
    created_at: datetime


class EventReviewsResponse(BaseModel):
    """All reviews for an event plus the aggregate rating."""

    items: list[EventReviewResponse]
    average_rating: float | None
    count: int

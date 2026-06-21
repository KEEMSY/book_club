"""HTTP surface for the event domain (M64).

Thin DTO → service → DTO adapters per CLAUDE.md §3.1. The router never catches
domain exceptions; the global handler maps them to HTTP responses.

Endpoints:
  * GET    /events/nearby            — proximity search (public events)
  * POST   /events                   — create a 번개 모임
  * POST   /events/{id}/waitlist     — join (confirmed or queued)
  * DELETE /events/{id}/waitlist     — leave
  * POST   /events/{id}/reviews      — leave a post-meetup review
  * GET    /events/{id}/reviews      — list reviews + average rating
"""

from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, Query, Response

from app.core.deps import get_current_user_id
from app.domains.event.providers import get_event_service
from app.domains.event.schemas import (
    EventCreateRequest,
    EventResponse,
    EventReviewRequest,
    EventReviewResponse,
    EventReviewsResponse,
    NearbyEventsResponse,
    WaitlistStatusResponse,
)
from app.domains.event.service import EventService

router = APIRouter(prefix="/events", tags=["event"])


@router.get("/nearby", response_model=NearbyEventsResponse)
async def get_nearby_events(
    service: Annotated[EventService, Depends(get_event_service)],
    _: Annotated[str, Depends(get_current_user_id)],
    lat: Annotated[float, Query(ge=-90.0, le=90.0)],
    lng: Annotated[float, Query(ge=-180.0, le=180.0)],
    radius_km: Annotated[float, Query(gt=0.0, le=100.0)] = 5.0,
    page: Annotated[int, Query(ge=1)] = 1,
    category: str | None = None,
) -> NearbyEventsResponse:
    """Public events within ``radius_km`` of the origin, nearest first."""
    return await service.get_nearby_events(
        lat=lat,
        lng=lng,
        radius_km=radius_km,
        page=page,
        category=category,
    )


@router.post("/", response_model=EventResponse)
async def create_event(
    body: EventCreateRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[EventService, Depends(get_event_service)],
) -> EventResponse:
    """Create a location-based meetup (club optional)."""
    return await service.create_event(
        creator_id=UUID(user_id),
        title=body.title,
        description=body.description,
        address=body.address,
        lat=body.lat,
        lng=body.lng,
        category=body.category,
        event_at=body.event_at,
        max_attendees=body.max_attendees,
        is_public=body.is_public,
        club_id=body.club_id,
        book_id=body.book_id,
    )


@router.post("/{event_id}/waitlist", response_model=WaitlistStatusResponse)
async def join_waitlist(
    event_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[EventService, Depends(get_event_service)],
) -> WaitlistStatusResponse:
    """Join an event; returns a confirmed seat or a queued position."""
    return await service.join_waitlist(user_id=UUID(user_id), event_id=event_id)


@router.delete("/{event_id}/waitlist", status_code=204)
async def leave_waitlist(
    event_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[EventService, Depends(get_event_service)],
) -> Response:
    """Leave an event's list."""
    await service.leave_waitlist(user_id=UUID(user_id), event_id=event_id)
    return Response(status_code=204)


@router.post("/{event_id}/reviews", response_model=EventReviewResponse)
async def create_review(
    event_id: UUID,
    body: EventReviewRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[EventService, Depends(get_event_service)],
) -> EventReviewResponse:
    """Leave a post-meetup review (one per user per event)."""
    return await service.create_review(
        reviewer_id=UUID(user_id),
        event_id=event_id,
        rating=body.rating,
        body=body.body,
    )


@router.get("/{event_id}/reviews", response_model=EventReviewsResponse)
async def list_reviews(
    event_id: UUID,
    _: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[EventService, Depends(get_event_service)],
) -> EventReviewsResponse:
    """All reviews for an event plus the average rating."""
    return await service.get_reviews(event_id)

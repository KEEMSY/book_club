"""Event domain service — location-based offline meetups (M64).

Depends only on ``EventRepositoryPort`` (CLAUDE.md §3.2) so the proximity and
capacity logic runs against in-memory fakes in unit tests (§5).

Design choices:
- Proximity is computed with an application-level Haversine, not a PostGIS /
  ``earth_distance`` query, so it stays portable across Fly.io's default
  Postgres and unit-testable without a database. The repository narrows the
  candidate set with a cheap lat/lng bounding box first.
- ``event_waitlist`` is both the attendance list and the overflow queue: a
  joiner whose 1-based position exceeds ``max_attendees`` is queued
  (``confirmed = False``); a NULL ``max_attendees`` means unlimited capacity.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import UTC, datetime
from decimal import Decimal
from math import asin, cos, radians, sin, sqrt
from uuid import UUID

from app.core.exceptions import ConflictError, NotFoundError, PermissionDeniedError
from app.domains.event.models import Event, EventReview
from app.domains.event.ports import EventRepositoryPort
from app.domains.event.schemas import (
    EventDetailResponse,
    EventResponse,
    EventReviewResponse,
    EventReviewsResponse,
    NearbyEventsResponse,
    WaitlistStatusResponse,
)

# Page size for proximity search.
PAGE_SIZE = 20

# Mean Earth radius (km) — WGS-84 authalic radius.
_EARTH_RADIUS_KM = 6371.0088

# Degrees of latitude per km (≈ constant). Longitude is scaled by cos(lat).
_KM_PER_DEG_LAT = 111.0


def haversine_km(lat1: float, lng1: float, lat2: float, lng2: float) -> float:
    """Great-circle distance in kilometres between two coordinates."""
    d_lat = radians(lat2 - lat1)
    d_lng = radians(lng2 - lng1)
    a = sin(d_lat / 2) ** 2 + cos(radians(lat1)) * cos(radians(lat2)) * sin(d_lng / 2) ** 2
    return 2 * _EARTH_RADIUS_KM * asin(sqrt(a))


@dataclass(slots=True)
class EventService:
    """Orchestrates meetup discovery, creation, join/waitlist, and reviews."""

    repo: EventRepositoryPort

    async def get_nearby_events(
        self,
        *,
        lat: float,
        lng: float,
        radius_km: float,
        page: int = 1,
        category: str | None = None,
        after: datetime | None = None,
    ) -> NearbyEventsResponse:
        """Public events within ``radius_km`` of (lat, lng), nearest first."""
        if page < 1:
            page = 1

        # Bounding box around the origin to prefilter candidates cheaply.
        d_lat = radius_km / _KM_PER_DEG_LAT
        # Guard against the cos→0 singularity near the poles.
        d_lng = radius_km / (_KM_PER_DEG_LAT * max(cos(radians(lat)), 0.01))

        candidates = await self.repo.list_candidates_in_bbox(
            min_lat=lat - d_lat,
            max_lat=lat + d_lat,
            min_lng=lng - d_lng,
            max_lng=lng + d_lng,
            category=category,
            after=after,
        )

        within: list[tuple[float, EventResponse]] = []
        for cand in candidates:
            ev = cand.event
            # Box candidates always have coordinates, but stay defensive.
            if ev.lat is None or ev.lng is None:
                continue
            distance = haversine_km(lat, lng, ev.lat, ev.lng)
            if distance <= radius_km:
                within.append(
                    (
                        distance,
                        _to_response(ev, joined_count=cand.joined_count, distance_km=distance),
                    )
                )

        within.sort(key=lambda pair: pair[0])

        offset = (page - 1) * PAGE_SIZE
        page_items = [resp for _, resp in within[offset : offset + PAGE_SIZE]]
        has_more = len(within) > offset + PAGE_SIZE
        return NearbyEventsResponse(items=page_items, page=page, has_more=has_more)

    async def create_event(
        self,
        *,
        creator_id: UUID,
        title: str,
        description: str | None,
        address: str | None,
        lat: float | None,
        lng: float | None,
        category: str | None,
        event_at: datetime,
        max_attendees: int | None,
        is_public: bool,
        club_id: UUID | None,
        book_id: UUID | None,
    ) -> EventResponse:
        """Create a 번개 모임 (``club_id`` optional)."""
        event = await self.repo.create_event(
            creator_id=creator_id,
            club_id=club_id,
            book_id=book_id,
            title=title,
            description=description,
            address=address,
            lat=lat,
            lng=lng,
            category=category,
            event_at=event_at,
            max_attendees=max_attendees,
            is_public=is_public,
        )
        return _to_response(event, joined_count=0, distance_km=None)

    async def cancel_event(self, *, user_id: UUID, event_id: UUID) -> None:
        """Soft-delete an event. Only its creator may cancel it."""
        event = await self._require_event(event_id)
        if event.creator_id != user_id:
            raise PermissionDeniedError(
                "only the creator can cancel this event", code="PERMISSION_DENIED"
            )
        await self.repo.soft_delete_event(event_id)

    async def join_waitlist(self, *, user_id: UUID, event_id: UUID) -> WaitlistStatusResponse:
        """Join an event; confirmed if within capacity, else queued."""
        event = await self._require_event(event_id)
        if await self.repo.is_on_waitlist(event_id, user_id):
            raise ConflictError("already joined this event", code="ALREADY_JOINED")

        await self.repo.add_to_waitlist(event_id, user_id)
        position = await self.repo.joined_count(event_id)
        confirmed = event.max_attendees is None or position <= event.max_attendees
        return WaitlistStatusResponse(event_id=event_id, position=position, confirmed=confirmed)

    async def leave_waitlist(self, *, user_id: UUID, event_id: UUID) -> None:
        """Leave an event's list; 404 if the caller was not on it."""
        await self._require_event(event_id)
        removed = await self.repo.remove_from_waitlist(event_id, user_id)
        if not removed:
            raise NotFoundError("not on this event's list", code="NOT_ON_WAITLIST")

    async def create_review(
        self,
        *,
        reviewer_id: UUID,
        event_id: UUID,
        rating: float,
        body: str | None,
    ) -> EventReviewResponse:
        """Leave a post-meetup review; one per (event, reviewer)."""
        event = await self._require_event(event_id)
        if event.event_at >= datetime.now(tz=UTC):
            raise ConflictError("event has not happened yet", code="REVIEW_TOO_EARLY")
        if await self.repo.has_review(event_id, reviewer_id):
            raise ConflictError("already reviewed this event", code="ALREADY_REVIEWED")

        review = await self.repo.create_review(
            event_id=event_id,
            reviewer_id=reviewer_id,
            rating=Decimal(str(rating)),
            body=body,
        )
        return _review_response(review)

    async def get_reviews(self, event_id: UUID) -> EventReviewsResponse:
        """All reviews for an event plus the average rating."""
        await self._require_event(event_id)
        return await self._reviews_summary(event_id)

    async def get_event_detail(self, event_id: UUID) -> EventDetailResponse:
        """Full event with its join count and review summary (M68 detail)."""
        event = await self._require_event(event_id)
        joined = await self.repo.joined_count(event_id)
        reviews = await self._reviews_summary(event_id)
        return EventDetailResponse(
            event=_to_response(event, joined_count=joined, distance_km=None),
            reviews=reviews,
        )

    async def _reviews_summary(self, event_id: UUID) -> EventReviewsResponse:
        reviews = await self.repo.list_reviews(event_id)
        items = [_review_response(r) for r in reviews]
        average = round(sum(i.rating for i in items) / len(items), 1) if items else None
        return EventReviewsResponse(items=items, average_rating=average, count=len(items))

    async def _require_event(self, event_id: UUID) -> Event:
        event = await self.repo.get_event(event_id)
        if event is None:
            raise NotFoundError("event not found", code="EVENT_NOT_FOUND")
        return event


def _to_response(event: Event, *, joined_count: int, distance_km: float | None) -> EventResponse:
    """Map an event entity to its DTO, rounding distance to 0.1 km."""
    return EventResponse(
        id=event.id,
        creator_id=event.creator_id,
        title=event.title,
        description=event.description,
        address=event.address,
        lat=event.lat,
        lng=event.lng,
        event_at=event.event_at,
        max_attendees=event.max_attendees,
        is_public=event.is_public,
        club_id=event.club_id,
        book_id=event.book_id,
        category=event.category,
        joined_count=joined_count,
        distance_km=round(distance_km, 1) if distance_km is not None else None,
        created_at=event.created_at,
    )


def _review_response(review: EventReview) -> EventReviewResponse:
    return EventReviewResponse(
        id=review.id,
        event_id=review.event_id,
        reviewer_id=review.reviewer_id,
        rating=float(review.rating),
        body=review.body,
        created_at=review.created_at,
    )

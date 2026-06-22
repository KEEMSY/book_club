"""Event domain port — the only persistence contract ``service.py`` imports.

Per CLAUDE.md §3.2 this Protocol lets ``EventService`` run against in-memory
fakes without a database, so the proximity and capacity logic stays unit-
testable (§5).
"""

from __future__ import annotations

from datetime import datetime
from decimal import Decimal
from typing import Protocol
from uuid import UUID

from app.domains.event.models import Event, EventReview
from app.domains.event.repository import EventWithCount


class EventRepositoryPort(Protocol):
    """Persistence operations for events, waitlist, and reviews."""

    async def create_event(
        self,
        *,
        creator_id: UUID,
        club_id: UUID | None,
        book_id: UUID | None,
        title: str,
        description: str | None,
        address: str | None,
        lat: float | None,
        lng: float | None,
        category: str | None,
        event_at: datetime,
        max_attendees: int | None,
        is_public: bool,
    ) -> Event: ...

    async def get_event(self, event_id: UUID) -> Event | None: ...

    async def soft_delete_event(self, event_id: UUID) -> None: ...

    async def list_candidates_in_bbox(
        self,
        *,
        min_lat: float,
        max_lat: float,
        min_lng: float,
        max_lng: float,
        category: str | None = None,
        after: datetime | None = None,
    ) -> list[EventWithCount]: ...

    async def joined_count(self, event_id: UUID) -> int: ...

    async def is_on_waitlist(self, event_id: UUID, user_id: UUID) -> bool: ...

    async def add_to_waitlist(self, event_id: UUID, user_id: UUID) -> None: ...

    async def remove_from_waitlist(self, event_id: UUID, user_id: UUID) -> bool: ...

    async def has_review(self, event_id: UUID, reviewer_id: UUID) -> bool: ...

    async def create_review(
        self,
        *,
        event_id: UUID,
        reviewer_id: UUID,
        rating: Decimal,
        body: str | None,
    ) -> EventReview: ...

    async def list_reviews(self, event_id: UUID) -> list[EventReview]: ...

"""SQLAlchemy async repository for the event domain (M64).

Owns the ``events`` / ``event_waitlist`` / ``event_reviews`` tables only. All
proximity maths and capacity rules live in the service; this layer just runs a
cheap lat/lng bounding-box prefilter and counts (CLAUDE.md §3.1/§3.3). It never
reaches into the club/community domains' tables.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
from decimal import Decimal
from uuid import UUID

from sqlalchemy import delete, func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.domains.event.models import Event, EventReview, EventWaitlist


@dataclass(slots=True)
class EventWithCount:
    """An event paired with how many users have joined it."""

    event: Event
    joined_count: int


@dataclass(slots=True)
class EventRepository:
    """All persistence for the event domain."""

    session: AsyncSession

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
    ) -> Event:
        """Insert one event row and return the persisted entity."""
        event = Event(
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
        self.session.add(event)
        await self.session.flush()
        return event

    async def get_event(self, event_id: UUID) -> Event | None:
        """Return a live (non-deleted) event, or ``None``."""
        result = await self.session.execute(
            select(Event).where(Event.id == event_id, Event.deleted_at.is_(None))
        )
        return result.scalar_one_or_none()

    async def list_candidates_in_bbox(
        self,
        *,
        min_lat: float,
        max_lat: float,
        min_lng: float,
        max_lng: float,
        category: str | None = None,
        after: datetime | None = None,
    ) -> list[EventWithCount]:
        """Live, public, geocoded events inside the bounding box, with counts.

        A coarse box prefilter keeps the precise Haversine pass (in the service)
        bounded to a small candidate set. ``category``/``after`` apply optional
        genre and date filters.
        """
        joined = (
            select(EventWaitlist.event_id, func.count().label("joined_count"))
            .group_by(EventWaitlist.event_id)
            .subquery()
        )
        stmt = (
            select(Event, func.coalesce(joined.c.joined_count, 0))
            .outerjoin(joined, joined.c.event_id == Event.id)
            .where(
                Event.deleted_at.is_(None),
                Event.is_public.is_(True),
                Event.lat.is_not(None),
                Event.lng.is_not(None),
                Event.lat >= min_lat,
                Event.lat <= max_lat,
                Event.lng >= min_lng,
                Event.lng <= max_lng,
            )
        )
        if category is not None:
            stmt = stmt.where(Event.category == category)
        if after is not None:
            stmt = stmt.where(Event.event_at >= after)

        result = await self.session.execute(stmt)
        return [EventWithCount(event=row[0], joined_count=row[1]) for row in result.all()]

    async def joined_count(self, event_id: UUID) -> int:
        """How many users have joined the event."""
        result = await self.session.execute(
            select(func.count())
            .select_from(EventWaitlist)
            .where(EventWaitlist.event_id == event_id)
        )
        return int(result.scalar_one())

    async def is_on_waitlist(self, event_id: UUID, user_id: UUID) -> bool:
        """Whether the user already joined the event's list."""
        result = await self.session.execute(
            select(EventWaitlist.id).where(
                EventWaitlist.event_id == event_id,
                EventWaitlist.user_id == user_id,
            )
        )
        return result.first() is not None

    async def add_to_waitlist(self, event_id: UUID, user_id: UUID) -> None:
        """Append the user to the event's join queue."""
        self.session.add(EventWaitlist(event_id=event_id, user_id=user_id))
        await self.session.flush()

    async def remove_from_waitlist(self, event_id: UUID, user_id: UUID) -> bool:
        """Remove the user from the queue; return whether a row was deleted.

        SELECT-then-DELETE so the boolean is reliable on async drivers where
        ``Result.rowcount`` is unspecified (same approach as feed/curation).
        """
        existing = await self.session.execute(
            select(EventWaitlist.id).where(
                EventWaitlist.event_id == event_id,
                EventWaitlist.user_id == user_id,
            )
        )
        if existing.first() is None:
            return False
        await self.session.execute(
            delete(EventWaitlist).where(
                EventWaitlist.event_id == event_id,
                EventWaitlist.user_id == user_id,
            )
        )
        return True

    async def has_review(self, event_id: UUID, reviewer_id: UUID) -> bool:
        """Whether the user has already reviewed the event."""
        result = await self.session.execute(
            select(EventReview.id).where(
                EventReview.event_id == event_id,
                EventReview.reviewer_id == reviewer_id,
            )
        )
        return result.first() is not None

    async def create_review(
        self,
        *,
        event_id: UUID,
        reviewer_id: UUID,
        rating: Decimal,
        body: str | None,
    ) -> EventReview:
        """Insert one review row and return the persisted entity."""
        review = EventReview(
            event_id=event_id,
            reviewer_id=reviewer_id,
            rating=rating,
            body=body,
        )
        self.session.add(review)
        await self.session.flush()
        return review

    async def list_reviews(self, event_id: UUID) -> list[EventReview]:
        """All reviews for an event, newest first."""
        result = await self.session.execute(
            select(EventReview)
            .where(EventReview.event_id == event_id)
            .order_by(EventReview.created_at.desc())
        )
        return list(result.scalars().all())

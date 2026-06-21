"""SQLAlchemy ORM models for the event domain (M64).

These back location-based offline meetups (번개 모임) that may exist without a
reading club. They are deliberately separate from the club domain's
``club_events`` — that table models club-scoped RSVP events; this one models
standalone, geocoded, capacity-managed meetups discoverable by proximity.

``EventWaitlist`` is both the join list and the waitlist: rows are ordered by
``queued_at`` and the first ``max_attendees`` are confirmed attendees, the rest
queue. A NULL ``max_attendees`` means unlimited capacity.
"""

from __future__ import annotations

import uuid
from datetime import datetime
from decimal import Decimal

from sqlalchemy import (
    Boolean,
    Double,
    ForeignKey,
    Index,
    Integer,
    Numeric,
    String,
    Text,
    UniqueConstraint,
    func,
)
from sqlalchemy.dialects.postgresql import TIMESTAMP
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column

from app.core.db import Base


class Event(Base):
    """A location-based offline meetup."""

    __tablename__ = "events"
    __table_args__ = (
        # Bounding-box prefilter for nearby search scans live public coords.
        Index("idx_events_public_coords", "is_public", "lat", "lng"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    creator_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    # NULL for a clubless 번개 모임.
    club_id: Mapped[uuid.UUID | None] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("reading_clubs.id", ondelete="SET NULL"),
        nullable=True,
    )
    book_id: Mapped[uuid.UUID | None] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("books.id", ondelete="SET NULL"),
        nullable=True,
    )
    title: Mapped[str] = mapped_column(String(200), nullable=False)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    address: Mapped[str | None] = mapped_column(Text, nullable=True)
    lat: Mapped[float | None] = mapped_column(Double, nullable=True)
    lng: Mapped[float | None] = mapped_column(Double, nullable=True)
    # Coarse genre, e.g. '소설', '자기계발', '인문학', '과학', '기타'.
    category: Mapped[str | None] = mapped_column(String(32), nullable=True)
    event_at: Mapped[datetime] = mapped_column(TIMESTAMP(timezone=True), nullable=False)
    max_attendees: Mapped[int | None] = mapped_column(Integer, nullable=True)
    is_public: Mapped[bool] = mapped_column(Boolean, nullable=False, server_default="true")
    # Soft-delete: deletion timestamp; NULL means live.
    deleted_at: Mapped[datetime | None] = mapped_column(TIMESTAMP(timezone=True), nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        TIMESTAMP(timezone=True), nullable=False, server_default=func.now()
    )


class EventWaitlist(Base):
    """One row per user who joined an event; also the capacity queue."""

    __tablename__ = "event_waitlist"
    __table_args__ = (
        UniqueConstraint("event_id", "user_id", name="uq_event_waitlist_event_user"),
        # Position/capacity is determined by queued_at order within an event.
        Index("idx_event_waitlist_event_queued", "event_id", "queued_at"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    event_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("events.id", ondelete="CASCADE"),
        nullable=False,
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    queued_at: Mapped[datetime] = mapped_column(
        TIMESTAMP(timezone=True), nullable=False, server_default=func.now()
    )


class EventReview(Base):
    """A post-meetup review left by an attendee."""

    __tablename__ = "event_reviews"
    __table_args__ = (
        UniqueConstraint("event_id", "reviewer_id", name="uq_event_reviews_event_reviewer"),
        Index("idx_event_reviews_event", "event_id"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    event_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("events.id", ondelete="CASCADE"),
        nullable=False,
    )
    reviewer_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    rating: Mapped[Decimal] = mapped_column(Numeric(precision=2, scale=1), nullable=False)
    body: Mapped[str | None] = mapped_column(Text, nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        TIMESTAMP(timezone=True), nullable=False, server_default=func.now()
    )

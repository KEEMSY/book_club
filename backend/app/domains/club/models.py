from __future__ import annotations

import enum
import secrets
import uuid
from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, Index, PrimaryKeyConstraint, SmallInteger, String, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.db import Base


class ClubRole(enum.StrEnum):
    OWNER = "owner"
    MEMBER = "member"


class EventType(enum.StrEnum):
    ONLINE = "online"
    OFFLINE = "offline"


class RSVPStatus(enum.StrEnum):
    GOING = "going"
    MAYBE = "maybe"
    NOT_GOING = "not_going"


class ReadingClub(Base):
    __tablename__ = "reading_clubs"
    __table_args__ = (Index("ix_reading_clubs_owner_id", "owner_id"),)

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, default=uuid.uuid4)
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    owner_id: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("users.id", ondelete="CASCADE"), nullable=False
    )
    book_id: Mapped[uuid.UUID | None] = mapped_column(
        ForeignKey("books.id", ondelete="SET NULL"), nullable=True
    )
    invite_code: Mapped[str] = mapped_column(
        String(16),
        nullable=False,
        unique=True,
        default=lambda: secrets.token_urlsafe(8)[:8].upper(),
    )
    max_members: Mapped[int] = mapped_column(SmallInteger, nullable=False, default=10)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, default=lambda: datetime.now()
    )

    members: Mapped[list[ClubMember]] = relationship(
        "ClubMember", back_populates="club", cascade="all, delete-orphan"
    )
    events: Mapped[list[ClubEvent]] = relationship(
        "ClubEvent", back_populates="club", cascade="all, delete-orphan"
    )


class ClubMember(Base):
    __tablename__ = "club_members"
    __table_args__ = (
        PrimaryKeyConstraint("club_id", "user_id", name="pk_club_members"),
        Index("ix_club_members_user_id", "user_id"),
    )

    club_id: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("reading_clubs.id", ondelete="CASCADE"), nullable=False
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("users.id", ondelete="CASCADE"), nullable=False
    )
    role: Mapped[str] = mapped_column(String(20), nullable=False, default=ClubRole.MEMBER)
    joined_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, default=lambda: datetime.now()
    )

    club: Mapped[ReadingClub] = relationship("ReadingClub", back_populates="members")


class ClubEvent(Base):
    __tablename__ = "club_events"
    __table_args__ = (Index("ix_club_events_club_id", "club_id"),)

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, default=uuid.uuid4)
    club_id: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("reading_clubs.id", ondelete="CASCADE"), nullable=False
    )
    title: Mapped[str] = mapped_column(String(200), nullable=False)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    event_type: Mapped[str] = mapped_column(String(20), nullable=False)
    location: Mapped[str | None] = mapped_column(Text, nullable=True)
    scheduled_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    created_by: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("users.id", ondelete="CASCADE"), nullable=False
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, default=lambda: datetime.now()
    )

    club: Mapped[ReadingClub] = relationship("ReadingClub", back_populates="events")
    rsvps: Mapped[list[EventRSVP]] = relationship(
        "EventRSVP", back_populates="event", cascade="all, delete-orphan"
    )


class EventRSVP(Base):
    __tablename__ = "event_rsvps"
    __table_args__ = (PrimaryKeyConstraint("event_id", "user_id", name="pk_event_rsvps"),)

    event_id: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("club_events.id", ondelete="CASCADE"), nullable=False
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("users.id", ondelete="CASCADE"), nullable=False
    )
    status: Mapped[str] = mapped_column(String(20), nullable=False)
    responded_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, default=lambda: datetime.now()
    )

    event: Mapped[ClubEvent] = relationship("ClubEvent", back_populates="rsvps")

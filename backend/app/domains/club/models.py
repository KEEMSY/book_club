from __future__ import annotations

import enum
import secrets
import uuid
from datetime import datetime

from sqlalchemy import (
    Boolean,
    CheckConstraint,
    DateTime,
    ForeignKey,
    Index,
    PrimaryKeyConstraint,
    SmallInteger,
    String,
    Text,
    UniqueConstraint,
)
from sqlalchemy.dialects.postgresql import UUID as PGUUID
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
    is_public: Mapped[bool] = mapped_column(Boolean, nullable=False, server_default="false")
    # Coarse genre category, e.g. '소설', '자기계발', '인문학', '과학', '기타'.
    category: Mapped[str | None] = mapped_column(String(32), nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, default=lambda: datetime.now()
    )

    members: Mapped[list[ClubMember]] = relationship(
        "ClubMember", back_populates="club", cascade="all, delete-orphan"
    )
    events: Mapped[list[ClubEvent]] = relationship(
        "ClubEvent", back_populates="club", cascade="all, delete-orphan"
    )
    tags: Mapped[list[ClubTag]] = relationship(
        "ClubTag", back_populates="club", cascade="all, delete-orphan"
    )


class ClubTag(Base):
    """Fine-grained label attached to a reading club."""

    __tablename__ = "club_tags"
    __table_args__ = (
        UniqueConstraint("club_id", "tag", name="uq_club_tags_club_tag"),
        Index("idx_club_tags_club", "club_id"),
        Index("idx_club_tags_tag", "tag"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    club_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("reading_clubs.id", ondelete="CASCADE"),
        nullable=False,
    )
    tag: Mapped[str] = mapped_column(String(32), nullable=False)

    club: Mapped[ReadingClub] = relationship("ReadingClub", back_populates="tags")


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
    location: Mapped[str | None] = mapped_column(String(300), nullable=True)
    event_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    max_attendees: Mapped[int | None] = mapped_column(SmallInteger, nullable=True)
    created_by: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("users.id", ondelete="CASCADE"), nullable=False
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, default=lambda: datetime.now()
    )

    club: Mapped[ReadingClub] = relationship("ReadingClub", back_populates="events")
    attendees: Mapped[list[EventAttendee]] = relationship(
        "EventAttendee", back_populates="event", cascade="all, delete-orphan"
    )


class EventAttendee(Base):
    __tablename__ = "event_attendees"
    __table_args__ = (
        PrimaryKeyConstraint("event_id", "user_id", name="pk_event_attendees"),
        CheckConstraint(
            "status IN ('going', 'maybe', 'not_going')",
            name="ck_event_attendees_status",
        ),
    )

    event_id: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("club_events.id", ondelete="CASCADE"), nullable=False
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        ForeignKey("users.id", ondelete="CASCADE"), nullable=False
    )
    status: Mapped[str] = mapped_column(String(12), nullable=False)
    responded_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, default=lambda: datetime.now()
    )

    event: Mapped[ClubEvent] = relationship("ClubEvent", back_populates="attendees")


class ClubRoom(Base):
    """A progress-gated chat room within a reading club.

    Members whose ``user_books.current_chapter`` value is below ``progress_gate``
    cannot enter.  ``progress_gate = 0`` means anyone in the club can enter.
    """

    __tablename__ = "club_rooms"
    __table_args__ = (Index("ix_club_rooms_club_id", "club_id"),)

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    club_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("reading_clubs.id", ondelete="CASCADE"),
        nullable=False,
    )
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    # 0 = open to all members; N = caller's current_chapter must be >= N to enter.
    progress_gate: Mapped[int] = mapped_column(SmallInteger, nullable=False, default=0)
    created_by: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, default=lambda: datetime.now()
    )


class ClubMessage(Base):
    """A chat message posted in a reading club channel.

    ``room_id`` is NULL for the club-wide channel and non-NULL for
    messages scoped to a :class:`ClubRoom`.
    """

    __tablename__ = "club_messages"
    __table_args__ = (
        # Primary query pattern: paginate a club's chat in reverse-chronological order.
        Index("ix_club_messages_club_id_created_at", "club_id", "created_at"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    club_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("reading_clubs.id", ondelete="CASCADE"),
        nullable=False,
    )
    room_id: Mapped[uuid.UUID | None] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("club_rooms.id", ondelete="SET NULL"),
        nullable=True,
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    content: Mapped[str] = mapped_column(Text, nullable=False)
    media_url: Mapped[str | None] = mapped_column(Text, nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, default=lambda: datetime.now()
    )
    # Set when sender edits the message; NULL means never edited.
    edited_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    # Soft-delete: set to the deletion timestamp; NULL means not deleted.
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    reads: Mapped[list[MessageRead]] = relationship(
        "MessageRead", back_populates="message", cascade="all, delete-orphan"
    )


class MessageRead(Base):
    """Tracks which users have read which club messages (read receipts)."""

    __tablename__ = "message_reads"
    __table_args__ = (PrimaryKeyConstraint("message_id", "user_id", name="pk_message_reads"),)

    message_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("club_messages.id", ondelete="CASCADE"),
        nullable=False,
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    read_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, default=lambda: datetime.now()
    )

    message: Mapped[ClubMessage] = relationship("ClubMessage", back_populates="reads")

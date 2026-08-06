from __future__ import annotations

import enum
import secrets
import uuid
from datetime import date, datetime

from sqlalchemy import (
    Boolean,
    CheckConstraint,
    Date,
    DateTime,
    ForeignKey,
    Index,
    Integer,
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


class SessionStatus(enum.StrEnum):
    """Lifecycle of a club session (BC-42 agenda/discussion feature)."""

    DRAFT = "draft"
    OPEN = "open"
    CLOSED = "closed"


class AgendaStatus(enum.StrEnum):
    """Publication state of a session agenda write-up."""

    DRAFT = "draft"
    PUBLISHED = "published"


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
    # Monetization hook (BC-42 design §4.2) — reserved for the paid-club epic's
    # join-gating logic. Unread/unwritten by BC-43; always 'open' for now.
    access_type: Mapped[str] = mapped_column(String(16), nullable=False, server_default="open")
    join_price_cents: Mapped[int | None] = mapped_column(Integer, nullable=True)
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
    sessions: Mapped[list[ClubSession]] = relationship(
        "ClubSession", back_populates="club", cascade="all, delete-orphan"
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
    # Self-reported page the member has read up to, against the active reading plan.
    current_page: Mapped[int] = mapped_column(Integer, nullable=False, server_default="0")
    last_page_updated_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )

    club: Mapped[ReadingClub] = relationship("ReadingClub", back_populates="members")


class ClubReadingPlan(Base):
    """An AI-paced reading schedule a Pro club owner sets for the club's book.

    ``weekly_pages`` is derived once at creation from the book's page count and
    the plan span; member progress is compared against it to drive coaching.
    """

    __tablename__ = "club_reading_plans"
    __table_args__ = (Index("idx_club_plans_club", "club_id"),)

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    club_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("reading_clubs.id", ondelete="CASCADE"),
        nullable=False,
    )
    book_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), ForeignKey("books.id"), nullable=False
    )
    start_date: Mapped[date] = mapped_column(Date, nullable=False)
    end_date: Mapped[date] = mapped_column(Date, nullable=False)
    weekly_pages: Mapped[int] = mapped_column(Integer, nullable=False)
    created_by: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), ForeignKey("users.id"), nullable=False
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, default=lambda: datetime.now()
    )


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


class ClubSession(Base):
    """A discussion round (회차) scoped to one book within a club.

    Distinct from :class:`ClubRoom` (real-time, progress-gated chat) — a
    session anchors asynchronous, structured discussion via its agenda and
    topics (BC-42 design doc §1, §3). ``access_tier``/``price_cents`` are
    monetization hooks reserved for a future paid-session epic; BC-43 does
    not read or write them beyond their defaults (design §4.2).
    """

    __tablename__ = "club_sessions"
    __table_args__ = (
        Index("ix_club_sessions_club_id", "club_id"),
        Index("ix_club_sessions_book_id", "book_id"),
        CheckConstraint("status IN ('draft', 'open', 'closed')", name="ck_club_sessions_status"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    club_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("reading_clubs.id", ondelete="CASCADE"),
        nullable=False,
    )
    book_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), ForeignKey("books.id"), nullable=False
    )
    title: Mapped[str] = mapped_column(String(200), nullable=False)
    # Free-text chapter/page range this session covers, e.g. "3장 ~ 5장".
    scope: Mapped[str | None] = mapped_column(Text, nullable=True)
    presenter_id: Mapped[uuid.UUID | None] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="SET NULL"),
        nullable=True,
    )
    scheduled_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    status: Mapped[str] = mapped_column(String(12), nullable=False, default=SessionStatus.DRAFT)
    # Monetization hook (design §4.2) — always 'included' until the paid-session epic.
    access_tier: Mapped[str] = mapped_column(String(16), nullable=False, default="included")
    price_cents: Mapped[int | None] = mapped_column(Integer, nullable=True)
    created_by: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, default=lambda: datetime.now()
    )

    club: Mapped[ReadingClub] = relationship("ReadingClub", back_populates="sessions")
    agendas: Mapped[list[SessionAgenda]] = relationship(
        "SessionAgenda", back_populates="session", cascade="all, delete-orphan"
    )


class SessionAgenda(Base):
    """The presenter's write-up (발제문) for one club session.

    Only the session's host or presenter may create/publish one (design §5);
    that authorization is enforced by the service layer (BC-44/45), not here.
    """

    __tablename__ = "session_agendas"
    __table_args__ = (
        Index("ix_session_agendas_session_id", "session_id"),
        CheckConstraint("status IN ('draft', 'published')", name="ck_session_agendas_status"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    session_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("club_sessions.id", ondelete="CASCADE"),
        nullable=False,
    )
    author_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False
    )
    body: Mapped[str] = mapped_column(Text, nullable=False)
    status: Mapped[str] = mapped_column(String(12), nullable=False, default=AgendaStatus.DRAFT)
    published_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, default=lambda: datetime.now()
    )

    session: Mapped[ClubSession] = relationship("ClubSession", back_populates="agendas")
    topics: Mapped[list[AgendaTopic]] = relationship(
        "AgendaTopic", back_populates="agenda", cascade="all, delete-orphan"
    )


class AgendaTopic(Base):
    """A single discussion prompt (논제) within an agenda, in display order."""

    __tablename__ = "agenda_topics"
    __table_args__ = (Index("ix_agenda_topics_agenda_id", "agenda_id"),)

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    agenda_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("session_agendas.id", ondelete="CASCADE"),
        nullable=False,
    )
    position: Mapped[int] = mapped_column(Integer, nullable=False)
    prompt: Mapped[str] = mapped_column(Text, nullable=False)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, default=lambda: datetime.now()
    )

    agenda: Mapped[SessionAgenda] = relationship("SessionAgenda", back_populates="topics")
    comments: Mapped[list[TopicComment]] = relationship(
        "TopicComment", back_populates="topic", cascade="all, delete-orphan"
    )


class TopicComment(Base):
    """A reply in a topic's discussion thread.

    Replies are limited to a single level (design §2 비목표) — enforced by
    the service layer, mirroring the ``feed.Comment`` convention, since "a
    parent must itself have no parent" is awkward to express as a pure CHECK.
    ``parent_comment_id`` cascades on delete so removing a top-level reply
    also removes the sub-replies hanging off it.
    """

    __tablename__ = "topic_comments"
    __table_args__ = (
        Index("ix_topic_comments_topic_id", "topic_id"),
        Index("ix_topic_comments_parent_comment_id", "parent_comment_id"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    topic_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("agenda_topics.id", ondelete="CASCADE"),
        nullable=False,
    )
    author_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"), nullable=False
    )
    parent_comment_id: Mapped[uuid.UUID | None] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("topic_comments.id", ondelete="CASCADE"),
        nullable=True,
    )
    body: Mapped[str] = mapped_column(Text, nullable=False)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, default=lambda: datetime.now()
    )
    edited_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    topic: Mapped[AgendaTopic] = relationship("AgendaTopic", back_populates="comments")

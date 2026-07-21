"""SQLAlchemy ORM models for the feed domain — posts, reactions, comments.

- ``Post`` is a per-book group post. Book group identity is the ``book_id``
  itself (design doc §5: "책 그룹 = book_id, separate table 없음"). Image
  uploads are sent directly to R2 via presigned PUT, so we store only the
  R2 object **keys** (not URLs); the read path materialises short-lived
  signed URLs on demand. ``deleted_at`` enables author-soft-delete and
  moderation hide-flows.
- ``Reaction`` is a (post, user, type) triple. UNIQUE on the triple keeps
  the toggle UX trivial — re-reacting with the same type collapses to the
  existing row (the repo catches IntegrityError and returns it).
- ``Comment`` supports a single layer of replies (1단계 답글). The CHECK
  "parent must itself have parent_id IS NULL" is awkward to express in
  pure SQL on this table, so the service layer enforces depth and the
  composite (post_id, created_at) index keeps the comment list O(log n).
- ``ON DELETE CASCADE`` is used on every FK — when a Post or User goes
  away, its reactions and comments must follow. Comment children cascade
  on parent deletion as well.
- Enums are portable string enums (``native_enum=False``) per M1/M2/M3
  convention so adding a value (e.g. a new reaction emoji) is a one-line
  schema tweak rather than an ALTER TYPE dance.
"""

from __future__ import annotations

import enum
import uuid
from datetime import datetime

from sqlalchemy import (
    DateTime,
    ForeignKey,
    Index,
    Integer,
    String,
    Text,
    UniqueConstraint,
    func,
)
from sqlalchemy import Enum as SAEnum
from sqlalchemy.dialects.postgresql import ARRAY, JSONB
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column

from app.core.db import Base


class PostType(enum.StrEnum):
    """Editorial flavour of a post."""

    HIGHLIGHT = "highlight"
    THOUGHT = "thought"
    QUESTION = "question"
    DISCUSSION = "discussion"


class ReactionType(enum.StrEnum):
    """Five-emoji reaction palette (design doc §5)."""

    IDEA = "idea"
    FIRE = "fire"
    THINK = "think"
    CLAP = "clap"
    HEART = "heart"


class Post(Base):
    """Per-book group post."""

    __tablename__ = "posts"
    __table_args__ = (
        # Book feed timeline: scoped to a book and ordered DESC by created_at.
        Index("ix_posts_book_created", "book_id", "created_at"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    book_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("books.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    post_type: Mapped[PostType] = mapped_column(
        SAEnum(
            PostType,
            name="post_type",
            values_callable=lambda enum_cls: [member.value for member in enum_cls],
            native_enum=False,
            length=16,
        ),
        nullable=False,
    )
    content: Mapped[str] = mapped_column(Text, nullable=False)
    image_keys: Mapped[list[str]] = mapped_column(
        ARRAY(Text),
        nullable=False,
        server_default="{}",
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)


class Reaction(Base):
    """Single reaction by one user on a post (post x user x type triple)."""

    __tablename__ = "reactions"
    __table_args__ = (
        # Idempotent toggle relies on UNIQUE — a duplicate INSERT collapses
        # to a clean IntegrityError that the repo turns into a noop.
        UniqueConstraint("post_id", "user_id", "reaction_type", name="uq_reactions_triple"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    post_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("posts.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    reaction_type: Mapped[ReactionType] = mapped_column(
        SAEnum(
            ReactionType,
            name="reaction_type",
            values_callable=lambda enum_cls: [member.value for member in enum_cls],
            native_enum=False,
            length=16,
        ),
        nullable=False,
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )


class Comment(Base):
    """Comment attached to a post. Replies are limited to depth 1 by service."""

    __tablename__ = "comments"
    __table_args__ = (Index("ix_comments_post_created", "post_id", "created_at"),)

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    post_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("posts.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    parent_id: Mapped[uuid.UUID | None] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("comments.id", ondelete="CASCADE"),
        nullable=True,
        index=True,
    )
    content: Mapped[str] = mapped_column(Text, nullable=False)

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)


class FeedEventType(enum.StrEnum):
    """Activity event types recorded in the feed events log."""

    CHAPTER_MILESTONE = "CHAPTER_MILESTONE"
    STREAK_MILESTONE = "STREAK_MILESTONE"
    BOOK_COMPLETED = "BOOK_COMPLETED"
    BOOK_REVIEWED = "BOOK_REVIEWED"
    CLUB_JOINED = "CLUB_JOINED"
    HIGHLIGHT_SHARED = "highlight_shared"


class FeedEvent(Base):
    """Append-only activity event row for a single user.

    Each event carries a JSONB ``metadata`` payload whose shape depends on
    ``event_type`` (see service docstrings).  Rows are never mutated after
    insert — they are an audit / activity stream only.
    """

    __tablename__ = "feed_events"
    __table_args__ = (
        Index("ix_feed_events_user_id_created_at", "user_id", "created_at"),
        # Global timeline (list_global) orders by created_at DESC with no
        # user_id filter, so the composite index above can't serve it — a
        # standalone created_at index keeps every home-feed page off a full sort.
        Index("ix_feed_events_created_at", "created_at"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    event_type: Mapped[str] = mapped_column(String(32), nullable=False)
    event_metadata: Mapped[dict[str, object] | None] = mapped_column(
        "metadata", JSONB, nullable=True
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )


class FeedEventReaction(Base):
    """Emoji reaction by one user on a feed_event (activity stream entry).

    UNIQUE on (feed_event_id, user_id, emoji) keeps toggle-on idempotent at
    the DB level — a duplicate INSERT is handled by ON CONFLICT DO NOTHING in
    the repository, mirroring the Reaction toggle pattern on posts.
    """

    __tablename__ = "feed_event_reactions"
    __table_args__ = (
        UniqueConstraint(
            "feed_event_id", "user_id", "emoji", name="uq_feed_event_reactions_triple"
        ),
        Index("ix_feed_event_reactions_event_id", "feed_event_id"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    feed_event_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("feed_events.id", ondelete="CASCADE"),
        nullable=False,
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    # One of: ❤️ 🔥 👏 📚 💪 — stored as the raw emoji string.
    emoji: Mapped[str] = mapped_column(String(8), nullable=False)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )


class FeedComment(Base):
    """Comment on a feed_event. Supports 2-depth replies via parent_id.

    Depth enforcement (parent must be a root comment) lives in the service
    layer because the rule references parent state, not just this row.
    The body CHECK (≤500 chars) is enforced at both the DB and Pydantic layers.
    """

    __tablename__ = "feed_comments"
    __table_args__ = (Index("ix_feed_comments_event_created", "feed_event_id", "created_at"),)

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    feed_event_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("feed_events.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    parent_id: Mapped[uuid.UUID | None] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("feed_comments.id", ondelete="CASCADE"),
        nullable=True,
        index=True,
    )
    body: Mapped[str] = mapped_column(Text, nullable=False)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )


class PostHighlight(Base):
    """A private quote saved by the user from a book they're reading.

    Stored separately from :class:`Post` so highlights stay private by
    default — the user explicitly shares them to the feed by creating a
    Post with ``post_type=highlight`` and the quote as ``content``.
    """

    __tablename__ = "post_highlights"
    __table_args__ = (Index("ix_highlights_user_book_created", "user_book_id", "created_at"),)

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    user_book_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("user_books.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    quote_text: Mapped[str] = mapped_column(Text, nullable=False)
    page_number: Mapped[int | None] = mapped_column(Integer, nullable=True)
    note_text: Mapped[str | None] = mapped_column(Text, nullable=True)

    # Who may see this highlight: 'private' (default), 'followers', or 'public'.
    # Promoting to 'public' is what surfaces a highlight in the explore feed.
    visibility: Mapped[str] = mapped_column(
        String(16), nullable=False, default="private", server_default="private"
    )
    # Set the first time the highlight is pushed to the feed — a non-null value
    # makes a re-share idempotent (the existing feed event is returned instead).
    shared_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )

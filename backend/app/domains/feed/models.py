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
    Text,
    UniqueConstraint,
    func,
)
from sqlalchemy import Enum as SAEnum
from sqlalchemy.dialects.postgresql import ARRAY
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

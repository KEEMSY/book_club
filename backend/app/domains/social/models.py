"""SQLAlchemy ORM models for the social domain — follows, blocks, reports.

- ``Follow`` is a directed edge: follower → followee. The UNIQUE constraint on
  (follower_id, followee_id) makes the follow idempotent at the DB level.
  A CHECK prevents self-follows. An index on followee_id enables efficient
  "follower count" queries.
- ``Block`` is a directed edge: blocker → blocked. Same uniqueness and
  self-reference guard pattern as Follow. When a block is created the service
  layer auto-unfollows both directions so the relationship is consistent.
- ``Report`` captures user abuse reports against a post, comment, or user.
  ``target_type`` is stored as a plain VARCHAR ('post'|'comment'|'user') rather
  than a Postgres ENUM so adding new target types is a single-line ORM change.
  The composite index (reporter_id, target_type, target_id) powers the
  duplicate-detection query in SocialService.report().
"""

from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy import CheckConstraint, DateTime, ForeignKey, Index, String, UniqueConstraint, func
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column

from app.core.db import Base


class Follow(Base):
    """Directed follow edge: follower → followee."""

    __tablename__ = "follows"
    __table_args__ = (
        UniqueConstraint("follower_id", "followee_id", name="uq_follows_pair"),
        CheckConstraint("follower_id != followee_id", name="ck_follows_no_self"),
        # Reverse-direction index for "who follows me?" queries.
        Index("ix_follows_followee_id", "followee_id"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    follower_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    followee_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )


class Block(Base):
    """Directed block edge: blocker → blocked."""

    __tablename__ = "blocks"
    __table_args__ = (
        UniqueConstraint("blocker_id", "blocked_id", name="uq_blocks_pair"),
        CheckConstraint("blocker_id != blocked_id", name="ck_blocks_no_self"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    blocker_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    blocked_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )


class Report(Base):
    """User abuse report against a post, comment, or another user."""

    __tablename__ = "reports"
    __table_args__ = (
        # Composite index enables O(log n) duplicate-detection in SocialService.report().
        Index("ix_reports_reporter_target", "reporter_id", "target_type", "target_id"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    reporter_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    # 'post' | 'comment' | 'user' — plain VARCHAR avoids ALTER TYPE on value addition.
    target_type: Mapped[str] = mapped_column(String(16), nullable=False)
    target_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), nullable=False
    )
    reason: Mapped[str] = mapped_column(String(500), nullable=False)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )

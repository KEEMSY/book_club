"""SQLAlchemy ORM models for the notification domain.

- ``Notification`` is the in-app inbox row created for every push. We keep
  a local copy so the mobile client can render the inbox without a live FCM
  connection and mark items read.
- ``WeeklyReport`` captures the aggregated reading stats for a given ISO week.
  The batch job (APScheduler, Sunday 21:00 KST) upserts one row per user per
  week and pushes a summary notification. ``UniqueConstraint(user_id,
  week_start)`` lets the job be safely re-run after a failure.
"""

from __future__ import annotations

import enum
import uuid
from datetime import date, datetime

from sqlalchemy import (
    Date,
    DateTime,
    ForeignKey,
    Index,
    Integer,
    String,
    UniqueConstraint,
    func,
)
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column

from app.core.db import Base


class NotificationType(enum.StrEnum):
    """Discriminator for in-app notification routing on the client."""

    REACTION = "reaction"
    COMMENT = "comment"
    GRADE_UP = "grade_up"
    WEEKLY_REPORT = "weekly_report"


class Notification(Base):
    """In-app notification inbox row."""

    __tablename__ = "notifications"
    __table_args__ = (
        # Cursor-based pagination by (user, recency) — the primary access pattern.
        Index("ix_notifications_user_created", "user_id", "created_at"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    ntype: Mapped[str] = mapped_column(String(32), nullable=False)
    title: Mapped[str] = mapped_column(String(256), nullable=False)
    body: Mapped[str] = mapped_column(String(512), nullable=False)
    # Carries routing payload (post_id, comment_id, etc.) — JSONB for flexibility.
    data: Mapped[dict[str, str]] = mapped_column(JSONB, nullable=False, server_default="{}")
    read_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )


class WeeklyReport(Base):
    """Aggregated reading stats for one ISO week per user."""

    __tablename__ = "weekly_reports"
    __table_args__ = (
        # The batch job upserts once per (user, week) — unique enforces idempotence.
        UniqueConstraint("user_id", "week_start", name="uq_weekly_reports_user_week"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    # ISO week Monday — the canonical week identifier.
    week_start: Mapped[date] = mapped_column(Date, nullable=False)
    total_seconds: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    session_count: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    # Day within the week with the most accumulated reading time.
    best_day: Mapped[date | None] = mapped_column(Date, nullable=True)
    longest_session_sec: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    push_sent_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )

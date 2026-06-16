"""SQLAlchemy ORM models for the retention domain.

- ``ReengagementPushLog`` — one row per (user, push_type, calendar-day).
  The scheduler checks this before dispatching a re-engagement push so each
  user receives at most one push per push_type per day.
- ``StreakRecoveryLog`` — records each streak recovery event. The service
  counts rows in the last 30 days to enforce the recovery limit (≤ 2 per month).
"""

from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, Index, Integer, String, func
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column

from app.core.db import Base


class ReengagementPushLog(Base):
    """Record of a re-engagement push sent to a user."""

    __tablename__ = "reengagement_push_logs"
    __table_args__ = (
        Index("ix_reengagement_push_logs_user_sent", "user_id", "sent_at"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    # 'day7_inactive' | 'streak_recovery'
    push_type: Mapped[str] = mapped_column(String(32), nullable=False)
    sent_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )


class StreakRecoveryLog(Base):
    """Record of a streak recovery applied for a user."""

    __tablename__ = "streak_recovery_logs"
    __table_args__ = (
        Index("ix_streak_recovery_logs_user_recovered", "user_id", "recovered_at"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    recovered_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )
    days_recovered: Mapped[int] = mapped_column(Integer, nullable=False, default=1)

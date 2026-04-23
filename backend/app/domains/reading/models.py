"""SQLAlchemy ORM models for the reading domain.

Core tables:
- ``reading_sessions`` — one row per timer or manual reading session.
  A partial UNIQUE index on ``user_id WHERE ended_at IS NULL`` enforces the
  single-active-session rule at the DB layer; the service layer also guards
  with a pre-flight check so the user gets a 409 rather than a naked
  IntegrityError. ``source`` gates what affects grades and heatmap — only
  ``timer`` rows feed DailyReadingStat / UserGrade; ``manual`` rows are
  logged for completeness but carry no grade/streak weight.
- ``daily_reading_stats`` — composite PK (user_id, date) aggregate. Fed by
  the ``ReadingSessionCompleted`` event subscriber via INSERT ... ON
  CONFLICT DO UPDATE. No FK on ``user_id``: the event handler on user
  soft-delete (when wired in M5) prunes these rows explicitly.
- ``user_grades`` — one row per user, snapshot of total_books /
  total_seconds / streak. Lazily created on first read via
  ``UserGradeRepository.get_or_init``.
- ``goals`` — one row per goal instance. Active goals are found by window
  (``today`` ∈ [start_date, end_date]); uniqueness is not enforced at the
  DB so future plan edits (multiple overlapping windows) remain possible
  without migrations.

Enum columns use ``native_enum=False`` (portable string) consistent with
M1/M2. Adding a source or period in the future is a string value tweak +
CheckConstraint refresh, not an ``ALTER TYPE`` dance.
"""

from __future__ import annotations

import enum
import uuid
from datetime import date, datetime

from sqlalchemy import (
    CheckConstraint,
    Date,
    DateTime,
    ForeignKey,
    Index,
    Integer,
    PrimaryKeyConstraint,
    SmallInteger,
    String,
    func,
    text,
)
from sqlalchemy import Enum as SAEnum
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column

from app.core.db import Base


class ReadingSessionSource(enum.StrEnum):
    """How a reading session was recorded."""

    TIMER = "timer"
    MANUAL = "manual"


class GoalPeriod(enum.StrEnum):
    """Goal window granularity."""

    WEEKLY = "weekly"
    MONTHLY = "monthly"
    YEARLY = "yearly"


class ReadingSession(Base):
    """One reading session — timer or manual."""

    __tablename__ = "reading_sessions"
    __table_args__ = (
        # Partial unique index: one active (ended_at IS NULL) session per user.
        # This is the core abuse guard. The service layer pre-checks to return
        # a clean 409, but this is the final line of defence against races.
        Index(
            "ix_reading_session_one_active",
            "user_id",
            unique=True,
            postgresql_where=text("ended_at IS NULL"),
        ),
        # Timeline queries: WHERE user_id = ? ORDER BY started_at DESC.
        Index("ix_reading_session_user_started", "user_id", "started_at"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    user_book_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("user_books.id", ondelete="CASCADE"),
        nullable=False,
    )
    started_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )
    ended_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    duration_sec: Mapped[int | None] = mapped_column(Integer, nullable=True)
    source: Mapped[ReadingSessionSource] = mapped_column(
        SAEnum(
            ReadingSessionSource,
            name="reading_session_source",
            values_callable=lambda enum_cls: [member.value for member in enum_cls],
            native_enum=False,
            length=16,
        ),
        nullable=False,
    )
    device: Mapped[str | None] = mapped_column(String(64), nullable=True)
    note: Mapped[str | None] = mapped_column(String(200), nullable=True)

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )


class DailyReadingStat(Base):
    """Per-day aggregate (user_id, date) — fuels the GitHub-style heatmap."""

    __tablename__ = "daily_reading_stats"
    __table_args__ = (PrimaryKeyConstraint("user_id", "date", name="pk_daily_reading_stats"),)

    user_id: Mapped[uuid.UUID] = mapped_column(PGUUID(as_uuid=True), nullable=False)
    date: Mapped[date] = mapped_column(Date, nullable=False)
    total_seconds: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    session_count: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )


class UserGrade(Base):
    """Per-user grade snapshot + streak state."""

    __tablename__ = "user_grades"
    __table_args__ = (
        CheckConstraint("grade >= 1 AND grade <= 5", name="ck_user_grades_grade_range"),
    )

    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        primary_key=True,
    )
    grade: Mapped[int] = mapped_column(SmallInteger, nullable=False, default=1)
    total_books: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    total_seconds: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    streak_days: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    longest_streak: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    streak_last_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )


class Goal(Base):
    """User-declared reading goal for a window (week/month/year)."""

    __tablename__ = "goals"
    __table_args__ = (
        CheckConstraint("target_books >= 0", name="ck_goals_target_books_nonneg"),
        CheckConstraint("target_seconds >= 0", name="ck_goals_target_seconds_nonneg"),
        CheckConstraint("end_date >= start_date", name="ck_goals_window_ordered"),
        Index("ix_goals_user_period_window", "user_id", "period", "start_date", "end_date"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    period: Mapped[GoalPeriod] = mapped_column(
        SAEnum(
            GoalPeriod,
            name="goal_period",
            values_callable=lambda enum_cls: [member.value for member in enum_cls],
            native_enum=False,
            length=16,
        ),
        nullable=False,
    )
    target_books: Mapped[int] = mapped_column(Integer, nullable=False)
    target_seconds: Mapped[int] = mapped_column(Integer, nullable=False)
    start_date: Mapped[date] = mapped_column(Date, nullable=False)
    end_date: Mapped[date] = mapped_column(Date, nullable=False)

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )

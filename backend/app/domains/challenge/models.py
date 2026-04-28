"""SQLAlchemy ORM models for the challenge domain.

Tables:
- ``badges`` — award icons that users earn. icon_key is stored as an R2
  object key; callers compose the full URL at read time using R2_BASE_URL.
- ``challenges`` — a time-boxed activity goal (e.g. read 5 books in January).
  Indexed on (starts_at, ends_at) to efficiently filter by status.
- ``challenge_participants`` — join table tracking each user's progress inside
  a challenge. The composite UNIQUE (challenge_id, user_id) prevents double
  joins. Indexed on (challenge_id, current_value DESC) for O(log n) leaderboard
  queries without a full sort.
- ``user_badges`` — one row per (user, badge) pair once the badge is earned.
  Indexed on badge_id for "how many users earned this badge?" counts.

Enum columns use ``native_enum=False`` consistent with all other domains.
"""

from __future__ import annotations

import enum
import uuid
from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, Index, Integer, String, Text, UniqueConstraint, func
from sqlalchemy import Enum as SAEnum
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column

from app.core.db import Base


class BadgeCategory(enum.StrEnum):
    """Broad grouping used for badge filtering in the UI."""

    READING = "reading"
    CHALLENGE = "challenge"
    SOCIAL = "social"


class ChallengeType(enum.StrEnum):
    """Determines which reading metric drives progress."""

    BOOKS_COUNT = "books_count"
    READING_TIME = "reading_time"
    STREAK = "streak"
    GENRE = "genre"


class Badge(Base):
    """An award icon that can be earned by users."""

    __tablename__ = "badges"

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    description: Mapped[str] = mapped_column(Text, nullable=False)
    category: Mapped[BadgeCategory] = mapped_column(
        SAEnum(
            BadgeCategory,
            name="badge_category",
            values_callable=lambda e: [m.value for m in e],
            native_enum=False,
            length=16,
        ),
        nullable=False,
    )
    # R2 object key; full URL composed by callers using R2_BASE_URL env var.
    icon_key: Mapped[str] = mapped_column(String(500), nullable=False)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )


class Challenge(Base):
    """A time-boxed reading challenge with an optional badge reward."""

    __tablename__ = "challenges"
    __table_args__ = (
        # Status filtering: WHERE now() BETWEEN starts_at AND ends_at.
        Index("ix_challenges_window", "starts_at", "ends_at"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    title: Mapped[str] = mapped_column(String(100), nullable=False)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    challenge_type: Mapped[ChallengeType] = mapped_column(
        SAEnum(
            ChallengeType,
            name="challenge_type",
            values_callable=lambda e: [m.value for m in e],
            native_enum=False,
            length=24,
        ),
        nullable=False,
    )
    target_value: Mapped[int] = mapped_column(Integer, nullable=False)
    # Non-null only when challenge_type == GENRE; restricts which books count.
    genre_filter: Mapped[str | None] = mapped_column(String(50), nullable=True)
    starts_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    ends_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    badge_id: Mapped[uuid.UUID | None] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("badges.id", ondelete="SET NULL"),
        nullable=True,
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )


class ChallengeParticipant(Base):
    """A user's participation record in a challenge, including progress."""

    __tablename__ = "challenge_participants"
    __table_args__ = (
        UniqueConstraint("challenge_id", "user_id", name="uq_challenge_participants_pair"),
        # Leaderboard reads: WHERE challenge_id = ? ORDER BY current_value DESC.
        Index("ix_challenge_participants_leaderboard", "challenge_id", "current_value"),
    )

    challenge_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("challenges.id", ondelete="CASCADE"),
        primary_key=True,
        nullable=False,
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        primary_key=True,
        nullable=False,
    )
    current_value: Mapped[int] = mapped_column(Integer, nullable=False, default=0)
    achieved_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    joined_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )


class UserBadge(Base):
    """Records when a user earned a badge."""

    __tablename__ = "user_badges"
    __table_args__ = (
        UniqueConstraint("user_id", "badge_id", name="uq_user_badges_pair"),
        # "How many users earned this badge?" counts scan on badge_id.
        Index("ix_user_badges_badge_id", "badge_id"),
    )

    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        primary_key=True,
        nullable=False,
    )
    badge_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("badges.id", ondelete="CASCADE"),
        primary_key=True,
        nullable=False,
    )
    earned_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )

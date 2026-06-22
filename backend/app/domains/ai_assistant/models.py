"""SQLAlchemy ORM models for the ai_assistant domain.

Two tables back the AI reading assistant (Phase 14 §5). ``AIReflectionGuide``
persists a completion reflection per (user, book) — the ``UNIQUE`` constraint
makes re-opening idempotent so the expensive Claude call runs at most once.
``AIUsageLog`` is an append-only record of every successful generation, queried
by the service to enforce per-feature rate limits.

Prep cards are intentionally not modelled here — they are cached in Redis with a
72h TTL and regenerated on miss (see ``service.py``).
"""

from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy import ForeignKey, Index, Integer, String, UniqueConstraint, func
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.dialects.postgresql import TIMESTAMP as PGTIMESTAMP
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column

from app.core.db import Base


class AIReflectionGuide(Base):
    """A Pro completion-reflection guide generated for one (user, book) pair."""

    __tablename__ = "ai_reflection_guides"
    __table_args__ = (
        UniqueConstraint("user_id", "book_id", name="uq_ai_reflections_user_book"),
        Index("idx_ai_reflections_user", "user_id", "created_at"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    book_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("books.id", ondelete="CASCADE"),
        nullable=False,
    )
    content: Mapped[dict[str, object]] = mapped_column(JSONB, nullable=False)
    tokens_used: Mapped[int] = mapped_column(Integer, nullable=False, server_default="0")
    created_at: Mapped[datetime] = mapped_column(
        PGTIMESTAMP(timezone=True), nullable=False, server_default=func.now()
    )


class UserAiPreference(Base):
    """One reader's AI prep-card persona style (M67).

    One row per user, created on first style pick. ``card_style`` feeds both the
    Claude prompt persona and the prep-card cache key. Default mirrors the
    column server-default so a never-set reader is treated as ``motivational``.
    """

    __tablename__ = "user_ai_preferences"

    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        primary_key=True,
    )
    card_style: Mapped[str] = mapped_column(
        String(32), nullable=False, server_default="motivational"
    )
    updated_at: Mapped[datetime] = mapped_column(
        PGTIMESTAMP(timezone=True), nullable=False, server_default=func.now()
    )


class AIUsageLog(Base):
    """One row per successful AI generation — the rate-limiting ledger."""

    __tablename__ = "ai_usage_logs"
    __table_args__ = (Index("idx_ai_usage_user_month", "user_id", "created_at"),)

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    # 'prep_card' | 'reflection' | 'club_topics'
    feature: Mapped[str] = mapped_column(String(32), nullable=False)
    book_id: Mapped[uuid.UUID | None] = mapped_column(
        PGUUID(as_uuid=True), ForeignKey("books.id"), nullable=True
    )
    tokens_used: Mapped[int] = mapped_column(Integer, nullable=False, server_default="0")
    created_at: Mapped[datetime] = mapped_column(
        PGTIMESTAMP(timezone=True), nullable=False, server_default=func.now()
    )

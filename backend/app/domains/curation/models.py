"""SQLAlchemy ORM model for the curation domain.

``CurationCard`` attaches editorial content cards to a catalog book.  Each
card belongs to one of four predefined types (intro / guide / context / quote)
that drive the mobile card carousel layout.  The DB-level CHECK mirrors the
service-layer ``MAX_CARDS_PER_BOOK`` guard so neither boundary alone is a
single point of failure.
"""

from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy import (
    CheckConstraint,
    DateTime,
    ForeignKey,
    Index,
    Integer,
    String,
    Text,
    UniqueConstraint,
    func,
)
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column

from app.core.db import Base


class CurationCard(Base):
    """Editorial curation card attached to a catalog book."""

    __tablename__ = "curation_cards"
    __table_args__ = (
        CheckConstraint(
            "card_type IN ('intro','guide','context','quote')",
            name="ck_curation_cards_card_type",
        ),
        Index("idx_curation_cards_book", "book_id", "order_index"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    book_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("books.id", ondelete="CASCADE"),
        nullable=False,
        index=False,  # covered by the composite index above
    )
    card_type: Mapped[str] = mapped_column(String(16), nullable=False)
    title: Mapped[str] = mapped_column(String(100), nullable=False)
    body: Mapped[str] = mapped_column(Text, nullable=False)
    order_index: Mapped[int] = mapped_column(
        Integer, nullable=False, server_default="0"
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )


class CurationCardFeedback(Base):
    """One reader's reaction to one curation card (M67 feedback loop).

    ``UNIQUE(user_id, card_id)`` makes the write an upsert: re-tapping flips the
    stored ``action`` instead of stacking rows, so the per-type skip/dismiss
    count that drives deprioritization stays one-vote-per-card.
    """

    __tablename__ = "curation_card_feedback"
    __table_args__ = (
        CheckConstraint(
            "action IN ('helpful','skip','dismiss')",
            name="ck_curation_card_feedback_action",
        ),
        UniqueConstraint("user_id", "card_id", name="uq_curation_feedback_user_card"),
        Index("idx_curation_feedback_user", "user_id"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    card_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("curation_cards.id", ondelete="CASCADE"),
        nullable=False,
    )
    action: Mapped[str] = mapped_column(String(16), nullable=False)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )

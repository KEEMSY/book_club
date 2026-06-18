"""SQLAlchemy ORM model for the review domain (M54).

``BookReview`` is one user's rating + free-text review of a single book.
UNIQUE(user_id, book_id) enforces 1인 1리뷰 at the DB level; edits mutate the
row in place. ``rating`` is stored as ``Numeric(2, 1)`` so the half-star scale
(1.0..5.0 in 0.5 steps) is exact rather than a float approximation.

Community moderation lives on this row: ``report_count`` is incremented per
report and ``hidden_at`` is stamped once it crosses the auto-hide threshold,
which removes the review from the per-book listing (see the partial index in
migration 0037).
"""

from __future__ import annotations

import uuid
from datetime import datetime
from decimal import Decimal

from sqlalchemy import (
    CheckConstraint,
    DateTime,
    ForeignKey,
    Index,
    Integer,
    Numeric,
    Text,
    UniqueConstraint,
    func,
    text,
)
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column

from app.core.db import Base


class BookReview(Base):
    """A single user's rating and review of a book."""

    __tablename__ = "book_reviews"
    __table_args__ = (
        UniqueConstraint("user_id", "book_id", name="uq_book_reviews_user_book"),
        CheckConstraint("rating >= 1.0 AND rating <= 5.0", name="ck_book_reviews_rating_range"),
        # Per-book timeline: WHERE book_id = ? AND hidden_at IS NULL ORDER BY
        # created_at DESC. Partial so hidden reviews never enter the listing.
        Index(
            "idx_reviews_book",
            "book_id",
            text("created_at DESC"),
            postgresql_where=text("hidden_at IS NULL"),
        ),
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
    book_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("books.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    rating: Mapped[Decimal] = mapped_column(Numeric(2, 1), nullable=False)
    body: Mapped[str | None] = mapped_column(Text, nullable=True)
    report_count: Mapped[int] = mapped_column(
        Integer, nullable=False, default=0, server_default="0"
    )
    hidden_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )

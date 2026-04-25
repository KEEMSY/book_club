"""SQLAlchemy ORM models for the book domain.

- ``Book`` is the global catalog row. We deduplicate by ``isbn13`` so concurrent
  searches for the same title converge on a single row. ``source`` records
  which provider (Naver / Kakao / manual) actually delivered the metadata
  that created or last updated the row — used for observability and for
  deciding whether to refresh stale entries later.
- ``UserBook`` is the per-user library entry. A user can only have one
  library row per book (UNIQUE user_id+book_id) — status transitions mutate
  this row rather than creating new ones. Ratings are bounded by a DB-level
  CHECK so a bug in the service cannot land an out-of-range value; the
  service validates at the 422 boundary anyway.
- ``ON DELETE CASCADE`` on user_id mirrors auth's soft-delete purge flow.
  ``ON DELETE RESTRICT`` on book_id prevents accidental catalog deletion
  from orphaning every library row.
- Enums are portable string enums (``native_enum=False``) per the M1 convention,
  so migrations stay engine-agnostic and adding a status value doesn't need
  an ``ALTER TYPE`` dance.
"""

from __future__ import annotations

import enum
import uuid
from datetime import datetime

from sqlalchemy import (
    CheckConstraint,
    DateTime,
    ForeignKey,
    Index,
    SmallInteger,
    String,
    Text,
    UniqueConstraint,
    func,
)
from sqlalchemy import Enum as SAEnum
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.db import Base


class BookSource(enum.StrEnum):
    """Origin of a Book row's metadata."""

    NAVER = "naver"
    KAKAO = "kakao"
    MANUAL = "manual"


class UserBookStatus(enum.StrEnum):
    """Lifecycle state of a user's library entry."""

    READING = "reading"
    COMPLETED = "completed"
    PAUSED = "paused"
    DROPPED = "dropped"


class Book(Base):
    """Global catalog row — one per ISBN13."""

    __tablename__ = "books"
    __table_args__ = (UniqueConstraint("isbn13", name="uq_books_isbn13"),)

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    isbn13: Mapped[str] = mapped_column(String(13), nullable=False)
    title: Mapped[str] = mapped_column(String(512), nullable=False)
    author: Mapped[str] = mapped_column(String(512), nullable=False)
    publisher: Mapped[str | None] = mapped_column(String(255), nullable=True)
    cover_url: Mapped[str | None] = mapped_column(String(1024), nullable=True)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    source: Mapped[BookSource] = mapped_column(
        SAEnum(
            BookSource,
            name="book_source",
            values_callable=lambda enum_cls: [member.value for member in enum_cls],
            native_enum=False,
            length=16,
        ),
        nullable=False,
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

    user_books: Mapped[list[UserBook]] = relationship(
        "UserBook",
        back_populates="book",
        passive_deletes=True,
    )


class UserBook(Base):
    """Per-user library entry. UNIQUE(user_id, book_id)."""

    __tablename__ = "user_books"
    __table_args__ = (
        UniqueConstraint("user_id", "book_id", name="uq_user_books_user_book"),
        CheckConstraint(
            "rating IS NULL OR (rating >= 1 AND rating <= 5)",
            name="ck_user_books_rating_range",
        ),
        # Library tab queries filter by (user_id, status) and sort by started_at DESC;
        # this composite index matches that exact shape so pagination stays fast
        # even for power users with 100+ books.
        Index(
            "ix_user_book_user_status_started",
            "user_id",
            "status",
            "started_at",
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
        ForeignKey("books.id", ondelete="RESTRICT"),
        nullable=False,
        index=True,
    )
    status: Mapped[UserBookStatus] = mapped_column(
        SAEnum(
            UserBookStatus,
            name="user_book_status",
            values_callable=lambda enum_cls: [member.value for member in enum_cls],
            native_enum=False,
            length=16,
        ),
        nullable=False,
        default=UserBookStatus.READING,
    )
    started_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True, server_default=func.now()
    )
    finished_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    rating: Mapped[int | None] = mapped_column(SmallInteger, nullable=True)
    one_line_review: Mapped[str | None] = mapped_column(String(200), nullable=True)

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )

    # selectin: async sessions cannot lazy-load; always eager-load the book
    # so router serializers can access ub.book without a greenlet error.
    book: Mapped[Book] = relationship("Book", back_populates="user_books", lazy="selectin")

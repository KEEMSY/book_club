"""book tables — books + user_books.

Revision ID: 0003_book_tables
Revises: 0002_auth_tables
Create Date: 2026-04-20

Introduces the book domain schema for Milestone 2.

Design choices:
- ``books.isbn13`` is UNIQUE and NOT NULL. Items returned by the Naver /
  Kakao search that lack a 13-digit ISBN are filtered out at the adapter
  layer, so the catalog never stores an item we cannot deduplicate.
- Portable string enums (``native_enum=False``) for ``book_source`` and
  ``user_book_status`` mirror the auth convention. Length 16 leaves room
  for future statuses (e.g. ``"wishlist"``) without an ALTER TYPE dance.
- ``user_books.rating`` is SMALLINT with a CHECK 1..5 so a bug in the
  service layer can never land an out-of-range value.
- ``user_books.one_line_review`` is VARCHAR(200) — the router validates
  length but the DB enforces it as a final line of defence.
- UNIQUE(user_id, book_id) so each user has at most one library row per
  book; state transitions mutate that row.
- FK ``user_id`` uses ``ON DELETE CASCADE`` to align with auth's account
  deletion flow; ``book_id`` uses ``ON DELETE RESTRICT`` so deleting a
  catalog row cannot silently orphan every library entry.
- Composite index ``ix_user_book_user_status_started`` matches the library
  tab's (user_id, status) filter + started_at DESC sort so pagination is
  fast for users with many books.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision: str = "0003_book_tables"
down_revision: str | None = "0002_auth_tables"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "books",
        sa.Column("id", sa.UUID(as_uuid=True), primary_key=True, nullable=False),
        sa.Column("isbn13", sa.String(length=13), nullable=False),
        sa.Column("title", sa.String(length=512), nullable=False),
        sa.Column("author", sa.String(length=512), nullable=False),
        sa.Column("publisher", sa.String(length=255), nullable=True),
        sa.Column("cover_url", sa.String(length=1024), nullable=True),
        sa.Column("description", sa.Text(), nullable=True),
        sa.Column("source", sa.String(length=16), nullable=False),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.CheckConstraint(
            "source IN ('naver', 'kakao', 'manual')",
            name="ck_books_source",
        ),
        sa.UniqueConstraint("isbn13", name="uq_books_isbn13"),
    )

    op.create_table(
        "user_books",
        sa.Column("id", sa.UUID(as_uuid=True), primary_key=True, nullable=False),
        sa.Column(
            "user_id",
            sa.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "book_id",
            sa.UUID(as_uuid=True),
            sa.ForeignKey("books.id", ondelete="RESTRICT"),
            nullable=False,
        ),
        sa.Column("status", sa.String(length=16), nullable=False),
        sa.Column(
            "started_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=True,
        ),
        sa.Column("finished_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("rating", sa.SmallInteger(), nullable=True),
        sa.Column("one_line_review", sa.String(length=200), nullable=True),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.CheckConstraint(
            "status IN ('reading', 'completed', 'paused', 'dropped')",
            name="ck_user_books_status",
        ),
        sa.CheckConstraint(
            "rating IS NULL OR (rating >= 1 AND rating <= 5)",
            name="ck_user_books_rating_range",
        ),
        sa.UniqueConstraint("user_id", "book_id", name="uq_user_books_user_book"),
    )
    op.create_index("ix_user_books_user_id", "user_books", ["user_id"])
    op.create_index("ix_user_books_book_id", "user_books", ["book_id"])
    op.create_index(
        "ix_user_book_user_status_started",
        "user_books",
        ["user_id", "status", "started_at"],
    )


def downgrade() -> None:
    op.drop_index("ix_user_book_user_status_started", table_name="user_books")
    op.drop_index("ix_user_books_book_id", table_name="user_books")
    op.drop_index("ix_user_books_user_id", table_name="user_books")
    op.drop_table("user_books")
    op.drop_table("books")

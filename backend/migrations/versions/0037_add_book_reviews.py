"""Add book_reviews table for ratings & reviews (M54).

Revision ID: 0037
Revises: 0036
Create Date: 2026-06-18

One review per (user, book) — UNIQUE(user_id, book_id) — gated to books the
user has finished. ``rating`` is NUMERIC(2,1) with a CHECK 1.0..5.0; the
0.5-step granularity is enforced in the service/Pydantic layer (a DB CHECK on
fractional steps would be brittle across locales).

``report_count`` + ``hidden_at`` implement community moderation: the service
hides a review once it accrues 5 reports. The partial index on
(book_id, created_at DESC) WHERE hidden_at IS NULL keeps the per-book review
timeline index-only and excludes hidden rows from listing.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = "0037"
down_revision: str | None = "0036"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "book_reviews",
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "user_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "book_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("books.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("rating", sa.Numeric(2, 1), nullable=False),
        sa.Column("body", sa.Text, nullable=True),
        sa.Column("report_count", sa.Integer, nullable=False, server_default=sa.text("0")),
        sa.Column("hidden_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
        sa.CheckConstraint("rating >= 1.0 AND rating <= 5.0", name="ck_book_reviews_rating_range"),
        sa.UniqueConstraint("user_id", "book_id", name="uq_book_reviews_user_book"),
    )
    op.create_index(
        "idx_reviews_book",
        "book_reviews",
        ["book_id", sa.text("created_at DESC")],
        postgresql_where=sa.text("hidden_at IS NULL"),
    )


def downgrade() -> None:
    op.drop_index("idx_reviews_book", table_name="book_reviews")
    op.drop_table("book_reviews")

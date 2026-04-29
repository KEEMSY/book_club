"""post_highlights — private quote storage for book readers

Revision ID: 0011_post_highlights
Revises: 0010_user_book_wishlist
Create Date: 2026-04-30
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "0011_post_highlights"
down_revision: str | None = "0010_user_book_wishlist"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "post_highlights",
        sa.Column("id", sa.UUID(), nullable=False),
        sa.Column("user_id", sa.UUID(), nullable=False),
        sa.Column("user_book_id", sa.UUID(), nullable=False),
        sa.Column("quote_text", sa.Text(), nullable=False),
        sa.Column("page_number", sa.Integer(), nullable=True),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(["user_id"], ["users.id"], ondelete="CASCADE"),
        sa.ForeignKeyConstraint(["user_book_id"], ["user_books.id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        "ix_highlights_user_book_created",
        "post_highlights",
        ["user_book_id", "created_at"],
        unique=False,
    )
    op.create_index(
        op.f("ix_post_highlights_user_id"),
        "post_highlights",
        ["user_id"],
        unique=False,
    )
    op.create_index(
        op.f("ix_post_highlights_user_book_id"),
        "post_highlights",
        ["user_book_id"],
        unique=False,
    )


def downgrade() -> None:
    op.drop_index("ix_highlights_user_book_created", table_name="post_highlights")
    op.drop_index(op.f("ix_post_highlights_user_book_id"), table_name="post_highlights")
    op.drop_index(op.f("ix_post_highlights_user_id"), table_name="post_highlights")
    op.drop_table("post_highlights")

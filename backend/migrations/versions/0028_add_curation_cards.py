"""Add curation_cards table for book curation card MVP (M42).

Revision ID: 0028
Revises: 0027
Create Date: 2026-06-15

Each book can have up to 5 curation cards (enforced at service layer).
``card_type`` is one of intro / guide / context / quote — stored as a
VARCHAR with a DB-level CHECK so the constraint survives direct SQL inserts.
``order_index`` drives the display order on the mobile card carousel.
The composite index on (book_id, order_index) matches the list-by-book
query shape exactly.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = "0028"
down_revision: str | None = "0027"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "curation_cards",
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "book_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("books.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "card_type",
            sa.String(16),
            sa.CheckConstraint(
                "card_type IN ('intro','guide','context','quote')",
                name="ck_curation_cards_card_type",
            ),
            nullable=False,
        ),
        sa.Column("title", sa.String(100), nullable=False),
        sa.Column("body", sa.Text, nullable=False),
        sa.Column(
            "order_index",
            sa.Integer,
            nullable=False,
            server_default=sa.text("0"),
        ),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
    )
    op.create_index(
        "idx_curation_cards_book",
        "curation_cards",
        ["book_id", "order_index"],
    )


def downgrade() -> None:
    op.drop_index("idx_curation_cards_book", table_name="curation_cards")
    op.drop_table("curation_cards")

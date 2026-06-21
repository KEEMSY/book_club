"""Add AI assistant tables (M63).

The AI reading assistant has three features (Phase 14 §5):
- prep cards (free, daily-capped) — cached in Redis only, never persisted as a
  row; regenerated on cache miss, so they need no table here.
- completion reflection guides (Pro) — persisted per (user, book) so the
  expensive generation is done at most once and re-opening returns the stored
  copy. ``UNIQUE(user_id, book_id)`` enforces that idempotency at the DB level.
- club discussion topics (Pro club owner) — posted to club chat, not stored.

``ai_usage_logs`` records every successful generation across all three features
so the service can enforce per-feature rate limits (daily prep cap, monthly
free-reflection cap) with a single COUNT query.

Note on ``curation_cards``: the Phase 14 plan mentioned adding an ``ai_prep``
source value, but the table keys content as ``card_type`` with a CHECK
constraint of (intro/guide/context/quote) and a flat title/body shape that does
not fit a prep card's structured JSON. Prep cards live in Redis instead, so this
migration intentionally leaves ``curation_cards`` untouched.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = "0041"
down_revision: str | None = "0040"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "ai_reflection_guides",
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
        sa.Column("content", postgresql.JSONB(), nullable=False),
        sa.Column("tokens_used", sa.Integer(), nullable=False, server_default="0"),
        sa.Column(
            "created_at",
            sa.TIMESTAMP(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
        sa.UniqueConstraint("user_id", "book_id", name="uq_ai_reflections_user_book"),
    )
    op.create_index(
        "idx_ai_reflections_user",
        "ai_reflection_guides",
        ["user_id", sa.text("created_at DESC")],
    )

    op.create_table(
        "ai_usage_logs",
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
        sa.Column("feature", sa.String(length=32), nullable=False),
        sa.Column(
            "book_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("books.id"),
            nullable=True,
        ),
        sa.Column("tokens_used", sa.Integer(), nullable=False, server_default="0"),
        sa.Column(
            "created_at",
            sa.TIMESTAMP(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
    )
    op.create_index(
        "idx_ai_usage_user_month",
        "ai_usage_logs",
        ["user_id", sa.text("created_at DESC")],
    )


def downgrade() -> None:
    op.drop_index("idx_ai_usage_user_month", table_name="ai_usage_logs")
    op.drop_table("ai_usage_logs")
    op.drop_index("idx_ai_reflections_user", table_name="ai_reflection_guides")
    op.drop_table("ai_reflection_guides")

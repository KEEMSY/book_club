"""M67 AI personalization — curation feedback loop + per-user prep card style.

Two persistence surfaces back the M67 AI-deepening work:

- ``curation_card_feedback`` — one row per (user, card). The mobile curation
  sheet emits ``helpful`` / ``skip`` / ``dismiss``; the curation service counts
  ``skip``/``dismiss`` per ``card_type`` and deprioritizes types a user keeps
  rejecting in future first-card selection. The ``UNIQUE(user_id, card_id)``
  makes the write an idempotent upsert — re-tapping flips the action, never
  inflates the count.
- ``user_ai_preferences`` — the reader's chosen prep-card persona
  (``motivational`` / ``analytical`` / ``reflective``). One row per user, created
  on first style pick; the AI assistant prepends a persona to the prep-card
  system prompt and keys the Redis cache per style.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = "0044"
down_revision: str | None = "0043"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "curation_card_feedback",
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
            "card_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("curation_cards.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("action", sa.String(length=16), nullable=False),
        sa.Column(
            "created_at",
            sa.TIMESTAMP(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
        sa.CheckConstraint(
            "action IN ('helpful', 'skip', 'dismiss')",
            name="ck_curation_card_feedback_action",
        ),
        sa.UniqueConstraint("user_id", "card_id", name="uq_curation_feedback_user_card"),
    )
    # Deprioritization counts skip/dismiss per user across their feedback rows.
    op.create_index(
        "idx_curation_feedback_user",
        "curation_card_feedback",
        ["user_id"],
    )

    op.create_table(
        "user_ai_preferences",
        sa.Column(
            "user_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            primary_key=True,
        ),
        sa.Column(
            "card_style",
            sa.String(length=32),
            nullable=False,
            server_default=sa.text("'motivational'"),
        ),
        sa.Column(
            "updated_at",
            sa.TIMESTAMP(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
    )


def downgrade() -> None:
    op.drop_table("user_ai_preferences")
    op.drop_index("idx_curation_feedback_user", table_name="curation_card_feedback")
    op.drop_table("curation_card_feedback")

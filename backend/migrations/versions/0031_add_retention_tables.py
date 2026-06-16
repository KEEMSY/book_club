"""Add retention tables and last_active_at to users (M46).

Revision ID: 0031
Revises: 0030
Create Date: 2026-06-16

``reengagement_push_logs`` records every re-engagement push sent. Duplicate
suppression (one per user/push_type/day) is enforced at the service layer via
a guarded INSERT — a per-timezone TIMESTAMPTZ cast cannot be made IMMUTABLE so
a DB-level expression unique index is not used.

``streak_recovery_logs`` records each streak-recovery event. The service
enforces a monthly limit (≤ 2 per 30 days) by counting rows here.

``users.last_active_at`` tracks the last authenticated request timestamp.
Populated by ``LastActiveMiddleware`` via a Redis-debounced DB write (TTL 60 s).
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = "0031"
down_revision: str | None = "0030"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    # last_active_at on users — DEFAULT now() so existing rows get a sensible value.
    op.add_column(
        "users",
        sa.Column(
            "last_active_at",
            sa.DateTime(timezone=True),
            nullable=True,
            server_default=sa.text("now()"),
        ),
    )

    # Re-engagement push log — one row per (user, push_type, calendar-day).
    op.create_table(
        "reengagement_push_logs",
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
        sa.Column("push_type", sa.String(32), nullable=False),
        sa.Column(
            "sent_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
    )
    op.create_index(
        "idx_reengagement_user",
        "reengagement_push_logs",
        ["user_id", "sent_at"],
    )

    # Streak recovery log — enforces the 2/30-day limit at the service layer.
    op.create_table(
        "streak_recovery_logs",
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
            "recovered_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
        sa.Column(
            "days_recovered",
            sa.Integer(),
            nullable=False,
            server_default=sa.text("1"),
        ),
    )
    op.create_index(
        "idx_streak_recovery_user",
        "streak_recovery_logs",
        ["user_id", "recovered_at"],
    )


def downgrade() -> None:
    op.drop_index("idx_streak_recovery_user", table_name="streak_recovery_logs")
    op.drop_table("streak_recovery_logs")
    op.drop_index("idx_reengagement_user", table_name="reengagement_push_logs")
    op.drop_table("reengagement_push_logs")
    op.drop_column("users", "last_active_at")

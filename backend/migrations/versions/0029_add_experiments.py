"""Add experiments and user_experiments tables for A/B experiment infra (M43).

Revision ID: 0029
Revises: 0028
Create Date: 2026-06-15

``experiments`` stores named experiment definitions with a JSON variants list.
``user_experiments`` records each user's deterministic variant assignment and
an optional ``converted_at`` timestamp written when the user converts to Pro.
The composite UNIQUE constraint on (user_id, experiment_key) ensures a single
assignment per user per experiment.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = "0029"
down_revision: str | None = "0028"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "experiments",
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column("experiment_key", sa.String(64), nullable=False, unique=True),
        sa.Column("description", sa.Text, nullable=True),
        sa.Column("variants", postgresql.JSONB(astext_type=sa.Text()), nullable=False),
        sa.Column(
            "is_active",
            sa.Boolean,
            nullable=False,
            server_default=sa.text("true"),
        ),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
    )

    op.create_table(
        "user_experiments",
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
        sa.Column("experiment_key", sa.String(64), nullable=False),
        sa.Column("variant", sa.String(64), nullable=False),
        sa.Column(
            "assigned_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
        sa.Column("converted_at", sa.DateTime(timezone=True), nullable=True),
        sa.UniqueConstraint("user_id", "experiment_key", name="uq_user_experiments_user_key"),
    )
    op.create_index(
        "idx_user_experiments_user",
        "user_experiments",
        ["user_id"],
    )
    op.create_index(
        "idx_user_experiments_key",
        "user_experiments",
        ["experiment_key"],
    )


def downgrade() -> None:
    op.drop_index("idx_user_experiments_key", table_name="user_experiments")
    op.drop_index("idx_user_experiments_user", table_name="user_experiments")
    op.drop_table("user_experiments")
    op.drop_table("experiments")

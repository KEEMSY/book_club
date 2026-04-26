"""social tables — follows, blocks, reports + users.bio.

Revision ID: 0008_social_tables
Revises: 0007_grade_tier
Create Date: 2026-04-26

Adds the social-graph tables required by M7:

- ``users.bio`` VARCHAR(200): optional user bio field.
- ``follows`` (follower_id, followee_id) with self-follow check and UNIQUE
  pair. Indexed on followee_id for follower-count queries.
- ``blocks`` (blocker_id, blocked_id) with self-block check and UNIQUE pair.
- ``reports`` (reporter_id, target_type, target_id, reason) with composite
  index on (reporter_id, target_type, target_id) for duplicate detection.

Design choices:
- All FKs use ON DELETE CASCADE — social edges disappear automatically when
  a user account is hard-deleted.
- Self-referential CHECKs are plain SQL expressions; Alembic supports these
  on Postgres without extra migration help.
- native_enum=False is not applicable here since reports.target_type is
  stored as a plain VARCHAR (values: 'post', 'comment', 'user') — no
  SQLAlchemy Enum type is used.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision: str = "0008_social_tables"
down_revision: str | None = "0007_grade_tier"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    # --- users.bio -----------------------------------------------------------
    op.add_column(
        "users",
        sa.Column("bio", sa.String(200), nullable=True),
    )

    # --- follows -------------------------------------------------------------
    op.create_table(
        "follows",
        sa.Column(
            "id",
            sa.dialects.postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "follower_id",
            sa.dialects.postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "followee_id",
            sa.dialects.postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
        sa.UniqueConstraint("follower_id", "followee_id", name="uq_follows_pair"),
        sa.CheckConstraint("follower_id != followee_id", name="ck_follows_no_self"),
    )
    # Reverse direction index: "who follows me?" queries scan on followee_id.
    op.create_index("ix_follows_followee_id", "follows", ["followee_id"])

    # --- blocks --------------------------------------------------------------
    op.create_table(
        "blocks",
        sa.Column(
            "id",
            sa.dialects.postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "blocker_id",
            sa.dialects.postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "blocked_id",
            sa.dialects.postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
        sa.UniqueConstraint("blocker_id", "blocked_id", name="uq_blocks_pair"),
        sa.CheckConstraint("blocker_id != blocked_id", name="ck_blocks_no_self"),
    )

    # --- reports -------------------------------------------------------------
    op.create_table(
        "reports",
        sa.Column(
            "id",
            sa.dialects.postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "reporter_id",
            sa.dialects.postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        # 'post' | 'comment' | 'user'
        sa.Column("target_type", sa.String(16), nullable=False),
        sa.Column(
            "target_id",
            sa.dialects.postgresql.UUID(as_uuid=True),
            nullable=False,
        ),
        sa.Column("reason", sa.String(500), nullable=False),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
    )
    # Duplicate-report guard: quick lookup on (reporter, target_type, target_id).
    op.create_index(
        "ix_reports_reporter_target",
        "reports",
        ["reporter_id", "target_type", "target_id"],
    )


def downgrade() -> None:
    op.drop_index("ix_reports_reporter_target", table_name="reports")
    op.drop_table("reports")
    op.drop_table("blocks")
    op.drop_index("ix_follows_followee_id", table_name="follows")
    op.drop_table("follows")
    op.drop_column("users", "bio")

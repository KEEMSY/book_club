"""notification tables — notifications, weekly_reports.

Revision ID: 0006_notification_tables
Revises: 0005_feed_tables
Create Date: 2026-04-25

Introduces the notification domain schema for Milestone 5.

Design choices:
- ``notifications.data`` is JSONB (not TEXT) so the mobile client can
  decode routing payloads (post_id, comment_id, etc.) without a second
  parse step. Server default ``'{}'::jsonb`` ensures NOT NULL without
  application-side defaults on INSERT.
- ``notifications (user_id, created_at)`` composite index drives the
  cursor-based inbox pagination (ORDER BY created_at DESC).
- ``weekly_reports UNIQUE(user_id, week_start)`` makes the Sunday batch
  job idempotent — a re-run after a crash safely upserts existing rows.
- All FKs use ``ON DELETE CASCADE`` — when a User is hard-deleted their
  notifications and reports follow without a manual prune job.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects.postgresql import JSONB

# revision identifiers, used by Alembic.
revision: str = "0006_notification_tables"
down_revision: str | None = "0005_feed_tables"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "notifications",
        sa.Column("id", sa.UUID(as_uuid=True), primary_key=True, nullable=False),
        sa.Column(
            "user_id",
            sa.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("ntype", sa.String(length=32), nullable=False),
        sa.Column("title", sa.String(length=256), nullable=False),
        sa.Column("body", sa.String(length=512), nullable=False),
        sa.Column(
            "data",
            JSONB,
            nullable=False,
            server_default=sa.text("'{}'::jsonb"),
        ),
        sa.Column("read_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
    )
    op.create_index("ix_notifications_user_id", "notifications", ["user_id"])
    op.create_index(
        "ix_notifications_user_created",
        "notifications",
        ["user_id", "created_at"],
    )

    op.create_table(
        "weekly_reports",
        sa.Column("id", sa.UUID(as_uuid=True), primary_key=True, nullable=False),
        sa.Column(
            "user_id",
            sa.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("week_start", sa.Date(), nullable=False),
        sa.Column("total_seconds", sa.Integer(), nullable=False, server_default="0"),
        sa.Column("session_count", sa.Integer(), nullable=False, server_default="0"),
        sa.Column("best_day", sa.Date(), nullable=True),
        sa.Column(
            "longest_session_sec", sa.Integer(), nullable=False, server_default="0"
        ),
        sa.Column("push_sent_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.UniqueConstraint(
            "user_id", "week_start", name="uq_weekly_reports_user_week"
        ),
    )
    op.create_index("ix_weekly_reports_user_id", "weekly_reports", ["user_id"])


def downgrade() -> None:
    op.drop_index("ix_weekly_reports_user_id", table_name="weekly_reports")
    op.drop_table("weekly_reports")

    op.drop_index("ix_notifications_user_created", table_name="notifications")
    op.drop_index("ix_notifications_user_id", table_name="notifications")
    op.drop_table("notifications")

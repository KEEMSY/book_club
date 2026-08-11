"""BC-91 — notification_preferences table (per-type inbox/push opt-outs).

One row per user. ``overrides`` is a sparse JSONB map of NotificationType
value -> bool; a missing key means "on" (the default) so introducing a new
NotificationType later never requires a backfill — every existing row simply
defaults that new type to enabled. Required types (billing/trial reminders)
are never looked up against this table at all (see
``app.domains.notification.models.REQUIRED_NOTIFICATION_TYPES``).
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = "0054"
down_revision: str | None = "0053"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "notification_preferences",
        sa.Column("user_id", sa.UUID(as_uuid=True), nullable=False),
        sa.Column(
            "overrides",
            postgresql.JSONB(astext_type=sa.Text()),
            nullable=False,
            server_default="{}",
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.func.now(),
        ),
        sa.ForeignKeyConstraint(["user_id"], ["users.id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("user_id"),
    )


def downgrade() -> None:
    op.drop_table("notification_preferences")

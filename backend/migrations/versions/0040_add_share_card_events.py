"""Add share_card_events for the SNS viral loop (M62).

M62 turns the basic M51 SNS share into a tracked growth channel: every share
of a certification card records which template (``card_type``) was shared, to
which ``platform``, and under which ``referral_code``. The (user_id, created_at
DESC) index powers the admin share-stats query and per-user share history.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = "0040"
down_revision: str | None = "0039"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "share_card_events",
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
        sa.Column("card_type", sa.String(length=32), nullable=False),
        sa.Column("platform", sa.String(length=32), nullable=True),
        sa.Column("referral_code", sa.String(length=16), nullable=True),
        sa.Column(
            "created_at",
            sa.TIMESTAMP(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
    )
    op.create_index(
        "idx_share_events_user",
        "share_card_events",
        ["user_id", sa.text("created_at DESC")],
    )


def downgrade() -> None:
    op.drop_index("idx_share_events_user", table_name="share_card_events")
    op.drop_table("share_card_events")

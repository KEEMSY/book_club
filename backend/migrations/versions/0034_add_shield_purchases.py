"""Add shield_purchases table for consumable IAP (M49).

Revision ID: 0034
Revises: 0033
Create Date: 2026-06-16

Records every streak-shield IAP transaction.  ``refunded_at`` is set by the
refund webhook handler so we can reconstruct the user's shield balance at any
point in time.

The composite index on (user_id, purchased_at) covers the two most common
access patterns: purchase history listing and balance reconstruction.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = "0034"
down_revision: str | None = "0033"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "shield_purchases",
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
        sa.Column("product_id", sa.String(64), nullable=False),
        sa.Column("shields_granted", sa.Integer, nullable=False),
        sa.Column("receipt_data", sa.Text, nullable=False),
        sa.Column(
            "purchased_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
        sa.Column("refunded_at", sa.DateTime(timezone=True), nullable=True),
    )
    op.create_index(
        "idx_shield_purchases_user",
        "shield_purchases",
        ["user_id", "purchased_at"],
    )


def downgrade() -> None:
    op.drop_index("idx_shield_purchases_user", table_name="shield_purchases")
    op.drop_table("shield_purchases")

"""add referral system

Revision ID: 0020
Revises: 91b769cdb6c4
Create Date: 2026-06-12

"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects.postgresql import UUID

# revision identifiers, used by Alembic.
revision: str = "0020"
down_revision: str | None = "91b769cdb6c4"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    # Add referral_code column to users
    op.add_column(
        "users",
        sa.Column("referral_code", sa.String(8), nullable=True),
    )
    op.create_unique_constraint("uq_users_referral_code", "users", ["referral_code"])

    # Create referrals table
    op.create_table(
        "referrals",
        sa.Column(
            "id",
            UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "referrer_id",
            UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "referee_id",
            UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="SET NULL"),
            nullable=True,
        ),
        sa.Column("code", sa.String(8), nullable=False),
        sa.Column(
            "created_at",
            sa.TIMESTAMP(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
        sa.Column("completed_at", sa.TIMESTAMP(timezone=True), nullable=True),
    )
    op.create_index("idx_referrals_referrer", "referrals", ["referrer_id"])
    op.create_index("idx_referrals_code", "referrals", ["code"])


def downgrade() -> None:
    op.drop_index("idx_referrals_code", table_name="referrals")
    op.drop_index("idx_referrals_referrer", table_name="referrals")
    op.drop_table("referrals")
    op.drop_constraint("uq_users_referral_code", "users", type_="unique")
    op.drop_column("users", "referral_code")

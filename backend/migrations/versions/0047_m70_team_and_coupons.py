"""M70 monetization phase 2 — B2B team plans and re-engagement coupons.

Three tables back the B2B team-plan MVP and the expiry re-engagement campaign:

- ``team_subscriptions`` — one row per contracted team. The admin holds the
  contract; ``seat_count`` caps how many members (admin included) the team can
  grant Pro to, and the ``valid_from``/``valid_until`` window mirrors the Pro
  entitlement period granted to each member.
- ``team_members`` — the seat roster. ``ON DELETE CASCADE`` on ``team_id`` drops
  the roster with the team; the ``UNIQUE(team_id, user_id)`` guard keeps a user
  from occupying two seats on the same team.
- ``discount_coupons`` — single-use re-engagement codes (``code`` is the natural
  PK). ``used_by``/``used_at`` are NULL until redeemed; the D+7 expiry batch
  issues ``REJOIN_*`` codes here before pushing them.

``down_revision`` chains onto ``0046`` (M69's pg_trgm indexes) to keep a single
linear head.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = "0047"
down_revision: str | None = "0046"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "team_subscriptions",
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column("team_name", sa.String(length=128), nullable=False),
        sa.Column(
            "admin_user_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id"),
            nullable=False,
        ),
        sa.Column("seat_count", sa.Integer(), nullable=False, server_default=sa.text("10")),
        sa.Column(
            "plan_type",
            sa.String(length=32),
            nullable=False,
            server_default=sa.text("'annual_team'"),
        ),
        sa.Column("valid_from", sa.TIMESTAMP(timezone=True), nullable=False),
        sa.Column("valid_until", sa.TIMESTAMP(timezone=True), nullable=False),
        sa.Column(
            "created_at",
            sa.TIMESTAMP(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
    )
    # The admin dashboard lists a user's owned teams; index by admin for it.
    op.create_index("idx_team_subscriptions_admin", "team_subscriptions", ["admin_user_id"])

    op.create_table(
        "team_members",
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "team_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("team_subscriptions.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "user_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "joined_at",
            sa.TIMESTAMP(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
        sa.UniqueConstraint("team_id", "user_id", name="uq_team_members_team_user"),
    )
    # Seat-count checks and the roster read both filter by team_id.
    op.create_index("idx_team_members_team", "team_members", ["team_id"])

    op.create_table(
        "discount_coupons",
        sa.Column("code", sa.String(length=32), primary_key=True),
        sa.Column("discount_pct", sa.Integer(), nullable=False),
        sa.Column("valid_days", sa.Integer(), nullable=False, server_default=sa.text("30")),
        sa.Column(
            "used_by",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id"),
            nullable=True,
        ),
        sa.Column("used_at", sa.TIMESTAMP(timezone=True), nullable=True),
        sa.Column(
            "created_at",
            sa.TIMESTAMP(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
    )


def downgrade() -> None:
    op.drop_table("discount_coupons")
    op.drop_index("idx_team_members_team", table_name="team_members")
    op.drop_table("team_members")
    op.drop_index("idx_team_subscriptions_admin", table_name="team_subscriptions")
    op.drop_table("team_subscriptions")

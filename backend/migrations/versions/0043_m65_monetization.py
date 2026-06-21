"""M65 monetization — trial window, early-bird promos, conversion events.

M65 adds three persistence surfaces backing the conversion-rate work:

- ``users.trial_started_at`` / ``users.trial_ends_at`` — the new-signup 7-day
  Pro trial window. Both nullable: rows created before this migration have no
  trial, and the service treats NULL as "not in trial".
- ``subscription_promos`` — early-bird annual campaign codes with a validity
  window. ``PromoService.get_active_promo`` selects the live one.
- ``subscription_events`` — a thin funnel/revenue event log. The mobile paywall
  emits ``paywall_view`` / ``paywall_click`` and RevenueCat webhooks land
  ``subscription`` / ``churn`` rows; the admin dashboard reads COUNT/SUM over
  this table for the conversion-funnel and revenue-metrics endpoints. The
  Phase 14 design references a ``subscription_events`` table for exactly this
  ("RevenueCat Webhook 데이터 → subscription_events 활용"); it is created here.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = "0043"
down_revision: str | None = "0042"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.add_column(
        "users",
        sa.Column("trial_started_at", sa.TIMESTAMP(timezone=True), nullable=True),
    )
    op.add_column(
        "users",
        sa.Column("trial_ends_at", sa.TIMESTAMP(timezone=True), nullable=True),
    )

    op.create_table(
        "subscription_promos",
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column("promo_code", sa.String(length=32), nullable=False),
        sa.Column("discount_pct", sa.Integer(), nullable=False),
        sa.Column("valid_from", sa.TIMESTAMP(timezone=True), nullable=False),
        sa.Column("valid_until", sa.TIMESTAMP(timezone=True), nullable=False),
        sa.Column("is_active", sa.Boolean(), server_default=sa.text("true"), nullable=False),
        sa.Column(
            "created_at",
            sa.TIMESTAMP(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
        sa.UniqueConstraint("promo_code", name="uq_subscription_promos_code"),
    )

    op.create_table(
        "subscription_events",
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
        # paywall_view | paywall_click | subscription | churn
        sa.Column("event_type", sa.String(length=32), nullable=False),
        sa.Column("product_id", sa.String(length=64), nullable=True),
        sa.Column(
            "revenue_amount",
            sa.Numeric(precision=12, scale=2),
            nullable=False,
            server_default=sa.text("0"),
        ),
        sa.Column(
            "created_at",
            sa.TIMESTAMP(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
    )
    # Funnel/revenue queries scan by event_type within a recency window.
    op.create_index(
        "idx_subscription_events_type_created",
        "subscription_events",
        ["event_type", "created_at"],
    )


def downgrade() -> None:
    op.drop_index("idx_subscription_events_type_created", table_name="subscription_events")
    op.drop_table("subscription_events")
    op.drop_table("subscription_promos")
    op.drop_column("users", "trial_ends_at")
    op.drop_column("users", "trial_started_at")

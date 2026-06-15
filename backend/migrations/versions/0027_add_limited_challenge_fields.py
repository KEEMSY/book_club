"""Add is_limited, ends_at_exclusive, and badge_id_exclusive to challenges.

Revision ID: 0027
Revises: 0026
Create Date: 2026-06-15

Adds three columns to support "limited-edition" challenges whose exclusive
badge cannot be awarded after the deadline:

- ``is_limited``        — marks a challenge as limited-edition (default false,
                          backward-compatible with all existing rows).
- ``ends_at_exclusive`` — nullable; only set when is_limited=true.
                          Formerly named badge_ends_at to avoid confusion with
                          the existing ends_at (challenge window end); using
                          this column name to avoid ambiguity.
- ``badge_id_exclusive``— nullable FK to badges(id); the limited-edition badge
                          awarded only while the challenge is within deadline.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = "0027"
down_revision: str | None = "0026"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.add_column(
        "challenges",
        sa.Column(
            "is_limited",
            sa.Boolean(),
            nullable=False,
            server_default=sa.text("false"),
        ),
    )
    op.add_column(
        "challenges",
        sa.Column(
            "ends_at_exclusive",
            sa.DateTime(timezone=True),
            nullable=True,
        ),
    )
    op.add_column(
        "challenges",
        sa.Column(
            "badge_id_exclusive",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("badges.id", ondelete="SET NULL"),
            nullable=True,
        ),
    )


def downgrade() -> None:
    op.drop_column("challenges", "badge_id_exclusive")
    op.drop_column("challenges", "ends_at_exclusive")
    op.drop_column("challenges", "is_limited")

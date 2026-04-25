"""grade tier column — user_grades.tier.

Revision ID: 0007_grade_tier
Revises: 0006_notification_tables
Create Date: 2026-04-25

Adds a ``tier`` column to ``user_grades`` that tracks the sub-level within
each grade (1–3, with grade-5 capped at tier-1).  Existing rows default to
tier=1 via the server_default so no data migration is required.

Design choices:
- ``server_default="1"`` — all existing rows receive tier=1 without a full
  table scan; the application layer will recompute the correct tier the next
  time a reading session completes for that user.
- NOT NULL with a server default satisfies the ORM's Mapped[int] type
  while keeping the migration safe for tables with millions of rows.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision: str = "0007_grade_tier"
down_revision: str | None = "0006_notification_tables"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.add_column(
        "user_grades",
        sa.Column(
            "tier",
            sa.Integer(),
            nullable=False,
            server_default="1",
        ),
    )


def downgrade() -> None:
    op.drop_column("user_grades", "tier")

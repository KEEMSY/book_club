"""add streak_shields to user_grades

Revision ID: 0016
Revises: 0015
Create Date: 2026-06-07

Adds ``streak_shields`` column to ``user_grades`` to support the M26
streak protection mechanic. Existing rows receive the default of 0.
"""

from __future__ import annotations

import sqlalchemy as sa
from alembic import op

revision = "0016"
down_revision = "1029cf1c65fe"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column(
        "user_grades",
        sa.Column(
            "streak_shields",
            sa.Integer(),
            nullable=False,
            server_default="0",
        ),
    )


def downgrade() -> None:
    op.drop_column("user_grades", "streak_shields")

"""Add is_admin and is_active columns to users.

Revision ID: 0026
Revises: 0025
Create Date: 2026-06-14

Adds:
- ``is_active`` — soft-disable an account without hard-deleting it.
  Default TRUE so existing rows are unaffected.
- ``is_admin`` — privilege flag for the M39 admin dashboard.
  Default FALSE so no existing user gains admin rights.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision: str = "0026"
down_revision: str | None = "0025"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.add_column(
        "users",
        sa.Column(
            "is_active",
            sa.Boolean(),
            nullable=False,
            server_default=sa.text("true"),
        ),
    )
    op.add_column(
        "users",
        sa.Column(
            "is_admin",
            sa.Boolean(),
            nullable=False,
            server_default=sa.text("false"),
        ),
    )


def downgrade() -> None:
    op.drop_column("users", "is_admin")
    op.drop_column("users", "is_active")

"""init — baseline empty revision to pin the Alembic head.

Revision ID: 0001_init
Revises:
Create Date: 2026-04-20

No operations: domain tables are introduced starting in Milestone 1
(0002_auth_tables.py). This revision exists so the head pointer is real
and later migrations have an unambiguous ancestor.
"""

from __future__ import annotations

from collections.abc import Sequence

# revision identifiers, used by Alembic.
revision: str = "0001_init"
down_revision: str | None = None
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    pass


def downgrade() -> None:
    pass

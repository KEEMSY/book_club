"""merge

Revision ID: 91b769cdb6c4
Revises: 0018, 0019
Create Date: 2026-06-09 10:45:13.931538

"""

from __future__ import annotations

from collections.abc import Sequence

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '91b769cdb6c4'
down_revision: str | None = ('0018', '0019')
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    pass


def downgrade() -> None:
    pass

"""add is_public to reading_clubs

Revision ID: 0021
Revises: 0020
Create Date: 2026-06-12

"""

from __future__ import annotations

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision: str = "0021"
down_revision: str = "0020"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column(
        "reading_clubs",
        sa.Column("is_public", sa.Boolean(), nullable=False, server_default="false"),
    )
    op.create_index(
        "idx_clubs_public",
        "reading_clubs",
        ["is_public"],
        postgresql_where=sa.text("is_public = true"),
    )


def downgrade() -> None:
    op.drop_index("idx_clubs_public", table_name="reading_clubs")
    op.drop_column("reading_clubs", "is_public")

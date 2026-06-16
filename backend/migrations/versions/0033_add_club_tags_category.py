"""Add category column to reading_clubs and create club_tags table (M48).

Revision ID: 0033
Revises: 0032
Create Date: 2026-06-16

Adds a ``category`` VARCHAR(32) to ``reading_clubs`` for coarse genre grouping
(e.g. '소설', '자기계발', '인문학', '과학', '기타').

Creates ``club_tags`` for many fine-grained labels per club, with a composite
UNIQUE on (club_id, tag) so duplicates are rejected at the DB level.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = "0033"
down_revision: str | None = "0032"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.add_column(
        "reading_clubs",
        sa.Column("category", sa.String(32), nullable=True),
    )

    op.create_table(
        "club_tags",
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "club_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("reading_clubs.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("tag", sa.String(32), nullable=False),
        sa.UniqueConstraint("club_id", "tag", name="uq_club_tags_club_tag"),
    )
    op.create_index("idx_club_tags_club", "club_tags", ["club_id"])
    op.create_index("idx_club_tags_tag", "club_tags", ["tag"])


def downgrade() -> None:
    op.drop_index("idx_club_tags_tag", table_name="club_tags")
    op.drop_index("idx_club_tags_club", table_name="club_tags")
    op.drop_table("club_tags")
    op.drop_column("reading_clubs", "category")

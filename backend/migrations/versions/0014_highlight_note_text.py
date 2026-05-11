"""add note_text to post_highlights

Revision ID: 0014
Revises: 0013
Create Date: 2026-05-11
"""
from __future__ import annotations
import sqlalchemy as sa
from alembic import op

revision = "0014"
down_revision = "0013"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.add_column(
        "post_highlights",
        sa.Column("note_text", sa.Text(), nullable=True),
    )


def downgrade() -> None:
    op.drop_column("post_highlights", "note_text")

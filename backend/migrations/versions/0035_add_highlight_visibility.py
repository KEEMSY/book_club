"""Add visibility / shared_at / deleted_at to post_highlights (M51).

Revision ID: 0035
Revises: 0034
Create Date: 2026-06-18

M51 lets a user promote a private highlight to the social feed. ``visibility``
gates who may see a highlight (private / followers / public) and ``shared_at``
records the moment it was pushed to the feed so a re-share is idempotent.

``deleted_at`` is added alongside because the explore index and the explore
read path filter on ``deleted_at IS NULL`` — without the column the partial
index below cannot be created. It keeps a shared (public) highlight removable
from discovery without a hard cascade.

The partial index covers the explore-recent timeline (public, live rows
ordered newest-first) so the discovery query stays index-only.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision: str = "0035"
down_revision: str | None = "0034"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.add_column(
        "post_highlights",
        sa.Column(
            "visibility",
            sa.String(16),
            nullable=False,
            server_default=sa.text("'private'"),
        ),
    )
    op.add_column(
        "post_highlights",
        sa.Column("shared_at", sa.DateTime(timezone=True), nullable=True),
    )
    op.add_column(
        "post_highlights",
        sa.Column("deleted_at", sa.DateTime(timezone=True), nullable=True),
    )
    op.create_index(
        "idx_highlights_public",
        "post_highlights",
        [sa.text("created_at DESC")],
        postgresql_where=sa.text("visibility = 'public' AND deleted_at IS NULL"),
    )


def downgrade() -> None:
    op.drop_index("idx_highlights_public", table_name="post_highlights")
    op.drop_column("post_highlights", "deleted_at")
    op.drop_column("post_highlights", "shared_at")
    op.drop_column("post_highlights", "visibility")

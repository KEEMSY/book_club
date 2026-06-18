"""Add standalone created_at index on feed_events (M55).

Revision ID: 0038
Revises: 0037
Create Date: 2026-06-18

The global feed timeline (``FeedEventRepository.list_global``) orders by
``created_at DESC`` with no ``user_id`` predicate, so the existing composite
``ix_feed_events_user_id_created_at`` index can't be used — Postgres falls back
to a full sort on every home-feed page. A standalone ``created_at`` index keeps
the timeline scan index-ordered.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision: str = "0038"
down_revision: str | None = "0037"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.create_index(
        "ix_feed_events_created_at",
        "feed_events",
        [sa.text("created_at DESC")],
    )


def downgrade() -> None:
    op.drop_index("ix_feed_events_created_at", table_name="feed_events")

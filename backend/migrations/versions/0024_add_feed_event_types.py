"""feed_events table — activity event log for M37 feed enrichment.

Revision ID: 0024
Revises: 0023
Create Date: 2026-06-13

Introduces the ``feed_events`` table that records per-user milestone
and lifecycle events surfaced in the activity feed.

Event types at creation time:
- CHAPTER_MILESTONE  — user completed a chapter that is a multiple of 5
- STREAK_MILESTONE   — user achieved a notable reading streak (3/7/14/30/60/100 days)
- BOOK_COMPLETED     — user finished reading a book
- CLUB_JOINED        — user joined a public reading club

Design choices:
- ``event_type`` is a portable VARCHAR with a CHECK constraint so adding
  types later requires only a CHECK update, not an ALTER TYPE dance.
- ``metadata`` is JSONB so each event type can carry its own payload
  (book_id, chapter, streak_days, club_id) without schema churn.
- ``created_at`` is indexed together with ``user_id`` to support timeline
  queries scoped to a user with recency ordering.
- ON DELETE CASCADE on user_id — when a user is deleted all their events
  follow automatically.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects.postgresql import JSONB

# revision identifiers, used by Alembic.
revision: str = "0024"
down_revision: str | None = "0023"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None

_EVENT_TYPES = (
    "CHAPTER_MILESTONE",
    "STREAK_MILESTONE",
    "BOOK_COMPLETED",
    "CLUB_JOINED",
)
_CHECK_EXPR = "event_type IN ({})".format(", ".join(f"'{t}'" for t in _EVENT_TYPES))


def upgrade() -> None:
    op.create_table(
        "feed_events",
        sa.Column("id", sa.UUID(as_uuid=True), primary_key=True, nullable=False),
        sa.Column(
            "user_id",
            sa.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("event_type", sa.String(length=32), nullable=False),
        sa.Column("metadata", JSONB, nullable=True),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.CheckConstraint(_CHECK_EXPR, name="ck_feed_events_event_type"),
    )
    op.create_index("ix_feed_events_user_id_created_at", "feed_events", ["user_id", "created_at"])


def downgrade() -> None:
    op.drop_index("ix_feed_events_user_id_created_at", table_name="feed_events")
    op.drop_table("feed_events")

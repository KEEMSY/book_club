"""Add feed_event_reactions and feed_comments tables (M47).

Revision ID: 0032
Revises: 0031
Create Date: 2026-06-16

``feed_event_reactions`` stores emoji reactions on feed_events (activity stream
entries). The UNIQUE on (feed_event_id, user_id, emoji) makes toggle idempotent
at the DB level without a read-before-write in the happy path.

``feed_comments`` stores threaded comments on feed_events. ``parent_id`` enables
2-depth replies; depth guard is enforced by the service layer. The composite
index on (feed_event_id, created_at) powers the comment-list timeline query.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = "0032"
down_revision: str | None = "0031"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "feed_event_reactions",
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "feed_event_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("feed_events.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "user_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("emoji", sa.String(8), nullable=False),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
        sa.UniqueConstraint(
            "feed_event_id", "user_id", "emoji", name="uq_feed_event_reactions_triple"
        ),
    )
    op.create_index(
        "idx_reactions_event",
        "feed_event_reactions",
        ["feed_event_id"],
    )

    op.create_table(
        "feed_comments",
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "feed_event_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("feed_events.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "user_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "parent_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("feed_comments.id", ondelete="CASCADE"),
            nullable=True,
        ),
        sa.Column("body", sa.Text, nullable=False),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
        sa.CheckConstraint("char_length(body) <= 500", name="ck_feed_comments_body_length"),
    )
    op.create_index(
        "idx_comments_event",
        "feed_comments",
        ["feed_event_id", "created_at"],
    )
    op.create_index(
        "idx_comments_parent",
        "feed_comments",
        ["parent_id"],
        postgresql_where=sa.text("parent_id IS NOT NULL"),
    )


def downgrade() -> None:
    op.drop_index("idx_comments_parent", table_name="feed_comments")
    op.drop_index("idx_comments_event", table_name="feed_comments")
    op.drop_table("feed_comments")
    op.drop_index("idx_reactions_event", table_name="feed_event_reactions")
    op.drop_table("feed_event_reactions")

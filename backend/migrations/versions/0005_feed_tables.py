"""feed tables — posts, reactions, comments.

Revision ID: 0005_feed_tables
Revises: 0004_reading_tables
Create Date: 2026-04-25

Introduces the feed domain schema for Milestone 4.

Design choices:
- Portable string enums (``native_enum=False``) for ``post_type`` and
  ``reaction_type`` mirror the auth/book/reading convention so adding a
  new flavour or emoji is a one-line schema tweak rather than ALTER TYPE.
- ``posts.image_keys`` is ``TEXT[]`` of R2 object keys (never URLs). The
  read path materialises short-lived signed URLs on demand so the DB never
  holds time-bounded credentials.
- ``posts.deleted_at`` enables author-soft-delete and moderation hide
  flows. The list query filters ``deleted_at IS NULL`` so soft-deleted
  rows disappear from the timeline without a hard cascade.
- ``reactions UNIQUE(post_id, user_id, reaction_type)`` makes the toggle
  flow trivial — a duplicate INSERT collapses to IntegrityError, which the
  repo treats as idempotent (returns the existing row).
- ``comments.parent_id`` cascades on parent deletion. Depth is enforced at
  the service layer (1단계 답글만) — a SQL CHECK with subquery is awkward
  on this table and a service guard plus the (post_id, created_at) index
  is sufficient.
- All FKs use ``ON DELETE CASCADE`` — when a Post or User goes away, its
  reactions and comments must follow.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects.postgresql import ARRAY

# revision identifiers, used by Alembic.
revision: str = "0005_feed_tables"
down_revision: str | None = "0004_reading_tables"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "posts",
        sa.Column("id", sa.UUID(as_uuid=True), primary_key=True, nullable=False),
        sa.Column(
            "book_id",
            sa.UUID(as_uuid=True),
            sa.ForeignKey("books.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "user_id",
            sa.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("post_type", sa.String(length=16), nullable=False),
        sa.Column("content", sa.Text(), nullable=False),
        sa.Column(
            "image_keys",
            ARRAY(sa.Text()),
            nullable=False,
            server_default=sa.text("'{}'::text[]"),
        ),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.Column("deleted_at", sa.DateTime(timezone=True), nullable=True),
        sa.CheckConstraint(
            "post_type IN ('highlight', 'thought', 'question', 'discussion')",
            name="ck_posts_post_type",
        ),
    )
    op.create_index("ix_posts_book_id", "posts", ["book_id"])
    op.create_index("ix_posts_user_id", "posts", ["user_id"])
    op.create_index("ix_posts_book_created", "posts", ["book_id", "created_at"])

    op.create_table(
        "reactions",
        sa.Column("id", sa.UUID(as_uuid=True), primary_key=True, nullable=False),
        sa.Column(
            "post_id",
            sa.UUID(as_uuid=True),
            sa.ForeignKey("posts.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "user_id",
            sa.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("reaction_type", sa.String(length=16), nullable=False),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.CheckConstraint(
            "reaction_type IN ('idea', 'fire', 'think', 'clap', 'heart')",
            name="ck_reactions_reaction_type",
        ),
        sa.UniqueConstraint(
            "post_id",
            "user_id",
            "reaction_type",
            name="uq_reactions_triple",
        ),
    )
    op.create_index("ix_reactions_post_id", "reactions", ["post_id"])
    op.create_index("ix_reactions_user_id", "reactions", ["user_id"])

    op.create_table(
        "comments",
        sa.Column("id", sa.UUID(as_uuid=True), primary_key=True, nullable=False),
        sa.Column(
            "post_id",
            sa.UUID(as_uuid=True),
            sa.ForeignKey("posts.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "user_id",
            sa.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "parent_id",
            sa.UUID(as_uuid=True),
            sa.ForeignKey("comments.id", ondelete="CASCADE"),
            nullable=True,
        ),
        sa.Column("content", sa.Text(), nullable=False),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.Column("deleted_at", sa.DateTime(timezone=True), nullable=True),
    )
    op.create_index("ix_comments_post_id", "comments", ["post_id"])
    op.create_index("ix_comments_user_id", "comments", ["user_id"])
    op.create_index("ix_comments_parent_id", "comments", ["parent_id"])
    op.create_index("ix_comments_post_created", "comments", ["post_id", "created_at"])


def downgrade() -> None:
    op.drop_index("ix_comments_post_created", table_name="comments")
    op.drop_index("ix_comments_parent_id", table_name="comments")
    op.drop_index("ix_comments_user_id", table_name="comments")
    op.drop_index("ix_comments_post_id", table_name="comments")
    op.drop_table("comments")

    op.drop_index("ix_reactions_user_id", table_name="reactions")
    op.drop_index("ix_reactions_post_id", table_name="reactions")
    op.drop_table("reactions")

    op.drop_index("ix_posts_book_created", table_name="posts")
    op.drop_index("ix_posts_user_id", table_name="posts")
    op.drop_index("ix_posts_book_id", table_name="posts")
    op.drop_table("posts")

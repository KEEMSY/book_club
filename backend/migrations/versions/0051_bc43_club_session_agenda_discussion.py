"""BC-43 — club sessions, agendas, topics, and topic threads.

BC-42 epic (docs/plans/2026-08-04-club-agenda-discussion-design.md §4) lifts
club discussion from progress-gated chat (``ClubRoom``/``ClubMessage``) onto
structured, book-scoped rounds:

    club_sessions -> session_agendas -> agenda_topics -> topic_comments

Four new tables, all FK-cascading from ``club_sessions`` down so deleting a
session (or a club) cleans up its agenda/topics/threads automatically.
``topic_comments.parent_comment_id`` self-references with ON DELETE CASCADE
so removing a top-level reply also removes the (single-level, per design §2)
sub-replies hanging off it — same convention as ``feed.comments``.

Also adds the monetization hook columns from design §4.2 (columns only, no
logic, no index — reserved for a future paid-club/paid-session epic):
- ``reading_clubs.access_type`` / ``reading_clubs.join_price_cents``
- ``club_sessions.access_tier`` / ``club_sessions.price_cents`` (part of the
  ``club_sessions`` CREATE TABLE below, not a separate ALTER)

Status columns (``club_sessions.status``, ``session_agendas.status``) are
portable VARCHAR + CHECK, matching the ``feed_events``/``event_attendees``
convention in this codebase — adding a status value later needs only a CHECK
update, not an ALTER TYPE dance. ``agenda_topics``/``topic_comments`` carry no
status of their own (design §4.1).
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = "0051"
down_revision: str | None = "0050"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "club_sessions",
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
        sa.Column(
            "book_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("books.id"),
            nullable=False,
        ),
        sa.Column("title", sa.String(length=200), nullable=False),
        sa.Column("scope", sa.Text(), nullable=True),
        sa.Column(
            "presenter_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="SET NULL"),
            nullable=True,
        ),
        sa.Column("scheduled_at", sa.TIMESTAMP(timezone=True), nullable=True),
        sa.Column("status", sa.String(length=12), nullable=False, server_default="draft"),
        # Monetization hook (design §4.2) — unused until the paid-session epic.
        sa.Column("access_tier", sa.String(length=16), nullable=False, server_default="included"),
        sa.Column("price_cents", sa.Integer(), nullable=True),
        sa.Column(
            "created_by",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "created_at",
            sa.TIMESTAMP(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
        sa.CheckConstraint("status IN ('draft', 'open', 'closed')", name="ck_club_sessions_status"),
    )
    op.create_index("ix_club_sessions_club_id", "club_sessions", ["club_id"])
    op.create_index("ix_club_sessions_book_id", "club_sessions", ["book_id"])

    op.create_table(
        "session_agendas",
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "session_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("club_sessions.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "author_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("body", sa.Text(), nullable=False),
        sa.Column("status", sa.String(length=12), nullable=False, server_default="draft"),
        sa.Column("published_at", sa.TIMESTAMP(timezone=True), nullable=True),
        sa.Column(
            "created_at",
            sa.TIMESTAMP(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
        sa.CheckConstraint("status IN ('draft', 'published')", name="ck_session_agendas_status"),
    )
    op.create_index("ix_session_agendas_session_id", "session_agendas", ["session_id"])

    op.create_table(
        "agenda_topics",
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "agenda_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("session_agendas.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("position", sa.Integer(), nullable=False),
        sa.Column("prompt", sa.Text(), nullable=False),
        sa.Column(
            "created_at",
            sa.TIMESTAMP(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
    )
    op.create_index("ix_agenda_topics_agenda_id", "agenda_topics", ["agenda_id"])

    op.create_table(
        "topic_comments",
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "topic_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("agenda_topics.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "author_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "parent_comment_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("topic_comments.id", ondelete="CASCADE"),
            nullable=True,
        ),
        sa.Column("body", sa.Text(), nullable=False),
        sa.Column(
            "created_at",
            sa.TIMESTAMP(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
        sa.Column("edited_at", sa.TIMESTAMP(timezone=True), nullable=True),
    )
    op.create_index("ix_topic_comments_topic_id", "topic_comments", ["topic_id"])
    op.create_index("ix_topic_comments_parent_comment_id", "topic_comments", ["parent_comment_id"])

    # Monetization hooks (design §4.2) — reading_clubs side. Columns only.
    op.add_column(
        "reading_clubs",
        sa.Column("access_type", sa.String(length=16), nullable=False, server_default="open"),
    )
    op.add_column(
        "reading_clubs",
        sa.Column("join_price_cents", sa.Integer(), nullable=True),
    )


def downgrade() -> None:
    op.drop_column("reading_clubs", "join_price_cents")
    op.drop_column("reading_clubs", "access_type")

    op.drop_index("ix_topic_comments_parent_comment_id", table_name="topic_comments")
    op.drop_index("ix_topic_comments_topic_id", table_name="topic_comments")
    op.drop_table("topic_comments")

    op.drop_index("ix_agenda_topics_agenda_id", table_name="agenda_topics")
    op.drop_table("agenda_topics")

    op.drop_index("ix_session_agendas_session_id", table_name="session_agendas")
    op.drop_table("session_agendas")

    op.drop_index("ix_club_sessions_book_id", table_name="club_sessions")
    op.drop_index("ix_club_sessions_club_id", table_name="club_sessions")
    op.drop_table("club_sessions")

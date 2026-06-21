"""Add standalone location-based events, waitlist & reviews (M64).

M64 introduces *번개 모임* — location-based offline meetups that can exist
without a reading club. The existing ``club_events`` table (owned by the club
domain) stays untouched; it models club-scoped RSVP events. This migration
creates a separate ``events`` table owned by the new ``event`` domain.

Design notes:
- ``cube`` + ``earthdistance`` are lightweight Postgres contrib extensions
  (unlike PostGIS) and ship with Fly.io's default Postgres, so enabling them
  is safe and keeps an ``earth_distance`` SQL path available. The service,
  however, computes proximity with an application-level Haversine over a
  cheap lat/lng bounding-box prefilter — no extension dependency on the hot
  path, and the distance maths stays unit-testable without a database
  (CLAUDE.md §5).
- ``club_id`` is nullable: a 번개 모임 needs no club. ``book_id`` and
  ``category`` back the mobile book-selection and genre filter.
- ``event_waitlist`` doubles as the attendance list: rows ordered by
  ``queued_at``; the first ``max_attendees`` are confirmed attendees, the rest
  wait. A NULL ``max_attendees`` means unlimited capacity.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = "0042"
down_revision: str | None = "0041"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    # Enable proximity extensions (contrib modules, available on Fly.io's
    # default Postgres). Kept for an optional earth_distance SQL path; the
    # service uses application-level Haversine on the hot path.
    op.execute("CREATE EXTENSION IF NOT EXISTS cube")
    op.execute("CREATE EXTENSION IF NOT EXISTS earthdistance")

    op.create_table(
        "events",
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "creator_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        # NULL — 번개 모임 is created without a club. SET NULL keeps the event
        # alive if its host club is later deleted.
        sa.Column(
            "club_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("reading_clubs.id", ondelete="SET NULL"),
            nullable=True,
        ),
        sa.Column(
            "book_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("books.id", ondelete="SET NULL"),
            nullable=True,
        ),
        sa.Column("title", sa.String(length=200), nullable=False),
        sa.Column("description", sa.Text(), nullable=True),
        sa.Column("address", sa.Text(), nullable=True),
        sa.Column("lat", sa.Double(), nullable=True),
        sa.Column("lng", sa.Double(), nullable=True),
        # Coarse genre, mirrors reading_clubs.category for the nearby filter.
        sa.Column("category", sa.String(length=32), nullable=True),
        sa.Column("event_at", sa.TIMESTAMP(timezone=True), nullable=False),
        sa.Column("max_attendees", sa.Integer(), nullable=True),
        sa.Column("is_public", sa.Boolean(), server_default=sa.text("true"), nullable=False),
        sa.Column("deleted_at", sa.TIMESTAMP(timezone=True), nullable=True),
        sa.Column(
            "created_at",
            sa.TIMESTAMP(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
    )
    # Bounding-box prefilter for nearby search scans lat/lng of live public events.
    op.create_index(
        "idx_events_public_coords",
        "events",
        ["is_public", "lat", "lng"],
    )

    op.create_table(
        "event_waitlist",
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "event_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("events.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "user_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "queued_at",
            sa.TIMESTAMP(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
        sa.UniqueConstraint("event_id", "user_id", name="uq_event_waitlist_event_user"),
    )
    # Capacity/position is determined by queued_at order within an event.
    op.create_index(
        "idx_event_waitlist_event_queued",
        "event_waitlist",
        ["event_id", "queued_at"],
    )

    op.create_table(
        "event_reviews",
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "event_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("events.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "reviewer_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("rating", sa.Numeric(precision=2, scale=1), nullable=False),
        sa.Column("body", sa.Text(), nullable=True),
        sa.Column(
            "created_at",
            sa.TIMESTAMP(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
        sa.UniqueConstraint("event_id", "reviewer_id", name="uq_event_reviews_event_reviewer"),
    )
    op.create_index("idx_event_reviews_event", "event_reviews", ["event_id"])


def downgrade() -> None:
    op.drop_index("idx_event_reviews_event", table_name="event_reviews")
    op.drop_table("event_reviews")
    op.drop_index("idx_event_waitlist_event_queued", table_name="event_waitlist")
    op.drop_table("event_waitlist")
    op.drop_index("idx_events_public_coords", table_name="events")
    op.drop_table("events")
    # Leave cube/earthdistance installed — other objects may rely on them and
    # dropping shared extensions on downgrade is unsafe.

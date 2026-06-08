"""m30: offline meeting events — reshape club_events, add event_attendees

Revision ID: 0017
Revises: 0016
Create Date: 2026-06-08

Changes:
- club_events: rename scheduled_at -> event_at, drop event_type,
  change location to VARCHAR(300), add max_attendees SMALLINT nullable
- Rename event_rsvps -> event_attendees, add CHECK constraint on status,
  rename PK constraint
"""

from __future__ import annotations

import sqlalchemy as sa
from alembic import op

revision = "0017"
down_revision = "0016"
branch_labels = None
depends_on = None


def upgrade() -> None:
    # --- reshape club_events ---

    # Rename scheduled_at -> event_at
    op.alter_column("club_events", "scheduled_at", new_column_name="event_at")

    # Drop event_type column (offline meeting context makes it implicit)
    op.drop_column("club_events", "event_type")

    # Change location from Text to VARCHAR(300)
    op.alter_column(
        "club_events",
        "location",
        type_=sa.String(300),
        existing_type=sa.Text(),
        existing_nullable=True,
    )

    # Add max_attendees
    op.add_column(
        "club_events",
        sa.Column("max_attendees", sa.SmallInteger(), nullable=True),
    )

    # --- rename event_rsvps -> event_attendees ---
    op.rename_table("event_rsvps", "event_attendees")

    # Rename the primary key constraint (Postgres requires drop+recreate)
    op.execute("ALTER TABLE event_attendees DROP CONSTRAINT pk_event_rsvps")
    op.execute(
        "ALTER TABLE event_attendees"
        " ADD CONSTRAINT pk_event_attendees PRIMARY KEY (event_id, user_id)"
    )

    # Add CHECK constraint on status
    op.create_check_constraint(
        "ck_event_attendees_status",
        "event_attendees",
        "status IN ('going', 'maybe', 'not_going')",
    )

    # Rename responded_at default — column already has server_default; no-op needed.
    # Ensure the column is VARCHAR(12) to match the spec
    op.alter_column(
        "event_attendees",
        "status",
        type_=sa.String(12),
        existing_type=sa.String(20),
        existing_nullable=False,
    )


def downgrade() -> None:
    # Restore event_attendees -> event_rsvps
    op.drop_constraint("ck_event_attendees_status", "event_attendees", type_="check")
    op.execute("ALTER TABLE event_attendees DROP CONSTRAINT pk_event_attendees")
    op.execute(
        "ALTER TABLE event_attendees"
        " ADD CONSTRAINT pk_event_rsvps PRIMARY KEY (event_id, user_id)"
    )
    op.alter_column(
        "event_attendees",
        "status",
        type_=sa.String(20),
        existing_type=sa.String(12),
        existing_nullable=False,
    )
    op.rename_table("event_attendees", "event_rsvps")

    # Restore club_events
    op.drop_column("club_events", "max_attendees")
    op.alter_column(
        "club_events",
        "location",
        type_=sa.Text(),
        existing_type=sa.String(300),
        existing_nullable=True,
    )
    op.add_column(
        "club_events",
        sa.Column("event_type", sa.String(20), nullable=False, server_default="offline"),
    )
    op.alter_column("club_events", "event_at", new_column_name="scheduled_at")

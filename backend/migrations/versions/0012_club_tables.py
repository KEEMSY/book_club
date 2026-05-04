"""club tables

Revision ID: 0012
Revises: 0011_post_highlights
Create Date: 2026-05-02
"""
from alembic import op
import sqlalchemy as sa

revision = "0012"
down_revision = "0011_post_highlights"
branch_labels = None
depends_on = None


def upgrade() -> None:
    op.create_table(
        "reading_clubs",
        sa.Column("id", sa.UUID(), nullable=False, primary_key=True),
        sa.Column("name", sa.String(100), nullable=False),
        sa.Column("description", sa.Text(), nullable=True),
        sa.Column("owner_id", sa.UUID(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False),
        sa.Column("book_id", sa.UUID(), sa.ForeignKey("books.id", ondelete="SET NULL"), nullable=True),
        sa.Column("invite_code", sa.String(16), nullable=False, unique=True),
        sa.Column("max_members", sa.SmallInteger(), nullable=False, server_default="10"),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
    )
    op.create_index("ix_reading_clubs_owner_id", "reading_clubs", ["owner_id"])

    op.create_table(
        "club_members",
        sa.Column("club_id", sa.UUID(), sa.ForeignKey("reading_clubs.id", ondelete="CASCADE"), nullable=False),
        sa.Column("user_id", sa.UUID(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False),
        sa.Column("role", sa.String(20), nullable=False, server_default="member"),
        sa.Column("joined_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.PrimaryKeyConstraint("club_id", "user_id", name="pk_club_members"),
    )
    op.create_index("ix_club_members_user_id", "club_members", ["user_id"])

    op.create_table(
        "club_events",
        sa.Column("id", sa.UUID(), nullable=False, primary_key=True),
        sa.Column("club_id", sa.UUID(), sa.ForeignKey("reading_clubs.id", ondelete="CASCADE"), nullable=False),
        sa.Column("title", sa.String(200), nullable=False),
        sa.Column("description", sa.Text(), nullable=True),
        sa.Column("event_type", sa.String(20), nullable=False),  # 'online' | 'offline'
        sa.Column("location", sa.Text(), nullable=True),
        sa.Column("scheduled_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("created_by", sa.UUID(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
    )
    op.create_index("ix_club_events_club_id", "club_events", ["club_id"])

    op.create_table(
        "event_rsvps",
        sa.Column("event_id", sa.UUID(), sa.ForeignKey("club_events.id", ondelete="CASCADE"), nullable=False),
        sa.Column("user_id", sa.UUID(), sa.ForeignKey("users.id", ondelete="CASCADE"), nullable=False),
        sa.Column("status", sa.String(20), nullable=False),  # 'going' | 'maybe' | 'not_going'
        sa.Column("responded_at", sa.DateTime(timezone=True), nullable=False, server_default=sa.func.now()),
        sa.PrimaryKeyConstraint("event_id", "user_id", name="pk_event_rsvps"),
    )


def downgrade() -> None:
    op.drop_table("event_rsvps")
    op.drop_table("club_events")
    op.drop_table("club_members")
    op.drop_table("reading_clubs")

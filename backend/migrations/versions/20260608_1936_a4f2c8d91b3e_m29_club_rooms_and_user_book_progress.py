"""m29_club_rooms_and_user_book_progress

Add ``club_rooms`` table, ``room_id`` FK on ``club_messages``, and
``progress`` column on ``user_books`` for progress-gated chapter chat rooms.

Revision ID: a4f2c8d91b3e
Revises: 1029cf1c65fe
Create Date: 2026-06-08 19:36:00.000000

"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision: str = "a4f2c8d91b3e"
down_revision: str | None = "1029cf1c65fe"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    # 1. Create club_rooms table.
    op.create_table(
        "club_rooms",
        sa.Column("id", sa.UUID(), nullable=False),
        sa.Column("club_id", sa.UUID(), nullable=False),
        sa.Column("name", sa.String(length=100), nullable=False),
        sa.Column(
            "progress_gate",
            sa.SmallInteger(),
            nullable=False,
            server_default=sa.text("0"),
        ),
        sa.Column("created_by", sa.UUID(), nullable=False),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.text("now()"),
            nullable=False,
        ),
        sa.ForeignKeyConstraint(["club_id"], ["reading_clubs.id"], ondelete="CASCADE"),
        sa.ForeignKeyConstraint(["created_by"], ["users.id"], ondelete="CASCADE"),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index("ix_club_rooms_club_id", "club_rooms", ["club_id"], unique=False)

    # 2. Add room_id FK to club_messages (nullable — NULL means club-wide channel).
    op.add_column(
        "club_messages",
        sa.Column("room_id", sa.UUID(), nullable=True),
    )
    op.create_foreign_key(
        "fk_club_messages_room_id",
        "club_messages",
        "club_rooms",
        ["room_id"],
        ["id"],
        ondelete="SET NULL",
    )

    # 3. Add progress column to user_books (0-100 percentage, default 0).
    op.add_column(
        "user_books",
        sa.Column(
            "progress",
            sa.SmallInteger(),
            nullable=False,
            server_default=sa.text("0"),
        ),
    )


def downgrade() -> None:
    op.drop_column("user_books", "progress")
    op.drop_constraint("fk_club_messages_room_id", "club_messages", type_="foreignkey")
    op.drop_column("club_messages", "room_id")
    op.drop_index("ix_club_rooms_club_id", table_name="club_rooms")
    op.drop_table("club_rooms")

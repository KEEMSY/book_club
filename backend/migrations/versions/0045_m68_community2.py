"""M68 community phase 2 — club video sessions.

``video_sessions`` backs the reading-club video-call MVP. A Pro club owner
opens a session (one active session per club at a time); the row holds the
Agora channel name and the lifecycle timestamps. ``ended_at`` is NULL while the
call is live and stamped on leave/end, so "active" is ``ended_at IS NULL``.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = "0045"
down_revision: str | None = "0044"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "video_sessions",
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
            "host_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id"),
            nullable=False,
        ),
        sa.Column("agora_channel", sa.String(length=64), nullable=False),
        sa.Column(
            "started_at",
            sa.TIMESTAMP(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
        sa.Column("ended_at", sa.TIMESTAMP(timezone=True), nullable=True),
        sa.Column("max_participants", sa.Integer(), nullable=False, server_default=sa.text("10")),
    )
    # "Active session for a club" is the hot read; index by club for the lookup.
    op.create_index("idx_video_sessions_club", "video_sessions", ["club_id"])


def downgrade() -> None:
    op.drop_index("idx_video_sessions_club", table_name="video_sessions")
    op.drop_table("video_sessions")

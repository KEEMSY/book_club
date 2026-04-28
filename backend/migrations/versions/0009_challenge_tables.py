"""challenge tables — badges, challenges, participants, user_badges.

Revision ID: 0009_challenge_tables
Revises: 0008_social_tables
Create Date: 2026-04-27

Adds four tables required by M9 (challenge system):

- ``badges`` — award icons. icon_key is an R2 object key composed into a
  full URL at read time.
- ``challenges`` — time-boxed reading goals with an optional badge reward.
  Indexed on (starts_at, ends_at) for status-filter queries.
- ``challenge_participants`` — composite PK (challenge_id, user_id) tracks
  each user's progress. Leaderboard index on (challenge_id, current_value).
- ``user_badges`` — composite PK (user_id, badge_id) records earned badges.
  Indexed on badge_id for earner-count queries.

Design choices:
- All Enum columns use VARCHAR (native_enum=False) consistent with M1-M8.
- challenge_participants.badge_id uses ON DELETE SET NULL so deleting a badge
  does not cascade-delete its associated challenges.
- challenge_participants and user_badges use composite PKs rather than
  surrogate UUIDs — the pair is always the natural identity.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision: str = "0009_challenge_tables"
down_revision: str | None = "0008_social_tables"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    # --- badges --------------------------------------------------------------
    op.create_table(
        "badges",
        sa.Column(
            "id",
            sa.dialects.postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column("name", sa.String(100), nullable=False),
        sa.Column("description", sa.Text, nullable=False),
        sa.Column("category", sa.String(16), nullable=False),
        sa.Column("icon_key", sa.String(500), nullable=False),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
    )

    # --- challenges ----------------------------------------------------------
    op.create_table(
        "challenges",
        sa.Column(
            "id",
            sa.dialects.postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column("title", sa.String(100), nullable=False),
        sa.Column("description", sa.Text, nullable=True),
        sa.Column("challenge_type", sa.String(24), nullable=False),
        sa.Column("target_value", sa.Integer, nullable=False),
        sa.Column("genre_filter", sa.String(50), nullable=True),
        sa.Column("starts_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("ends_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column(
            "badge_id",
            sa.dialects.postgresql.UUID(as_uuid=True),
            sa.ForeignKey("badges.id", ondelete="SET NULL"),
            nullable=True,
        ),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
    )
    # Status-filter index: WHERE now() BETWEEN starts_at AND ends_at.
    op.create_index("ix_challenges_window", "challenges", ["starts_at", "ends_at"])

    # --- challenge_participants -----------------------------------------------
    op.create_table(
        "challenge_participants",
        sa.Column(
            "challenge_id",
            sa.dialects.postgresql.UUID(as_uuid=True),
            sa.ForeignKey("challenges.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "user_id",
            sa.dialects.postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("current_value", sa.Integer, nullable=False, server_default="0"),
        sa.Column("achieved_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column(
            "joined_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
        sa.PrimaryKeyConstraint("challenge_id", "user_id", name="pk_challenge_participants"),
        sa.UniqueConstraint(
            "challenge_id", "user_id", name="uq_challenge_participants_pair"
        ),
    )
    # Leaderboard index: WHERE challenge_id = ? ORDER BY current_value DESC.
    op.create_index(
        "ix_challenge_participants_leaderboard",
        "challenge_participants",
        ["challenge_id", "current_value"],
    )

    # --- user_badges ---------------------------------------------------------
    op.create_table(
        "user_badges",
        sa.Column(
            "user_id",
            sa.dialects.postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "badge_id",
            sa.dialects.postgresql.UUID(as_uuid=True),
            sa.ForeignKey("badges.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "earned_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
        sa.PrimaryKeyConstraint("user_id", "badge_id", name="pk_user_badges"),
        sa.UniqueConstraint("user_id", "badge_id", name="uq_user_badges_pair"),
    )
    # "How many users earned this badge?" count index.
    op.create_index("ix_user_badges_badge_id", "user_badges", ["badge_id"])


def downgrade() -> None:
    op.drop_index("ix_user_badges_badge_id", table_name="user_badges")
    op.drop_table("user_badges")
    op.drop_index(
        "ix_challenge_participants_leaderboard", table_name="challenge_participants"
    )
    op.drop_table("challenge_participants")
    op.drop_index("ix_challenges_window", table_name="challenges")
    op.drop_table("challenges")
    op.drop_table("badges")

"""Add club_reading_plans and member progress columns (M52).

Revision ID: 0036
Revises: 0035
Create Date: 2026-06-18

M52 lets a Pro club owner generate an AI-paced reading plan for the club's
book. ``club_reading_plans`` stores the schedule (start/end dates and the
derived ``weekly_pages`` target); ``club_members.current_page`` /
``last_page_updated_at`` track each member's self-reported progress against
that plan so coaching cards can compare actual vs. expected pace.

The club FK targets ``reading_clubs`` — that is the physical table backing the
``ReadingClub`` model (the M52 spec's ``clubs`` was shorthand for the domain).
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision: str = "0036"
down_revision: str | None = "0035"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "club_reading_plans",
        sa.Column(
            "id",
            sa.dialects.postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "club_id",
            sa.dialects.postgresql.UUID(as_uuid=True),
            sa.ForeignKey("reading_clubs.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "book_id",
            sa.dialects.postgresql.UUID(as_uuid=True),
            sa.ForeignKey("books.id"),
            nullable=False,
        ),
        sa.Column("start_date", sa.Date(), nullable=False),
        sa.Column("end_date", sa.Date(), nullable=False),
        sa.Column("weekly_pages", sa.Integer(), nullable=False),
        sa.Column(
            "created_by",
            sa.dialects.postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id"),
            nullable=False,
        ),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
    )
    op.create_index("idx_club_plans_club", "club_reading_plans", ["club_id"])

    op.add_column(
        "club_members",
        sa.Column(
            "current_page",
            sa.Integer(),
            nullable=False,
            server_default=sa.text("0"),
        ),
    )
    op.add_column(
        "club_members",
        sa.Column("last_page_updated_at", sa.DateTime(timezone=True), nullable=True),
    )


def downgrade() -> None:
    op.drop_column("club_members", "last_page_updated_at")
    op.drop_column("club_members", "current_page")
    op.drop_index("idx_club_plans_club", table_name="club_reading_plans")
    op.drop_table("club_reading_plans")

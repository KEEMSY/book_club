"""reading tables — sessions, daily stats, user grades, goals.

Revision ID: 0004_reading_tables
Revises: 0003_book_tables
Create Date: 2026-04-20

Introduces the reading domain schema for Milestone 3.

Design choices:
- Portable string enums (``native_enum=False``) for ``reading_session_source``
  and ``goal_period`` mirror the auth/book convention so adding a new value
  is a schema tweak rather than an ALTER TYPE dance.
- Partial UNIQUE index ``ix_reading_session_one_active`` on
  ``(user_id) WHERE ended_at IS NULL`` enforces the one-active-session
  rule at the DB layer. The service layer pre-checks to convert races into
  a clean 409 ``ACTIVE_SESSION_EXISTS``.
- ``reading_sessions.user_book_id`` cascades when a UserBook is deleted —
  rows would be orphans otherwise. We also cascade on ``user_id`` to align
  with auth's (eventual hard) delete flow.
- ``daily_reading_stats`` has no FK on user_id: the event handler prunes
  on user soft-delete (M5). A composite PK (user_id, date) keeps heatmap
  lookups O(1) without an explicit index.
- ``user_grades.grade`` uses a CHECK 1..5 as a final line of defence.
- ``goals`` uniqueness (one active goal per (user, period)) is enforced at
  the service layer, not DB, so the product can later allow overlapping or
  edit histories without a painful migration.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision: str = "0004_reading_tables"
down_revision: str | None = "0003_book_tables"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "reading_sessions",
        sa.Column("id", sa.UUID(as_uuid=True), primary_key=True, nullable=False),
        sa.Column(
            "user_id",
            sa.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "user_book_id",
            sa.UUID(as_uuid=True),
            sa.ForeignKey("user_books.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column(
            "started_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.Column("ended_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("duration_sec", sa.Integer(), nullable=True),
        sa.Column("source", sa.String(length=16), nullable=False),
        sa.Column("device", sa.String(length=64), nullable=True),
        sa.Column("note", sa.String(length=200), nullable=True),
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
        sa.CheckConstraint(
            "source IN ('timer', 'manual')",
            name="ck_reading_sessions_source",
        ),
    )
    # Partial unique index — one active session per user. Postgres evaluates the
    # WHERE clause on insert/update so a second INSERT with ended_at IS NULL
    # raises IntegrityError, which the repository maps to ConflictError.
    op.create_index(
        "ix_reading_session_one_active",
        "reading_sessions",
        ["user_id"],
        unique=True,
        postgresql_where=sa.text("ended_at IS NULL"),
    )
    op.create_index(
        "ix_reading_session_user_started",
        "reading_sessions",
        ["user_id", "started_at"],
    )

    op.create_table(
        "daily_reading_stats",
        sa.Column("user_id", sa.UUID(as_uuid=True), nullable=False),
        sa.Column("date", sa.Date(), nullable=False),
        sa.Column(
            "total_seconds",
            sa.Integer(),
            nullable=False,
            server_default=sa.text("0"),
        ),
        sa.Column(
            "session_count",
            sa.Integer(),
            nullable=False,
            server_default=sa.text("0"),
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.PrimaryKeyConstraint("user_id", "date", name="pk_daily_reading_stats"),
    )

    op.create_table(
        "user_grades",
        sa.Column(
            "user_id",
            sa.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            primary_key=True,
        ),
        sa.Column(
            "grade",
            sa.SmallInteger(),
            nullable=False,
            server_default=sa.text("1"),
        ),
        sa.Column(
            "total_books",
            sa.Integer(),
            nullable=False,
            server_default=sa.text("0"),
        ),
        sa.Column(
            "total_seconds",
            sa.Integer(),
            nullable=False,
            server_default=sa.text("0"),
        ),
        sa.Column(
            "streak_days",
            sa.Integer(),
            nullable=False,
            server_default=sa.text("0"),
        ),
        sa.Column(
            "longest_streak",
            sa.Integer(),
            nullable=False,
            server_default=sa.text("0"),
        ),
        sa.Column("streak_last_date", sa.Date(), nullable=True),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.CheckConstraint("grade >= 1 AND grade <= 5", name="ck_user_grades_grade_range"),
    )

    op.create_table(
        "goals",
        sa.Column("id", sa.UUID(as_uuid=True), primary_key=True, nullable=False),
        sa.Column(
            "user_id",
            sa.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("period", sa.String(length=16), nullable=False),
        sa.Column("target_books", sa.Integer(), nullable=False),
        sa.Column("target_seconds", sa.Integer(), nullable=False),
        sa.Column("start_date", sa.Date(), nullable=False),
        sa.Column("end_date", sa.Date(), nullable=False),
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
        sa.CheckConstraint(
            "period IN ('weekly', 'monthly', 'yearly')",
            name="ck_goals_period",
        ),
        sa.CheckConstraint("target_books >= 0", name="ck_goals_target_books_nonneg"),
        sa.CheckConstraint("target_seconds >= 0", name="ck_goals_target_seconds_nonneg"),
        sa.CheckConstraint("end_date >= start_date", name="ck_goals_window_ordered"),
    )
    op.create_index(
        "ix_goals_user_period_window",
        "goals",
        ["user_id", "period", "start_date", "end_date"],
    )


def downgrade() -> None:
    op.drop_index("ix_goals_user_period_window", table_name="goals")
    op.drop_table("goals")
    op.drop_table("user_grades")
    op.drop_table("daily_reading_stats")
    op.drop_index("ix_reading_session_user_started", table_name="reading_sessions")
    op.drop_index(
        "ix_reading_session_one_active",
        table_name="reading_sessions",
        postgresql_where=sa.text("ended_at IS NULL"),
    )
    op.drop_table("reading_sessions")

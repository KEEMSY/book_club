"""Smoke tests for the reading domain SQLAlchemy models.

These tests verify the model classes import cleanly, registered tables are
what we expect, and the partial unique index on ``reading_sessions`` is
wired the way M3's design demands. DB-round-trip behaviour is exercised in
``tests/domains/reading/test_repository.py`` (needs Postgres).
"""

from __future__ import annotations

from app.domains.reading.models import (
    DailyReadingStat,
    Goal,
    GoalPeriod,
    ReadingSession,
    ReadingSessionSource,
    UserGrade,
)


def test_reading_session_table_name_and_columns() -> None:
    assert ReadingSession.__tablename__ == "reading_sessions"
    cols = {c.name for c in ReadingSession.__table__.columns}
    assert {
        "id",
        "user_id",
        "user_book_id",
        "started_at",
        "ended_at",
        "duration_sec",
        "source",
        "device",
        "note",
        "created_at",
        "updated_at",
    } <= cols


def test_reading_session_has_partial_active_index() -> None:
    # The one-active-session guard is the most important structural
    # invariant of M3 — verify it exists with the right predicate.
    idxs = {i.name: i for i in ReadingSession.__table__.indexes}
    assert "ix_reading_session_one_active" in idxs
    active = idxs["ix_reading_session_one_active"]
    assert active.unique is True
    # dialect_options carry the partial predicate
    predicate = active.dialect_options.get("postgresql", {}).get("where")
    assert predicate is not None
    assert "ended_at" in str(predicate).lower()


def test_daily_reading_stat_composite_pk() -> None:
    assert DailyReadingStat.__tablename__ == "daily_reading_stats"
    pk_cols = {c.name for c in DailyReadingStat.__table__.primary_key.columns}
    assert pk_cols == {"user_id", "date"}


def test_user_grade_defaults_and_columns() -> None:
    assert UserGrade.__tablename__ == "user_grades"
    cols = {c.name for c in UserGrade.__table__.columns}
    assert {
        "user_id",
        "grade",
        "total_books",
        "total_seconds",
        "streak_days",
        "longest_streak",
        "streak_last_date",
        "updated_at",
    } <= cols


def test_goal_enum_values() -> None:
    assert {e.value for e in GoalPeriod} == {"weekly", "monthly", "yearly"}
    assert Goal.__tablename__ == "goals"


def test_reading_session_source_enum_values() -> None:
    assert {e.value for e in ReadingSessionSource} == {"timer", "manual"}

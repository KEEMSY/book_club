"""Extend feed_events event_type CHECK for BC-47 club session/agenda/discussion.

The ``FeedEventType`` enum (app/domains/feed/models.py) grew three values for
the BC-42 agenda/discussion epic — ``session_opened``, ``agenda_published``,
``discussion_commented`` (design §6.1) — emitted by ``ClubService`` through
``FeedClubPort``. Per the BC-37/BC-38 drift-bug class, the DB CHECK
constraint ``ck_feed_events_event_type`` must be recreated in the same change
that grows the enum, or publishing these events raises a CheckViolationError
and rolls back the enclosing club-service transaction.

Chains onto 0051 (BC-43 club session/agenda/discussion tables) to keep a
single linear revision history. Postgres has no in-place ALTER for a CHECK,
so it is dropped and re-added, same as 0050.
"""

from __future__ import annotations

from collections.abc import Sequence

from alembic import op

revision: str = "0052"
down_revision: str | None = "0051"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None

_CONSTRAINT = "ck_feed_events_event_type"
_TABLE = "feed_events"

# Full set the code emits. Keep in sync with FeedEventType in
# app/domains/feed/models.py — a drift here is caught by
# tests/domains/feed/test_event_type_constraint_drift.py (BC-38).
_EVENT_TYPES_NEW = (
    "CHAPTER_MILESTONE",
    "STREAK_MILESTONE",
    "BOOK_COMPLETED",
    "CLUB_JOINED",
    "BOOK_REVIEWED",
    "highlight_shared",
    "session_opened",
    "agenda_published",
    "discussion_commented",
)

# Prior set defined in 0050 (for downgrade).
_EVENT_TYPES_OLD = (
    "CHAPTER_MILESTONE",
    "STREAK_MILESTONE",
    "BOOK_COMPLETED",
    "CLUB_JOINED",
    "BOOK_REVIEWED",
    "highlight_shared",
)


def _check_expr(types: Sequence[str]) -> str:
    return "event_type IN ({})".format(", ".join(f"'{t}'" for t in types))


def upgrade() -> None:
    op.drop_constraint(_CONSTRAINT, _TABLE, type_="check")
    op.create_check_constraint(_CONSTRAINT, _TABLE, _check_expr(_EVENT_TYPES_NEW))


def downgrade() -> None:
    op.drop_constraint(_CONSTRAINT, _TABLE, type_="check")
    op.create_check_constraint(_CONSTRAINT, _TABLE, _check_expr(_EVENT_TYPES_OLD))

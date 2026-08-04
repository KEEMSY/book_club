"""Extend feed_events event_type CHECK to include BOOK_REVIEWED and highlight_shared.

The ``FeedEventType`` enum (app/domains/feed/models.py) grew ``BOOK_REVIEWED``
(M54 review) and ``highlight_shared`` (M51 highlight share) but the DB CHECK
constraint ``ck_feed_events_event_type`` (added in 0024) was never extended to
match. Publishing either event violated the constraint, so creating a review or
sharing a highlight failed with a 500 (asyncpg CheckViolationError), and the
enclosing transaction rolled back the primary write too (BC-37).

This migration recreates the constraint with the full set of event types the
code emits. Postgres has no in-place ALTER for a CHECK, so it is dropped and
re-added. Chains onto 0049 to keep the revision line linear.
"""

from __future__ import annotations

from collections.abc import Sequence

from alembic import op

revision: str = "0050"
down_revision: str | None = "0049"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None

_CONSTRAINT = "ck_feed_events_event_type"
_TABLE = "feed_events"

# Full set the code emits (feed/service.py + review/service.py). Keep in sync
# with FeedEventType in app/domains/feed/models.py.
_EVENT_TYPES_NEW = (
    "CHAPTER_MILESTONE",
    "STREAK_MILESTONE",
    "BOOK_COMPLETED",
    "CLUB_JOINED",
    "BOOK_REVIEWED",
    "highlight_shared",
)

# Prior set defined in 0024 (for downgrade).
_EVENT_TYPES_OLD = (
    "CHAPTER_MILESTONE",
    "STREAK_MILESTONE",
    "BOOK_COMPLETED",
    "CLUB_JOINED",
)


def _check_expr(types: Sequence[str]) -> str:
    return "event_type IN ({})".format(", ".join(f"'{t}'" for t in types))


def upgrade() -> None:
    op.drop_constraint(_CONSTRAINT, _TABLE, type_="check")
    op.create_check_constraint(_CONSTRAINT, _TABLE, _check_expr(_EVENT_TYPES_NEW))


def downgrade() -> None:
    op.drop_constraint(_CONSTRAINT, _TABLE, type_="check")
    op.create_check_constraint(_CONSTRAINT, _TABLE, _check_expr(_EVENT_TYPES_OLD))

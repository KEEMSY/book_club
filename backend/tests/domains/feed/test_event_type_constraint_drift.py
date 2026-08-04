"""Guard against FeedEventType enum ↔ DB CHECK constraint drift (BC-38).

BC-37 root cause: the ``FeedEventType`` enum grew values (``BOOK_REVIEWED``,
``highlight_shared``) but ``ck_feed_events_event_type`` was never migrated to
match, so publishing those events raised a CheckViolationError → runtime 500.

This test introspects the live constraint on a migrated DB and asserts the set
of allowed ``event_type`` values equals the enum exactly. A future enum change
without a matching migration fails here in CI instead of in production.

Uses the Postgres-backed ``session`` fixture from this package's conftest, which
skips gracefully when no database is reachable.
"""

from __future__ import annotations

import re

import pytest
from app.domains.feed.models import FeedEventType
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession

_CONSTRAINT = "ck_feed_events_event_type"


@pytest.mark.asyncio
async def test_feed_event_type_check_matches_enum(session: AsyncSession) -> None:
    result = await session.execute(
        text(
            "SELECT pg_get_constraintdef(oid) FROM pg_constraint WHERE conname = :name"
        ),
        {"name": _CONSTRAINT},
    )
    constraintdef = result.scalar_one_or_none()
    assert constraintdef is not None, f"{_CONSTRAINT} not found on feed_events"

    # The only single-quoted literals in the CHECK expression are the allowed
    # event_type values (type-cast keywords like `character varying` are not
    # quoted), so extracting quoted tokens yields exactly the allowed set.
    allowed = set(re.findall(r"'([^']+)'", constraintdef))
    expected = {member.value for member in FeedEventType}

    assert allowed == expected, (
        "feed_events event_type drift between code and schema.\n"
        f"  CHECK allows: {sorted(allowed)}\n"
        f"  FeedEventType: {sorted(expected)}\n"
        f"Add an alembic migration recreating {_CONSTRAINT} to match the enum."
    )

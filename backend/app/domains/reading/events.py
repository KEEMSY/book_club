"""Domain events emitted by the reading service.

These are plain frozen dataclasses — no pydantic, no SQLAlchemy, no
transport concerns. Subscribers in this domain (and, later, in
``notification``) match on event *type*, which is why each one is its
own class rather than a generic payload.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import date
from uuid import UUID


@dataclass(frozen=True, slots=True)
class ReadingSessionCompleted:
    """A timer session finished — the anchor event for grade/streak/heatmap.

    ``source`` is carried even though only ``'timer'`` completions publish
    this event today — keeping the field makes it trivial to extend later
    without a subscriber rewrite.
    """

    user_id: UUID
    user_book_id: UUID
    session_id: UUID
    date: date
    duration_sec: int
    source: str = "timer"


@dataclass(frozen=True, slots=True)
class UserGradeRecomputed:
    """Fired after ``ReadingSessionCompleted`` causes a grade snapshot to
    change. M5 push handlers pick this up to send a grade-up notification.
    """

    user_id: UUID
    old_grade: int
    new_grade: int
    streak_days: int

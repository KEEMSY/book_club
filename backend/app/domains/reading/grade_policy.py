"""Pure-function grade policy — design doc §5.2.

The ladder is AND-thresholded: a user reaches grade N only when *both*
``total_books`` and ``total_seconds`` meet the thresholds for N. The
highest-satisfied grade wins so a single call handles jumps (a backfilled
batch of reading can rocket a user from 1 to 3 in one go).

Keeping this file free of SQLAlchemy/Pydantic imports means the logic can
be unit-tested in milliseconds and reused by the event subscriber without
pulling in transport concerns.
"""

from __future__ import annotations

GRADE_THRESHOLDS: list[tuple[int, int, int]] = [
    (1, 0, 0),
    (2, 3, 10 * 3600),
    (3, 10, 50 * 3600),
    (4, 30, 150 * 3600),
    (5, 100, 500 * 3600),
]
"""(grade, books_required, seconds_required) — design doc §5.2."""


def calculate_grade(*, total_books: int, total_seconds: int) -> int:
    """Return the highest grade the user has earned under AND semantics."""
    grade = 1
    for g, b, s in GRADE_THRESHOLDS:
        if total_books >= b and total_seconds >= s:
            grade = g
    return grade


def next_threshold(current_grade: int) -> tuple[int, int] | None:
    """Thresholds required to advance from ``current_grade`` to the next.

    Returns ``None`` when already at the cap (grade 5).
    """
    max_grade = GRADE_THRESHOLDS[-1][0]
    if current_grade >= max_grade:
        return None
    for g, b, s in GRADE_THRESHOLDS:
        if g == current_grade + 1:
            return (b, s)
    return None

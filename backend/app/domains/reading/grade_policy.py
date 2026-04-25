"""Pure-function grade and tier policy — design doc §5.2.

The ladder is AND-thresholded: a user reaches grade N / tier T only when
*both* ``total_books`` and ``total_seconds`` meet the thresholds for that
row.  The highest-satisfied row wins, so a single call handles jumps (a
backfilled batch of reading can rocket a user from 1-I to 3-II in one go).

Keeping this file free of SQLAlchemy/Pydantic imports means the logic can
be unit-tested in milliseconds and reused by the event subscriber without
pulling in transport concerns.
"""

from __future__ import annotations

# (grade, tier, books_required, seconds_required)
TIER_THRESHOLDS: list[tuple[int, int, int, int]] = [
    (1, 1, 0,   0),
    (1, 2, 1,   2 * 3600),
    (1, 3, 2,   6 * 3600),
    (2, 1, 3,   10 * 3600),
    (2, 2, 5,   20 * 3600),
    (2, 3, 7,   35 * 3600),
    (3, 1, 10,  50 * 3600),
    (3, 2, 17,  83 * 3600),
    (3, 3, 23,  117 * 3600),
    (4, 1, 30,  150 * 3600),
    (4, 2, 53,  250 * 3600),
    (4, 3, 77,  375 * 3600),
    (5, 1, 100, 500 * 3600),
]
"""(grade, tier, books_required, seconds_required) — design doc §5.2."""

# Backward-compat alias: grade-level entries only (tier == 1) as 3-tuples.
GRADE_THRESHOLDS: list[tuple[int, int, int]] = [
    (g, b, s) for g, t, b, s in TIER_THRESHOLDS if t == 1
]
"""Legacy 3-tuple table kept so existing imports don't break."""


def calculate_grade_tier(*, total_books: int, total_seconds: int) -> tuple[int, int]:
    """Return (grade, tier) under AND semantics — highest satisfied row wins."""
    grade, tier = 1, 1
    for g, t, b, s in TIER_THRESHOLDS:
        if total_books >= b and total_seconds >= s:
            grade, tier = g, t
    return grade, tier


def calculate_grade(*, total_books: int, total_seconds: int) -> int:
    """Return only the grade (1-5).

    Legacy entry point — delegates to ``calculate_grade_tier`` so callers
    that don't yet need ``tier`` don't have to change their signatures.
    """
    grade, _ = calculate_grade_tier(total_books=total_books, total_seconds=total_seconds)
    return grade


def next_tier_threshold(
    current_grade: int, current_tier: int
) -> tuple[int, int] | None:
    """Books and seconds needed to advance to the next tier.

    Scans ``TIER_THRESHOLDS`` for the matching (grade, tier) row and returns
    the requirements of the following row.  Returns ``None`` at the apex
    (grade=5, tier=1) — there is no higher level.
    """
    for i, (g, t, _b, _s) in enumerate(TIER_THRESHOLDS):
        if g == current_grade and t == current_tier:
            if i + 1 < len(TIER_THRESHOLDS):
                _, _, nb, ns = TIER_THRESHOLDS[i + 1]
                return (nb, ns)
            return None
    return None


def next_threshold(current_grade: int) -> tuple[int, int] | None:
    """Thresholds required to advance from ``current_grade`` to the next grade.

    Legacy entry point — kept for backward compatibility with callers that
    only track grade (not tier).  Equivalent to querying the next grade's
    tier-1 entry.
    """
    max_grade = GRADE_THRESHOLDS[-1][0]
    if current_grade >= max_grade:
        return None
    for g, b, s in GRADE_THRESHOLDS:
        if g == current_grade + 1:
            return (b, s)
    return None

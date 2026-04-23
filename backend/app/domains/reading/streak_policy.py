"""Pure-function streak policy — consecutive-day reading tracker.

Rules enforced here:
- First-ever (or state-reset) session -> streak_days = 1, stamp last_date.
- Same day as last_date -> no change; multiple sessions per day do not
  compound.
- Exactly one day after last_date -> streak_days += 1, longest_streak
  bumped if a new maximum is reached.
- More than one day after last_date -> streak_days reset to 1 (today
  counts); longest_streak preserved.
- A session dated before last_date is treated as a noop. Manual sessions
  must not affect streaks at all, so they never reach this policy in
  practice — but we still guard here in case a future flow forwards a
  backdated date by accident.

Returning ``longest_streak`` alongside the new streak lets the caller
persist both with a single ``update_snapshot`` call.
"""

from __future__ import annotations

from datetime import date, timedelta


def update_streak(
    *,
    previous_last_date: date | None,
    previous_streak_days: int,
    longest_streak: int,
    session_date: date,
) -> tuple[int, int, date]:
    """Return ``(new_streak_days, new_longest_streak, new_last_date)``.

    The three-tuple is intentionally explicit rather than a dataclass so
    test assertions stay compact.
    """
    # Missing anchor -> clean restart. Don't shrink longest_streak in case
    # the caller has a valid historical value; just kick the counter to 1.
    if previous_last_date is None:
        return (1, max(longest_streak, 1), session_date)

    if session_date < previous_last_date:
        # Backdated — keep everything the caller had.
        return (previous_streak_days, longest_streak, previous_last_date)

    if session_date == previous_last_date:
        return (previous_streak_days, longest_streak, previous_last_date)

    if session_date == previous_last_date + timedelta(days=1):
        new_streak = previous_streak_days + 1
        return (new_streak, max(longest_streak, new_streak), session_date)

    # session_date > previous_last_date + 1 day -> gap, reset counter to 1.
    return (1, longest_streak, session_date)

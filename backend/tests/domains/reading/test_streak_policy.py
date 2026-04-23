"""Boundary-value tests for the pure streak policy."""

from __future__ import annotations

from datetime import date

from app.domains.reading.streak_policy import update_streak


def test_first_ever_session_starts_streak_at_one() -> None:
    new_streak, new_longest, new_last = update_streak(
        previous_last_date=None,
        previous_streak_days=0,
        longest_streak=0,
        session_date=date(2026, 4, 20),
    )
    assert new_streak == 1
    assert new_longest == 1
    assert new_last == date(2026, 4, 20)


def test_same_day_session_preserves_streak() -> None:
    new_streak, new_longest, new_last = update_streak(
        previous_last_date=date(2026, 4, 20),
        previous_streak_days=5,
        longest_streak=7,
        session_date=date(2026, 4, 20),
    )
    assert new_streak == 5
    assert new_longest == 7
    assert new_last == date(2026, 4, 20)


def test_consecutive_day_increments_streak() -> None:
    new_streak, new_longest, new_last = update_streak(
        previous_last_date=date(2026, 4, 20),
        previous_streak_days=5,
        longest_streak=7,
        session_date=date(2026, 4, 21),
    )
    assert new_streak == 6
    # Current longest is still 7 because 6 < 7.
    assert new_longest == 7
    assert new_last == date(2026, 4, 21)


def test_consecutive_day_updates_longest_when_new_high() -> None:
    new_streak, new_longest, new_last = update_streak(
        previous_last_date=date(2026, 4, 20),
        previous_streak_days=7,
        longest_streak=7,
        session_date=date(2026, 4, 21),
    )
    assert new_streak == 8
    assert new_longest == 8
    assert new_last == date(2026, 4, 21)


def test_gap_of_two_days_resets_streak_but_preserves_longest() -> None:
    new_streak, new_longest, new_last = update_streak(
        previous_last_date=date(2026, 4, 20),
        previous_streak_days=12,
        longest_streak=15,
        session_date=date(2026, 4, 22),  # gap = 2
    )
    assert new_streak == 1
    assert new_longest == 15
    assert new_last == date(2026, 4, 22)


def test_large_gap_resets_streak() -> None:
    new_streak, new_longest, new_last = update_streak(
        previous_last_date=date(2026, 1, 1),
        previous_streak_days=100,
        longest_streak=100,
        session_date=date(2026, 4, 20),
    )
    assert new_streak == 1
    assert new_longest == 100
    assert new_last == date(2026, 4, 20)


def test_backdated_session_before_last_date_is_noop() -> None:
    # Defensive: manual sessions should never reach this policy, but if a
    # future flow accidentally feeds a past date we don't want the streak
    # inflating. Keep everything unchanged and return the old last_date.
    new_streak, new_longest, new_last = update_streak(
        previous_last_date=date(2026, 4, 20),
        previous_streak_days=5,
        longest_streak=7,
        session_date=date(2026, 4, 10),  # before previous_last_date
    )
    assert new_streak == 5
    assert new_longest == 7
    assert new_last == date(2026, 4, 20)


def test_multiple_same_day_sessions_dont_compound() -> None:
    # First session of the day
    s1, l1, d1 = update_streak(
        previous_last_date=date(2026, 4, 19),
        previous_streak_days=3,
        longest_streak=5,
        session_date=date(2026, 4, 20),
    )
    # Second session of the same day — should not touch the counter.
    s2, l2, d2 = update_streak(
        previous_last_date=d1,
        previous_streak_days=s1,
        longest_streak=l1,
        session_date=date(2026, 4, 20),
    )
    assert s1 == 4
    assert s2 == 4
    assert l2 == 5
    assert d2 == date(2026, 4, 20)


def test_consecutive_day_from_no_previous_last_date_initialises() -> None:
    # Defensive: previous_last_date=None but streak_days>0 is a corrupt
    # state; treat it as "first session" to recover cleanly.
    new_streak, new_longest, new_last = update_streak(
        previous_last_date=None,
        previous_streak_days=99,
        longest_streak=5,
        session_date=date(2026, 4, 20),
    )
    assert new_streak == 1
    assert new_longest == 5  # Don't decrease the longest observed.
    assert new_last == date(2026, 4, 20)

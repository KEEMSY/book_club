"""Boundary-value tests for the pure grade + tier policy.

The AND-thresholded ladder has a well-defined shape so we enumerate every
boundary, every "one-axis satisfied but not the other" case, and every
tier transition within and across grade boundaries.
"""

from __future__ import annotations

import pytest
from app.domains.reading.grade_policy import (
    GRADE_THRESHOLDS,
    TIER_THRESHOLDS,
    calculate_grade,
    calculate_grade_tier,
    next_threshold,
    next_tier_threshold,
)


# ---------------------------------------------------------------------------
# calculate_grade_tier — primary function
# ---------------------------------------------------------------------------


def test_sprout_i() -> None:
    g, t = calculate_grade_tier(total_books=0, total_seconds=0)
    assert g == 1 and t == 1


def test_sprout_ii() -> None:
    g, t = calculate_grade_tier(total_books=1, total_seconds=2 * 3600)
    assert g == 1 and t == 2


def test_sprout_iii() -> None:
    g, t = calculate_grade_tier(total_books=2, total_seconds=6 * 3600)
    assert g == 1 and t == 3


def test_explorer_i() -> None:
    g, t = calculate_grade_tier(total_books=3, total_seconds=10 * 3600)
    assert g == 2 and t == 1


def test_explorer_ii() -> None:
    g, t = calculate_grade_tier(total_books=5, total_seconds=20 * 3600)
    assert g == 2 and t == 2


def test_explorer_iii() -> None:
    g, t = calculate_grade_tier(total_books=7, total_seconds=35 * 3600)
    assert g == 2 and t == 3


def test_avid_i() -> None:
    g, t = calculate_grade_tier(total_books=10, total_seconds=50 * 3600)
    assert g == 3 and t == 1


def test_avid_ii() -> None:
    g, t = calculate_grade_tier(total_books=17, total_seconds=83 * 3600)
    assert g == 3 and t == 2


def test_avid_iii() -> None:
    g, t = calculate_grade_tier(total_books=23, total_seconds=117 * 3600)
    assert g == 3 and t == 3


def test_passionate_i() -> None:
    g, t = calculate_grade_tier(total_books=30, total_seconds=150 * 3600)
    assert g == 4 and t == 1


def test_passionate_ii() -> None:
    g, t = calculate_grade_tier(total_books=53, total_seconds=250 * 3600)
    assert g == 4 and t == 2


def test_passionate_iii() -> None:
    g, t = calculate_grade_tier(total_books=77, total_seconds=375 * 3600)
    assert g == 4 and t == 3


def test_master() -> None:
    g, t = calculate_grade_tier(total_books=100, total_seconds=500 * 3600)
    assert g == 5 and t == 1


def test_grade5_is_cap() -> None:
    # Overshooting does not produce grade 6 or tier 2.
    g, t = calculate_grade_tier(total_books=1000, total_seconds=1000 * 3600)
    assert g == 5 and t == 1


def test_partial_threshold_books_only_stays_lower_tier() -> None:
    # 3 books but only 5h — books meet grade-2/tier-1 but seconds do not.
    # 새싹 III (2권/6h) 도 시간 미달(5h < 6h) → 새싹 II (1권/2h) 까지만 통과.
    g, t = calculate_grade_tier(total_books=3, total_seconds=5 * 3600)
    assert g == 1 and t == 2


def test_partial_threshold_uses_lower_tier() -> None:
    # 새싹 III threshold: 2 books AND 6h.
    # With 2 books and exactly 6h, should be 새싹 III.
    g, t = calculate_grade_tier(total_books=2, total_seconds=6 * 3600)
    assert g == 1 and t == 3


def test_and_semantics_only_seconds_satisfied() -> None:
    # Many seconds but no books → stays grade-1 tier-1.
    g, t = calculate_grade_tier(total_books=0, total_seconds=500 * 3600)
    assert g == 1 and t == 1


def test_and_semantics_only_books_satisfied() -> None:
    # Many books but no seconds → stays grade-1 tier-1.
    g, t = calculate_grade_tier(total_books=100, total_seconds=0)
    assert g == 1 and t == 1


@pytest.mark.parametrize(
    "books,seconds,expected_grade,expected_tier",
    [
        (0, 0, 1, 1),
        (1, 2 * 3600, 1, 2),
        (2, 6 * 3600, 1, 3),
        (3, 10 * 3600, 2, 1),
        (7, 35 * 3600, 2, 3),
        (10, 50 * 3600, 3, 1),
        (23, 117 * 3600, 3, 3),
        (30, 150 * 3600, 4, 1),
        (77, 375 * 3600, 4, 3),
        (100, 500 * 3600, 5, 1),
    ],
)
def test_calculate_grade_tier_table(
    books: int, seconds: int, expected_grade: int, expected_tier: int
) -> None:
    g, t = calculate_grade_tier(total_books=books, total_seconds=seconds)
    assert g == expected_grade and t == expected_tier


# ---------------------------------------------------------------------------
# calculate_grade — legacy shim
# ---------------------------------------------------------------------------


def test_calculate_grade_legacy_grade1() -> None:
    assert calculate_grade(total_books=0, total_seconds=0) == 1


def test_calculate_grade_legacy_grade2_exact() -> None:
    assert calculate_grade(total_books=3, total_seconds=10 * 3600) == 2


def test_calculate_grade_legacy_grade5() -> None:
    assert calculate_grade(total_books=100, total_seconds=500 * 3600) == 5


def test_calculate_grade_legacy_one_below_grade2_books() -> None:
    assert calculate_grade(total_books=2, total_seconds=10 * 3600) == 1


def test_calculate_grade_legacy_one_below_grade2_seconds() -> None:
    assert calculate_grade(total_books=3, total_seconds=10 * 3600 - 1) == 1


@pytest.mark.parametrize(
    "books,seconds,expected_grade",
    [
        (0, 0, 1),
        (2, 10 * 3600 - 1, 1),
        (3, 10 * 3600, 2),
        (9, 50 * 3600 - 1, 2),
        (10, 50 * 3600, 3),
        (29, 150 * 3600 - 1, 3),
        (30, 150 * 3600, 4),
        (99, 500 * 3600 - 1, 4),
        (100, 500 * 3600, 5),
    ],
)
def test_calculate_grade_table(books: int, seconds: int, expected_grade: int) -> None:
    assert calculate_grade(total_books=books, total_seconds=seconds) == expected_grade


# ---------------------------------------------------------------------------
# next_tier_threshold
# ---------------------------------------------------------------------------


def test_next_tier_threshold_within_grade() -> None:
    b, s = next_tier_threshold(1, 1)  # type: ignore[misc]
    assert b == 1 and s == 2 * 3600


def test_next_tier_threshold_sprout_ii_to_iii() -> None:
    b, s = next_tier_threshold(1, 2)  # type: ignore[misc]
    assert b == 2 and s == 6 * 3600


def test_next_tier_threshold_grade_boundary() -> None:
    # 새싹 III → 탐독 I
    b, s = next_tier_threshold(1, 3)  # type: ignore[misc]
    assert b == 3 and s == 10 * 3600


def test_next_tier_threshold_apex() -> None:
    assert next_tier_threshold(5, 1) is None


def test_next_tier_threshold_unknown_returns_none() -> None:
    # (grade=5, tier=2) does not exist in the table.
    assert next_tier_threshold(5, 2) is None


# ---------------------------------------------------------------------------
# next_threshold — legacy shim
# ---------------------------------------------------------------------------


def test_next_threshold_at_grade1() -> None:
    assert next_threshold(1) == (3, 10 * 3600)


def test_next_threshold_at_grade2() -> None:
    assert next_threshold(2) == (10, 50 * 3600)


def test_next_threshold_at_grade3() -> None:
    assert next_threshold(3) == (30, 150 * 3600)


def test_next_threshold_at_grade4() -> None:
    assert next_threshold(4) == (100, 500 * 3600)


def test_next_threshold_at_grade5_is_none() -> None:
    assert next_threshold(5) is None


# ---------------------------------------------------------------------------
# Table shape guards — defend against accidental config drift
# ---------------------------------------------------------------------------


def test_tier_threshold_table_length() -> None:
    # 13 rows: grade-1×3, grade-2×3, grade-3×3, grade-4×3, grade-5×1.
    assert len(TIER_THRESHOLDS) == 13


def test_tier_threshold_table_apex_row() -> None:
    assert TIER_THRESHOLDS[-1] == (5, 1, 100, 500 * 3600)


def test_grade_thresholds_backward_compat_shape() -> None:
    # Legacy table must still contain the same grade-1 entries as before.
    assert GRADE_THRESHOLDS == [
        (1, 0, 0),
        (2, 3, 10 * 3600),
        (3, 10, 50 * 3600),
        (4, 30, 150 * 3600),
        (5, 100, 500 * 3600),
    ]

"""Boundary-value tests for the pure grade policy.

The AND-thresholded ladder has a well-defined shape so we enumerate every
boundary and every "one-axis satisfied but not the other" case.
"""

from __future__ import annotations

import pytest
from app.domains.reading.grade_policy import (
    GRADE_THRESHOLDS,
    calculate_grade,
    next_threshold,
)


def test_grade1_default() -> None:
    assert calculate_grade(total_books=0, total_seconds=0) == 1


def test_grade2_exact_boundary() -> None:
    # Grade 2 = 3 books AND 10h
    assert calculate_grade(total_books=3, total_seconds=10 * 3600) == 2


def test_grade2_one_second_below() -> None:
    assert calculate_grade(total_books=3, total_seconds=10 * 3600 - 1) == 1


def test_grade2_one_book_below() -> None:
    assert calculate_grade(total_books=2, total_seconds=10 * 3600) == 1


def test_grade_stays_1_when_only_books_satisfied() -> None:
    # 100 books but 0 seconds -> grade 1 (AND semantics)
    assert calculate_grade(total_books=100, total_seconds=0) == 1


def test_grade_stays_1_when_only_seconds_satisfied() -> None:
    assert calculate_grade(total_books=0, total_seconds=500 * 3600) == 1


def test_grade3_exact_boundary() -> None:
    assert calculate_grade(total_books=10, total_seconds=50 * 3600) == 3


def test_grade4_exact_boundary() -> None:
    assert calculate_grade(total_books=30, total_seconds=150 * 3600) == 4


def test_grade5_exact_boundary() -> None:
    assert calculate_grade(total_books=100, total_seconds=500 * 3600) == 5


def test_grade5_is_cap() -> None:
    # Overshooting doesn't produce grade 6.
    assert calculate_grade(total_books=1000, total_seconds=1000 * 3600) == 5


@pytest.mark.parametrize(
    "books,seconds,expected_grade",
    [
        (0, 0, 1),
        (2, 36000 - 1, 1),
        (3, 36000, 2),
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


def test_threshold_table_shape() -> None:
    # Defend against accidental config drift — the design doc §5.2 values
    # are the source of truth and must not be edited lightly.
    assert GRADE_THRESHOLDS == [
        (1, 0, 0),
        (2, 3, 10 * 3600),
        (3, 10, 50 * 3600),
        (4, 30, 150 * 3600),
        (5, 100, 500 * 3600),
    ]

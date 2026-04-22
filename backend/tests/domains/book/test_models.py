"""Model-level smoke tests (no DB) for the book domain.

Covers pure Python semantics — enum round-tripping and default values.
Persistence and CHECK constraints are exercised by ``test_repository.py``
against a real Postgres container.
"""

from __future__ import annotations

import uuid

from app.domains.book.models import Book, BookSource, UserBook, UserBookStatus


def test_book_source_values() -> None:
    assert BookSource.NAVER.value == "naver"
    assert BookSource.KAKAO.value == "kakao"
    assert BookSource.MANUAL.value == "manual"


def test_user_book_status_values() -> None:
    assert UserBookStatus.READING.value == "reading"
    assert UserBookStatus.COMPLETED.value == "completed"
    assert UserBookStatus.PAUSED.value == "paused"
    assert UserBookStatus.DROPPED.value == "dropped"


def test_book_fields_round_trip() -> None:
    book = Book(
        isbn13="9788937460777",
        title="오만과 편견",
        author="제인 오스틴",
        publisher="민음사",
        cover_url="https://example.com/cover.jpg",
        description="19세기 영국 사회를 배경으로 한 연애 소설.",
        source=BookSource.NAVER,
    )
    assert book.isbn13 == "9788937460777"
    assert book.title == "오만과 편견"
    assert book.source is BookSource.NAVER


def test_user_book_defaults() -> None:
    user_id = uuid.uuid4()
    book_id = uuid.uuid4()
    ub = UserBook(user_id=user_id, book_id=book_id, status=UserBookStatus.READING)
    assert ub.user_id == user_id
    assert ub.book_id == book_id
    assert ub.status is UserBookStatus.READING
    assert ub.rating is None
    assert ub.one_line_review is None
    assert ub.finished_at is None

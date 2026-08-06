"""Integration tests for BookReviewRepository.list_by_user / count_by_user (BC-80).

Verifies the "내 활동 > 내 리뷰" query: newest-first, joined to the book for
display, excludes hidden reviews and other users' reviews.
"""

from __future__ import annotations

from datetime import datetime
from decimal import Decimal
from uuid import UUID

import pytest
from app.domains.auth.models import AuthProvider
from app.domains.auth.repository import UserRepository
from app.domains.book.models import BookSource
from app.domains.book.repository import BookRepository
from app.domains.review.repository import BookReviewRepository
from sqlalchemy.ext.asyncio import AsyncSession


async def _create_user(session: AsyncSession, *, sub: str) -> UUID:
    user_repo = UserRepository(session)
    user = await user_repo.create(
        provider=AuthProvider.KAKAO,
        sub=sub,
        email=None,
        nickname=f"user-{sub}",
        profile_image_url=None,
    )
    return user.id


async def _create_book(session: AsyncSession, *, isbn13: str, title: str) -> UUID:
    book_repo = BookRepository(session)
    book = await book_repo.upsert_by_isbn(
        isbn13=isbn13,
        title=title,
        author="저자",
        publisher=None,
        cover_url="https://example.com/cover.jpg",
        description=None,
        source=BookSource.NAVER,
    )
    return book.id


@pytest.mark.asyncio
async def test_list_by_user_newest_first_with_book_info(session: AsyncSession) -> None:
    user_id = await _create_user(session, sub="review-user")
    other_id = await _create_user(session, sub="review-other")
    book_a = await _create_book(session, isbn13="9788937469101", title="책 A")
    book_b = await _create_book(session, isbn13="9788937469102", title="책 B")

    repo = BookReviewRepository(session)
    older = await repo.create(
        user_id=user_id, book_id=book_a, rating=Decimal("3.0"), body="첫 리뷰"
    )
    older.created_at = datetime(2026, 1, 1)
    await session.flush()
    newer = await repo.create(
        user_id=user_id, book_id=book_b, rating=Decimal("5.0"), body="둘째 리뷰"
    )
    newer.created_at = datetime(2026, 6, 1)
    await session.flush()
    await repo.create(user_id=other_id, book_id=book_a, rating=Decimal("4.0"), body="남의 리뷰")

    rows = await repo.list_by_user(user_id, limit=10, offset=0)

    assert [r.review.id for r in rows] == [newer.id, older.id]
    assert rows[0].book_title == "책 B"
    assert rows[0].book_cover_url == "https://example.com/cover.jpg"
    assert await repo.count_by_user(user_id) == 2
    assert await repo.count_by_user(other_id) == 1


@pytest.mark.asyncio
async def test_list_by_user_excludes_hidden(session: AsyncSession) -> None:
    user_id = await _create_user(session, sub="review-hide-user")
    book_1 = await _create_book(session, isbn13="9788937469103", title="책1")
    book_2 = await _create_book(session, isbn13="9788937469104", title="책2")

    repo = BookReviewRepository(session)
    visible = await repo.create(
        user_id=user_id, book_id=book_1, rating=Decimal("4.0"), body="공개 리뷰"
    )
    hidden = await repo.create(
        user_id=user_id, book_id=book_2, rating=Decimal("1.0"), body="숨김 리뷰"
    )
    await repo.increment_report(hidden.id, hide_threshold=1)

    rows = await repo.list_by_user(user_id, limit=10, offset=0)

    assert [r.review.id for r in rows] == [visible.id]
    assert await repo.count_by_user(user_id) == 1


@pytest.mark.asyncio
async def test_list_by_user_pagination(session: AsyncSession) -> None:
    user_id = await _create_user(session, sub="review-page-user")

    repo = BookReviewRepository(session)
    for i in range(3):
        book_id = await _create_book(session, isbn13=f"978893746920{i}", title=f"책 {i}")
        r = await repo.create(
            user_id=user_id, book_id=book_id, rating=Decimal("3.0"), body=f"리뷰 {i}"
        )
        r.created_at = datetime(2026, 1, 1 + i)
        await session.flush()

    page1 = await repo.list_by_user(user_id, limit=2, offset=0)
    page2 = await repo.list_by_user(user_id, limit=2, offset=2)

    assert len(page1) == 2
    assert len(page2) == 1
    assert {r.review.id for r in page1}.isdisjoint({r.review.id for r in page2})

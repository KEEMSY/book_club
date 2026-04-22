"""Integration tests for the book repository adapters (async Postgres).

Verifies:
- ``Book.upsert_by_isbn`` is idempotent and updates mutable fields.
- ``UserBook.create`` raises ``ConflictError(BOOK_ALREADY_IN_LIBRARY)`` on
  duplicate insert.
- ``list_for_user`` honours the (started_at DESC, id DESC) cursor order.
- ``update_status`` on an unknown id raises NotFoundError.
- ``set_rating_review`` rejects out-of-range ratings via the CHECK constraint.
"""

from __future__ import annotations

from datetime import UTC, datetime, timedelta
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError, NotFoundError
from app.domains.auth.models import AuthProvider
from app.domains.auth.repository import UserRepository
from app.domains.book.models import BookSource, UserBookStatus
from app.domains.book.repository import BookRepository, UserBookRepository
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


@pytest.mark.asyncio
async def test_upsert_by_isbn_is_idempotent(session: AsyncSession) -> None:
    repo = BookRepository(session)

    first = await repo.upsert_by_isbn(
        isbn13="9788937460777",
        title="오만과 편견",
        author="제인 오스틴",
        publisher="민음사",
        cover_url="https://example.com/cover.jpg",
        description="초판",
        source=BookSource.NAVER,
    )
    first_id = first.id
    first_created = first.created_at

    # Same ISBN, refreshed metadata — same row, mutable fields updated.
    second = await repo.upsert_by_isbn(
        isbn13="9788937460777",
        title="오만과 편견(개정판)",
        author="제인 오스틴 · 윤지관 옮김",
        publisher="민음사",
        cover_url="https://example.com/cover-v2.jpg",
        description="개정판",
        source=BookSource.NAVER,
    )

    assert second.id == first_id
    assert second.title == "오만과 편견(개정판)"
    assert second.cover_url == "https://example.com/cover-v2.jpg"
    assert second.description == "개정판"
    # created_at is preserved on conflict update
    assert second.created_at == first_created


@pytest.mark.asyncio
async def test_get_by_id_and_isbn(session: AsyncSession) -> None:
    repo = BookRepository(session)
    book = await repo.upsert_by_isbn(
        isbn13="9788937460555",
        title="데미안",
        author="헤르만 헤세",
        publisher=None,
        cover_url=None,
        description=None,
        source=BookSource.KAKAO,
    )
    assert (await repo.get_by_id(book.id)) is not None
    assert (await repo.get_by_isbn("9788937460555")) is not None
    assert (await repo.get_by_isbn("0000000000000")) is None


@pytest.mark.asyncio
async def test_user_book_create_then_duplicate_raises(session: AsyncSession) -> None:
    user_id = await _create_user(session, sub="u-dup")
    book_repo = BookRepository(session)
    book = await book_repo.upsert_by_isbn(
        isbn13="9788937460222",
        title="코스모스",
        author="칼 세이건",
        publisher=None,
        cover_url=None,
        description=None,
        source=BookSource.NAVER,
    )

    ub_repo = UserBookRepository(session)
    created = await ub_repo.create(user_id=user_id, book_id=book.id)
    assert created.status is UserBookStatus.READING
    assert created.started_at is not None

    with pytest.raises(ConflictError) as exc_info:
        await ub_repo.create(user_id=user_id, book_id=book.id)
    assert exc_info.value.code == "BOOK_ALREADY_IN_LIBRARY"


@pytest.mark.asyncio
async def test_update_status_happy_and_not_found(session: AsyncSession) -> None:
    user_id = await _create_user(session, sub="u-stat")
    book_repo = BookRepository(session)
    book = await book_repo.upsert_by_isbn(
        isbn13="9788937460333",
        title="사피엔스",
        author="유발 하라리",
        publisher=None,
        cover_url=None,
        description=None,
        source=BookSource.NAVER,
    )
    ub_repo = UserBookRepository(session)
    ub = await ub_repo.create(user_id=user_id, book_id=book.id)

    updated = await ub_repo.update_status(ub.id, UserBookStatus.COMPLETED)
    assert updated.status is UserBookStatus.COMPLETED

    with pytest.raises(NotFoundError):
        await ub_repo.update_status(uuid4(), UserBookStatus.PAUSED)


@pytest.mark.asyncio
async def test_set_rating_review_happy_and_out_of_range(session: AsyncSession) -> None:
    user_id = await _create_user(session, sub="u-rate")
    book_repo = BookRepository(session)
    book = await book_repo.upsert_by_isbn(
        isbn13="9788937460444",
        title="총균쇠",
        author="재레드 다이아몬드",
        publisher=None,
        cover_url=None,
        description=None,
        source=BookSource.NAVER,
    )
    ub_repo = UserBookRepository(session)
    ub = await ub_repo.create(user_id=user_id, book_id=book.id)
    now = datetime.now(tz=UTC)

    done = await ub_repo.set_rating_review(
        ub.id,
        rating=5,
        one_line_review="인생책",
        finished_at=now,
        status=UserBookStatus.COMPLETED,
    )
    assert done.rating == 5
    assert done.one_line_review == "인생책"
    assert done.status is UserBookStatus.COMPLETED
    assert done.finished_at is not None

    with pytest.raises(ConflictError) as exc_info:
        await ub_repo.set_rating_review(ub.id, rating=99, one_line_review=None)
    assert exc_info.value.code == "RATING_OUT_OF_RANGE"


@pytest.mark.asyncio
async def test_list_for_user_status_filter_and_pagination(session: AsyncSession) -> None:
    user_id = await _create_user(session, sub="u-list")
    book_repo = BookRepository(session)
    ub_repo = UserBookRepository(session)

    # Seed 5 UserBooks with strictly decreasing started_at to make
    # cursor ordering observable.
    created = []
    now = datetime.now(tz=UTC)
    for i in range(5):
        book = await book_repo.upsert_by_isbn(
            isbn13=f"978893746{i:04d}",
            title=f"book-{i}",
            author="a",
            publisher=None,
            cover_url=None,
            description=None,
            source=BookSource.NAVER,
        )
        ub = await ub_repo.create(user_id=user_id, book_id=book.id)
        # Manually set started_at so the test is deterministic.
        ub.started_at = now - timedelta(hours=i)
        await session.flush()
        created.append(ub)

    # Mark the second one completed so the status filter can exclude it.
    await ub_repo.update_status(created[1].id, UserBookStatus.COMPLETED)

    # First page, no status filter, limit=3 — expect the 3 most recent (i=0,1,2).
    page1 = await ub_repo.list_for_user(user_id, status=None, cursor=None, limit=3)
    assert [ub.id for ub in page1] == [
        created[0].id,
        created[1].id,
        created[2].id,
    ]

    # Continue from page1's last started_at — expect (i=3,4).
    last_started = page1[-1].started_at
    page2 = await ub_repo.list_for_user(user_id, status=None, cursor=last_started, limit=3)
    assert [ub.id for ub in page2] == [created[3].id, created[4].id]

    # Status filter only returns completed row.
    only_done = await ub_repo.list_for_user(
        user_id, status=UserBookStatus.COMPLETED, cursor=None, limit=10
    )
    assert [ub.id for ub in only_done] == [created[1].id]

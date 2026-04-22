"""Unit tests for BookService with in-memory fakes for every Port.

No DB, no HTTP — every collaborator is a dict-backed stub that implements
the Port Protocol shape. Covers the business rules owned by the service:
- search_books caches external results as catalog rows
- add_to_library raises NotFoundError when the book is missing,
  ConflictError(BOOK_ALREADY_IN_LIBRARY) on duplicates
- update_status returns 404 on ownership failure (no ForbiddenError
  leak) and happy-paths any-to-any transitions
- submit_review transitions to completed, stamps finished_at, and rejects
  out-of-range rating + over-length review
- list_library clamps limit and emits next_cursor only on full pages
"""

from __future__ import annotations

from datetime import UTC, datetime, timedelta
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError, NotFoundError
from app.domains.book.models import Book, BookSource, UserBook, UserBookStatus
from app.domains.book.ports import BookSearchResult, ExternalBook
from app.domains.book.service import BookService


class FakeBookRepo:
    def __init__(self) -> None:
        self.by_id: dict[UUID, Book] = {}
        self.by_isbn: dict[str, UUID] = {}

    async def upsert_by_isbn(
        self,
        *,
        isbn13: str,
        title: str,
        author: str,
        publisher: str | None,
        cover_url: str | None,
        description: str | None,
        source: BookSource,
    ) -> Book:
        existing_id = self.by_isbn.get(isbn13)
        if existing_id is not None:
            existing = self.by_id[existing_id]
            existing.title = title
            existing.author = author
            existing.publisher = publisher
            existing.cover_url = cover_url
            existing.description = description
            existing.source = source
            return existing
        book = Book(
            isbn13=isbn13,
            title=title,
            author=author,
            publisher=publisher,
            cover_url=cover_url,
            description=description,
            source=source,
        )
        book.id = uuid4()
        self.by_id[book.id] = book
        self.by_isbn[isbn13] = book.id
        return book

    async def get_by_id(self, book_id: UUID) -> Book | None:
        return self.by_id.get(book_id)

    async def get_by_isbn(self, isbn13: str) -> Book | None:
        book_id = self.by_isbn.get(isbn13)
        return self.by_id.get(book_id) if book_id else None


class FakeUserBookRepo:
    def __init__(self) -> None:
        self.by_id: dict[UUID, UserBook] = {}
        self.by_user_book: dict[tuple[UUID, UUID], UUID] = {}

    async def create(
        self,
        *,
        user_id: UUID,
        book_id: UUID,
        status: UserBookStatus = UserBookStatus.READING,
    ) -> UserBook:
        if (user_id, book_id) in self.by_user_book:
            raise ConflictError("already in library", code="BOOK_ALREADY_IN_LIBRARY")
        ub = UserBook(user_id=user_id, book_id=book_id, status=status)
        ub.id = uuid4()
        ub.started_at = datetime.now(tz=UTC)
        self.by_id[ub.id] = ub
        self.by_user_book[(user_id, book_id)] = ub.id
        return ub

    async def get_by_id(self, user_book_id: UUID) -> UserBook | None:
        return self.by_id.get(user_book_id)

    async def get_by_user_and_book(self, user_id: UUID, book_id: UUID) -> UserBook | None:
        ub_id = self.by_user_book.get((user_id, book_id))
        return self.by_id.get(ub_id) if ub_id else None

    async def update_status(self, user_book_id: UUID, status: UserBookStatus) -> UserBook:
        ub = self.by_id.get(user_book_id)
        if ub is None:
            raise NotFoundError("not found", code="USER_BOOK_NOT_FOUND")
        ub.status = status
        return ub

    async def set_rating_review(
        self,
        user_book_id: UUID,
        *,
        rating: int,
        one_line_review: str | None,
        finished_at: datetime | None = None,
        status: UserBookStatus | None = None,
    ) -> UserBook:
        ub = self.by_id.get(user_book_id)
        if ub is None:
            raise NotFoundError("not found", code="USER_BOOK_NOT_FOUND")
        ub.rating = rating
        ub.one_line_review = one_line_review
        if finished_at is not None:
            ub.finished_at = finished_at
        if status is not None:
            ub.status = status
        return ub

    async def list_for_user(
        self,
        user_id: UUID,
        *,
        status: UserBookStatus | None,
        cursor: datetime | None,
        limit: int,
    ) -> list[UserBook]:
        rows = [ub for ub in self.by_id.values() if ub.user_id == user_id]
        if status is not None:
            rows = [ub for ub in rows if ub.status == status]
        if cursor is not None:
            rows = [ub for ub in rows if ub.started_at is not None and ub.started_at < cursor]
        rows.sort(
            key=lambda u: (u.started_at or datetime.min.replace(tzinfo=UTC), u.id),
            reverse=True,
        )
        return rows[:limit]


class StubSearch:
    def __init__(self, result: BookSearchResult) -> None:
        self.result = result
        self.calls: list[tuple[str, int, int]] = []

    async def search(self, query: str, *, page: int = 1, size: int = 20) -> BookSearchResult:
        self.calls.append((query, page, size))
        return self.result


def _build_service(
    *, external_items: list[ExternalBook] | None = None, total: int = 0
) -> tuple[BookService, FakeBookRepo, FakeUserBookRepo, StubSearch]:
    books = FakeBookRepo()
    user_books = FakeUserBookRepo()
    search = StubSearch(
        BookSearchResult(
            items=external_items or [],
            total=total,
            page=1,
            size=20,
        )
    )
    service = BookService(books=books, user_books=user_books, search_provider=search)
    return service, books, user_books, search


def _external(isbn13: str, title: str = "책") -> ExternalBook:
    return ExternalBook(
        isbn13=isbn13,
        title=title,
        author="저자",
        publisher=None,
        cover_url=None,
        description=None,
        source=BookSource.NAVER,
    )


@pytest.mark.asyncio
async def test_search_books_upserts_each_item_into_catalog() -> None:
    items = [_external("9788937460777"), _external("9788937460555")]
    service, books, _, search = _build_service(external_items=items, total=2)

    result = await service.search_books("query")

    assert len(result.items) == 2
    # Both items now live in the local catalog.
    assert len(books.by_isbn) == 2
    assert search.calls == [("query", 1, 20)]
    assert result.has_more is False


@pytest.mark.asyncio
async def test_search_books_has_more_when_total_exceeds_page() -> None:
    # Full page of 20 items and total=100 signals more results available.
    items = [_external(f"978893746{i:04d}") for i in range(20)]
    service, _, _, _ = _build_service(external_items=items, total=100)

    result = await service.search_books("q", page=1, size=20)

    assert result.has_more is True


@pytest.mark.asyncio
async def test_get_book_returns_or_raises() -> None:
    service, books, _, _ = _build_service()
    seeded = await books.upsert_by_isbn(
        isbn13="9788937460777",
        title="t",
        author="a",
        publisher=None,
        cover_url=None,
        description=None,
        source=BookSource.NAVER,
    )
    fetched = await service.get_book(seeded.id)
    assert fetched.id == seeded.id

    with pytest.raises(NotFoundError):
        await service.get_book(uuid4())


@pytest.mark.asyncio
async def test_add_to_library_happy_and_duplicate() -> None:
    service, books, _, _ = _build_service()
    seeded = await books.upsert_by_isbn(
        isbn13="9788937460777",
        title="t",
        author="a",
        publisher=None,
        cover_url=None,
        description=None,
        source=BookSource.NAVER,
    )
    user_id = uuid4()

    ub = await service.add_to_library(user_id=user_id, book_id=seeded.id)
    assert ub.status is UserBookStatus.READING

    with pytest.raises(ConflictError) as exc_info:
        await service.add_to_library(user_id=user_id, book_id=seeded.id)
    assert exc_info.value.code == "BOOK_ALREADY_IN_LIBRARY"


@pytest.mark.asyncio
async def test_add_to_library_missing_book_raises_not_found() -> None:
    service, _, _, _ = _build_service()

    with pytest.raises(NotFoundError) as exc_info:
        await service.add_to_library(user_id=uuid4(), book_id=uuid4())
    assert exc_info.value.code == "BOOK_NOT_FOUND"


@pytest.mark.asyncio
async def test_update_status_returns_404_when_not_owner() -> None:
    service, books, _, _ = _build_service()
    seeded = await books.upsert_by_isbn(
        isbn13="9788937460777",
        title="t",
        author="a",
        publisher=None,
        cover_url=None,
        description=None,
        source=BookSource.NAVER,
    )
    owner = uuid4()
    attacker = uuid4()
    ub = await service.add_to_library(user_id=owner, book_id=seeded.id)

    # Right user can transition freely.
    updated = await service.update_status(
        user_id=owner, user_book_id=ub.id, status=UserBookStatus.PAUSED
    )
    assert updated.status is UserBookStatus.PAUSED

    # Another user gets 404 (not 403) — don't leak existence.
    with pytest.raises(NotFoundError):
        await service.update_status(
            user_id=attacker, user_book_id=ub.id, status=UserBookStatus.DROPPED
        )


@pytest.mark.asyncio
async def test_submit_review_transitions_to_completed_and_stamps_finished_at() -> None:
    service, books, _, _ = _build_service()
    seeded = await books.upsert_by_isbn(
        isbn13="9788937460777",
        title="t",
        author="a",
        publisher=None,
        cover_url=None,
        description=None,
        source=BookSource.NAVER,
    )
    user_id = uuid4()
    ub = await service.add_to_library(user_id=user_id, book_id=seeded.id)
    assert ub.status is UserBookStatus.READING
    assert ub.finished_at is None

    done = await service.submit_review(
        user_id=user_id,
        user_book_id=ub.id,
        rating=5,
        one_line_review="인생책",
    )
    assert done.status is UserBookStatus.COMPLETED
    assert done.rating == 5
    assert done.one_line_review == "인생책"
    assert done.finished_at is not None


@pytest.mark.asyncio
async def test_submit_review_rejects_bad_rating_and_long_review() -> None:
    service, books, _, _ = _build_service()
    seeded = await books.upsert_by_isbn(
        isbn13="9788937460777",
        title="t",
        author="a",
        publisher=None,
        cover_url=None,
        description=None,
        source=BookSource.NAVER,
    )
    user_id = uuid4()
    ub = await service.add_to_library(user_id=user_id, book_id=seeded.id)

    with pytest.raises(ConflictError) as exc_info:
        await service.submit_review(
            user_id=user_id, user_book_id=ub.id, rating=99, one_line_review=None
        )
    assert exc_info.value.code == "RATING_OUT_OF_RANGE"

    with pytest.raises(ConflictError) as exc_info:
        await service.submit_review(
            user_id=user_id,
            user_book_id=ub.id,
            rating=4,
            one_line_review="x" * 201,
        )
    assert exc_info.value.code == "REVIEW_TOO_LONG"


@pytest.mark.asyncio
async def test_submit_review_404_for_non_owner() -> None:
    service, books, _, _ = _build_service()
    seeded = await books.upsert_by_isbn(
        isbn13="9788937460777",
        title="t",
        author="a",
        publisher=None,
        cover_url=None,
        description=None,
        source=BookSource.NAVER,
    )
    owner = uuid4()
    attacker = uuid4()
    ub = await service.add_to_library(user_id=owner, book_id=seeded.id)

    with pytest.raises(NotFoundError):
        await service.submit_review(
            user_id=attacker,
            user_book_id=ub.id,
            rating=5,
            one_line_review=None,
        )


@pytest.mark.asyncio
async def test_list_library_clamps_limit_and_emits_next_cursor() -> None:
    service, books, _user_books, _ = _build_service()
    user_id = uuid4()

    # Seed 5 UserBooks with strictly decreasing started_at.
    now = datetime.now(tz=UTC)
    for i in range(5):
        b = await books.upsert_by_isbn(
            isbn13=f"978893746{i:04d}",
            title=f"t-{i}",
            author="a",
            publisher=None,
            cover_url=None,
            description=None,
            source=BookSource.NAVER,
        )
        ub = await service.add_to_library(user_id=user_id, book_id=b.id)
        ub.started_at = now - timedelta(hours=i)

    # limit=3 → 3 rows and a cursor pointing at the 3rd row's started_at.
    page1 = await service.list_library(user_id=user_id, status=None, cursor=None, limit=3)
    assert len(page1.items) == 3
    assert page1.next_cursor is not None

    # Continue pagination.
    cursor_dt = datetime.fromisoformat(page1.next_cursor)
    page2 = await service.list_library(user_id=user_id, status=None, cursor=cursor_dt, limit=3)
    assert len(page2.items) == 2  # only 2 remaining
    assert page2.next_cursor is None  # short page, no more data

    # Limit clamped to 50 — 999 is silently reduced, no error.
    all_rows = await service.list_library(user_id=user_id, status=None, cursor=None, limit=999)
    assert len(all_rows.items) == 5

"""Unit tests for BookService with in-memory fakes for every Port.

No DB, no HTTP — every collaborator is a dict-backed stub that implements
the Port Protocol shape. Covers the business rules owned by the service:
- search_books caches external results as catalog rows
- add_to_library raises NotFoundError when the book is missing,
  ConflictError(BOOK_ALREADY_IN_LIBRARY) on duplicates
- update_status returns 404 on ownership failure (no ForbiddenError
  leak) and happy-paths any-to-any transitions
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
        page_count: int | None = None,
    ) -> Book:
        existing_id = self.by_isbn.get(isbn13)
        if existing_id is not None:
            existing = self.by_id[existing_id]
            existing.title = title
            existing.author = author
            existing.publisher = publisher
            existing.cover_url = cover_url
            existing.description = description
            existing.page_count = page_count or existing.page_count
            existing.source = source
            return existing
        book = Book(
            isbn13=isbn13,
            title=title,
            author=author,
            publisher=publisher,
            cover_url=cover_url,
            description=description,
            page_count=page_count,
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

    async def update_chapter(self, user_book_id: UUID, current_chapter: int) -> UserBook:
        ub = self.by_id.get(user_book_id)
        if ub is None:
            raise NotFoundError("not found", code="USER_BOOK_NOT_FOUND")
        ub.current_chapter = current_chapter
        return ub

    async def delete(self, user_book_id: UUID) -> None:
        self.by_id.pop(user_book_id, None)

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

    async def count_for_user(self, user_id: UUID, *, status: UserBookStatus | None) -> int:
        rows = [ub for ub in self.by_id.values() if ub.user_id == user_id]
        if status is not None:
            rows = [ub for ub in rows if ub.status == status]
        return len(rows)


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
        page_count=None,
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


@pytest.mark.asyncio
async def test_count_library_filters_by_status() -> None:
    """count_library (BC-80) — used by the community "내 활동" summary."""
    service, books, _, _ = _build_service()
    user_id = uuid4()
    b1 = await books.upsert_by_isbn(
        isbn13="9788937461234",
        title="t1",
        author="a",
        publisher=None,
        cover_url=None,
        description=None,
        source=BookSource.NAVER,
    )
    b2 = await books.upsert_by_isbn(
        isbn13="9788937465678",
        title="t2",
        author="a",
        publisher=None,
        cover_url=None,
        description=None,
        source=BookSource.NAVER,
    )
    await service.add_to_library(user_id=user_id, book_id=b1.id, status=UserBookStatus.READING)
    await service.add_to_library(user_id=user_id, book_id=b2.id, status=UserBookStatus.WISHLIST)

    reading_count = await service.count_library(user_id=user_id, status=UserBookStatus.READING)
    total_count = await service.count_library(user_id=user_id, status=None)

    assert reading_count == 1
    assert total_count == 2


@pytest.mark.asyncio
async def test_remove_from_library_deletes_and_rejects_non_owner() -> None:
    service, books, _, _ = _build_service()
    owner = uuid4()
    attacker = uuid4()
    seeded = await books.upsert_by_isbn(
        isbn13="9788937460999",
        title="t",
        author="a",
        publisher=None,
        cover_url=None,
        description=None,
        source=BookSource.NAVER,
    )
    ub = await service.add_to_library(user_id=owner, book_id=seeded.id)

    # Non-owner gets 404.
    with pytest.raises(NotFoundError):
        await service.remove_from_library(user_id=attacker, user_book_id=ub.id)

    # Owner can delete; library becomes empty afterwards.
    await service.remove_from_library(user_id=owner, user_book_id=ub.id)
    page = await service.list_library(user_id=owner, status=None, cursor=None, limit=10)
    assert len(page.items) == 0


# ---------------------------------------------------------------------------
# update_chapter
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_update_chapter_happy_path() -> None:
    service, books, _, _ = _build_service()
    seeded = await books.upsert_by_isbn(
        isbn13="9788937460111",
        title="t",
        author="a",
        publisher=None,
        cover_url=None,
        description=None,
        source=BookSource.NAVER,
    )
    user_id = uuid4()
    ub = await service.add_to_library(user_id=user_id, book_id=seeded.id)

    updated = await service.update_chapter(user_id=user_id, user_book_id=ub.id, current_chapter=5)
    assert updated.current_chapter == 5


@pytest.mark.asyncio
async def test_update_chapter_non_owner_returns_not_found() -> None:
    service, books, _, _ = _build_service()
    seeded = await books.upsert_by_isbn(
        isbn13="9788937460222",
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
        await service.update_chapter(user_id=attacker, user_book_id=ub.id, current_chapter=3)


@pytest.mark.asyncio
async def test_update_chapter_nonexistent_book_returns_not_found() -> None:
    service, _, _, _ = _build_service()

    with pytest.raises(NotFoundError):
        await service.update_chapter(user_id=uuid4(), user_book_id=uuid4(), current_chapter=1)

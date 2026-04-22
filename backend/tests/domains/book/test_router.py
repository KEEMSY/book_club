"""HTTP contract tests for the book router.

Uses FastAPI ``app.dependency_overrides`` to swap ``get_book_service`` with
an in-memory FakeBookService. No DB, no HTTP to Naver/Kakao.

Coverage:
- 200 happy path for search / get_book / list_library
- 201 for add_to_library; 409 BOOK_ALREADY_IN_LIBRARY on duplicate
- 200 for update_status and submit_review; 404 on not-owned
- 401 for missing auth header
- 422 for rating out of range
- 404 for unknown book_id and unknown user_book_id
"""

from __future__ import annotations

from collections.abc import AsyncIterator
from datetime import UTC, datetime
from uuid import UUID, uuid4

import pytest
import pytest_asyncio
from app.core.exceptions import ConflictError, NotFoundError
from app.core.security import create_access_token
from app.domains.book.models import Book, BookSource, UserBook, UserBookStatus
from app.domains.book.providers import get_book_service
from app.domains.book.service import LibraryPage, SearchBooksResult
from app.main import create_app
from httpx import ASGITransport, AsyncClient


def _book_row() -> Book:
    book = Book(
        isbn13="9788937460777",
        title="오만과 편견",
        author="제인 오스틴",
        publisher="민음사",
        cover_url="https://example.com/cover.jpg",
        description="19세기 영국 사회를 배경으로 한 연애 소설의 고전.",
        source=BookSource.NAVER,
    )
    book.id = uuid4()
    book.created_at = datetime.now(tz=UTC)
    book.updated_at = datetime.now(tz=UTC)
    return book


def _user_book(user_id: UUID, book: Book) -> UserBook:
    ub = UserBook(user_id=user_id, book_id=book.id, status=UserBookStatus.READING)
    ub.id = uuid4()
    ub.started_at = datetime.now(tz=UTC)
    ub.finished_at = None
    ub.rating = None
    ub.one_line_review = None
    ub.book = book
    return ub


class FakeBookService:
    """Records calls and returns configurable results."""

    def __init__(self) -> None:
        self.book = _book_row()
        self.user_book: UserBook | None = None
        # Flags / programmable failures.
        self.search_result: SearchBooksResult | None = None
        self.add_conflict = False
        self.not_found_on_book = False
        self.not_found_on_user_book = False
        self.calls: list[tuple[str, dict]] = []

    async def search_books(self, query: str, *, page: int = 1, size: int = 20) -> SearchBooksResult:
        self.calls.append(("search_books", {"query": query, "page": page, "size": size}))
        if self.search_result is not None:
            return self.search_result
        return SearchBooksResult(items=[self.book], page=page, size=size, has_more=False)

    async def get_book(self, book_id: UUID) -> Book:
        self.calls.append(("get_book", {"book_id": book_id}))
        if self.not_found_on_book:
            raise NotFoundError("book not found", code="BOOK_NOT_FOUND")
        return self.book

    async def add_to_library(self, *, user_id: UUID, book_id: UUID) -> UserBook:
        self.calls.append(("add_to_library", {"user_id": user_id, "book_id": book_id}))
        if self.add_conflict:
            raise ConflictError("already", code="BOOK_ALREADY_IN_LIBRARY")
        if self.not_found_on_book:
            raise NotFoundError("book not found", code="BOOK_NOT_FOUND")
        self.user_book = _user_book(user_id, self.book)
        return self.user_book

    async def update_status(
        self, *, user_id: UUID, user_book_id: UUID, status: UserBookStatus
    ) -> UserBook:
        self.calls.append(
            (
                "update_status",
                {"user_id": user_id, "user_book_id": user_book_id, "status": status},
            )
        )
        if self.not_found_on_user_book:
            raise NotFoundError("not found", code="USER_BOOK_NOT_FOUND")
        if self.user_book is None:
            self.user_book = _user_book(user_id, self.book)
        self.user_book.status = status
        return self.user_book

    async def submit_review(
        self,
        *,
        user_id: UUID,
        user_book_id: UUID,
        rating: int,
        one_line_review: str | None,
    ) -> UserBook:
        self.calls.append(
            (
                "submit_review",
                {
                    "user_id": user_id,
                    "user_book_id": user_book_id,
                    "rating": rating,
                    "one_line_review": one_line_review,
                },
            )
        )
        if self.not_found_on_user_book:
            raise NotFoundError("not found", code="USER_BOOK_NOT_FOUND")
        if self.user_book is None:
            self.user_book = _user_book(user_id, self.book)
        self.user_book.status = UserBookStatus.COMPLETED
        self.user_book.rating = rating
        self.user_book.one_line_review = one_line_review
        self.user_book.finished_at = datetime.now(tz=UTC)
        return self.user_book

    async def list_library(
        self,
        *,
        user_id: UUID,
        status: UserBookStatus | None,
        cursor: datetime | None,
        limit: int,
    ) -> LibraryPage:
        self.calls.append(
            (
                "list_library",
                {
                    "user_id": user_id,
                    "status": status,
                    "cursor": cursor,
                    "limit": limit,
                },
            )
        )
        ub = _user_book(user_id, self.book)
        return LibraryPage(items=[ub], next_cursor=None)


@pytest_asyncio.fixture
async def client_and_fake() -> AsyncIterator[tuple[AsyncClient, FakeBookService, UUID]]:
    app = create_app()
    fake = FakeBookService()
    app.dependency_overrides[get_book_service] = lambda: fake
    transport = ASGITransport(app=app)
    user_id = uuid4()
    async with AsyncClient(transport=transport, base_url="http://testserver") as client:
        yield client, fake, user_id
    app.dependency_overrides.clear()


def _auth(user_id: UUID) -> dict[str, str]:
    return {"Authorization": f"Bearer {create_access_token(str(user_id))}"}


@pytest.mark.asyncio
async def test_search_books_requires_auth(
    client_and_fake: tuple[AsyncClient, FakeBookService, UUID],
) -> None:
    client, _, _ = client_and_fake
    response = await client.get("/books/search", params={"q": "오만과 편견"})
    assert response.status_code == 401


@pytest.mark.asyncio
async def test_search_books_returns_items(
    client_and_fake: tuple[AsyncClient, FakeBookService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    response = await client.get(
        "/books/search",
        params={"q": "오만과 편견"},
        headers=_auth(user_id),
    )
    assert response.status_code == 200
    body = response.json()
    assert body["page"] == 1
    assert body["size"] == 20
    assert body["has_more"] is False
    assert len(body["items"]) == 1
    assert body["items"][0]["title"] == "오만과 편견"
    assert body["items"][0]["isbn13"] == "9788937460777"
    assert fake.calls[0][0] == "search_books"


@pytest.mark.asyncio
async def test_get_book_happy_and_404(
    client_and_fake: tuple[AsyncClient, FakeBookService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    response = await client.get(f"/books/{fake.book.id}", headers=_auth(user_id))
    assert response.status_code == 200
    assert response.json()["id"] == str(fake.book.id)

    fake.not_found_on_book = True
    response = await client.get(f"/books/{uuid4()}", headers=_auth(user_id))
    assert response.status_code == 404
    assert response.json()["error"]["code"] == "BOOK_NOT_FOUND"


@pytest.mark.asyncio
async def test_add_to_library_201_and_409_on_duplicate(
    client_and_fake: tuple[AsyncClient, FakeBookService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    response = await client.post(
        "/me/library",
        json={"book_id": str(fake.book.id)},
        headers=_auth(user_id),
    )
    assert response.status_code == 201
    body = response.json()
    assert body["status"] == "reading"
    assert body["book"]["id"] == str(fake.book.id)

    fake.add_conflict = True
    response = await client.post(
        "/me/library",
        json={"book_id": str(fake.book.id)},
        headers=_auth(user_id),
    )
    assert response.status_code == 409
    assert response.json()["error"]["code"] == "BOOK_ALREADY_IN_LIBRARY"


@pytest.mark.asyncio
async def test_add_to_library_requires_auth(
    client_and_fake: tuple[AsyncClient, FakeBookService, UUID],
) -> None:
    client, fake, _ = client_and_fake
    response = await client.post("/me/library", json={"book_id": str(fake.book.id)})
    assert response.status_code == 401


@pytest.mark.asyncio
async def test_update_status_happy_and_404(
    client_and_fake: tuple[AsyncClient, FakeBookService, UUID],
) -> None:
    client, fake, user_id = client_and_fake

    response = await client.patch(
        f"/me/library/{uuid4()}",
        json={"status": "completed"},
        headers=_auth(user_id),
    )
    assert response.status_code == 200
    assert response.json()["status"] == "completed"

    fake.not_found_on_user_book = True
    response = await client.patch(
        f"/me/library/{uuid4()}",
        json={"status": "paused"},
        headers=_auth(user_id),
    )
    assert response.status_code == 404
    assert response.json()["error"]["code"] == "USER_BOOK_NOT_FOUND"


@pytest.mark.asyncio
async def test_update_status_rejects_invalid_enum(
    client_and_fake: tuple[AsyncClient, FakeBookService, UUID],
) -> None:
    client, _, user_id = client_and_fake
    response = await client.patch(
        f"/me/library/{uuid4()}",
        json={"status": "finished"},  # not in enum
        headers=_auth(user_id),
    )
    assert response.status_code == 422


@pytest.mark.asyncio
async def test_submit_review_happy_and_422_on_bad_rating(
    client_and_fake: tuple[AsyncClient, FakeBookService, UUID],
) -> None:
    client, _, user_id = client_and_fake

    response = await client.post(
        f"/me/library/{uuid4()}/review",
        json={"rating": 5, "one_line_review": "인생책"},
        headers=_auth(user_id),
    )
    assert response.status_code == 200
    body = response.json()
    assert body["status"] == "completed"
    assert body["rating"] == 5
    assert body["one_line_review"] == "인생책"
    assert body["finished_at"] is not None

    # Out-of-range rating → 422 from pydantic.
    response = await client.post(
        f"/me/library/{uuid4()}/review",
        json={"rating": 9, "one_line_review": None},
        headers=_auth(user_id),
    )
    assert response.status_code == 422


@pytest.mark.asyncio
async def test_submit_review_404_when_not_owner(
    client_and_fake: tuple[AsyncClient, FakeBookService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.not_found_on_user_book = True
    response = await client.post(
        f"/me/library/{uuid4()}/review",
        json={"rating": 3, "one_line_review": None},
        headers=_auth(user_id),
    )
    assert response.status_code == 404
    assert response.json()["error"]["code"] == "USER_BOOK_NOT_FOUND"


@pytest.mark.asyncio
async def test_list_library_returns_items(
    client_and_fake: tuple[AsyncClient, FakeBookService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    response = await client.get(
        "/me/library",
        params={"status": "reading", "limit": 10},
        headers=_auth(user_id),
    )
    assert response.status_code == 200
    body = response.json()
    assert len(body["items"]) == 1
    assert body["next_cursor"] is None
    assert body["items"][0]["book"]["title"] == "오만과 편견"
    # Status filter was forwarded to the service.
    assert fake.calls[0][0] == "list_library"
    assert fake.calls[0][1]["status"] == UserBookStatus.READING
    assert fake.calls[0][1]["limit"] == 10


@pytest.mark.asyncio
async def test_list_library_rejects_bad_status(
    client_and_fake: tuple[AsyncClient, FakeBookService, UUID],
) -> None:
    client, _, user_id = client_and_fake
    response = await client.get(
        "/me/library",
        params={"status": "finished"},
        headers=_auth(user_id),
    )
    assert response.status_code == 422


@pytest.mark.asyncio
async def test_list_library_requires_auth(
    client_and_fake: tuple[AsyncClient, FakeBookService, UUID],
) -> None:
    client, _, _ = client_and_fake
    response = await client.get("/me/library")
    assert response.status_code == 401

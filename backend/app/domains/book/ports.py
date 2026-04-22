"""Book domain ports — the only contracts ``service.py`` is allowed to import.

Per CLAUDE.md §3.2 the Port/Adapter boundary is enforced strictly for external
collaborators (Naver / Kakao book APIs). The repository ports are kept
Port-shaped even though they have a 1:1 implementation, because the service
layer is unit-tested against in-memory fakes that implement the same Protocol.

DTOs (``ExternalBook``, ``BookSearchResult``) live here rather than in
``schemas.py`` so they never leak pydantic / HTTP concerns into the domain.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
from typing import Protocol
from uuid import UUID

from app.domains.book.models import Book, BookSource, UserBook, UserBookStatus


@dataclass(frozen=True, slots=True)
class ExternalBook:
    """Normalized shape returned by any external book search adapter.

    Adapters are responsible for cleaning provider-specific artefacts
    (e.g. Naver's ``<b>...</b>`` emphasis tags, pipe-delimited authors)
    so the service layer sees consistent, clean strings.
    """

    isbn13: str
    title: str
    author: str
    publisher: str | None
    cover_url: str | None
    description: str | None
    source: BookSource


@dataclass(frozen=True, slots=True)
class BookSearchResult:
    """Paginated search result wrapper."""

    items: list[ExternalBook]
    total: int
    page: int
    size: int


class BookRepositoryPort(Protocol):
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
    ) -> Book: ...

    async def get_by_id(self, book_id: UUID) -> Book | None: ...

    async def get_by_isbn(self, isbn13: str) -> Book | None: ...


class UserBookRepositoryPort(Protocol):
    async def create(
        self,
        *,
        user_id: UUID,
        book_id: UUID,
        status: UserBookStatus = UserBookStatus.READING,
    ) -> UserBook: ...

    async def get_by_id(self, user_book_id: UUID) -> UserBook | None: ...

    async def get_by_user_and_book(self, user_id: UUID, book_id: UUID) -> UserBook | None: ...

    async def update_status(self, user_book_id: UUID, status: UserBookStatus) -> UserBook: ...

    async def set_rating_review(
        self,
        user_book_id: UUID,
        *,
        rating: int,
        one_line_review: str | None,
        finished_at: datetime | None = None,
        status: UserBookStatus | None = None,
    ) -> UserBook: ...

    async def list_for_user(
        self,
        user_id: UUID,
        *,
        status: UserBookStatus | None,
        cursor: datetime | None,
        limit: int,
    ) -> list[UserBook]: ...


class BookSearchPort(Protocol):
    async def search(self, query: str, *, page: int = 1, size: int = 20) -> BookSearchResult: ...

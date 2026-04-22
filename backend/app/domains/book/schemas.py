"""Pydantic v2 DTOs for the book router.

These are the sole types the mobile client observes at the HTTP boundary.
The router never leaks SQLAlchemy models past this shell.
"""

from __future__ import annotations

from datetime import datetime
from typing import Literal
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field

from app.domains.book.models import Book, UserBook


class BookPublic(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    isbn13: str
    title: str
    author: str
    publisher: str | None
    cover_url: str | None
    description: str | None

    @classmethod
    def from_book(cls, book: Book) -> BookPublic:
        return cls.model_validate(book)


# For now SearchBookItem is identical to BookPublic; leaving a dedicated type
# so M2.B mobile can add ``in_library: bool`` without a wire break.
class SearchBookItem(BookPublic):
    pass


class SearchBooksResponse(BaseModel):
    items: list[SearchBookItem]
    page: int
    size: int
    has_more: bool


class AddToLibraryRequest(BaseModel):
    book_id: UUID


class UpdateStatusRequest(BaseModel):
    status: Literal["reading", "completed", "paused", "dropped"]


class SubmitReviewRequest(BaseModel):
    rating: int = Field(ge=1, le=5)
    one_line_review: str | None = Field(default=None, max_length=200)


class UserBookPublic(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    book: BookPublic
    status: Literal["reading", "completed", "paused", "dropped"]
    started_at: datetime | None
    finished_at: datetime | None
    rating: int | None
    one_line_review: str | None

    @classmethod
    def from_user_book(cls, ub: UserBook) -> UserBookPublic:
        return cls.model_validate(
            {
                "id": ub.id,
                "book": BookPublic.model_validate(ub.book),
                "status": ub.status.value,
                "started_at": ub.started_at,
                "finished_at": ub.finished_at,
                "rating": ub.rating,
                "one_line_review": ub.one_line_review,
            }
        )


class LibraryResponse(BaseModel):
    items: list[UserBookPublic]
    next_cursor: str | None

"""HTTP surface for the book domain — /books/* and /me/library/*.

Keep this file thin: every handler is at most a DTO -> service -> DTO
adapter. Business decisions live in ``service.py``. The router never
catches domain exceptions; the global handler translates them (CLAUDE.md
§3.1).
"""

from __future__ import annotations

from datetime import datetime
from typing import Annotated, Literal
from uuid import UUID

from fastapi import APIRouter, Depends, Query, status

from app.core.deps import get_current_user_id
from app.domains.book.models import UserBookStatus
from app.domains.book.providers import get_book_service
from app.domains.book.schemas import (
    AddToLibraryRequest,
    BookPublic,
    LibraryResponse,
    SearchBookItem,
    SearchBooksResponse,
    SubmitReviewRequest,
    UpdateStatusRequest,
    UserBookPublic,
)
from app.domains.book.service import BookService

router = APIRouter(tags=["book"])


def _parse_cursor(raw: str | None) -> datetime | None:
    if raw is None or raw == "":
        return None
    try:
        return datetime.fromisoformat(raw)
    except ValueError:
        # Silently treat a malformed cursor as "start of collection" — the
        # alternative (422) breaks the mobile app's graceful-recovery flow
        # when a stale cursor gets retried.
        return None


@router.get("/books/search", response_model=SearchBooksResponse)
async def search_books(
    q: Annotated[str, Query(min_length=1, max_length=200)],
    _user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[BookService, Depends(get_book_service)],
    page: Annotated[int, Query(ge=1, le=100)] = 1,
    size: Annotated[int, Query(ge=1, le=50)] = 20,
) -> SearchBooksResponse:
    result = await service.search_books(q, page=page, size=size)
    return SearchBooksResponse(
        items=[SearchBookItem.model_validate(b) for b in result.items],
        page=result.page,
        size=result.size,
        has_more=result.has_more,
    )


@router.get("/books/{book_id}", response_model=BookPublic)
async def get_book(
    book_id: UUID,
    _user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[BookService, Depends(get_book_service)],
) -> BookPublic:
    book = await service.get_book(book_id)
    return BookPublic.from_book(book)


@router.post(
    "/me/library",
    response_model=UserBookPublic,
    status_code=status.HTTP_201_CREATED,
)
async def add_to_library(
    body: AddToLibraryRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[BookService, Depends(get_book_service)],
) -> UserBookPublic:
    ub = await service.add_to_library(user_id=UUID(user_id), book_id=body.book_id)
    return UserBookPublic.from_user_book(ub)


@router.patch("/me/library/{user_book_id}", response_model=UserBookPublic)
async def update_library_status(
    user_book_id: UUID,
    body: UpdateStatusRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[BookService, Depends(get_book_service)],
) -> UserBookPublic:
    ub = await service.update_status(
        user_id=UUID(user_id),
        user_book_id=user_book_id,
        status=UserBookStatus(body.status),
    )
    return UserBookPublic.from_user_book(ub)


@router.post("/me/library/{user_book_id}/review", response_model=UserBookPublic)
async def submit_review(
    user_book_id: UUID,
    body: SubmitReviewRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[BookService, Depends(get_book_service)],
) -> UserBookPublic:
    ub = await service.submit_review(
        user_id=UUID(user_id),
        user_book_id=user_book_id,
        rating=body.rating,
        one_line_review=body.one_line_review,
    )
    return UserBookPublic.from_user_book(ub)


@router.get("/me/library", response_model=LibraryResponse)
async def list_library(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[BookService, Depends(get_book_service)],
    status_filter: Annotated[
        Literal["reading", "completed", "paused", "dropped"] | None,
        Query(alias="status"),
    ] = None,
    cursor: Annotated[str | None, Query()] = None,
    limit: Annotated[int, Query(ge=1, le=50)] = 20,
) -> LibraryResponse:
    parsed_status = UserBookStatus(status_filter) if status_filter is not None else None
    parsed_cursor = _parse_cursor(cursor)
    page = await service.list_library(
        user_id=UUID(user_id),
        status=parsed_status,
        cursor=parsed_cursor,
        limit=limit,
    )
    return LibraryResponse(
        items=[UserBookPublic.from_user_book(ub) for ub in page.items],
        next_cursor=page.next_cursor,
    )

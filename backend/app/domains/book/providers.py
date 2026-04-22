"""FastAPI dependency factories for the book domain.

Keeps the router file free of wiring code (CLAUDE.md §3.1) and gives tests
a stable seam: override ``get_book_service`` with
``app.dependency_overrides`` to inject a FakeBookService in router tests.
"""

from __future__ import annotations

from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.book.adapters.composite_book_search_adapter import (
    CompositeBookSearchAdapter,
)
from app.domains.book.adapters.kakao_book_adapter import KakaoBookAdapter
from app.domains.book.adapters.naver_book_adapter import NaverBookAdapter
from app.domains.book.repository import BookRepository, UserBookRepository
from app.domains.book.service import BookService


def get_book_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> BookService:
    """Construct a BookService wired with live repositories + the composite
    search adapter (Naver primary, Kakao fallback).
    """
    search = CompositeBookSearchAdapter(
        primary=NaverBookAdapter(),
        fallback=KakaoBookAdapter(),
    )
    return BookService(
        books=BookRepository(session),
        user_books=UserBookRepository(session),
        search_provider=search,
    )

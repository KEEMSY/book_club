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
from app.domains.feed.providers import get_feed_service
from app.domains.reading.providers import get_event_bus
from app.shared.event_bus import commit_and_publish, stage_event


def get_book_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> BookService:
    """Construct a BookService wired with live repositories + the composite
    search adapter (Naver primary, Kakao fallback).

    ``feed_service`` is injected to fire CHAPTER_MILESTONE and BOOK_COMPLETED
    activity events when the user updates chapter progress or finishes a book.
    """
    bus = get_event_bus()

    def _stage(event: object) -> None:
        stage_event(session, event)

    commit_and_publish(session, bus)

    search = CompositeBookSearchAdapter(
        primary=NaverBookAdapter(),
        fallback=KakaoBookAdapter(),
    )
    return BookService(
        books=BookRepository(session),
        user_books=UserBookRepository(session),
        search_provider=search,
        stage_event=_stage,
        feed_service=get_feed_service(session),
    )

"""FastAPI dependency factories for the review domain.

Composition root: concrete adapters (book completion query, feed event
publisher) are assembled here so the service stays Port-only (CLAUDE.md §3.1).
"""

from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.book.models import UserBookStatus
from app.domains.book.repository import UserBookRepository
from app.domains.feed.repository import FeedEventRepository
from app.domains.review.repository import BookReviewRepository
from app.domains.review.service import ReviewService


class _UserBookQueryAdapter:
    """Implements ``UserBookQueryPort`` over the book domain's repository."""

    def __init__(self, repo: UserBookRepository) -> None:
        self._repo = repo

    async def is_completed(self, user_id: UUID, book_id: UUID) -> bool:
        ub = await self._repo.get_by_user_and_book(user_id, book_id)
        return ub is not None and ub.status == UserBookStatus.COMPLETED


def get_review_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> ReviewService:
    """Construct a ReviewService wired with live repositories and the feed
    event publisher."""
    return ReviewService(
        reviews=BookReviewRepository(session),
        user_books=_UserBookQueryAdapter(UserBookRepository(session)),
        feed_events=FeedEventRepository(session),
    )

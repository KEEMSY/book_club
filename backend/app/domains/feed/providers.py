"""FastAPI dependency factories for the feed domain.

Keeps the router file free of wiring code (CLAUDE.md §3.1) and gives
tests a stable seam: override ``get_feed_service`` /
``get_feed_user_query`` with ``app.dependency_overrides`` to inject
in-memory fakes.
"""

from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.auth.repository import UserRepository
from app.domains.book.repository import BookRepository
from app.domains.feed.adapters.r2_image_storage_adapter import R2ImageStorageAdapter
from app.domains.feed.ports import AuthorView
from app.domains.feed.repository import (
    CommentRepository,
    PostRepository,
    ReactionRepository,
)
from app.domains.feed.service import FeedService
from app.domains.reading.providers import get_event_bus
from app.shared.event_bus import commit_and_publish, stage_event


class _FeedBookQueryAdapter:
    """Cross-domain implementation — reads through the book repository."""

    def __init__(self, books: BookRepository) -> None:
        self._books = books

    async def book_exists(self, book_id: UUID) -> bool:
        return (await self._books.get_by_id(book_id)) is not None


class _FeedUserQueryAdapter:
    """Cross-domain implementation — reads through the user repository.

    A future optimisation may batch with a single ``WHERE id IN (...)``
    query; the current per-id read is fine for M4 page sizes (≤50).
    """

    def __init__(self, users: UserRepository) -> None:
        self._users = users

    async def get_authors(self, user_ids: list[UUID]) -> dict[UUID, AuthorView]:
        out: dict[UUID, AuthorView] = {}
        for uid in user_ids:
            user = await self._users.get_by_id(uid)
            if user is None:
                continue
            out[uid] = AuthorView(
                id=user.id,
                nickname=user.nickname,
                profile_image_url=user.profile_image_url,
            )
        return out


def get_feed_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> FeedService:
    """Construct a FeedService wired with live repositories, R2 image storage,
    and the process-wide event bus so feed events propagate to notification.
    """
    bus = get_event_bus()

    def _stage(event: object) -> None:
        stage_event(session, event)

    # One-shot after_commit hook ties event delivery to the request transaction.
    commit_and_publish(session, bus)

    return FeedService(
        posts=PostRepository(session),
        reactions=ReactionRepository(session),
        comments=CommentRepository(session),
        image_storage=R2ImageStorageAdapter(),
        book_query=_FeedBookQueryAdapter(BookRepository(session)),
        bus=bus,
        stage_event=_stage,
    )


def get_feed_user_query(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> _FeedUserQueryAdapter:
    """Returns the cross-domain user lookup the feed router uses to
    hydrate ``AuthorPublic`` for each post and comment.
    """
    return _FeedUserQueryAdapter(UserRepository(session))

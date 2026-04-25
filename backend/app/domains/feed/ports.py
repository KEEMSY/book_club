"""Feed domain ports — the only contracts ``service.py`` is allowed to import.

Per CLAUDE.md §3.2 the Port/Adapter boundary is enforced strictly for the
external collaborator (R2 / MinIO presign). Repository ports are kept
Port-shaped even though they have a 1:1 implementation so the service
layer can be unit-tested against in-memory fakes that implement the same
Protocol.

DTOs (``PresignedUpload``, ``PostFeedItem``) live here rather than in
``schemas.py`` so they never leak pydantic / HTTP concerns into the
domain.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
from typing import Protocol
from uuid import UUID

from app.domains.feed.models import (
    Comment,
    Post,
    PostType,
    Reaction,
    ReactionType,
)


@dataclass(frozen=True, slots=True)
class PresignedUpload:
    """Output of an upload-presign call.

    ``url`` is a one-shot HTTP PUT target. ``key`` is the R2 object key the
    server will persist on the post (never the URL — the read path signs
    a fresh GET on demand). ``headers`` carries the Content-Type the
    presign was bound to so the client must echo it on PUT.
    """

    url: str
    key: str
    headers: dict[str, str]
    expires_in: int


@dataclass(frozen=True, slots=True)
class PostFeedItem:
    """Service-layer composition of a Post with its derived counters.

    ``image_urls`` are short-lived signed GETs materialised at read time
    from ``post.image_keys``; the DB never stores time-bounded URLs.
    """

    post: Post
    reactions: dict[ReactionType, int]
    my_reactions: set[ReactionType]
    comment_count: int
    image_urls: list[str]


class PostRepositoryPort(Protocol):
    async def create(
        self,
        *,
        user_id: UUID,
        book_id: UUID,
        post_type: PostType,
        content: str,
        image_keys: list[str],
    ) -> Post: ...

    async def get_by_id(self, post_id: UUID) -> Post | None: ...

    async def list_by_book(
        self,
        book_id: UUID,
        *,
        cursor: datetime | None,
        limit: int,
    ) -> list[Post]: ...

    async def soft_delete(self, post_id: UUID, at: datetime) -> None: ...

    async def comment_counts_for(self, post_ids: list[UUID]) -> dict[UUID, int]: ...


class ReactionRepositoryPort(Protocol):
    async def add(
        self,
        *,
        post_id: UUID,
        user_id: UUID,
        reaction_type: ReactionType,
    ) -> Reaction: ...

    async def remove(
        self,
        *,
        post_id: UUID,
        user_id: UUID,
        reaction_type: ReactionType,
    ) -> int: ...

    async def aggregate_for_post(self, post_id: UUID) -> dict[ReactionType, int]: ...

    async def reactions_by_user(self, post_id: UUID, user_id: UUID) -> set[ReactionType]: ...

    async def aggregates_for_posts(
        self, post_ids: list[UUID]
    ) -> dict[UUID, dict[ReactionType, int]]: ...

    async def my_reactions_for_posts(
        self, post_ids: list[UUID], user_id: UUID
    ) -> dict[UUID, set[ReactionType]]: ...


class CommentRepositoryPort(Protocol):
    async def create(
        self,
        *,
        user_id: UUID,
        post_id: UUID,
        parent_id: UUID | None,
        content: str,
    ) -> Comment: ...

    async def get_by_id(self, comment_id: UUID) -> Comment | None: ...

    async def list_by_post(
        self,
        post_id: UUID,
        *,
        cursor: datetime | None,
        limit: int,
    ) -> list[Comment]: ...

    async def soft_delete(self, comment_id: UUID, at: datetime) -> None: ...


class ImageStoragePort(Protocol):
    """Wraps R2 presign for the upload contract.

    Service stays UploadPort-agnostic — the adapter chooses between R2,
    MinIO, or an in-memory stub for tests.
    """

    async def presign_upload(
        self,
        key: str,
        *,
        content_type: str,
        expires_in: int = 600,
    ) -> PresignedUpload: ...

    async def public_url(self, key: str) -> str: ...


class FeedBookQueryPort(Protocol):
    """Cross-domain read of the book catalog.

    Defined here (rather than reaching into ``book.repository``) so the
    feed service depends only on its own ports per CLAUDE.md §3.3. The
    concrete implementation lives in ``providers.py`` and delegates to
    ``BookRepository.get_by_id``.
    """

    async def book_exists(self, book_id: UUID) -> bool: ...


@dataclass(frozen=True, slots=True)
class AuthorView:
    """Cross-domain read shape — minimal user info safe to expose."""

    id: UUID
    nickname: str | None
    profile_image_url: str | None


class FeedUserQueryPort(Protocol):
    """Cross-domain read of user profile info for feed authors.

    Implementation in ``providers.py`` delegates to ``UserRepository``.
    """

    async def get_authors(self, user_ids: list[UUID]) -> dict[UUID, AuthorView]: ...

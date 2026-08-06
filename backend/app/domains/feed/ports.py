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
    FeedComment,
    FeedEvent,
    FeedEventReaction,
    Post,
    PostHighlight,
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


@dataclass(frozen=True, slots=True)
class BookSnapshot:
    """Minimal book info for enriching feed posts at the router layer."""

    id: UUID
    title: str
    cover_url: str | None


class FeedBookQueryPort(Protocol):
    """Cross-domain read of the book catalog.

    Defined here (rather than reaching into ``book.repository``) so the
    feed service depends only on its own ports per CLAUDE.md §3.3. The
    concrete implementation lives in ``providers.py`` and delegates to
    ``BookRepository.get_by_id``.
    """

    async def book_exists(self, book_id: UUID) -> bool: ...

    async def get_book_snapshot(self, book_id: UUID) -> BookSnapshot | None: ...


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


@dataclass(frozen=True, slots=True)
class HighlightWithBookId:
    """Pairs a highlight with its parent book_id for the all-highlights endpoint.

    ``book_id`` is not stored on ``PostHighlight`` directly; it comes from the
    ``user_books`` JOIN. This DTO carries both so the service can group
    highlights by book without an additional query per row.
    """

    highlight: PostHighlight
    book_id: UUID


@dataclass(frozen=True, slots=True)
class FeedEventWithReactionsItem:
    """Service-layer composition of a FeedEvent with its reactions and comment count."""

    event: FeedEvent
    reactions: list[FeedEventReaction]
    comment_count: int


@dataclass(frozen=True, slots=True)
class ExploreHighlightItem:
    """A public highlight enriched for the discovery feed.

    ``book_id`` / ``book_title`` / ``book_cover_url`` come from the
    ``user_books`` → ``books`` JOIN (not stored on ``PostHighlight``).
    ``reaction_count`` is the number of reactions on the highlight's
    HIGHLIGHT_SHARED feed event, computed by a correlated subquery so the
    explore page stays N+1 free.
    """

    highlight: PostHighlight
    book_id: UUID
    book_title: str | None
    book_cover_url: str | None
    reaction_count: int


@dataclass(frozen=True, slots=True)
class MyHighlightItem:
    """A caller's own highlight enriched with book display info (BC-80).

    ``book_id``/``book_title``/``book_cover_url`` come from the
    ``user_books`` → ``books`` JOIN, mirroring :class:`ExploreHighlightItem`
    but without the reaction count (not needed for the "내 활동" list).
    """

    highlight: PostHighlight
    book_id: UUID
    book_title: str | None
    book_cover_url: str | None


class FeedEventRepositoryPort(Protocol):
    """Append-only log of per-user activity events, with M47 read extensions."""

    async def create_event(
        self,
        *,
        user_id: UUID,
        event_type: str,
        metadata: dict[str, object] | None,
    ) -> object: ...

    async def get_by_id(self, event_id: UUID) -> FeedEvent | None: ...

    async def list_global(self, *, cursor: str | None, limit: int) -> list[FeedEvent]: ...

    async def list_following(
        self,
        *,
        user_id: UUID,
        cursor: str | None,
        limit: int,
    ) -> list[FeedEvent]: ...

    async def comment_counts_for_events(self, event_ids: list[UUID]) -> dict[UUID, int]: ...

    async def find_highlight_share(self, highlight_id: UUID) -> FeedEvent | None: ...


class FeedEventReactionRepositoryPort(Protocol):
    """Reactions on feed_events (activity stream entries)."""

    async def add(self, *, event_id: UUID, user_id: UUID, emoji: str) -> FeedEventReaction: ...

    async def remove(self, *, event_id: UUID, user_id: UUID, emoji: str) -> bool: ...

    async def get_for_event(self, event_id: UUID) -> list[FeedEventReaction]: ...

    async def get_for_events(
        self, event_ids: list[UUID]
    ) -> dict[UUID, list[FeedEventReaction]]: ...

    async def has_reacted(self, *, event_id: UUID, user_id: UUID, emoji: str) -> bool: ...


class FeedCommentRepositoryPort(Protocol):
    """Comments on feed_events (activity stream entries)."""

    async def create(
        self,
        *,
        event_id: UUID,
        user_id: UUID,
        parent_id: UUID | None,
        body: str,
    ) -> FeedComment: ...

    async def get_by_id(self, comment_id: UUID) -> FeedComment | None: ...

    async def list_for_event(self, event_id: UUID) -> list[FeedComment]: ...

    async def delete(self, *, comment_id: UUID, user_id: UUID) -> bool: ...


class HighlightRepositoryPort(Protocol):
    async def create(
        self,
        *,
        user_id: UUID,
        user_book_id: UUID,
        quote_text: str,
        page_number: int | None,
        note_text: str | None,
    ) -> PostHighlight: ...

    async def list_by_user_book(
        self,
        user_book_id: UUID,
        *,
        user_id: UUID,
        cursor: datetime | None,
        limit: int,
    ) -> list[PostHighlight]: ...

    async def get_by_id(self, highlight_id: UUID) -> PostHighlight | None: ...

    async def delete(self, highlight_id: UUID) -> None: ...

    async def list_all_for_user(self, user_id: UUID) -> list[HighlightWithBookId]: ...

    async def set_visibility(self, highlight_id: UUID, visibility: str) -> None: ...

    async def mark_shared(self, highlight_id: UUID, *, shared_at: datetime) -> None: ...

    async def list_public(self, *, limit: int, sort: str) -> list[ExploreHighlightItem]: ...

    async def list_recent_for_user(
        self, user_id: UUID, *, limit: int, offset: int
    ) -> list[MyHighlightItem]: ...

    async def count_by_user(self, user_id: UUID) -> int: ...

"""Feed domain service — posts, reactions, comments, image upload.

Depends only on the Protocols in ``ports.py`` (CLAUDE.md §3.2). Concrete
repositories, the R2 image storage adapter, and the cross-domain
``FeedBookQueryPort`` are injected by ``providers.py`` for HTTP traffic
or by test fakes for unit tests.

Business rules captured here (the spec the service is responsible for):
- ``request_image_upload`` validates the content type allowlist
  (image/jpeg, image/png, image/webp), generates a stable R2 object key
  ``feed/{user_id}/{uuid4}.{ext}`` and asks the storage port for a
  presigned PUT URL.
- ``create_post`` enforces content length (≤2000), image_keys cardinality
  (≤4) and the existence of book_id via ``FeedBookQueryPort``. Storing
  R2 keys (not URLs) keeps the DB free of time-bounded credentials.
- ``list_posts_by_book`` materialises a ``FeedPage`` of ``PostFeedItem``
  by batching the reaction aggregates, viewer's reactions, and comment
  counts per page so the timeline is N+1 free. Image URLs are signed
  GETs materialised at read time.
- ``delete_post`` and ``delete_comment`` use 404 (not 403) on ownership
  failure so attackers cannot enumerate live ids (CLAUDE.md §9).
- ``toggle_reaction`` flips the (user, post, type) triple — same type
  collapses to remove, otherwise add.
- ``add_comment`` enforces content length (≤1000) and depth = 1 (1단계
  답글만): a reply must reference a parent comment whose ``parent_id``
  is None and whose ``post_id`` matches.
- ``list_comments`` is flat and ordered ASC — mobile renders the nesting
  from ``parent_id`` so the list query stays simple.
"""

from __future__ import annotations

import uuid as uuid_lib
from collections.abc import Callable
from dataclasses import dataclass, field
from datetime import UTC, datetime
from uuid import UUID

from app.core.exceptions import ConflictError, NotFoundError
from app.domains.feed.events import CommentAdded, PostCreated, ReactionAdded
from app.domains.feed.models import Comment, Post, PostType, ReactionType
from app.domains.feed.ports import (
    CommentRepositoryPort,
    FeedBookQueryPort,
    ImageStoragePort,
    PostFeedItem,
    PostRepositoryPort,
    PresignedUpload,
    ReactionRepositoryPort,
)
from app.shared.event_bus import EventBus

_CONTENT_MAX = 2000
_COMMENT_MAX = 1000
_IMAGES_MAX = 4
_FEED_PAGE_MAX = 50
_FEED_PAGE_MIN = 1
_COMMENTS_PAGE_MAX = 100
_COMMENTS_PAGE_MIN = 1

_ALLOWED_CONTENT_TYPES: dict[str, str] = {
    "image/jpeg": "jpg",
    "image/png": "png",
    "image/webp": "webp",
}


@dataclass(frozen=True, slots=True)
class FeedPage:
    items: list[PostFeedItem]
    next_cursor: str | None


@dataclass(frozen=True, slots=True)
class CommentPage:
    items: list[Comment]
    next_cursor: str | None


@dataclass(frozen=True, slots=True)
class ReactionToggleResult:
    """Outcome of a toggle — mobile uses ``state`` to flip the icon and
    ``counts`` to update the bar without a re-fetch."""

    state: str  # "added" | "removed"
    counts: dict[ReactionType, int]


@dataclass(slots=True)
class FeedService:
    """Orchestrates feed posts, reactions, comments, and image uploads."""

    posts: PostRepositoryPort
    reactions: ReactionRepositoryPort
    comments: CommentRepositoryPort
    image_storage: ImageStoragePort
    book_query: FeedBookQueryPort
    # Optional fields keep backward compatibility with existing tests that do
    # not wire an event bus (the notification domain depends on these events).
    bus: EventBus | None = field(default=None)
    stage_event: Callable[[object], None] | None = field(default=None)

    async def request_image_upload(
        self,
        *,
        user_id: UUID,
        content_type: str,
    ) -> PresignedUpload:
        ext = _ALLOWED_CONTENT_TYPES.get(content_type)
        if ext is None:
            raise ConflictError(
                "unsupported image content type",
                code="UNSUPPORTED_CONTENT_TYPE",
            )
        key = f"feed/{user_id}/{uuid_lib.uuid4()}.{ext}"
        return await self.image_storage.presign_upload(key, content_type=content_type)

    async def create_post(
        self,
        *,
        user_id: UUID,
        book_id: UUID,
        post_type: PostType,
        content: str,
        image_keys: list[str],
    ) -> Post:
        if not content:
            raise ConflictError("content empty", code="CONTENT_EMPTY")
        if len(content) > _CONTENT_MAX:
            raise ConflictError("content too long", code="CONTENT_TOO_LONG")
        if len(image_keys) > _IMAGES_MAX:
            raise ConflictError("too many images", code="TOO_MANY_IMAGES")
        # Prefix gate keeps a curious client from registering arbitrary R2 keys
        # on a post (e.g. another user's prefix). Real validation lives in R2's
        # signature check; this is a defence-in-depth guard.
        for key in image_keys:
            if not key.startswith(f"feed/{user_id}/"):
                raise ConflictError(
                    "image key does not belong to user",
                    code="IMAGE_KEY_FORBIDDEN",
                )

        if not await self.book_query.book_exists(book_id):
            raise NotFoundError("book not found", code="BOOK_NOT_FOUND")

        post = await self.posts.create(
            user_id=user_id,
            book_id=book_id,
            post_type=post_type,
            content=content,
            image_keys=image_keys,
        )
        if self.stage_event is not None:
            self.stage_event(PostCreated(post_id=post.id, book_id=book_id, author_id=user_id))
        return post

    async def list_posts_by_book(
        self,
        *,
        book_id: UUID,
        viewer_id: UUID,
        cursor: str | None,
        limit: int,
    ) -> FeedPage:
        clamped = max(_FEED_PAGE_MIN, min(limit, _FEED_PAGE_MAX))
        cursor_dt = _parse_iso_cursor(cursor)
        rows = await self.posts.list_by_book(book_id, cursor=cursor_dt, limit=clamped)
        if not rows:
            return FeedPage(items=[], next_cursor=None)

        post_ids = [row.id for row in rows]
        aggs = await self.reactions.aggregates_for_posts(post_ids)
        my = await self.reactions.my_reactions_for_posts(post_ids, viewer_id)
        comment_counts = await self.posts.comment_counts_for(post_ids)

        items: list[PostFeedItem] = []
        for row in rows:
            urls = [await self.image_storage.public_url(k) for k in row.image_keys]
            items.append(
                PostFeedItem(
                    post=row,
                    reactions=aggs.get(row.id, {}),
                    my_reactions=my.get(row.id, set()),
                    comment_count=comment_counts.get(row.id, 0),
                    image_urls=urls,
                )
            )

        next_cursor: str | None = None
        if len(rows) == clamped:
            next_cursor = rows[-1].created_at.isoformat()
        return FeedPage(items=items, next_cursor=next_cursor)

    async def delete_post(self, *, user_id: UUID, post_id: UUID) -> None:
        post = await self.posts.get_by_id(post_id)
        if post is None or post.user_id != user_id:
            # 404 (not 403) — don't leak existence (CLAUDE.md §9).
            raise NotFoundError("post not found", code="POST_NOT_FOUND")
        await self.posts.soft_delete(post_id, datetime.now(tz=UTC))

    async def toggle_reaction(
        self,
        *,
        user_id: UUID,
        post_id: UUID,
        reaction_type: ReactionType,
    ) -> ReactionToggleResult:
        post = await self.posts.get_by_id(post_id)
        if post is None:
            raise NotFoundError("post not found", code="POST_NOT_FOUND")

        existing = await self.reactions.reactions_by_user(post_id, user_id)
        if reaction_type in existing:
            await self.reactions.remove(
                post_id=post_id, user_id=user_id, reaction_type=reaction_type
            )
            state = "removed"
        else:
            await self.reactions.add(post_id=post_id, user_id=user_id, reaction_type=reaction_type)
            state = "added"
            if self.stage_event is not None:
                self.stage_event(
                    ReactionAdded(
                        post_id=post_id,
                        reactor_id=user_id,
                        post_author_id=post.user_id,
                        reaction_type=reaction_type.value,
                    )
                )

        counts = await self.reactions.aggregate_for_post(post_id)
        return ReactionToggleResult(state=state, counts=counts)

    async def add_comment(
        self,
        *,
        user_id: UUID,
        post_id: UUID,
        parent_id: UUID | None,
        content: str,
    ) -> Comment:
        if not content:
            raise ConflictError("content empty", code="CONTENT_EMPTY")
        if len(content) > _COMMENT_MAX:
            raise ConflictError("content too long", code="CONTENT_TOO_LONG")

        post = await self.posts.get_by_id(post_id)
        if post is None:
            raise NotFoundError("post not found", code="POST_NOT_FOUND")

        parent_author_id: UUID | None = None
        if parent_id is not None:
            parent = await self.comments.get_by_id(parent_id)
            if parent is None or parent.post_id != post_id:
                raise NotFoundError("parent comment not found", code="COMMENT_NOT_FOUND")
            if parent.parent_id is not None:
                # Depth = 1: replies cannot reply (1단계 답글만).
                raise ConflictError(
                    "comment depth exceeded",
                    code="COMMENT_DEPTH_EXCEEDED",
                )
            parent_author_id = parent.user_id

        comment = await self.comments.create(
            user_id=user_id,
            post_id=post_id,
            parent_id=parent_id,
            content=content,
        )
        if self.stage_event is not None:
            self.stage_event(
                CommentAdded(
                    comment_id=comment.id,
                    post_id=post_id,
                    commenter_id=user_id,
                    post_author_id=post.user_id,
                    parent_author_id=parent_author_id,
                )
            )
        return comment

    async def list_comments(
        self,
        *,
        post_id: UUID,
        cursor: str | None,
        limit: int,
    ) -> CommentPage:
        clamped = max(_COMMENTS_PAGE_MIN, min(limit, _COMMENTS_PAGE_MAX))
        cursor_dt = _parse_iso_cursor(cursor)
        rows = await self.comments.list_by_post(post_id, cursor=cursor_dt, limit=clamped)
        next_cursor: str | None = None
        if len(rows) == clamped:
            next_cursor = rows[-1].created_at.isoformat()
        return CommentPage(items=rows, next_cursor=next_cursor)

    async def delete_comment(self, *, user_id: UUID, comment_id: UUID) -> None:
        comment = await self.comments.get_by_id(comment_id)
        if comment is None or comment.user_id != user_id:
            raise NotFoundError("comment not found", code="COMMENT_NOT_FOUND")
        await self.comments.soft_delete(comment_id, datetime.now(tz=UTC))


def _parse_iso_cursor(cursor: str | None) -> datetime | None:
    if cursor is None or cursor == "":
        return None
    try:
        return datetime.fromisoformat(cursor)
    except ValueError:
        # A malformed cursor is silently treated as "start of the
        # collection". This mirrors the book domain's behaviour and
        # keeps the mobile recovery flow simple when a stale cursor is
        # retried.
        return None


__all__ = [
    "CommentAdded",
    "CommentPage",
    "FeedPage",
    "FeedService",
    "PostCreated",
    "PostFeedItem",
    "PostType",
    "ReactionAdded",
    "ReactionToggleResult",
    "ReactionType",
]

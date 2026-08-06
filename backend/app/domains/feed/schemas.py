"""Pydantic v2 DTOs for the feed router.

These are the sole types the mobile client observes at the HTTP
boundary. The router never leaks SQLAlchemy models past this shell.
"""

from __future__ import annotations

from datetime import datetime
from enum import StrEnum
from typing import Literal
from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field

from app.domains.feed.models import Post, ReactionType
from app.domains.feed.ports import BookSnapshot, PostFeedItem

PostTypeStr = Literal["highlight", "thought", "question", "discussion"]
ReactionTypeStr = Literal["idea", "fire", "think", "clap", "heart"]
ContentTypeStr = Literal["image/jpeg", "image/png", "image/webp"]


class AuthorPublic(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    nickname: str | None = None
    profile_image_url: str | None = None


class RequestUploadRequest(BaseModel):
    content_type: ContentTypeStr


class PresignedUploadResponse(BaseModel):
    url: str
    key: str
    headers: dict[str, str]
    expires_in: int


class CreatePostRequest(BaseModel):
    book_id: UUID
    post_type: PostTypeStr
    content: str = Field(min_length=1, max_length=2000)
    image_keys: list[str] = Field(default_factory=list, max_length=4)


class PostPublic(BaseModel):
    id: UUID
    book_id: UUID
    book_title: str | None = None
    book_cover_url: str | None = None
    user: AuthorPublic
    post_type: PostTypeStr
    content: str
    image_urls: list[str]
    reactions: dict[str, int]
    my_reactions: list[str]
    comment_count: int
    created_at: datetime

    @classmethod
    def from_feed_item(
        cls,
        item: PostFeedItem,
        *,
        author: AuthorPublic,
        book_snapshot: BookSnapshot | None = None,
    ) -> PostPublic:
        return cls(
            id=item.post.id,
            book_id=item.post.book_id,
            book_title=book_snapshot.title if book_snapshot else None,
            book_cover_url=book_snapshot.cover_url if book_snapshot else None,
            user=author,
            post_type=item.post.post_type.value,
            content=item.post.content,
            image_urls=list(item.image_urls),
            reactions={k.value: v for k, v in item.reactions.items()},
            my_reactions=sorted(rt.value for rt in item.my_reactions),
            comment_count=item.comment_count,
            created_at=item.post.created_at,
        )

    @classmethod
    def from_post(
        cls,
        post: Post,
        *,
        author: AuthorPublic,
        book_snapshot: BookSnapshot | None = None,
    ) -> PostPublic:
        return cls(
            id=post.id,
            book_id=post.book_id,
            book_title=book_snapshot.title if book_snapshot else None,
            book_cover_url=book_snapshot.cover_url if book_snapshot else None,
            user=author,
            post_type=post.post_type.value,
            content=post.content,
            image_urls=[],
            reactions={},
            my_reactions=[],
            comment_count=0,
            created_at=post.created_at,
        )


class FeedResponse(BaseModel):
    items: list[PostPublic]
    next_cursor: str | None


class ToggleReactionRequest(BaseModel):
    reaction_type: ReactionTypeStr


class ToggleReactionResponse(BaseModel):
    state: Literal["added", "removed"]
    counts: dict[str, int]


class CreateCommentRequest(BaseModel):
    parent_id: UUID | None = None
    content: str = Field(min_length=1, max_length=1000)


class CommentPublic(BaseModel):
    id: UUID
    user: AuthorPublic
    parent_id: UUID | None
    content: str
    created_at: datetime


class CommentResponse(BaseModel):
    items: list[CommentPublic]
    next_cursor: str | None


class CreateHighlightRequest(BaseModel):
    quote_text: str = Field(min_length=1, max_length=500)
    page_number: int | None = Field(default=None, ge=1)
    note_text: str | None = Field(default=None, max_length=300)


class HighlightPublic(BaseModel):
    id: UUID
    user_book_id: UUID
    quote_text: str
    page_number: int | None
    note_text: str | None
    created_at: datetime


class HighlightResponse(BaseModel):
    items: list[HighlightPublic]
    next_cursor: str | None


class HighlightVisibility(StrEnum):
    """Who may see a highlight (M51)."""

    private = "private"
    followers = "followers"
    public = "public"


class UpdateHighlightVisibilityRequest(BaseModel):
    visibility: HighlightVisibility


class HighlightVisibilityResponse(BaseModel):
    id: UUID
    visibility: HighlightVisibility
    shared_at: datetime | None


class HighlightExploreItem(BaseModel):
    id: UUID
    user_id: UUID
    book_id: UUID
    book_title: str | None = None
    book_cover_url: str | None = None
    quote_text: str
    page: int | None = None
    created_at: datetime
    reaction_count: int


class HighlightExploreResponse(BaseModel):
    items: list[HighlightExploreItem]


class BookHighlightGroupPublic(BaseModel):
    user_book_id: UUID
    book_id: UUID
    book_title: str | None = None
    book_cover_url: str | None = None
    highlights: list[HighlightPublic]


class AllHighlightsResponse(BaseModel):
    groups: list[BookHighlightGroupPublic]


class MyHighlightItemPublic(BaseModel):
    """A single row in the caller's own highlight list (BC-80 — GET /me/highlights)."""

    id: UUID
    book_id: UUID
    book_title: str | None = None
    book_cover_url: str | None = None
    quote_text: str
    page_number: int | None
    created_at: datetime


class MyHighlightListResponse(BaseModel):
    """Flat, newest-first page of the caller's own highlights."""

    items: list[MyHighlightItemPublic]
    total: int
    has_more: bool


_ALLOWED_EMOJIS: frozenset[str] = frozenset({"❤️", "🔥", "👏", "📚", "💪"})


class FeedEventReactionPublic(BaseModel):
    """Single emoji reaction on a feed_event."""

    model_config = ConfigDict(from_attributes=True)

    id: UUID
    emoji: str
    user_id: UUID
    created_at: datetime


class FeedCommentPublic(BaseModel):
    """Comment (or reply) on a feed_event, with nested replies list."""

    model_config = ConfigDict(from_attributes=True)

    id: UUID
    body: str
    user_id: UUID
    event_id: UUID = Field(alias="feed_event_id")
    parent_id: UUID | None
    created_at: datetime
    replies: list[FeedCommentPublic] = Field(default_factory=list)

    model_config = ConfigDict(from_attributes=True, populate_by_name=True)


class FeedEventPublic(BaseModel):
    """Serialised feed_event row for the activity timeline."""

    id: UUID
    user_id: UUID
    event_type: str
    event_metadata: dict[str, object] | None
    created_at: datetime


class FeedEventWithReactions(BaseModel):
    """Feed event enriched with reactions and comment count for the timeline."""

    id: UUID
    user_id: UUID
    event_type: str
    event_metadata: dict[str, object] | None
    created_at: datetime
    reactions: list[FeedEventReactionPublic]
    comment_count: int


class FeedEventPage(BaseModel):
    """Cursor-paged list of feed events with reactions."""

    items: list[FeedEventWithReactions]
    next_cursor: str | None


class AddFeedEventReactionRequest(BaseModel):
    emoji: str = Field(
        description="One of ❤️ 🔥 👏 📚 💪",
    )


class ToggleFeedReactionResponse(BaseModel):
    state: Literal["added", "removed"]
    reactions: list[FeedEventReactionPublic]


class CreateFeedCommentRequest(BaseModel):
    body: str = Field(min_length=1, max_length=500)
    parent_id: UUID | None = None


class FeedCommentListResponse(BaseModel):
    items: list[FeedCommentPublic]


__all__ = [
    "AddFeedEventReactionRequest",
    "AllHighlightsResponse",
    "AuthorPublic",
    "BookHighlightGroupPublic",
    "CommentPublic",
    "CommentResponse",
    "CreateCommentRequest",
    "CreateFeedCommentRequest",
    "CreateHighlightRequest",
    "CreatePostRequest",
    "FeedCommentListResponse",
    "FeedCommentPublic",
    "FeedEventPage",
    "FeedEventPublic",
    "FeedEventReactionPublic",
    "FeedEventWithReactions",
    "FeedResponse",
    "HighlightExploreItem",
    "HighlightExploreResponse",
    "HighlightPublic",
    "HighlightResponse",
    "HighlightVisibility",
    "HighlightVisibilityResponse",
    "MyHighlightItemPublic",
    "MyHighlightListResponse",
    "PostPublic",
    "PresignedUploadResponse",
    "ReactionType",
    "RequestUploadRequest",
    "ToggleFeedReactionResponse",
    "ToggleReactionRequest",
    "ToggleReactionResponse",
    "UpdateHighlightVisibilityRequest",
]

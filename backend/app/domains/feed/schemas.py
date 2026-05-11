"""Pydantic v2 DTOs for the feed router.

These are the sole types the mobile client observes at the HTTP
boundary. The router never leaks SQLAlchemy models past this shell.
"""

from __future__ import annotations

from datetime import datetime
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


class BookHighlightGroupPublic(BaseModel):
    user_book_id: UUID
    book_id: UUID
    book_title: str | None = None
    book_cover_url: str | None = None
    highlights: list[HighlightPublic]


class AllHighlightsResponse(BaseModel):
    groups: list[BookHighlightGroupPublic]


__all__ = [
    "AllHighlightsResponse",
    "AuthorPublic",
    "BookHighlightGroupPublic",
    "CommentPublic",
    "CommentResponse",
    "CreateCommentRequest",
    "CreateHighlightRequest",
    "CreatePostRequest",
    "FeedResponse",
    "HighlightPublic",
    "HighlightResponse",
    "PostPublic",
    "PresignedUploadResponse",
    "ReactionType",
    "RequestUploadRequest",
    "ToggleReactionRequest",
    "ToggleReactionResponse",
]

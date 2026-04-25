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
from app.domains.feed.ports import PostFeedItem

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
    user: AuthorPublic
    post_type: PostTypeStr
    content: str
    image_urls: list[str]
    reactions: dict[str, int]
    my_reactions: list[str]
    comment_count: int
    created_at: datetime

    @classmethod
    def from_feed_item(cls, item: PostFeedItem, *, author: AuthorPublic) -> PostPublic:
        return cls(
            id=item.post.id,
            book_id=item.post.book_id,
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
    def from_post(cls, post: Post, *, author: AuthorPublic) -> PostPublic:
        return cls(
            id=post.id,
            book_id=post.book_id,
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


__all__ = [
    "AuthorPublic",
    "CommentPublic",
    "CommentResponse",
    "CreateCommentRequest",
    "CreatePostRequest",
    "FeedResponse",
    "PostPublic",
    "PresignedUploadResponse",
    "ReactionType",
    "RequestUploadRequest",
    "ToggleReactionRequest",
    "ToggleReactionResponse",
]

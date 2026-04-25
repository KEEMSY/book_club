"""HTTP surface for the feed domain.

Endpoints span ``/books/{book_id}/posts``, ``/posts/{id}/...``,
``/comments/{id}``, and ``/uploads/presign-image``. They register on a
single APIRouter tagged ``feed`` so the FastAPI app can mount them all
at once.

Keep this file thin: every handler is at most a DTO -> service -> DTO
adapter. Business decisions live in ``service.py``. The router never
catches domain exceptions; the global handler translates them
(CLAUDE.md §3.1).
"""

from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, Query, Response, status

from app.core.deps import get_current_user_id
from app.domains.feed.models import PostType, ReactionType
from app.domains.feed.ports import AuthorView, FeedUserQueryPort
from app.domains.feed.providers import (
    get_feed_service,
    get_feed_user_query,
)
from app.domains.feed.schemas import (
    AuthorPublic,
    CommentPublic,
    CommentResponse,
    CreateCommentRequest,
    CreatePostRequest,
    FeedResponse,
    PostPublic,
    PresignedUploadResponse,
    RequestUploadRequest,
    ToggleReactionRequest,
    ToggleReactionResponse,
)
from app.domains.feed.service import FeedService

router = APIRouter(tags=["feed"])


def _author_from_view(view: AuthorView | None, fallback_id: UUID) -> AuthorPublic:
    if view is None:
        # The user soft-deleted their account but their content remains.
        # Render a neutral placeholder rather than 500-ing the feed.
        return AuthorPublic(id=fallback_id, nickname=None, profile_image_url=None)
    return AuthorPublic(
        id=view.id,
        nickname=view.nickname,
        profile_image_url=view.profile_image_url,
    )


@router.post(
    "/uploads/presign-image",
    response_model=PresignedUploadResponse,
)
async def presign_image_upload(
    body: RequestUploadRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[FeedService, Depends(get_feed_service)],
) -> PresignedUploadResponse:
    presigned = await service.request_image_upload(
        user_id=UUID(user_id),
        content_type=body.content_type,
    )
    return PresignedUploadResponse(
        url=presigned.url,
        key=presigned.key,
        headers=presigned.headers,
        expires_in=presigned.expires_in,
    )


@router.get("/books/{book_id}/posts", response_model=FeedResponse)
async def list_book_posts(
    book_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[FeedService, Depends(get_feed_service)],
    user_query: Annotated[FeedUserQueryPort, Depends(get_feed_user_query)],
    cursor: Annotated[str | None, Query()] = None,
    limit: Annotated[int, Query(ge=1, le=50)] = 20,
) -> FeedResponse:
    page = await service.list_posts_by_book(
        book_id=book_id,
        viewer_id=UUID(user_id),
        cursor=cursor,
        limit=limit,
    )
    author_ids = [item.post.user_id for item in page.items]
    authors = await user_query.get_authors(author_ids) if author_ids else {}
    items = [
        PostPublic.from_feed_item(
            item,
            author=_author_from_view(authors.get(item.post.user_id), item.post.user_id),
        )
        for item in page.items
    ]
    return FeedResponse(items=items, next_cursor=page.next_cursor)


@router.post(
    "/books/{book_id}/posts",
    response_model=PostPublic,
    status_code=status.HTTP_201_CREATED,
)
async def create_book_post(
    book_id: UUID,
    body: CreatePostRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[FeedService, Depends(get_feed_service)],
    user_query: Annotated[FeedUserQueryPort, Depends(get_feed_user_query)],
) -> PostPublic:
    # The body carries book_id too — we trust the path parameter as the
    # canonical source so a mismatched body is silently corrected to the
    # path. This mirrors the convention in book.router.add_to_library.
    _ = body.book_id  # accepted for forward-compat but ignored.
    post = await service.create_post(
        user_id=UUID(user_id),
        book_id=book_id,
        post_type=PostType(body.post_type),
        content=body.content,
        image_keys=body.image_keys,
    )
    authors = await user_query.get_authors([post.user_id])
    author = _author_from_view(authors.get(post.user_id), post.user_id)
    return PostPublic.from_post(post, author=author)


@router.delete("/posts/{post_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_post(
    post_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[FeedService, Depends(get_feed_service)],
) -> Response:
    await service.delete_post(user_id=UUID(user_id), post_id=post_id)
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@router.post(
    "/posts/{post_id}/reactions",
    response_model=ToggleReactionResponse,
)
async def toggle_reaction(
    post_id: UUID,
    body: ToggleReactionRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[FeedService, Depends(get_feed_service)],
) -> ToggleReactionResponse:
    result = await service.toggle_reaction(
        user_id=UUID(user_id),
        post_id=post_id,
        reaction_type=ReactionType(body.reaction_type),
    )
    return ToggleReactionResponse(
        state=result.state,  # type: ignore[arg-type]
        counts={k.value: v for k, v in result.counts.items()},
    )


@router.get("/posts/{post_id}/comments", response_model=CommentResponse)
async def list_comments(
    post_id: UUID,
    _user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[FeedService, Depends(get_feed_service)],
    user_query: Annotated[FeedUserQueryPort, Depends(get_feed_user_query)],
    cursor: Annotated[str | None, Query()] = None,
    limit: Annotated[int, Query(ge=1, le=100)] = 50,
) -> CommentResponse:
    page = await service.list_comments(post_id=post_id, cursor=cursor, limit=limit)
    author_ids = [c.user_id for c in page.items]
    authors = await user_query.get_authors(author_ids) if author_ids else {}
    items = [
        CommentPublic(
            id=c.id,
            user=_author_from_view(authors.get(c.user_id), c.user_id),
            parent_id=c.parent_id,
            content=c.content,
            created_at=c.created_at,
        )
        for c in page.items
    ]
    return CommentResponse(items=items, next_cursor=page.next_cursor)


@router.post(
    "/posts/{post_id}/comments",
    response_model=CommentPublic,
    status_code=status.HTTP_201_CREATED,
)
async def create_comment(
    post_id: UUID,
    body: CreateCommentRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[FeedService, Depends(get_feed_service)],
    user_query: Annotated[FeedUserQueryPort, Depends(get_feed_user_query)],
) -> CommentPublic:
    comment = await service.add_comment(
        user_id=UUID(user_id),
        post_id=post_id,
        parent_id=body.parent_id,
        content=body.content,
    )
    authors = await user_query.get_authors([comment.user_id])
    author = _author_from_view(authors.get(comment.user_id), comment.user_id)
    return CommentPublic(
        id=comment.id,
        user=author,
        parent_id=comment.parent_id,
        content=comment.content,
        created_at=comment.created_at,
    )


@router.delete("/comments/{comment_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_comment(
    comment_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[FeedService, Depends(get_feed_service)],
) -> Response:
    await service.delete_comment(user_id=UUID(user_id), comment_id=comment_id)
    return Response(status_code=status.HTTP_204_NO_CONTENT)

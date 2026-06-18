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

from collections import defaultdict
from typing import Annotated, Literal
from uuid import UUID

from fastapi import APIRouter, Depends, Query, Response, status

from app.core.deps import get_current_user_id
from app.domains.feed.models import FeedComment, PostType, ReactionType
from app.domains.feed.ports import (
    AuthorView,
    BookSnapshot,
    FeedBookQueryPort,
    FeedEventWithReactionsItem,
    FeedUserQueryPort,
)
from app.domains.feed.providers import (
    get_feed_book_query,
    get_feed_service,
    get_feed_user_query,
)
from app.domains.feed.schemas import (
    AddFeedEventReactionRequest,
    AllHighlightsResponse,
    AuthorPublic,
    BookHighlightGroupPublic,
    CommentPublic,
    CommentResponse,
    CreateCommentRequest,
    CreateFeedCommentRequest,
    CreateHighlightRequest,
    CreatePostRequest,
    FeedCommentListResponse,
    FeedCommentPublic,
    FeedEventPage,
    FeedEventPublic,
    FeedEventReactionPublic,
    FeedEventWithReactions,
    FeedResponse,
    HighlightExploreItem,
    HighlightExploreResponse,
    HighlightPublic,
    HighlightResponse,
    HighlightVisibility,
    HighlightVisibilityResponse,
    PostPublic,
    PresignedUploadResponse,
    RequestUploadRequest,
    ToggleFeedReactionResponse,
    ToggleReactionRequest,
    ToggleReactionResponse,
    UpdateHighlightVisibilityRequest,
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
    book_query: Annotated[FeedBookQueryPort, Depends(get_feed_book_query)],
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
    book_snapshot: BookSnapshot | None = await book_query.get_book_snapshot(book_id)
    items = [
        PostPublic.from_feed_item(
            item,
            author=_author_from_view(authors.get(item.post.user_id), item.post.user_id),
            book_snapshot=book_snapshot,
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
    book_query: Annotated[FeedBookQueryPort, Depends(get_feed_book_query)],
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
    book_snapshot: BookSnapshot | None = await book_query.get_book_snapshot(book_id)
    return PostPublic.from_post(post, author=author, book_snapshot=book_snapshot)


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


def _build_feed_event_public(item: FeedEventWithReactionsItem) -> FeedEventWithReactions:
    """Convert a FeedEventWithReactionsItem to its HTTP schema."""
    return FeedEventWithReactions(
        id=item.event.id,
        user_id=item.event.user_id,
        event_type=item.event.event_type,
        event_metadata=item.event.event_metadata,
        created_at=item.event.created_at,
        reactions=[
            FeedEventReactionPublic(
                id=r.id,
                emoji=r.emoji,
                user_id=r.user_id,
                created_at=r.created_at,
            )
            for r in item.reactions
        ],
        comment_count=item.comment_count,
    )


@router.get("/feed", response_model=FeedEventPage)
async def get_global_feed(
    _user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[FeedService, Depends(get_feed_service)],
    cursor: Annotated[str | None, Query()] = None,
    limit: Annotated[int, Query(ge=1, le=50)] = 20,
) -> FeedEventPage:
    """Global activity feed — all users' feed_events, newest-first."""
    items = await service.get_global_feed(cursor=cursor, limit=limit)
    next_cursor: str | None = None
    if len(items) == limit and items:
        next_cursor = items[-1].event.created_at.isoformat()
    return FeedEventPage(
        items=[_build_feed_event_public(i) for i in items],
        next_cursor=next_cursor,
    )


@router.get("/feed/following", response_model=FeedEventPage)
async def get_following_feed(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[FeedService, Depends(get_feed_service)],
    cursor: Annotated[str | None, Query()] = None,
    limit: Annotated[int, Query(ge=1, le=50)] = 20,
) -> FeedEventPage:
    """Activity feed from users that the current user follows, newest-first."""
    items = await service.get_following_feed(UUID(user_id), cursor=cursor, limit=limit)
    next_cursor: str | None = None
    if len(items) == limit and items:
        next_cursor = items[-1].event.created_at.isoformat()
    return FeedEventPage(
        items=[_build_feed_event_public(i) for i in items],
        next_cursor=next_cursor,
    )


@router.post(
    "/feed/{event_id}/reactions",
    response_model=ToggleFeedReactionResponse,
)
async def toggle_feed_reaction(
    event_id: UUID,
    body: AddFeedEventReactionRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[FeedService, Depends(get_feed_service)],
) -> ToggleFeedReactionResponse:
    """Toggle an emoji reaction on a feed_event (add or remove)."""
    result = await service.toggle_feed_reaction(
        event_id=event_id,
        user_id=UUID(user_id),
        emoji=body.emoji,
    )
    return ToggleFeedReactionResponse(
        state=result.state,  # type: ignore[arg-type]
        reactions=[
            FeedEventReactionPublic(
                id=r.id,
                emoji=r.emoji,
                user_id=r.user_id,
                created_at=r.created_at,
            )
            for r in result.reactions
        ],
    )


@router.get("/feed/{event_id}/comments", response_model=FeedCommentListResponse)
async def get_feed_comments(
    event_id: UUID,
    _user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[FeedService, Depends(get_feed_service)],
) -> FeedCommentListResponse:
    """Retrieve comments (with replies) for a feed_event."""
    flat = await service.get_feed_comments(event_id)
    # Build tree: root comments with their replies nested.
    children: dict[UUID, list[FeedComment]] = defaultdict(list)
    roots: list[FeedComment] = []
    for c in flat:
        if c.parent_id is None:
            roots.append(c)
        else:
            children[c.parent_id].append(c)

    def _to_public(c: FeedComment) -> FeedCommentPublic:
        return FeedCommentPublic(
            id=c.id,
            body=c.body,
            user_id=c.user_id,
            feed_event_id=c.feed_event_id,
            parent_id=c.parent_id,
            created_at=c.created_at,
            replies=[_to_public(r) for r in children.get(c.id, [])],
        )

    return FeedCommentListResponse(items=[_to_public(r) for r in roots])


@router.post(
    "/feed/{event_id}/comments",
    response_model=FeedCommentPublic,
    status_code=status.HTTP_201_CREATED,
)
async def create_feed_comment(
    event_id: UUID,
    body: CreateFeedCommentRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[FeedService, Depends(get_feed_service)],
) -> FeedCommentPublic:
    """Add a comment (or reply) to a feed_event."""
    comment = await service.add_feed_comment(
        event_id=event_id,
        user_id=UUID(user_id),
        parent_id=body.parent_id,
        body=body.body,
    )
    return FeedCommentPublic(
        id=comment.id,
        body=comment.body,
        user_id=comment.user_id,
        feed_event_id=comment.feed_event_id,
        parent_id=comment.parent_id,
        created_at=comment.created_at,
        replies=[],
    )


@router.delete("/feed/comments/{comment_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_feed_comment(
    comment_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[FeedService, Depends(get_feed_service)],
) -> Response:
    """Delete a feed comment (author only)."""
    await service.delete_feed_comment(comment_id=comment_id, user_id=UUID(user_id))
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@router.post(
    "/me/library/{user_book_id}/highlights",
    response_model=HighlightPublic,
    status_code=status.HTTP_201_CREATED,
)
async def create_highlight(
    user_book_id: UUID,
    body: CreateHighlightRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[FeedService, Depends(get_feed_service)],
) -> HighlightPublic:
    highlight = await service.create_highlight(
        user_id=UUID(user_id),
        user_book_id=user_book_id,
        quote_text=body.quote_text,
        page_number=body.page_number,
        note_text=body.note_text,
    )
    return HighlightPublic(
        id=highlight.id,
        user_book_id=highlight.user_book_id,
        quote_text=highlight.quote_text,
        page_number=highlight.page_number,
        note_text=highlight.note_text,
        created_at=highlight.created_at,
    )


@router.get("/me/library/{user_book_id}/highlights", response_model=HighlightResponse)
async def list_highlights(
    user_book_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[FeedService, Depends(get_feed_service)],
    cursor: Annotated[str | None, Query()] = None,
    limit: Annotated[int, Query(ge=1, le=50)] = 20,
) -> HighlightResponse:
    page = await service.list_highlights(
        user_id=UUID(user_id),
        user_book_id=user_book_id,
        cursor=cursor,
        limit=limit,
    )
    return HighlightResponse(
        items=[
            HighlightPublic(
                id=h.id,
                user_book_id=h.user_book_id,
                quote_text=h.quote_text,
                page_number=h.page_number,
                note_text=h.note_text,
                created_at=h.created_at,
            )
            for h in page.items
        ],
        next_cursor=page.next_cursor,
    )


@router.get("/me/highlights", response_model=AllHighlightsResponse)
async def list_all_my_highlights(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[FeedService, Depends(get_feed_service)],
) -> AllHighlightsResponse:
    groups = await service.list_all_highlights(user_id=UUID(user_id))
    return AllHighlightsResponse(
        groups=[
            BookHighlightGroupPublic(
                user_book_id=g.user_book_id,
                book_id=g.book_id,
                book_title=g.book_title,
                book_cover_url=g.book_cover_url,
                highlights=[
                    HighlightPublic(
                        id=h.id,
                        user_book_id=h.user_book_id,
                        quote_text=h.quote_text,
                        page_number=h.page_number,
                        note_text=h.note_text,
                        created_at=h.created_at,
                    )
                    for h in g.highlights
                ],
            )
            for g in groups
        ]
    )


@router.delete(
    "/me/library/{user_book_id}/highlights/{highlight_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def delete_highlight(
    user_book_id: UUID,  # path param kept for RESTful consistency; unused in handler
    highlight_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[FeedService, Depends(get_feed_service)],
) -> Response:
    await service.delete_highlight(user_id=UUID(user_id), highlight_id=highlight_id)
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@router.patch(
    "/me/highlights/{highlight_id}/visibility",
    response_model=HighlightVisibilityResponse,
)
async def update_highlight_visibility(
    highlight_id: UUID,
    body: UpdateHighlightVisibilityRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[FeedService, Depends(get_feed_service)],
) -> HighlightVisibilityResponse:
    highlight = await service.update_highlight_visibility(
        user_id=UUID(user_id),
        highlight_id=highlight_id,
        visibility=body.visibility.value,
    )
    return HighlightVisibilityResponse(
        id=highlight.id,
        visibility=HighlightVisibility(highlight.visibility),
        shared_at=highlight.shared_at,
    )


@router.post(
    "/me/highlights/{highlight_id}/share",
    response_model=FeedEventPublic,
    status_code=status.HTTP_201_CREATED,
)
async def share_highlight_to_feed(
    highlight_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[FeedService, Depends(get_feed_service)],
) -> FeedEventPublic:
    event = await service.share_highlight_to_feed(
        user_id=UUID(user_id),
        highlight_id=highlight_id,
    )
    return FeedEventPublic(
        id=event.id,
        user_id=event.user_id,
        event_type=event.event_type,
        event_metadata=event.event_metadata,
        created_at=event.created_at,
    )


@router.get("/highlights/explore", response_model=HighlightExploreResponse)
async def explore_highlights(
    _user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[FeedService, Depends(get_feed_service)],
    sort: Annotated[Literal["recent", "popular"], Query()] = "recent",
    limit: Annotated[int, Query(ge=1, le=50)] = 50,
) -> HighlightExploreResponse:
    items = await service.get_explore_highlights(limit=limit, sort=sort)
    return HighlightExploreResponse(
        items=[
            HighlightExploreItem(
                id=item.highlight.id,
                user_id=item.highlight.user_id,
                book_id=item.book_id,
                book_title=item.book_title,
                book_cover_url=item.book_cover_url,
                quote_text=item.highlight.quote_text,
                page=item.highlight.page_number,
                created_at=item.highlight.created_at,
                reaction_count=item.reaction_count,
            )
            for item in items
        ]
    )

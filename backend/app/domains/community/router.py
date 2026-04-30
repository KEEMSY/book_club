"""HTTP surface for the community domain.

Prefix: /community. All endpoints require a valid access token.

Endpoints:
  GET /community/feed                    — following timeline (cursor-paged)
  GET /community/explore                 — discover feed (sort=latest|popular)
  GET /community/users/{id}/profile      — full user profile with follow counts
  GET /community/users/{id}/posts        — posts authored by a user (cursor-paged)
"""

from __future__ import annotations

from typing import Annotated, Literal
from uuid import UUID

from fastapi import APIRouter, Depends, Query

from app.core.deps import get_current_user_id
from app.domains.community.providers import get_community_service
from app.domains.community.schemas import UserProfileResponse
from app.domains.community.service import CommunityService
from app.domains.feed.models import PostType
from app.domains.feed.ports import (
    AuthorView,
    BookSnapshot,
    FeedBookQueryPort,
    FeedUserQueryPort,
    PostFeedItem,
)
from app.domains.feed.providers import get_feed_book_query, get_feed_user_query
from app.domains.feed.schemas import AuthorPublic, FeedResponse, PostPublic

router = APIRouter(prefix="/community", tags=["community"])


def _author_from_view(view: AuthorView | None, fallback_id: UUID) -> AuthorPublic:
    if view is None:
        return AuthorPublic(id=fallback_id, nickname=None, profile_image_url=None)
    return AuthorPublic(
        id=view.id,
        nickname=view.nickname,
        profile_image_url=view.profile_image_url,
    )


async def _book_snapshots_for_highlights(
    items: list[PostFeedItem],
    book_query: FeedBookQueryPort,
) -> dict[UUID, BookSnapshot]:
    """Batch-fetch book snapshots for highlight posts (one query per unique book_id)."""
    highlight_book_ids = {
        item.post.book_id for item in items if item.post.post_type == PostType.HIGHLIGHT
    }
    snapshots: dict[UUID, BookSnapshot] = {}
    for book_id in highlight_book_ids:
        snap = await book_query.get_book_snapshot(book_id)
        if snap is not None:
            snapshots[book_id] = snap
    return snapshots


@router.get("/feed", response_model=FeedResponse)
async def get_following_feed(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[CommunityService, Depends(get_community_service)],
    user_query: Annotated[FeedUserQueryPort, Depends(get_feed_user_query)],
    book_query: Annotated[FeedBookQueryPort, Depends(get_feed_book_query)],
    cursor: Annotated[str | None, Query()] = None,
    limit: Annotated[int, Query(ge=1, le=50)] = 20,
) -> FeedResponse:
    page = await service.get_following_feed(user_id=UUID(user_id), cursor=cursor, limit=limit)
    author_ids = [item.post.user_id for item in page.items]
    authors = await user_query.get_authors(author_ids) if author_ids else {}
    book_snaps = await _book_snapshots_for_highlights(page.items, book_query)
    items = [
        PostPublic.from_feed_item(
            item,
            author=_author_from_view(authors.get(item.post.user_id), item.post.user_id),
            book_snapshot=book_snaps.get(item.post.book_id),
        )
        for item in page.items
    ]
    return FeedResponse(items=items, next_cursor=page.next_cursor)


@router.get("/explore", response_model=FeedResponse)
async def get_explore_feed(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[CommunityService, Depends(get_community_service)],
    user_query: Annotated[FeedUserQueryPort, Depends(get_feed_user_query)],
    book_query: Annotated[FeedBookQueryPort, Depends(get_feed_book_query)],
    sort: Annotated[Literal["latest", "popular"], Query()] = "latest",
    post_type: Annotated[str | None, Query()] = None,
    cursor: Annotated[str | None, Query()] = None,
    limit: Annotated[int, Query(ge=1, le=50)] = 20,
) -> FeedResponse:
    page = await service.get_explore_feed(
        viewer_id=UUID(user_id), sort=sort, post_type=post_type, cursor=cursor, limit=limit
    )
    author_ids = [item.post.user_id for item in page.items]
    authors = await user_query.get_authors(author_ids) if author_ids else {}
    book_snaps = await _book_snapshots_for_highlights(page.items, book_query)
    items = [
        PostPublic.from_feed_item(
            item,
            author=_author_from_view(authors.get(item.post.user_id), item.post.user_id),
            book_snapshot=book_snaps.get(item.post.book_id),
        )
        for item in page.items
    ]
    return FeedResponse(items=items, next_cursor=page.next_cursor)


@router.get("/users/{user_id}/posts", response_model=FeedResponse)
async def get_user_posts(
    user_id: UUID,
    viewer_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[CommunityService, Depends(get_community_service)],
    user_query: Annotated[FeedUserQueryPort, Depends(get_feed_user_query)],
    book_query: Annotated[FeedBookQueryPort, Depends(get_feed_book_query)],
    cursor: Annotated[str | None, Query()] = None,
    limit: Annotated[int, Query(ge=1, le=50)] = 20,
) -> FeedResponse:
    page = await service.get_user_posts(
        user_id=user_id, viewer_id=UUID(viewer_id), cursor=cursor, limit=limit
    )
    author_ids = [item.post.user_id for item in page.items]
    authors = await user_query.get_authors(author_ids) if author_ids else {}
    book_snaps = await _book_snapshots_for_highlights(page.items, book_query)
    items = [
        PostPublic.from_feed_item(
            item,
            author=_author_from_view(authors.get(item.post.user_id), item.post.user_id),
            book_snapshot=book_snaps.get(item.post.book_id),
        )
        for item in page.items
    ]
    return FeedResponse(items=items, next_cursor=page.next_cursor)


@router.get("/users/{user_id}/profile", response_model=UserProfileResponse)
async def get_user_profile(
    user_id: UUID,
    viewer_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[CommunityService, Depends(get_community_service)],
) -> UserProfileResponse:
    profile = await service.get_user_profile(user_id=user_id, viewer_id=UUID(viewer_id))
    return UserProfileResponse(
        id=profile.user_id,
        nickname=profile.nickname,
        profile_image_url=profile.profile_image_url,
        bio=profile.bio,
        follower_count=profile.follower_count,
        following_count=profile.following_count,
        is_following=profile.is_following,
        is_me=profile.is_me,
    )

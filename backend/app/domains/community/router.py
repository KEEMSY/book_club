"""HTTP surface for the community domain.

Prefix: /community. All endpoints require a valid access token.

Endpoints:
  GET /community/feed                    — following timeline (cursor-paged)
  GET /community/explore                 — discover feed (sort=latest|popular)
  GET /community/users/{id}/profile      — full user profile with follow counts
  GET /community/users/{id}/posts        — posts authored by a user (cursor-paged)

``me_router`` below carries no ``/community`` prefix and is mounted
unconditionally in ``app.main`` — a user's own activity roll-up is core
surface, not gated behind ``feature_community_enabled`` (BC-90; relocated
from ``GET /community/me/activity``, originally added in BC-80):

  GET /me/activity                       — "내 활동" summary: counts + a short
                                            preview per category. Each
                                            category's full paginated list lives
                                            behind its own domain endpoint:
                                              - GET /me/reviews (review)
                                              - GET /me/highlights/recent (feed)
                                              - GET /clubs/me/agendas (club)
                                              - GET /clubs/me (club)
                                              - GET /me/library?status=reading (book)

Its orchestration still lives entirely in
``CommunityService.get_my_activity``, which reaches the owning domains only
through their ``Activity*QueryPort`` protocols (CLAUDE.md §3.3) — moving the
transport layer out from behind the feature gate doesn't change that
boundary.
"""

from __future__ import annotations

from typing import Annotated, Literal
from uuid import UUID

from fastapi import APIRouter, Depends, Query

from app.core.deps import get_current_user_id
from app.domains.community.providers import get_community_service
from app.domains.community.schemas import (
    ActivityAgendaItemPublic,
    ActivityBookItemPublic,
    ActivityClubItemPublic,
    ActivityCountsPublic,
    ActivityHighlightItemPublic,
    ActivityReviewItemPublic,
    BadgeSummaryPublic,
    GradeStatsPublic,
    HighlightSummaryPublic,
    MyActivityResponse,
    UserProfileResponse,
)
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
# No prefix — mounted unconditionally in app.main regardless of
# feature_community_enabled (BC-90). See module docstring.
me_router = APIRouter(tags=["community"])


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
        grade_stats=GradeStatsPublic(
            grade=profile.grade_stats.grade,
            tier=profile.grade_stats.tier,
            total_books=profile.grade_stats.total_books,
            total_seconds=profile.grade_stats.total_seconds,
            streak_days=profile.grade_stats.streak_days,
        )
        if profile.grade_stats
        else None,
        badges=[
            BadgeSummaryPublic(
                id=b.id,
                name=b.name,
                icon_url=b.icon_url,
                category=b.category,
                earned_at=b.earned_at,
            )
            for b in profile.badges
        ],
        recent_highlights=[
            HighlightSummaryPublic(
                id=h.id,
                quote_text=h.quote_text,
                book_title=h.book_title,
                created_at=h.created_at,
            )
            for h in profile.recent_highlights
        ],
        cover_image_url=profile.cover_image_url,
        theme=profile.theme,
        featured_book_id=profile.featured_book_id,
        featured_quote=profile.featured_quote,
    )


@me_router.get("/me/activity", response_model=MyActivityResponse)
async def get_my_activity(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[CommunityService, Depends(get_community_service)],
) -> MyActivityResponse:
    """내 활동 요약 (BC-80) — 카테고리별 총 개수 + 최신 5개 미리보기.

    각 카테고리의 전체 페이지네이션 목록은 해당 도메인의 전용 엔드포인트를
    쓴다 (모듈 docstring 참고).
    """
    summary = await service.get_my_activity(user_id=UUID(user_id))
    return MyActivityResponse(
        counts=ActivityCountsPublic(
            reviews=summary.counts.reviews,
            highlights=summary.counts.highlights,
            agendas=summary.counts.agendas,
            clubs=summary.counts.clubs,
            reading_books=summary.counts.reading_books,
        ),
        reviews=[
            ActivityReviewItemPublic(
                id=r.id,
                book_id=r.book_id,
                book_title=r.book_title,
                book_cover_url=r.book_cover_url,
                rating=r.rating,
                body=r.body,
                created_at=r.created_at,
            )
            for r in summary.reviews
        ],
        highlights=[
            ActivityHighlightItemPublic(
                id=h.id,
                book_id=h.book_id,
                book_title=h.book_title,
                book_cover_url=h.book_cover_url,
                quote_text=h.quote_text,
                created_at=h.created_at,
            )
            for h in summary.highlights
        ],
        agendas=[
            ActivityAgendaItemPublic(
                id=a.id,
                club_id=a.club_id,
                club_name=a.club_name,
                session_id=a.session_id,
                session_title=a.session_title,
                status=a.status,
                published_at=a.published_at,
                created_at=a.created_at,
            )
            for a in summary.agendas
        ],
        clubs=[
            ActivityClubItemPublic(id=c.id, name=c.name, created_at=c.created_at)
            for c in summary.clubs
        ],
        reading_books=[
            ActivityBookItemPublic(
                user_book_id=b.user_book_id,
                book_id=b.book_id,
                title=b.title,
                cover_url=b.cover_url,
                current_chapter=b.current_chapter,
                started_at=b.started_at,
            )
            for b in summary.reading_books
        ],
    )

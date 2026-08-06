"""Community domain service — following feed, explore feed, user profiles.

Aggregates across post, reaction, follow, and block data so the router
layer stays thin. Uses FeedPage from feed.service (a plain dataclass — no
business logic) and delegates reaction/comment enrichment to the same
repository adapters the feed service uses, avoiding duplicated SQL.
"""

from __future__ import annotations

import asyncio
from dataclasses import dataclass
from datetime import UTC, datetime, timedelta
from uuid import UUID

from app.core.exceptions import NotFoundError
from app.domains.auth.repository import UserRepository
from app.domains.community.ports import (
    ActivityAgendaItem,
    ActivityAgendaQueryPort,
    ActivityBookItem,
    ActivityClubItem,
    ActivityClubQueryPort,
    ActivityHighlightItem,
    ActivityHighlightQueryPort,
    ActivityLibraryQueryPort,
    ActivityReviewItem,
    ActivityReviewQueryPort,
    BadgeSummary,
    GradeStats,
    HighlightSummary,
    ProfileChallengeQueryPort,
    ProfileHighlightQueryPort,
    ProfileReadingQueryPort,
)
from app.domains.community.repository import CommunityRepository
from app.domains.feed.models import Post, PostType
from app.domains.feed.ports import ImageStoragePort, PostFeedItem, ReactionRepositoryPort
from app.domains.feed.repository import PostRepository
from app.domains.feed.service import FeedPage

_FEED_PAGE_MAX = 50
_FEED_PAGE_MIN = 1
_POPULAR_DAYS = 30
# BC-80 — "내 활동" summary preview size per category (full lists live behind
# each domain's own paginated "list mine" endpoint; see MyActivitySummary).
_ACTIVITY_PREVIEW_SIZE = 5


def _parse_cursor(cursor: str | None) -> datetime | None:
    if not cursor:
        return None
    try:
        return datetime.fromisoformat(cursor)
    except ValueError:
        return None


@dataclass(frozen=True, slots=True)
class UserProfileView:
    user_id: UUID
    nickname: str | None
    profile_image_url: str | None
    bio: str | None
    follower_count: int
    following_count: int
    is_following: bool
    is_me: bool
    grade_stats: GradeStats | None
    badges: list[BadgeSummary]
    recent_highlights: list[HighlightSummary]
    # Profile expressiveness (BC-81).
    cover_image_url: str | None
    theme: str | None
    featured_book_id: UUID | None
    featured_quote: str | None


@dataclass(frozen=True, slots=True)
class MyActivityCounts:
    reviews: int
    highlights: int
    agendas: int
    clubs: int
    reading_books: int


@dataclass(frozen=True, slots=True)
class MyActivitySummary:
    """Dashboard-preview payload for GET /community/me/activity (BC-80).

    Each list is capped at ``_ACTIVITY_PREVIEW_SIZE`` — the full, paginated
    list for a category lives behind its own domain's "list mine" endpoint
    (``GET /me/reviews``, ``GET /me/highlights/recent``,
    ``GET /clubs/me/agendas``, ``GET /clubs/me``, ``GET /me/library?status=reading``).
    """

    counts: MyActivityCounts
    reviews: list[ActivityReviewItem]
    highlights: list[ActivityHighlightItem]
    agendas: list[ActivityAgendaItem]
    clubs: list[ActivityClubItem]
    reading_books: list[ActivityBookItem]


@dataclass(slots=True)
class CommunityService:
    community_repo: CommunityRepository
    post_repo: PostRepository
    reactions: ReactionRepositoryPort
    image_storage: ImageStoragePort
    user_repo: UserRepository
    reading_query: ProfileReadingQueryPort
    challenge_query: ProfileChallengeQueryPort
    highlight_query: ProfileHighlightQueryPort
    activity_reviews: ActivityReviewQueryPort
    activity_highlights: ActivityHighlightQueryPort
    activity_agendas: ActivityAgendaQueryPort
    activity_clubs: ActivityClubQueryPort
    activity_library: ActivityLibraryQueryPort

    async def get_following_feed(
        self,
        *,
        user_id: UUID,
        cursor: str | None,
        limit: int,
    ) -> FeedPage:
        clamped = max(_FEED_PAGE_MIN, min(limit, _FEED_PAGE_MAX))
        posts = await self.community_repo.get_following_feed(
            user_id, cursor=_parse_cursor(cursor), limit=clamped
        )
        return await self._build_page(posts, viewer_id=user_id, limit=clamped)

    async def get_explore_feed(
        self,
        *,
        viewer_id: UUID,
        sort: str,
        post_type: str | None,
        cursor: str | None,
        limit: int,
    ) -> FeedPage:
        clamped = max(_FEED_PAGE_MIN, min(limit, _FEED_PAGE_MAX))
        parsed_post_type: PostType | None = None
        if post_type is not None:
            try:
                parsed_post_type = PostType(post_type)
            except ValueError:
                parsed_post_type = None
        if sort == "popular":
            since = datetime.now(tz=UTC) - timedelta(days=_POPULAR_DAYS)
            posts = await self.community_repo.get_explore_feed_popular(
                viewer_id, since=since, post_type=parsed_post_type, limit=clamped
            )
        else:
            posts = await self.community_repo.get_explore_feed_latest(
                viewer_id,
                cursor=_parse_cursor(cursor),
                post_type=parsed_post_type,
                limit=clamped,
            )
        return await self._build_page(posts, viewer_id=viewer_id, limit=clamped)

    async def get_user_posts(
        self,
        *,
        user_id: UUID,
        viewer_id: UUID,
        cursor: str | None,
        limit: int,
    ) -> FeedPage:
        clamped = max(_FEED_PAGE_MIN, min(limit, _FEED_PAGE_MAX))
        posts = await self.community_repo.get_user_posts(
            user_id, cursor=_parse_cursor(cursor), limit=clamped
        )
        return await self._build_page(posts, viewer_id=viewer_id, limit=clamped)

    async def get_user_profile(
        self,
        *,
        user_id: UUID,
        viewer_id: UUID,
    ) -> UserProfileView:
        user = await self.user_repo.get_by_id(user_id)
        if user is None:
            raise NotFoundError("user not found", code="USER_NOT_FOUND")
        follower_count, following_count = await self.community_repo.follow_counts(user_id)
        is_following = (
            await self.community_repo.is_following(viewer_id, user_id)
            if viewer_id != user_id
            else False
        )
        grade_stats, badges, highlights = await asyncio.gather(
            self.reading_query.get_grade_stats(user_id),
            self.challenge_query.get_user_badges(user_id, limit=6),
            self.highlight_query.get_recent_highlights(user_id, limit=3),
        )
        return UserProfileView(
            user_id=user.id,
            nickname=user.nickname,
            profile_image_url=user.profile_image_url,
            bio=user.bio,
            follower_count=follower_count,
            following_count=following_count,
            is_following=is_following,
            is_me=viewer_id == user_id,
            grade_stats=grade_stats,
            badges=badges,
            recent_highlights=highlights,
            cover_image_url=user.cover_image_url,
            theme=user.theme.value if user.theme is not None else None,
            featured_book_id=user.featured_book_id,
            featured_quote=user.featured_quote,
        )

    async def get_my_activity(self, *, user_id: UUID) -> MyActivitySummary:
        """내 활동 요약 (BC-80) — 카테고리별 총 개수 + 최신 미리보기.

        Cross-domain reads happen sequentially, not via ``asyncio.gather`` —
        mirrors the explicit constraint documented in
        ``reading/service.py`` (concurrent gather on a single shared
        AsyncSession causes connection drops).
        """
        review_total, review_items = await self.activity_reviews.preview(
            user_id, _ACTIVITY_PREVIEW_SIZE
        )
        highlight_total, highlight_items = await self.activity_highlights.preview(
            user_id, _ACTIVITY_PREVIEW_SIZE
        )
        agenda_total, agenda_items = await self.activity_agendas.preview(
            user_id, _ACTIVITY_PREVIEW_SIZE
        )
        club_total, club_items = await self.activity_clubs.preview(user_id, _ACTIVITY_PREVIEW_SIZE)
        library_total, library_items = await self.activity_library.preview(
            user_id, _ACTIVITY_PREVIEW_SIZE
        )
        return MyActivitySummary(
            counts=MyActivityCounts(
                reviews=review_total,
                highlights=highlight_total,
                agendas=agenda_total,
                clubs=club_total,
                reading_books=library_total,
            ),
            reviews=review_items,
            highlights=highlight_items,
            agendas=agenda_items,
            clubs=club_items,
            reading_books=library_items,
        )

    async def _build_page(
        self,
        posts: list[Post],
        *,
        viewer_id: UUID,
        limit: int,
    ) -> FeedPage:
        if not posts:
            return FeedPage(items=[], next_cursor=None)
        post_ids = [p.id for p in posts]
        aggs = await self.reactions.aggregates_for_posts(post_ids)
        my = await self.reactions.my_reactions_for_posts(post_ids, viewer_id)
        comment_counts = await self.post_repo.comment_counts_for(post_ids)
        items: list[PostFeedItem] = []
        for p in posts:
            urls = [await self.image_storage.public_url(k) for k in p.image_keys]
            items.append(
                PostFeedItem(
                    post=p,
                    reactions=aggs.get(p.id, {}),
                    my_reactions=my.get(p.id, set()),
                    comment_count=comment_counts.get(p.id, 0),
                    image_urls=urls,
                )
            )
        next_cursor: str | None = None
        if len(posts) == limit:
            next_cursor = posts[-1].created_at.isoformat()
        return FeedPage(items=items, next_cursor=next_cursor)

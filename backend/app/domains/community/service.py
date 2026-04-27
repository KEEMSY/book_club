"""Community domain service — following feed, explore feed, user profiles.

Aggregates across post, reaction, follow, and block data so the router
layer stays thin. Uses FeedPage from feed.service (a plain dataclass — no
business logic) and delegates reaction/comment enrichment to the same
repository adapters the feed service uses, avoiding duplicated SQL.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import UTC, datetime, timedelta
from uuid import UUID

from app.core.exceptions import NotFoundError
from app.domains.auth.repository import UserRepository
from app.domains.community.repository import CommunityRepository
from app.domains.feed.models import Post
from app.domains.feed.ports import ImageStoragePort, PostFeedItem, ReactionRepositoryPort
from app.domains.feed.repository import PostRepository
from app.domains.feed.service import FeedPage

_FEED_PAGE_MAX = 50
_FEED_PAGE_MIN = 1
_POPULAR_DAYS = 7


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


@dataclass(slots=True)
class CommunityService:
    community_repo: CommunityRepository
    post_repo: PostRepository
    reactions: ReactionRepositoryPort
    image_storage: ImageStoragePort
    user_repo: UserRepository

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
        cursor: str | None,
        limit: int,
    ) -> FeedPage:
        clamped = max(_FEED_PAGE_MIN, min(limit, _FEED_PAGE_MAX))
        if sort == "popular":
            since = datetime.now(tz=UTC) - timedelta(days=_POPULAR_DAYS)
            posts = await self.community_repo.get_explore_feed_popular(
                viewer_id, since=since, limit=clamped
            )
        else:
            posts = await self.community_repo.get_explore_feed_latest(
                viewer_id, cursor=_parse_cursor(cursor), limit=clamped
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
        return UserProfileView(
            user_id=user.id,
            nickname=user.nickname,
            profile_image_url=user.profile_image_url,
            bio=user.bio,
            follower_count=follower_count,
            following_count=following_count,
            is_following=is_following,
            is_me=viewer_id == user_id,
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

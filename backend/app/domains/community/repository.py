"""Cross-domain read queries for community feed views.

CommunityRepository queries against posts/follows/blocks/reactions tables
directly because community is an aggregation domain — all tables live in the
same Postgres instance and the joins are essential for correctness and
performance.
"""

from __future__ import annotations

from datetime import datetime
from uuid import UUID

from sqlalchemy import ColumnElement, and_, desc, func, outerjoin, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.domains.feed.models import Post, Reaction
from app.domains.social.models import Block, Follow


class CommunityRepository:
    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get_following_feed(
        self,
        user_id: UUID,
        *,
        cursor: datetime | None,
        limit: int,
    ) -> list[Post]:
        """Posts from users that `user_id` follows, newest-first."""
        followees_subq = (
            select(Follow.followee_id)
            .where(Follow.follower_id == user_id)
            .scalar_subquery()
        )
        conditions: list[ColumnElement[bool]] = [
            Post.user_id.in_(followees_subq),
            Post.deleted_at.is_(None),
        ]
        if cursor is not None:
            conditions.append(Post.created_at < cursor)
        stmt = (
            select(Post)
            .where(and_(*conditions))
            .order_by(Post.created_at.desc(), Post.id.desc())
            .limit(limit)
        )
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

    async def get_explore_feed_latest(
        self,
        viewer_id: UUID,
        *,
        cursor: datetime | None,
        limit: int,
    ) -> list[Post]:
        """All non-deleted posts excluding blocked users' content, newest-first."""
        blocked_subq = (
            select(Block.blocked_id)
            .where(Block.blocker_id == viewer_id)
            .scalar_subquery()
        )
        conditions: list[ColumnElement[bool]] = [
            Post.deleted_at.is_(None),
            Post.user_id.notin_(blocked_subq),
        ]
        if cursor is not None:
            conditions.append(Post.created_at < cursor)
        stmt = (
            select(Post)
            .where(and_(*conditions))
            .order_by(Post.created_at.desc(), Post.id.desc())
            .limit(limit)
        )
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

    async def get_explore_feed_popular(
        self,
        viewer_id: UUID,
        *,
        since: datetime,
        limit: int,
    ) -> list[Post]:
        """Posts from the last N days ordered by reaction count, excluding blocked.

        Uses LEFT OUTER JOIN + GROUP BY so a single query covers both posts
        that have zero reactions and those that have many.
        """
        blocked_subq = (
            select(Block.blocked_id)
            .where(Block.blocker_id == viewer_id)
            .scalar_subquery()
        )
        rc = func.count(Reaction.id).label("rc")
        j = outerjoin(Post, Reaction, Reaction.post_id == Post.id)
        stmt = (
            select(Post, rc)
            .select_from(j)
            .where(
                Post.deleted_at.is_(None),
                Post.user_id.notin_(blocked_subq),
                Post.created_at >= since,
            )
            .group_by(Post.id)
            .order_by(desc("rc"), Post.id.desc())
            .limit(limit)
        )
        result = await self._session.execute(stmt)
        return [row.Post for row in result.all()]

    async def get_user_posts(
        self,
        user_id: UUID,
        *,
        cursor: datetime | None,
        limit: int,
    ) -> list[Post]:
        """Posts authored by `user_id`, newest-first."""
        conditions: list[ColumnElement[bool]] = [
            Post.user_id == user_id,
            Post.deleted_at.is_(None),
        ]
        if cursor is not None:
            conditions.append(Post.created_at < cursor)
        stmt = (
            select(Post)
            .where(and_(*conditions))
            .order_by(Post.created_at.desc(), Post.id.desc())
            .limit(limit)
        )
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

    async def follow_counts(self, user_id: UUID) -> tuple[int, int]:
        """Returns (follower_count, following_count) for `user_id`."""
        follower_stmt = select(func.count(Follow.id)).where(Follow.followee_id == user_id)
        following_stmt = select(func.count(Follow.id)).where(Follow.follower_id == user_id)
        follower_count = (await self._session.execute(follower_stmt)).scalar_one()
        following_count = (await self._session.execute(following_stmt)).scalar_one()
        return int(follower_count), int(following_count)

    async def is_following(self, follower_id: UUID, followee_id: UUID) -> bool:
        stmt = select(Follow.id).where(
            Follow.follower_id == follower_id,
            Follow.followee_id == followee_id,
        )
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none() is not None

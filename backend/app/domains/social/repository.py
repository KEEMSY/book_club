"""SQLAlchemy async implementation of the social repository port.

Cursor pagination uses base64-encoded ``created_at`` ISO strings so the
mobile client treats them as opaque tokens. The pattern mirrors the
feed domain's cursor approach (ISO string, strict less/greater-than).

Key choices:
- ``follow`` / ``block`` catch IntegrityError and re-raise as ConflictError
  when the UNIQUE constraint fires so the service layer stays transport-agnostic
  (CLAUDE.md §3.1).
- ``unfollow`` / ``unblock`` are silent no-ops when the row does not exist —
  idempotency is explicitly required by the service contract.
- List queries join to the users table and return hydrated User ORM objects
  so the service layer can build UserSummary items without extra queries.
"""

from __future__ import annotations

import base64
from datetime import datetime
from uuid import UUID

from sqlalchemy import and_, delete, select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.exceptions import ConflictError
from app.domains.auth.models import User
from app.domains.social.models import Block, Follow, Report


def _encode_cursor(dt: datetime) -> str:
    return base64.urlsafe_b64encode(dt.isoformat().encode()).decode()


def _decode_cursor(cursor: str) -> datetime | None:
    try:
        iso = base64.urlsafe_b64decode(cursor.encode()).decode()
        return datetime.fromisoformat(iso)
    except Exception:
        return None


class SocialRepository:
    """Concrete SQLAlchemy implementation of ``SocialRepositoryPort``."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    # ------------------------------------------------------------------
    # Follow
    # ------------------------------------------------------------------

    async def follow(self, follower_id: UUID, followee_id: UUID) -> Follow:
        row = Follow(follower_id=follower_id, followee_id=followee_id)
        self._session.add(row)
        try:
            await self._session.flush()
        except IntegrityError as exc:
            await self._session.rollback()
            raise ConflictError(
                "already following this user",
                code="FOLLOW_ALREADY_EXISTS",
            ) from exc
        await self._session.refresh(row)
        return row

    async def unfollow(self, follower_id: UUID, followee_id: UUID) -> None:
        stmt = delete(Follow).where(
            Follow.follower_id == follower_id,
            Follow.followee_id == followee_id,
        )
        await self._session.execute(stmt)
        await self._session.flush()

    async def is_following(self, follower_id: UUID, followee_id: UUID) -> bool:
        stmt = select(Follow.id).where(
            Follow.follower_id == follower_id,
            Follow.followee_id == followee_id,
        )
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none() is not None

    async def get_follow_counts(self, user_id: UUID) -> tuple[int, int]:
        """Return (follower_count, following_count)."""
        follower_stmt = select(Follow).where(Follow.followee_id == user_id)
        following_stmt = select(Follow).where(Follow.follower_id == user_id)
        follower_result = await self._session.execute(follower_stmt)
        following_result = await self._session.execute(following_stmt)
        return (
            len(follower_result.scalars().all()),
            len(following_result.scalars().all()),
        )

    async def list_followers(
        self,
        user_id: UUID,
        viewer_id: UUID,  # reserved for future server-side is_following join
        cursor: str | None,
        limit: int,
    ) -> tuple[list[User], str | None]:
        """List users who follow ``user_id``, paginated by follow.created_at DESC."""
        conditions = [Follow.followee_id == user_id, User.deleted_at.is_(None)]
        if cursor:
            cursor_dt = _decode_cursor(cursor)
            if cursor_dt is not None:
                conditions.append(Follow.created_at < cursor_dt)

        stmt = (
            select(User)
            .join(Follow, Follow.follower_id == User.id)
            .where(and_(*conditions))
            .order_by(Follow.created_at.desc())
            .limit(limit)
        )
        result = await self._session.execute(stmt)
        users = list(result.scalars().all())

        next_cursor: str | None = None
        if len(users) == limit:
            # Fetch the created_at of the last follow edge for cursor generation.
            last_user = users[-1]
            edge_stmt = select(Follow.created_at).where(
                Follow.followee_id == user_id,
                Follow.follower_id == last_user.id,
            )
            edge_result = await self._session.execute(edge_stmt)
            last_dt = edge_result.scalar_one_or_none()
            if last_dt is not None:
                next_cursor = _encode_cursor(last_dt)

        return users, next_cursor

    async def list_following(
        self,
        user_id: UUID,
        viewer_id: UUID,
        cursor: str | None,
        limit: int,
    ) -> tuple[list[User], str | None]:
        """List users that ``user_id`` follows, paginated by follow.created_at DESC."""
        conditions = [Follow.follower_id == user_id, User.deleted_at.is_(None)]
        if cursor:
            cursor_dt = _decode_cursor(cursor)
            if cursor_dt is not None:
                conditions.append(Follow.created_at < cursor_dt)

        stmt = (
            select(User)
            .join(Follow, Follow.followee_id == User.id)
            .where(and_(*conditions))
            .order_by(Follow.created_at.desc())
            .limit(limit)
        )
        result = await self._session.execute(stmt)
        users = list(result.scalars().all())

        next_cursor: str | None = None
        if len(users) == limit:
            last_user = users[-1]
            edge_stmt = select(Follow.created_at).where(
                Follow.follower_id == user_id,
                Follow.followee_id == last_user.id,
            )
            edge_result = await self._session.execute(edge_stmt)
            last_dt = edge_result.scalar_one_or_none()
            if last_dt is not None:
                next_cursor = _encode_cursor(last_dt)

        return users, next_cursor

    # ------------------------------------------------------------------
    # Block
    # ------------------------------------------------------------------

    async def block(self, blocker_id: UUID, blocked_id: UUID) -> Block:
        row = Block(blocker_id=blocker_id, blocked_id=blocked_id)
        self._session.add(row)
        try:
            await self._session.flush()
        except IntegrityError as exc:
            await self._session.rollback()
            raise ConflictError(
                "already blocking this user",
                code="BLOCK_ALREADY_EXISTS",
            ) from exc
        await self._session.refresh(row)
        return row

    async def unblock(self, blocker_id: UUID, blocked_id: UUID) -> None:
        stmt = delete(Block).where(
            Block.blocker_id == blocker_id,
            Block.blocked_id == blocked_id,
        )
        await self._session.execute(stmt)
        await self._session.flush()

    async def is_blocked(self, blocker_id: UUID, blocked_id: UUID) -> bool:
        stmt = select(Block.id).where(
            Block.blocker_id == blocker_id,
            Block.blocked_id == blocked_id,
        )
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none() is not None

    async def list_blocks(
        self,
        blocker_id: UUID,
        cursor: str | None,
        limit: int,
    ) -> tuple[list[User], str | None]:
        """List users blocked by ``blocker_id``, paginated by block.created_at DESC."""
        conditions = [Block.blocker_id == blocker_id, User.deleted_at.is_(None)]
        if cursor:
            cursor_dt = _decode_cursor(cursor)
            if cursor_dt is not None:
                conditions.append(Block.created_at < cursor_dt)

        stmt = (
            select(User)
            .join(Block, Block.blocked_id == User.id)
            .where(and_(*conditions))
            .order_by(Block.created_at.desc())
            .limit(limit)
        )
        result = await self._session.execute(stmt)
        users = list(result.scalars().all())

        next_cursor: str | None = None
        if len(users) == limit:
            last_user = users[-1]
            edge_stmt = select(Block.created_at).where(
                Block.blocker_id == blocker_id,
                Block.blocked_id == last_user.id,
            )
            edge_result = await self._session.execute(edge_stmt)
            last_dt = edge_result.scalar_one_or_none()
            if last_dt is not None:
                next_cursor = _encode_cursor(last_dt)

        return users, next_cursor

    # ------------------------------------------------------------------
    # Report
    # ------------------------------------------------------------------

    async def report(
        self,
        reporter_id: UUID,
        target_type: str,
        target_id: UUID,
        reason: str,
    ) -> Report:
        row = Report(
            reporter_id=reporter_id,
            target_type=target_type,
            target_id=target_id,
            reason=reason,
        )
        self._session.add(row)
        await self._session.flush()
        await self._session.refresh(row)
        return row

    async def has_reported(
        self,
        reporter_id: UUID,
        target_type: str,
        target_id: UUID,
    ) -> bool:
        stmt = select(Report.id).where(
            Report.reporter_id == reporter_id,
            Report.target_type == target_type,
            Report.target_id == target_id,
        )
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none() is not None

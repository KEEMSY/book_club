"""Social domain service — follows, blocks, reports.

Depends only on the Protocols in ``ports.py`` (CLAUDE.md §3.2). Concrete
repositories are injected by ``providers.py`` for HTTP traffic or by test
fakes for unit tests.

Business rules:
- ``follow``: cannot follow self (ConflictError); cannot follow a user who
  has blocked the actor (ConflictError); removes any reverse block (actor
  blocked target) before inserting; fires FollowReceived event via EventBus.
- ``unfollow``: idempotent — no error if the follow edge does not exist.
- ``block``: cannot block self (ConflictError); auto-unfollows both
  directions (actor→target and target→actor) before inserting the block row.
- ``unblock``: idempotent.
- ``report``: one report per (reporter, target_type, target_id) —
  ConflictError on duplicate.
- ``get_followers`` / ``get_following``: return a UserSummaryPage with
  ``is_following`` populated from the requesting actor's perspective.
"""

from __future__ import annotations

from collections.abc import Callable
from dataclasses import dataclass, field
from uuid import UUID

from app.core.exceptions import ConflictError
from app.domains.social.events import FollowReceived
from app.domains.social.ports import SocialRepositoryPort
from app.domains.social.schemas import UserSummary, UserSummaryPage
from app.shared.event_bus import EventBus

_PAGE_MAX = 50
_PAGE_MIN = 1


@dataclass(slots=True)
class SocialService:
    """Orchestrates follow/block/report and social-graph queries."""

    repo: SocialRepositoryPort
    bus: EventBus | None = field(default=None)
    stage_event: Callable[[object], None] | None = field(default=None)

    async def follow(self, actor_id: UUID, target_id: UUID) -> None:
        """Follow target_id on behalf of actor_id.

        Raises ConflictError when actor tries to follow themselves or when the
        target has blocked the actor.
        """
        if actor_id == target_id:
            raise ConflictError("cannot follow yourself", code="FOLLOW_SELF")

        # Block in either direction prevents following.
        if await self.repo.is_blocked(target_id, actor_id):
            raise ConflictError(
                "cannot follow a user who has blocked you",
                code="FOLLOW_BLOCKED",
            )

        # If the actor had previously blocked the target, remove it — the
        # follow action implies the actor wants the relationship open.
        if await self.repo.is_blocked(actor_id, target_id):
            await self.repo.unblock(actor_id, target_id)

        await self.repo.follow(actor_id, target_id)

        if self.stage_event is not None:
            self.stage_event(FollowReceived(follower_id=actor_id, followee_id=target_id))

    async def unfollow(self, actor_id: UUID, target_id: UUID) -> None:
        """Unfollow target_id. Idempotent — no error if not following."""
        await self.repo.unfollow(actor_id, target_id)

    async def block(self, actor_id: UUID, target_id: UUID) -> None:
        """Block target_id on behalf of actor_id.

        Auto-unfollows both directions before inserting the block edge.
        Raises ConflictError when actor tries to block themselves.
        """
        if actor_id == target_id:
            raise ConflictError("cannot block yourself", code="BLOCK_SELF")

        # Sever follow edges in both directions so the blocked user's feed no
        # longer sees the actor's content and vice versa.
        await self.repo.unfollow(actor_id, target_id)
        await self.repo.unfollow(target_id, actor_id)

        await self.repo.block(actor_id, target_id)

    async def unblock(self, actor_id: UUID, target_id: UUID) -> None:
        """Unblock target_id. Idempotent — no error if not blocking."""
        await self.repo.unblock(actor_id, target_id)

    async def report(
        self,
        actor_id: UUID,
        target_type: str,
        target_id: UUID,
        reason: str,
    ) -> None:
        """Submit an abuse report.

        One report per (reporter, target_type, target_id) — raises
        ConflictError on a duplicate to prevent spam flooding.
        """
        if await self.repo.has_reported(actor_id, target_type, target_id):
            raise ConflictError(
                "you have already reported this content",
                code="REPORT_DUPLICATE",
            )
        await self.repo.report(actor_id, target_type, target_id, reason)

    async def get_followers(
        self,
        actor_id: UUID,
        user_id: UUID,
        cursor: str | None,
        limit: int,
    ) -> UserSummaryPage:
        """Return paginated followers of user_id with is_following from actor's view."""
        clamped = max(_PAGE_MIN, min(limit, _PAGE_MAX))
        users, next_cursor = await self.repo.list_followers(
            user_id, actor_id, cursor, clamped
        )
        items = []
        for u in users:
            is_following = await self.repo.is_following(actor_id, u.id)
            items.append(
                UserSummary(
                    id=u.id,
                    nickname=u.nickname,
                    profile_image_url=u.profile_image_url,
                    bio=u.bio,
                    is_following=is_following,
                )
            )
        return UserSummaryPage(items=items, next_cursor=next_cursor)

    async def get_following(
        self,
        actor_id: UUID,
        user_id: UUID,
        cursor: str | None,
        limit: int,
    ) -> UserSummaryPage:
        """Return paginated following list of user_id with is_following from actor's view."""
        clamped = max(_PAGE_MIN, min(limit, _PAGE_MAX))
        users, next_cursor = await self.repo.list_following(
            user_id, actor_id, cursor, clamped
        )
        items = []
        for u in users:
            is_following = await self.repo.is_following(actor_id, u.id)
            items.append(
                UserSummary(
                    id=u.id,
                    nickname=u.nickname,
                    profile_image_url=u.profile_image_url,
                    bio=u.bio,
                    is_following=is_following,
                )
            )
        return UserSummaryPage(items=items, next_cursor=next_cursor)

    async def get_blocks(
        self,
        actor_id: UUID,
        cursor: str | None,
        limit: int,
    ) -> UserSummaryPage:
        """Return paginated list of users blocked by actor_id."""
        clamped = max(_PAGE_MIN, min(limit, _PAGE_MAX))
        users, next_cursor = await self.repo.list_blocks(actor_id, cursor, clamped)
        items = [
            UserSummary(
                id=u.id,
                nickname=u.nickname,
                profile_image_url=u.profile_image_url,
                bio=u.bio,
                # Blocked users are never shown as "following" from the blocker's
                # perspective — the block severs all follow edges.
                is_following=False,
            )
            for u in users
        ]
        return UserSummaryPage(items=items, next_cursor=next_cursor)

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
from datetime import UTC, date, datetime, timedelta
from uuid import UUID

from app.core.exceptions import ConflictError
from app.domains.social.events import FollowReceived
from app.domains.social.ports import SocialRepositoryPort
from app.domains.social.schemas import (
    LeaderboardEntry,
    LeaderboardResponse,
    UserSummary,
    UserSummaryPage,
)
from app.shared.event_bus import EventBus

# Grade name labels indexed by (grade, tier).
# grade 1-5 maps to Bronze/Silver/Gold/Platinum/Diamond;
# tier 1-3 maps to I/II/III (I is highest within a grade).
_GRADE_NAMES = {1: "Bronze", 2: "Silver", 3: "Gold", 4: "Platinum", 5: "Diamond"}
_TIER_NAMES = {1: "I", 2: "II", 3: "III"}


def _grade_tier_label(grade: int | None, tier: int | None) -> str | None:
    """Convert numeric grade/tier to a human-readable label, e.g. 'Gold II'."""
    if grade is None or tier is None:
        return None
    name = _GRADE_NAMES.get(grade)
    rank = _TIER_NAMES.get(tier)
    if name is None or rank is None:
        return None
    return f"{name} {rank}"


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
        users, next_cursor = await self.repo.list_followers(user_id, actor_id, cursor, clamped)
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
        users, next_cursor = await self.repo.list_following(user_id, actor_id, cursor, clamped)
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

    async def search_users(
        self,
        actor_id: UUID,
        q: str,
        cursor: str | None,
        limit: int,
    ) -> UserSummaryPage:
        """Search users by nickname. Excludes actor and users who blocked actor."""
        q = q.strip()
        if not q:
            return UserSummaryPage(items=[], next_cursor=None)
        clamped = max(_PAGE_MIN, min(limit, _PAGE_MAX))
        users, next_cursor = await self.repo.search_users(actor_id, q, cursor, clamped)
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

    async def get_weekly_leaderboard(self, user_id: UUID) -> LeaderboardResponse:
        """Build a weekly reading leaderboard for the requesting user and their followings.

        The window spans the last 7 calendar days (inclusive of today).
        Ranking is dense: ties share a rank and the next rank is not skipped.
        The requesting user always appears even when they have no reading time.
        """
        rows = await self.repo.get_weekly_leaderboard(user_id)

        entries: list[LeaderboardEntry] = []
        current_rank = 0
        prev_minutes: int | None = None
        for i, row in enumerate(rows):
            # Dense ranking: only advance rank when the score changes.
            if row.weekly_minutes != prev_minutes:
                current_rank = i + 1
                prev_minutes = row.weekly_minutes
            entries.append(
                LeaderboardEntry(
                    rank=current_rank,
                    user_id=row.user_id,
                    nickname=row.nickname,
                    profile_image_url=row.profile_image_url,
                    grade_tier=_grade_tier_label(row.grade, row.tier),
                    weekly_minutes=row.weekly_minutes,
                    is_me=row.user_id == user_id,
                )
            )

        now_utc = datetime.now(tz=UTC)
        # week_start = 7 days ago (the beginning of the rolling window).
        week_start: date = (now_utc - timedelta(days=6)).date()

        return LeaderboardResponse(
            entries=entries,
            week_start=week_start,
            generated_at=now_utc,
        )

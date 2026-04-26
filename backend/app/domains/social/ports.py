"""Social domain ports — the only contracts ``service.py`` is allowed to import.

Per CLAUDE.md §3.2 the Port/Adapter boundary ensures the service layer is
unit-testable against in-memory fakes without a real database.

``User`` is imported from auth.models so the listing methods can return
fully-hydrated user objects; this is a read-only cross-domain access that
does not breach the domain boundary because social is the consumer and auth
is the authoritative source (CLAUDE.md §3.3).
"""

from __future__ import annotations

from typing import Protocol
from uuid import UUID

from app.domains.auth.models import User
from app.domains.social.models import Block, Follow, Report


class SocialRepositoryPort(Protocol):
    """All persistence operations required by SocialService."""

    async def follow(self, follower_id: UUID, followee_id: UUID) -> Follow: ...

    async def unfollow(self, follower_id: UUID, followee_id: UUID) -> None: ...

    async def is_following(self, follower_id: UUID, followee_id: UUID) -> bool: ...

    async def get_follow_counts(self, user_id: UUID) -> tuple[int, int]:
        """Return (follower_count, following_count) for user_id."""
        ...

    async def list_followers(
        self,
        user_id: UUID,
        viewer_id: UUID,
        cursor: str | None,
        limit: int,
    ) -> tuple[list[User], str | None]:
        """List users who follow ``user_id``.

        Returns (users, next_cursor). ``viewer_id`` is used by the caller to
        populate ``is_following`` per item; the repository returns raw User rows
        and the service layer resolves the viewer relationship.
        """
        ...

    async def list_following(
        self,
        user_id: UUID,
        viewer_id: UUID,
        cursor: str | None,
        limit: int,
    ) -> tuple[list[User], str | None]:
        """List users that ``user_id`` follows."""
        ...

    async def block(self, blocker_id: UUID, blocked_id: UUID) -> Block: ...

    async def unblock(self, blocker_id: UUID, blocked_id: UUID) -> None: ...

    async def is_blocked(self, blocker_id: UUID, blocked_id: UUID) -> bool: ...

    async def list_blocks(
        self,
        blocker_id: UUID,
        cursor: str | None,
        limit: int,
    ) -> tuple[list[User], str | None]:
        """List users blocked by ``blocker_id``."""
        ...

    async def report(
        self,
        reporter_id: UUID,
        target_type: str,
        target_id: UUID,
        reason: str,
    ) -> Report: ...

    async def has_reported(
        self,
        reporter_id: UUID,
        target_type: str,
        target_id: UUID,
    ) -> bool: ...

    async def search_users(
        self,
        actor_id: UUID,
        q: str,
        cursor: str | None,
        limit: int,
    ) -> tuple[list[User], str | None]:
        """Nickname ILIKE search. Excludes actor and users who blocked actor."""
        ...

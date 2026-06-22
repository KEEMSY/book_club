"""Team domain ports — the only contracts ``service.py`` imports (CLAUDE.md §3.2).

Two boundaries are modelled so ``TeamService`` runs against in-memory fakes
without a database (§5):

- ``TeamRepositoryPort`` — persistence for ``team_subscriptions`` /
  ``team_members`` plus the read-only member-profile projection the roster view
  needs.
- ``MemberProGrantPort`` — the cross-domain Pro write. The subscription domain
  owns the ``users`` Pro columns, so granting/revoking a seat's Pro entitlement
  is delegated through this port rather than touching those columns here.
"""

from __future__ import annotations

import uuid
from dataclasses import dataclass
from datetime import datetime
from typing import Protocol

from app.domains.team.models import TeamSubscription


@dataclass(frozen=True, slots=True)
class TeamMemberInfo:
    """A roster row joined with the member's public profile fields."""

    user_id: uuid.UUID
    nickname: str
    profile_image_url: str | None
    joined_at: datetime


class TeamRepositoryPort(Protocol):
    """Persistence for team subscriptions and their seat roster."""

    async def create_team(
        self,
        *,
        team_name: str,
        admin_user_id: uuid.UUID,
        seat_count: int,
        plan_type: str,
        valid_from: datetime,
        valid_until: datetime,
    ) -> TeamSubscription: ...

    async def get_team(self, team_id: uuid.UUID) -> TeamSubscription | None: ...

    async def add_member(self, *, team_id: uuid.UUID, user_id: uuid.UUID) -> None: ...

    async def remove_member(self, *, team_id: uuid.UUID, user_id: uuid.UUID) -> None: ...

    async def is_member(self, *, team_id: uuid.UUID, user_id: uuid.UUID) -> bool: ...

    async def count_members(self, team_id: uuid.UUID) -> int: ...

    async def list_members(self, team_id: uuid.UUID) -> list[TeamMemberInfo]: ...


class MemberProGrantPort(Protocol):
    """Cross-domain Pro write for team seats (owned by the subscription domain)."""

    async def grant_pro(
        self, *, user_id: uuid.UUID, expires_at: datetime, product_id: str
    ) -> None: ...

    async def revoke_pro(self, *, user_id: uuid.UUID) -> None: ...

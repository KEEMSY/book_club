"""SQLAlchemy async repository for the team domain (M70).

Owns the ``team_subscriptions`` and ``team_members`` tables. The roster read
joins ``users`` for each member's public profile fields (nickname, avatar);
this is a read-only projection — Pro state writes go through the subscription
domain via ``MemberProGrantPort`` rather than this repository.
"""

from __future__ import annotations

import uuid
from dataclasses import dataclass
from datetime import datetime

from sqlalchemy import delete, func, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.domains.auth.models import User
from app.domains.team.models import TeamMember, TeamSubscription
from app.domains.team.ports import TeamMemberInfo


@dataclass(slots=True)
class TeamRepository:
    """All persistence for the team domain."""

    session: AsyncSession

    async def create_team(
        self,
        *,
        team_name: str,
        admin_user_id: uuid.UUID,
        seat_count: int,
        plan_type: str,
        valid_from: datetime,
        valid_until: datetime,
    ) -> TeamSubscription:
        team = TeamSubscription(
            team_name=team_name,
            admin_user_id=admin_user_id,
            seat_count=seat_count,
            plan_type=plan_type,
            valid_from=valid_from,
            valid_until=valid_until,
        )
        self.session.add(team)
        await self.session.flush()
        return team

    async def get_team(self, team_id: uuid.UUID) -> TeamSubscription | None:
        return await self.session.get(TeamSubscription, team_id)

    async def add_member(self, *, team_id: uuid.UUID, user_id: uuid.UUID) -> None:
        self.session.add(TeamMember(team_id=team_id, user_id=user_id))
        await self.session.flush()

    async def remove_member(self, *, team_id: uuid.UUID, user_id: uuid.UUID) -> None:
        await self.session.execute(
            delete(TeamMember).where(TeamMember.team_id == team_id, TeamMember.user_id == user_id)
        )
        await self.session.flush()

    async def is_member(self, *, team_id: uuid.UUID, user_id: uuid.UUID) -> bool:
        result = await self.session.execute(
            select(TeamMember.id).where(
                TeamMember.team_id == team_id, TeamMember.user_id == user_id
            )
        )
        return result.first() is not None

    async def count_members(self, team_id: uuid.UUID) -> int:
        result = await self.session.execute(
            select(func.count(TeamMember.id)).where(TeamMember.team_id == team_id)
        )
        return result.scalar_one() or 0

    async def list_members(self, team_id: uuid.UUID) -> list[TeamMemberInfo]:
        """Roster ordered by join time, joined with each member's profile."""
        result = await self.session.execute(
            select(
                TeamMember.user_id,
                User.nickname,
                User.profile_image_url,
                TeamMember.joined_at,
            )
            .join(User, User.id == TeamMember.user_id)
            .where(TeamMember.team_id == team_id)
            .order_by(TeamMember.joined_at.asc())
        )
        return [
            TeamMemberInfo(
                user_id=row.user_id,
                nickname=row.nickname,
                profile_image_url=row.profile_image_url,
                joined_at=row.joined_at,
            )
            for row in result.all()
        ]

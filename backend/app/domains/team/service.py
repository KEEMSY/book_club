"""Team domain service — B2B team-plan MVP (M70).

Depends only on ``TeamRepositoryPort`` and ``MemberProGrantPort`` (CLAUDE.md
§3.2) so the seat-limit and admin-only rules run against in-memory fakes
without a database (§5).

Rules:
- Creating a team seats the admin as the first member and grants them Pro for
  the contract window.
- Adding a member is admin-only, capped by ``seat_count`` (the admin counts as
  one seat), and rejects duplicates; the new member is granted Pro for the
  team's remaining window.
- Removing a member is admin-only; the admin cannot be removed. Removal revokes
  the member's Pro.
- Reading a team is restricted to the admin and current members.
"""

from __future__ import annotations

import calendar
from dataclasses import dataclass
from datetime import UTC, datetime
from uuid import UUID

from app.core.exceptions import ConflictError, NotFoundError, PermissionDeniedError
from app.domains.team.models import TeamSubscription
from app.domains.team.ports import MemberProGrantPort, TeamMemberInfo, TeamRepositoryPort
from app.domains.team.schemas import TeamMemberResponse, TeamResponse

# Plan identifier written to ``users.pro_product_id`` for team-granted Pro, so
# the admin dashboard can tell team seats apart from individual subscribers.
TEAM_PLAN_PRODUCT_ID = "annual_team"


@dataclass(slots=True)
class TeamService:
    """Orchestrates team creation, seat management, and the roster read."""

    repo: TeamRepositoryPort
    pro_grant: MemberProGrantPort

    async def create_team(
        self,
        *,
        admin_user_id: UUID,
        team_name: str,
        seat_count: int,
        valid_months: int,
    ) -> TeamResponse:
        """Create a team, seat the admin, and grant the admin Pro."""
        valid_from = datetime.now(tz=UTC)
        valid_until = _add_months(valid_from, valid_months)
        team = await self.repo.create_team(
            team_name=team_name,
            admin_user_id=admin_user_id,
            seat_count=seat_count,
            plan_type=TEAM_PLAN_PRODUCT_ID,
            valid_from=valid_from,
            valid_until=valid_until,
        )
        await self.repo.add_member(team_id=team.id, user_id=admin_user_id)
        await self.pro_grant.grant_pro(
            user_id=admin_user_id, expires_at=valid_until, product_id=TEAM_PLAN_PRODUCT_ID
        )
        return await self._build_response(team)

    async def add_member(
        self, *, team_id: UUID, admin_user_id: UUID, user_id: UUID
    ) -> TeamResponse:
        """Seat a new member (admin only), capped by ``seat_count``."""
        team = await self._require_admin(team_id=team_id, admin_user_id=admin_user_id)

        if await self.repo.is_member(team_id=team_id, user_id=user_id):
            raise ConflictError("이미 팀 멤버입니다.", code="ALREADY_MEMBER")
        if await self.repo.count_members(team_id) >= team.seat_count:
            raise ConflictError("좌석이 모두 찼습니다.", code="SEAT_LIMIT_EXCEEDED")

        await self.repo.add_member(team_id=team_id, user_id=user_id)
        await self.pro_grant.grant_pro(
            user_id=user_id, expires_at=team.valid_until, product_id=TEAM_PLAN_PRODUCT_ID
        )
        return await self._build_response(team)

    async def remove_member(
        self, *, team_id: UUID, admin_user_id: UUID, user_id: UUID
    ) -> TeamResponse:
        """Remove a member (admin only) and revoke their Pro."""
        team = await self._require_admin(team_id=team_id, admin_user_id=admin_user_id)

        if user_id == team.admin_user_id:
            raise ConflictError("관리자는 제거할 수 없습니다.", code="CANNOT_REMOVE_ADMIN")
        if not await self.repo.is_member(team_id=team_id, user_id=user_id):
            raise NotFoundError("팀 멤버를 찾을 수 없습니다.", code="MEMBER_NOT_FOUND")

        await self.repo.remove_member(team_id=team_id, user_id=user_id)
        await self.pro_grant.revoke_pro(user_id=user_id)
        return await self._build_response(team)

    async def get_team(self, *, team_id: UUID, user_id: UUID) -> TeamResponse:
        """Return team details + roster. Visible to the admin and members only."""
        team = await self.repo.get_team(team_id)
        if team is None:
            raise NotFoundError("팀을 찾을 수 없습니다.", code="TEAM_NOT_FOUND")
        if team.admin_user_id != user_id and not await self.repo.is_member(
            team_id=team_id, user_id=user_id
        ):
            raise PermissionDeniedError("팀에 접근할 권한이 없습니다.", code="PERMISSION_DENIED")
        return await self._build_response(team)

    async def _require_admin(self, *, team_id: UUID, admin_user_id: UUID) -> TeamSubscription:
        team = await self.repo.get_team(team_id)
        if team is None:
            raise NotFoundError("팀을 찾을 수 없습니다.", code="TEAM_NOT_FOUND")
        if team.admin_user_id != admin_user_id:
            raise PermissionDeniedError("팀 관리자만 가능합니다.", code="PERMISSION_DENIED")
        return team

    async def _build_response(self, team: TeamSubscription) -> TeamResponse:
        members = await self.repo.list_members(team.id)
        return TeamResponse(
            id=team.id,
            team_name=team.team_name,
            admin_user_id=team.admin_user_id,
            seat_count=team.seat_count,
            plan_type=team.plan_type,
            valid_from=team.valid_from,
            valid_until=team.valid_until,
            used_seats=len(members),
            members=[_member_response(m) for m in members],
        )


def _member_response(info: TeamMemberInfo) -> TeamMemberResponse:
    return TeamMemberResponse(
        user_id=info.user_id,
        nickname=info.nickname,
        profile_image_url=info.profile_image_url,
        joined_at=info.joined_at,
    )


def _add_months(dt: datetime, months: int) -> datetime:
    """Add ``months`` calendar months, clamping the day to the target month."""
    zero_based = dt.month - 1 + months
    year = dt.year + zero_based // 12
    month = zero_based % 12 + 1
    day = min(dt.day, calendar.monthrange(year, month)[1])
    return dt.replace(year=year, month=month, day=day)

"""Unit tests for TeamService — in-memory fakes, no DB (CLAUDE.md §5).

Covers the M70 B2B team-plan rules: admin-as-first-seat on create, the
admin-only + seat-limit + duplicate guards on add, host/admin-only removal with
Pro revocation, and roster-read access control.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import UTC, datetime
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError, NotFoundError, PermissionDeniedError
from app.domains.team.ports import TeamMemberInfo
from app.domains.team.service import TEAM_PLAN_PRODUCT_ID, TeamService


@dataclass
class _FakeTeam:
    id: UUID
    team_name: str
    admin_user_id: UUID
    seat_count: int
    plan_type: str
    valid_from: datetime
    valid_until: datetime


@dataclass
class FakeTeamRepository:
    teams: dict[UUID, _FakeTeam] = field(default_factory=dict)
    # team_id -> {user_id: joined_at}
    members: dict[UUID, dict[UUID, datetime]] = field(default_factory=dict)
    nicknames: dict[UUID, str] = field(default_factory=dict)

    async def create_team(
        self,
        *,
        team_name: str,
        admin_user_id: UUID,
        seat_count: int,
        plan_type: str,
        valid_from: datetime,
        valid_until: datetime,
    ) -> _FakeTeam:
        team = _FakeTeam(
            id=uuid4(),
            team_name=team_name,
            admin_user_id=admin_user_id,
            seat_count=seat_count,
            plan_type=plan_type,
            valid_from=valid_from,
            valid_until=valid_until,
        )
        self.teams[team.id] = team
        self.members[team.id] = {}
        return team

    async def get_team(self, team_id: UUID) -> _FakeTeam | None:
        return self.teams.get(team_id)

    async def add_member(self, *, team_id: UUID, user_id: UUID) -> None:
        self.members.setdefault(team_id, {})[user_id] = datetime.now(tz=UTC)

    async def remove_member(self, *, team_id: UUID, user_id: UUID) -> None:
        self.members.get(team_id, {}).pop(user_id, None)

    async def is_member(self, *, team_id: UUID, user_id: UUID) -> bool:
        return user_id in self.members.get(team_id, {})

    async def count_members(self, team_id: UUID) -> int:
        return len(self.members.get(team_id, {}))

    async def list_members(self, team_id: UUID) -> list[TeamMemberInfo]:
        return [
            TeamMemberInfo(
                user_id=uid,
                nickname=self.nicknames.get(uid, "회원"),
                profile_image_url=None,
                joined_at=joined,
            )
            for uid, joined in sorted(self.members.get(team_id, {}).items(), key=lambda kv: kv[1])
        ]


@dataclass
class FakeProGrant:
    granted: dict[UUID, tuple[datetime, str]] = field(default_factory=dict)
    revoked: set[UUID] = field(default_factory=set)

    async def grant_pro(self, *, user_id: UUID, expires_at: datetime, product_id: str) -> None:
        self.granted[user_id] = (expires_at, product_id)
        self.revoked.discard(user_id)

    async def revoke_pro(self, *, user_id: UUID) -> None:
        self.revoked.add(user_id)
        self.granted.pop(user_id, None)


def _svc() -> tuple[TeamService, FakeTeamRepository, FakeProGrant]:
    repo, grant = FakeTeamRepository(), FakeProGrant()
    return TeamService(repo=repo, pro_grant=grant), repo, grant  # type: ignore[arg-type]


# ---------------------------------------------------------------------------
# create_team
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_create_team_seats_admin_and_grants_pro() -> None:
    svc, _repo, grant = _svc()
    admin = uuid4()

    res = await svc.create_team(
        admin_user_id=admin, team_name="우리팀", seat_count=10, valid_months=12
    )

    assert res.admin_user_id == admin
    assert res.seat_count == 10
    assert res.used_seats == 1
    assert res.members[0].user_id == admin
    assert res.valid_until.year - res.valid_from.year == 1 or res.valid_until > res.valid_from
    assert grant.granted[admin][1] == TEAM_PLAN_PRODUCT_ID


# ---------------------------------------------------------------------------
# add_member
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_add_member_by_admin_grants_pro() -> None:
    svc, _repo, grant = _svc()
    admin = uuid4()
    team = await svc.create_team(admin_user_id=admin, team_name="t", seat_count=10, valid_months=12)
    member = uuid4()

    res = await svc.add_member(team_id=team.id, admin_user_id=admin, user_id=member)

    assert res.used_seats == 2
    assert member in grant.granted
    assert grant.granted[member][0] == team.valid_until


@pytest.mark.asyncio
async def test_add_member_non_admin_denied() -> None:
    svc, _repo, _grant = _svc()
    admin = uuid4()
    team = await svc.create_team(admin_user_id=admin, team_name="t", seat_count=10, valid_months=12)
    with pytest.raises(PermissionDeniedError) as exc:
        await svc.add_member(team_id=team.id, admin_user_id=uuid4(), user_id=uuid4())
    assert exc.value.code == "PERMISSION_DENIED"


@pytest.mark.asyncio
async def test_add_member_duplicate_rejected() -> None:
    svc, _repo, _grant = _svc()
    admin = uuid4()
    team = await svc.create_team(admin_user_id=admin, team_name="t", seat_count=10, valid_months=12)
    member = uuid4()
    await svc.add_member(team_id=team.id, admin_user_id=admin, user_id=member)
    with pytest.raises(ConflictError) as exc:
        await svc.add_member(team_id=team.id, admin_user_id=admin, user_id=member)
    assert exc.value.code == "ALREADY_MEMBER"


@pytest.mark.asyncio
async def test_add_member_seat_limit_exceeded() -> None:
    svc, _repo, _grant = _svc()
    admin = uuid4()
    # Two seats: admin takes one, so only one more member fits.
    team = await svc.create_team(admin_user_id=admin, team_name="t", seat_count=2, valid_months=12)
    await svc.add_member(team_id=team.id, admin_user_id=admin, user_id=uuid4())
    with pytest.raises(ConflictError) as exc:
        await svc.add_member(team_id=team.id, admin_user_id=admin, user_id=uuid4())
    assert exc.value.code == "SEAT_LIMIT_EXCEEDED"


@pytest.mark.asyncio
async def test_add_member_unknown_team_not_found() -> None:
    svc, _repo, _grant = _svc()
    with pytest.raises(NotFoundError) as exc:
        await svc.add_member(team_id=uuid4(), admin_user_id=uuid4(), user_id=uuid4())
    assert exc.value.code == "TEAM_NOT_FOUND"


# ---------------------------------------------------------------------------
# remove_member
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_remove_member_revokes_pro() -> None:
    svc, _repo, grant = _svc()
    admin = uuid4()
    team = await svc.create_team(admin_user_id=admin, team_name="t", seat_count=10, valid_months=12)
    member = uuid4()
    await svc.add_member(team_id=team.id, admin_user_id=admin, user_id=member)

    res = await svc.remove_member(team_id=team.id, admin_user_id=admin, user_id=member)

    assert res.used_seats == 1
    assert member in grant.revoked


@pytest.mark.asyncio
async def test_remove_member_admin_cannot_be_removed() -> None:
    svc, _repo, _grant = _svc()
    admin = uuid4()
    team = await svc.create_team(admin_user_id=admin, team_name="t", seat_count=10, valid_months=12)
    with pytest.raises(ConflictError) as exc:
        await svc.remove_member(team_id=team.id, admin_user_id=admin, user_id=admin)
    assert exc.value.code == "CANNOT_REMOVE_ADMIN"


@pytest.mark.asyncio
async def test_remove_unknown_member_not_found() -> None:
    svc, _repo, _grant = _svc()
    admin = uuid4()
    team = await svc.create_team(admin_user_id=admin, team_name="t", seat_count=10, valid_months=12)
    with pytest.raises(NotFoundError) as exc:
        await svc.remove_member(team_id=team.id, admin_user_id=admin, user_id=uuid4())
    assert exc.value.code == "MEMBER_NOT_FOUND"


@pytest.mark.asyncio
async def test_remove_member_non_admin_denied() -> None:
    svc, _repo, _grant = _svc()
    admin = uuid4()
    team = await svc.create_team(admin_user_id=admin, team_name="t", seat_count=10, valid_months=12)
    member = uuid4()
    await svc.add_member(team_id=team.id, admin_user_id=admin, user_id=member)
    with pytest.raises(PermissionDeniedError) as exc:
        await svc.remove_member(team_id=team.id, admin_user_id=uuid4(), user_id=member)
    assert exc.value.code == "PERMISSION_DENIED"


# ---------------------------------------------------------------------------
# get_team
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_get_team_by_member_returns_roster() -> None:
    svc, _repo, _grant = _svc()
    admin = uuid4()
    team = await svc.create_team(admin_user_id=admin, team_name="t", seat_count=10, valid_months=12)
    member = uuid4()
    await svc.add_member(team_id=team.id, admin_user_id=admin, user_id=member)

    res = await svc.get_team(team_id=team.id, user_id=member)

    assert {m.user_id for m in res.members} == {admin, member}


@pytest.mark.asyncio
async def test_get_team_by_outsider_denied() -> None:
    svc, _repo, _grant = _svc()
    admin = uuid4()
    team = await svc.create_team(admin_user_id=admin, team_name="t", seat_count=10, valid_months=12)
    with pytest.raises(PermissionDeniedError) as exc:
        await svc.get_team(team_id=team.id, user_id=uuid4())
    assert exc.value.code == "PERMISSION_DENIED"


@pytest.mark.asyncio
async def test_get_team_unknown_not_found() -> None:
    svc, _repo, _grant = _svc()
    with pytest.raises(NotFoundError) as exc:
        await svc.get_team(team_id=uuid4(), user_id=uuid4())
    assert exc.value.code == "TEAM_NOT_FOUND"


@pytest.mark.asyncio
async def test_add_months_handles_year_rollover() -> None:
    from app.domains.team.service import _add_months

    base = datetime(2026, 6, 22, tzinfo=UTC)
    assert _add_months(base, 12) == datetime(2027, 6, 22, tzinfo=UTC)
    # Day clamp: Jan 31 + 1 month -> Feb 28.
    jan31 = datetime(2026, 1, 31, tzinfo=UTC)
    assert _add_months(jan31, 1) == datetime(2026, 2, 28, tzinfo=UTC)

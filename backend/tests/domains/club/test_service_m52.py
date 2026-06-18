"""Unit tests for ClubService — M52 (club AI reading coach).

Covers:
- create_reading_plan: success + weekly_pages computation, non-owner rejection,
  non-Pro rejection (PRO_REQUIRED), page-count fallback, span-based weeks.
- update_member_progress: success, non-member rejection.
- get_club_progress: no plan, with plan, progress_pct clamping.

Uses an in-memory fake repository — no DB, Redis, or push backend required.
"""

from __future__ import annotations

import secrets
from dataclasses import dataclass, field
from datetime import date, datetime, timedelta
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError, PermissionDeniedError
from app.domains.club.service import ClubService

# ---------------------------------------------------------------------------
# Fake domain objects
# ---------------------------------------------------------------------------


@dataclass
class _FakeClub:
    id: UUID = field(default_factory=uuid4)
    name: str = "Test Club"
    owner_id: UUID = field(default_factory=uuid4)
    book_id: UUID | None = None
    invite_code: str = field(default_factory=lambda: secrets.token_urlsafe(6).upper()[:8])
    max_members: int = 10
    is_public: bool = True
    created_at: datetime = field(default_factory=datetime.now)


@dataclass
class _FakeMember:
    club_id: UUID
    user_id: UUID
    role: str = "member"
    current_page: int = 0
    last_page_updated_at: datetime | None = None
    joined_at: datetime = field(default_factory=datetime.now)


@dataclass
class _FakePlan:
    club_id: UUID
    book_id: UUID
    start_date: date
    end_date: date
    weekly_pages: int
    created_by: UUID
    id: UUID = field(default_factory=uuid4)
    created_at: datetime = field(default_factory=datetime.now)


# ---------------------------------------------------------------------------
# Fake repository
# ---------------------------------------------------------------------------


class FakeClubRepository:
    def __init__(self) -> None:
        self._clubs: dict[UUID, _FakeClub] = {}
        self._members: dict[tuple[UUID, UUID], _FakeMember] = {}
        self._nicknames: dict[UUID, str] = {}
        self._pro: set[UUID] = set()
        self._page_counts: dict[UUID, int | None] = {}
        self._plans: list[_FakePlan] = []

    # --- test helpers ---

    def add_club(self, *, owner_id: UUID, book_id: UUID | None = None) -> _FakeClub:
        club = _FakeClub(owner_id=owner_id, book_id=book_id)
        self._clubs[club.id] = club
        self.add_member(club.id, owner_id, role="owner", nickname="Owner")
        return club

    def add_member(
        self, club_id: UUID, user_id: UUID, *, role: str = "member", nickname: str = "Member"
    ) -> _FakeMember:
        member = _FakeMember(club_id=club_id, user_id=user_id, role=role)
        self._members[(club_id, user_id)] = member
        self._nicknames[user_id] = nickname
        return member

    def set_pro(self, user_id: UUID) -> None:
        self._pro.add(user_id)

    def set_page_count(self, book_id: UUID, count: int | None) -> None:
        self._page_counts[book_id] = count

    # --- ClubRepository interface ---

    async def get_by_id(self, club_id: UUID) -> _FakeClub | None:
        return self._clubs.get(club_id)

    async def is_member(self, club_id: UUID, user_id: UUID) -> bool:
        return (club_id, user_id) in self._members

    async def get_user_is_pro(self, user_id: UUID) -> bool:
        return user_id in self._pro

    async def get_book_page_count(self, book_id: UUID) -> int | None:
        return self._page_counts.get(book_id)

    async def create_reading_plan(
        self,
        *,
        club_id: UUID,
        book_id: UUID,
        start_date: date,
        end_date: date,
        weekly_pages: int,
        created_by: UUID,
    ) -> _FakePlan:
        plan = _FakePlan(
            club_id=club_id,
            book_id=book_id,
            start_date=start_date,
            end_date=end_date,
            weekly_pages=weekly_pages,
            created_by=created_by,
        )
        self._plans.append(plan)
        return plan

    async def get_active_reading_plan(self, club_id: UUID) -> _FakePlan | None:
        plans = [p for p in self._plans if p.club_id == club_id]
        return plans[-1] if plans else None

    async def update_member_progress(
        self, *, club_id: UUID, user_id: UUID, current_page: int
    ) -> _FakeMember | None:
        member = self._members.get((club_id, user_id))
        if member is None:
            return None
        member.current_page = current_page
        member.last_page_updated_at = datetime.now()
        return member

    async def get_members_with_progress(self, club_id: UUID) -> list[tuple[_FakeMember, str]]:
        return [
            (m, self._nicknames.get(m.user_id, ""))
            for (cid, _), m in self._members.items()
            if cid == club_id
        ]

    async def get_member_ids(self, club_id: UUID) -> list[UUID]:
        return [uid for (cid, uid) in self._members if cid == club_id]


# ---------------------------------------------------------------------------
# Factory
# ---------------------------------------------------------------------------


def _svc() -> tuple[ClubService, FakeClubRepository]:
    repo = FakeClubRepository()
    return ClubService(repo=repo), repo  # type: ignore[arg-type]


# ---------------------------------------------------------------------------
# create_reading_plan
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_create_reading_plan_success_computes_weekly_pages() -> None:
    """A Pro owner creates a plan; weekly_pages = ceil(pages / weeks)."""
    svc, repo = _svc()
    owner = uuid4()
    book_id = uuid4()
    repo.set_pro(owner)
    repo.set_page_count(book_id, 300)
    club = repo.add_club(owner_id=owner, book_id=book_id)

    start = date(2026, 6, 1)
    end = date(2026, 6, 28)  # 27 days span -> 4 weeks
    plan = await svc.create_reading_plan(
        club_id=club.id,
        created_by=owner,
        book_id=book_id,
        start_date=start,
        end_date=end,
    )

    # 27 days -> ceil((27+1)/7) = 4 weeks; ceil(300/4) = 75 pages/week.
    assert plan.weekly_pages == 75
    assert plan.book_id == book_id


@pytest.mark.asyncio
async def test_create_reading_plan_page_count_fallback() -> None:
    """When the book has no page count, the 200-page default is used."""
    svc, repo = _svc()
    owner = uuid4()
    book_id = uuid4()
    repo.set_pro(owner)
    repo.set_page_count(book_id, None)
    club = repo.add_club(owner_id=owner, book_id=book_id)

    plan = await svc.create_reading_plan(
        club_id=club.id,
        created_by=owner,
        book_id=book_id,
        start_date=date(2026, 6, 1),
        end_date=date(2026, 6, 14),  # 13 days -> 2 weeks
    )

    # ceil((13+1)/7) = 2 weeks; ceil(200/2) = 100.
    assert plan.weekly_pages == 100


@pytest.mark.asyncio
async def test_create_reading_plan_span_drives_weeks() -> None:
    """A longer span yields more weeks and fewer pages per week."""
    svc, repo = _svc()
    owner = uuid4()
    book_id = uuid4()
    repo.set_pro(owner)
    repo.set_page_count(book_id, 350)
    club = repo.add_club(owner_id=owner, book_id=book_id)

    plan = await svc.create_reading_plan(
        club_id=club.id,
        created_by=owner,
        book_id=book_id,
        start_date=date(2026, 6, 1),
        end_date=date(2026, 7, 13),  # 42 days -> ceil(43/7) = 7 weeks
    )

    # ceil(350/7) = 50 pages/week.
    assert plan.weekly_pages == 50


@pytest.mark.asyncio
async def test_create_reading_plan_non_owner_rejected() -> None:
    """A non-owner member cannot create a reading plan."""
    svc, repo = _svc()
    owner = uuid4()
    book_id = uuid4()
    repo.set_pro(owner)
    club = repo.add_club(owner_id=owner, book_id=book_id)
    member = uuid4()
    repo.add_member(club.id, member)
    repo.set_pro(member)

    with pytest.raises(PermissionDeniedError):
        await svc.create_reading_plan(
            club_id=club.id,
            created_by=member,
            book_id=book_id,
            start_date=date(2026, 6, 1),
            end_date=date(2026, 6, 28),
        )


@pytest.mark.asyncio
async def test_create_reading_plan_non_pro_rejected() -> None:
    """A non-Pro owner gets PRO_REQUIRED."""
    svc, repo = _svc()
    owner = uuid4()
    book_id = uuid4()
    club = repo.add_club(owner_id=owner, book_id=book_id)  # owner not Pro

    with pytest.raises(ConflictError) as exc:
        await svc.create_reading_plan(
            club_id=club.id,
            created_by=owner,
            book_id=book_id,
            start_date=date(2026, 6, 1),
            end_date=date(2026, 6, 28),
        )
    assert exc.value.code == "PRO_REQUIRED"


# ---------------------------------------------------------------------------
# update_member_progress
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_update_member_progress_success() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)

    member = await svc.update_member_progress(club_id=club.id, user_id=owner, current_page=42)

    assert member.current_page == 42
    assert member.last_page_updated_at is not None


@pytest.mark.asyncio
async def test_update_member_progress_non_member_rejected() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    stranger = uuid4()

    with pytest.raises(PermissionDeniedError):
        await svc.update_member_progress(club_id=club.id, user_id=stranger, current_page=10)


# ---------------------------------------------------------------------------
# get_club_progress
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_get_club_progress_no_plan() -> None:
    """Without a plan, progress is reported but plan is None and pct is 0."""
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)

    resp = await svc.get_club_progress(club_id=club.id, requester_id=owner)

    assert resp.plan is None
    assert len(resp.members) == 1
    assert resp.members[0].progress_pct == 0.0


@pytest.mark.asyncio
async def test_get_club_progress_with_plan() -> None:
    """With a plan, member progress_pct reflects pages read vs expected pace."""
    svc, repo = _svc()
    owner = uuid4()
    book_id = uuid4()
    repo.set_pro(owner)
    repo.set_page_count(book_id, 280)
    club = repo.add_club(owner_id=owner, book_id=book_id)

    # Plan started two weeks ago so some pace has elapsed.
    start = date.today() - timedelta(days=10)
    end = date.today() + timedelta(days=18)
    await svc.create_reading_plan(
        club_id=club.id,
        created_by=owner,
        book_id=book_id,
        start_date=start,
        end_date=end,
    )
    await svc.update_member_progress(club_id=club.id, user_id=owner, current_page=20)

    resp = await svc.get_club_progress(club_id=club.id, requester_id=owner)

    assert resp.plan is not None
    assert len(resp.members) == 1
    assert 0.0 < resp.members[0].progress_pct <= 100.0


@pytest.mark.asyncio
async def test_get_club_progress_pct_clamped_at_100() -> None:
    """A member far ahead of pace is clamped to 100%."""
    svc, repo = _svc()
    owner = uuid4()
    book_id = uuid4()
    repo.set_pro(owner)
    repo.set_page_count(book_id, 300)
    club = repo.add_club(owner_id=owner, book_id=book_id)

    await svc.create_reading_plan(
        club_id=club.id,
        created_by=owner,
        book_id=book_id,
        start_date=date.today(),
        end_date=date.today() + timedelta(days=27),
    )
    await svc.update_member_progress(club_id=club.id, user_id=owner, current_page=99999)

    resp = await svc.get_club_progress(club_id=club.id, requester_id=owner)

    assert resp.members[0].progress_pct == 100.0


@pytest.mark.asyncio
async def test_get_club_progress_non_member_rejected() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    stranger = uuid4()

    with pytest.raises(PermissionDeniedError):
        await svc.get_club_progress(club_id=club.id, requester_id=stranger)

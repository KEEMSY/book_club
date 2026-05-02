"""Unit tests for ClubService.

Uses a FakeClubRepository (in-memory) — no DB required.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import UTC, datetime
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError, NotFoundError, PermissionDeniedError
from app.domains.club.schemas import CreateClubRequest, CreateEventRequest
from app.domains.club.service import ClubService


# ---------------------------------------------------------------------------
# Plain-dataclass stand-ins that duck-type ReadingClub / ClubEvent
# (SQLAlchemy ORM objects cannot be instantiated without a session)
# ---------------------------------------------------------------------------


@dataclass
class _FakeClub:
    id: UUID = field(default_factory=uuid4)
    name: str = "Test Club"
    description: str | None = None
    owner_id: UUID = field(default_factory=uuid4)
    book_id: UUID | None = None
    invite_code: str = "ABCD1234"
    max_members: int = 10
    created_at: datetime = field(default_factory=lambda: datetime.now(tz=UTC))


@dataclass
class _FakeEvent:
    id: UUID = field(default_factory=uuid4)
    club_id: UUID = field(default_factory=uuid4)
    title: str = "Test Event"
    description: str | None = None
    event_type: str = "online"
    location: str | None = None
    scheduled_at: datetime = field(default_factory=lambda: datetime.now(tz=UTC))
    created_by: UUID = field(default_factory=uuid4)
    created_at: datetime = field(default_factory=lambda: datetime.now(tz=UTC))


# ---------------------------------------------------------------------------
# Fake repository
# ---------------------------------------------------------------------------


class FakeClubRepository:
    def __init__(self) -> None:
        self._clubs: dict[UUID, _FakeClub] = {}
        self._by_code: dict[str, _FakeClub] = {}
        self._members: dict[UUID, set[UUID]] = {}  # club_id → {user_id}
        self._events: dict[UUID, _FakeEvent] = {}  # event_id → event

    async def create(
        self,
        *,
        owner_id: UUID,
        name: str,
        description: str | None,
        book_id: UUID | None,
        max_members: int,
    ) -> _FakeClub:
        c = _FakeClub(owner_id=owner_id, name=name, max_members=max_members)
        self._clubs[c.id] = c
        self._by_code[c.invite_code] = c
        self._members[c.id] = {owner_id}
        return c

    async def get_by_id(self, club_id: UUID) -> _FakeClub | None:
        return self._clubs.get(club_id)

    async def get_by_invite_code(self, code: str) -> _FakeClub | None:
        return self._by_code.get(code)

    async def list_by_user(self, user_id: UUID) -> list[_FakeClub]:
        return [c for c in self._clubs.values() if user_id in self._members.get(c.id, set())]

    async def member_count(self, club_id: UUID) -> int:
        return len(self._members.get(club_id, set()))

    async def is_member(self, club_id: UUID, user_id: UUID) -> bool:
        return user_id in self._members.get(club_id, set())

    async def join(self, club_id: UUID, user_id: UUID) -> None:
        self._members.setdefault(club_id, set()).add(user_id)

    async def leave(self, club_id: UUID, user_id: UUID) -> None:
        self._members.get(club_id, set()).discard(user_id)

    async def create_event(
        self,
        *,
        club_id: UUID,
        created_by: UUID,
        title: str,
        description: str | None,
        event_type: str,
        location: str | None,
        scheduled_at: datetime,
    ) -> _FakeEvent:
        ev = _FakeEvent(club_id=club_id, title=title, created_by=created_by)
        self._events[ev.id] = ev
        return ev

    async def get_event(self, event_id: UUID) -> _FakeEvent | None:
        return self._events.get(event_id)

    async def list_events(self, club_id: UUID) -> list[_FakeEvent]:
        return [e for e in self._events.values() if e.club_id == club_id]

    async def upsert_rsvp(self, *, event_id: UUID, user_id: UUID, status: str) -> None:
        pass


def _svc() -> tuple[ClubService, FakeClubRepository]:
    repo = FakeClubRepository()
    return ClubService(repo=repo), repo  # type: ignore[arg-type]


def _create_req(name: str = "My Club", max_members: int = 10) -> CreateClubRequest:
    return CreateClubRequest(name=name, description=None, book_id=None, max_members=max_members)


def _event_req() -> CreateEventRequest:
    return CreateEventRequest(
        title="Weekly Meeting",
        description=None,
        event_type="online",
        location=None,
        scheduled_at=datetime.now(tz=UTC),
    )


# ---------------------------------------------------------------------------
# create_club
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_create_club_returns_club_with_owner() -> None:
    svc, _ = _svc()
    owner = uuid4()
    club = await svc.create_club(user_id=owner, req=_create_req())
    assert club.owner_id == owner
    assert club.name == "My Club"


# ---------------------------------------------------------------------------
# join_by_code
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_join_by_code_happy_path() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = await svc.create_club(user_id=owner, req=_create_req())

    new_user = uuid4()
    joined = await svc.join_by_code(user_id=new_user, invite_code=club.invite_code)
    assert joined.id == club.id
    assert await repo.is_member(club.id, new_user)


@pytest.mark.asyncio
async def test_join_by_code_invalid_code_raises_not_found() -> None:
    svc, _ = _svc()
    with pytest.raises(NotFoundError):
        await svc.join_by_code(user_id=uuid4(), invite_code="BADCODE")


@pytest.mark.asyncio
async def test_join_by_code_full_club_raises_conflict() -> None:
    svc, repo = _svc()
    owner = uuid4()
    # max_members=2: owner fills slot 1, one more member fills slot 2
    club = await svc.create_club(user_id=owner, req=_create_req(max_members=2))
    second = uuid4()
    await repo.join(club.id, second)

    with pytest.raises(ConflictError):
        await svc.join_by_code(user_id=uuid4(), invite_code=club.invite_code)


@pytest.mark.asyncio
async def test_join_by_code_idempotent_for_existing_member() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = await svc.create_club(user_id=owner, req=_create_req())
    # owner is already a member; joining again should not raise
    await svc.join_by_code(user_id=owner, invite_code=club.invite_code)
    assert await repo.member_count(club.id) == 1


# ---------------------------------------------------------------------------
# leave_club
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_leave_club_happy_path() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = await svc.create_club(user_id=owner, req=_create_req())
    member = uuid4()
    await repo.join(club.id, member)

    await svc.leave_club(user_id=member, club_id=club.id)
    assert not await repo.is_member(club.id, member)


@pytest.mark.asyncio
async def test_owner_cannot_leave_raises_conflict() -> None:
    svc, _ = _svc()
    owner = uuid4()
    club = await svc.create_club(user_id=owner, req=_create_req())

    with pytest.raises(ConflictError):
        await svc.leave_club(user_id=owner, club_id=club.id)


@pytest.mark.asyncio
async def test_leave_nonexistent_club_raises_not_found() -> None:
    svc, _ = _svc()
    with pytest.raises(NotFoundError):
        await svc.leave_club(user_id=uuid4(), club_id=uuid4())


# ---------------------------------------------------------------------------
# events
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_create_event_non_member_raises_permission_denied() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = await svc.create_club(user_id=owner, req=_create_req())
    outsider = uuid4()

    with pytest.raises(PermissionDeniedError):
        await svc.create_event(user_id=outsider, club_id=club.id, req=_event_req())


@pytest.mark.asyncio
async def test_create_event_member_succeeds() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = await svc.create_club(user_id=owner, req=_create_req())

    event = await svc.create_event(user_id=owner, club_id=club.id, req=_event_req())
    assert event.club_id == club.id
    assert event.title == "Weekly Meeting"


@pytest.mark.asyncio
async def test_list_events_non_member_raises_permission_denied() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = await svc.create_club(user_id=owner, req=_create_req())
    outsider = uuid4()

    with pytest.raises(PermissionDeniedError):
        await svc.list_events(user_id=outsider, club_id=club.id)


# ---------------------------------------------------------------------------
# rsvp
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_rsvp_nonexistent_event_raises_not_found() -> None:
    svc, _ = _svc()
    with pytest.raises(NotFoundError):
        await svc.rsvp(user_id=uuid4(), event_id=uuid4(), status="going")


@pytest.mark.asyncio
async def test_rsvp_non_member_raises_permission_denied() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = await svc.create_club(user_id=owner, req=_create_req())
    event = await svc.create_event(user_id=owner, club_id=club.id, req=_event_req())
    outsider = uuid4()

    with pytest.raises(PermissionDeniedError):
        await svc.rsvp(user_id=outsider, event_id=event.id, status="going")


@pytest.mark.asyncio
async def test_rsvp_member_succeeds() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = await svc.create_club(user_id=owner, req=_create_req())
    event = await svc.create_event(user_id=owner, club_id=club.id, req=_event_req())

    # Should not raise
    await svc.rsvp(user_id=owner, event_id=event.id, status="going")

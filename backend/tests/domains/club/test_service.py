"""Unit tests for ClubService.

Uses a FakeClubRepository (in-memory) — no DB required.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import UTC, datetime
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError, NotFoundError, PermissionDeniedError
from app.domains.club.schemas import (
    AttendeeCount,
    ClubEventCreate,
    ClubEventUpdate,
    CreateClubRequest,
)
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
    location: str | None = None
    event_at: datetime = field(default_factory=lambda: datetime.now(tz=UTC))
    max_attendees: int | None = None
    created_by: UUID = field(default_factory=uuid4)
    created_at: datetime = field(default_factory=lambda: datetime.now(tz=UTC))


# ---------------------------------------------------------------------------
# Fake repository
# ---------------------------------------------------------------------------


class FakeClubRepository:
    def __init__(self) -> None:
        self._clubs: dict[UUID, _FakeClub] = {}
        self._by_code: dict[str, _FakeClub] = {}
        self._members: dict[UUID, dict[UUID, str]] = {}  # club_id → {user_id: role}
        self._events: dict[UUID, _FakeEvent] = {}
        self._rsvps: dict[tuple[UUID, UUID], str] = {}  # (event_id, user_id) → status

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
        self._members[c.id] = {owner_id: "owner"}
        return c

    async def get_by_id(self, club_id: UUID) -> _FakeClub | None:
        return self._clubs.get(club_id)

    async def get_by_invite_code(self, code: str) -> _FakeClub | None:
        return self._by_code.get(code)

    async def list_by_user(self, user_id: UUID) -> list[_FakeClub]:
        return [c for c in self._clubs.values() if user_id in self._members.get(c.id, {})]

    async def member_count(self, club_id: UUID) -> int:
        return len(self._members.get(club_id, {}))

    async def is_member(self, club_id: UUID, user_id: UUID) -> bool:
        return user_id in self._members.get(club_id, {})

    async def get_member_role(self, club_id: UUID, user_id: UUID) -> str | None:
        return self._members.get(club_id, {}).get(user_id)

    async def join(self, club_id: UUID, user_id: UUID) -> None:
        self._members.setdefault(club_id, {})[user_id] = "member"

    async def leave(self, club_id: UUID, user_id: UUID) -> None:
        self._members.get(club_id, {}).pop(user_id, None)

    async def create_event(
        self,
        *,
        club_id: UUID,
        created_by: UUID,
        title: str,
        description: str | None,
        event_at: datetime,
        location: str | None,
        max_attendees: int | None,
    ) -> _FakeEvent:
        ev = _FakeEvent(
            club_id=club_id,
            title=title,
            created_by=created_by,
            description=description,
            event_at=event_at,
            location=location,
            max_attendees=max_attendees,
        )
        self._events[ev.id] = ev
        return ev

    async def get_events(
        self, club_id: UUID, *, upcoming_only: bool = True
    ) -> list[_FakeEvent]:
        return [e for e in self._events.values() if e.club_id == club_id]

    async def get_event(self, event_id: UUID) -> _FakeEvent | None:
        return self._events.get(event_id)

    async def update_event(
        self,
        event_id: UUID,
        *,
        title: str | None = None,
        description: str | None = None,
        event_at: datetime | None = None,
        location: str | None = None,
        max_attendees: int | None = None,
    ) -> _FakeEvent | None:
        ev = self._events.get(event_id)
        if ev is None:
            return None
        if title is not None:
            ev.title = title
        if description is not None:
            ev.description = description
        if event_at is not None:
            ev.event_at = event_at
        if location is not None:
            ev.location = location
        if max_attendees is not None:
            ev.max_attendees = max_attendees
        return ev

    async def delete_event(self, event_id: UUID) -> None:
        self._events.pop(event_id, None)

    async def upsert_rsvp(self, *, event_id: UUID, user_id: UUID, status: str) -> None:
        self._rsvps[(event_id, user_id)] = status

    async def get_attendees(self, event_id: UUID) -> list:  # type: ignore[type-arg]
        return []

    async def get_attendee_counts(self, event_id: UUID) -> AttendeeCount:
        return AttendeeCount(going=0, maybe=0, not_going=0)

    async def get_my_rsvp_status(self, event_id: UUID, user_id: UUID) -> str | None:
        return self._rsvps.get((event_id, user_id))

    # Kept for any code still calling old names.
    async def rsvp_counts(self, event_id: UUID) -> dict[str, int]:
        return {"going": 0, "maybe": 0, "not_going": 0}

    async def my_rsvp(self, event_id: UUID, user_id: UUID) -> str | None:
        return self._rsvps.get((event_id, user_id))


def _svc() -> tuple[ClubService, FakeClubRepository]:
    repo = FakeClubRepository()
    return ClubService(repo=repo), repo  # type: ignore[arg-type]


def _create_req(name: str = "My Club", max_members: int = 10) -> CreateClubRequest:
    return CreateClubRequest(name=name, description=None, book_id=None, max_members=max_members)


def _event_data() -> ClubEventCreate:
    return ClubEventCreate(
        title="Weekly Meeting",
        description=None,
        event_at=datetime.now(tz=UTC),
        location=None,
        max_attendees=None,
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
async def test_create_event_non_owner_raises_permission_denied() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = await svc.create_club(user_id=owner, req=_create_req())
    # regular member (not owner) should be denied
    member = uuid4()
    await repo.join(club.id, member)

    with pytest.raises(PermissionDeniedError):
        await svc.create_event(user_id=member, club_id=club.id, data=_event_data())


@pytest.mark.asyncio
async def test_create_event_outsider_raises_permission_denied() -> None:
    svc, _ = _svc()
    owner = uuid4()
    club = await svc.create_club(user_id=owner, req=_create_req())
    outsider = uuid4()

    with pytest.raises(PermissionDeniedError):
        await svc.create_event(user_id=outsider, club_id=club.id, data=_event_data())


@pytest.mark.asyncio
async def test_create_event_owner_succeeds() -> None:
    svc, _ = _svc()
    owner = uuid4()
    club = await svc.create_club(user_id=owner, req=_create_req())

    result = await svc.create_event(user_id=owner, club_id=club.id, data=_event_data())
    assert result.club_id == club.id
    assert result.title == "Weekly Meeting"
    assert result.attendee_counts.going == 0


@pytest.mark.asyncio
async def test_list_events_non_member_raises_permission_denied() -> None:
    svc, _ = _svc()
    owner = uuid4()
    club = await svc.create_club(user_id=owner, req=_create_req())
    outsider = uuid4()

    with pytest.raises(PermissionDeniedError):
        await svc.list_events(club_id=club.id, caller_user_id=outsider)


@pytest.mark.asyncio
async def test_list_events_member_succeeds() -> None:
    svc, _ = _svc()
    owner = uuid4()
    club = await svc.create_club(user_id=owner, req=_create_req())
    await svc.create_event(user_id=owner, club_id=club.id, data=_event_data())

    events = await svc.list_events(club_id=club.id, caller_user_id=owner)
    assert len(events) == 1
    assert events[0].title == "Weekly Meeting"


@pytest.mark.asyncio
async def test_update_event_owner_succeeds() -> None:
    svc, _ = _svc()
    owner = uuid4()
    club = await svc.create_club(user_id=owner, req=_create_req())
    created = await svc.create_event(user_id=owner, club_id=club.id, data=_event_data())

    patch = ClubEventUpdate(title="Renamed Meeting")
    updated = await svc.update_event(event_id=created.id, user_id=owner, data=patch)
    assert updated.title == "Renamed Meeting"


@pytest.mark.asyncio
async def test_update_event_non_owner_raises_permission_denied() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = await svc.create_club(user_id=owner, req=_create_req())
    created = await svc.create_event(user_id=owner, club_id=club.id, data=_event_data())

    member = uuid4()
    await repo.join(club.id, member)

    with pytest.raises(PermissionDeniedError):
        await svc.update_event(
            event_id=created.id, user_id=member, data=ClubEventUpdate(title="Hack")
        )


@pytest.mark.asyncio
async def test_delete_event_owner_succeeds() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = await svc.create_club(user_id=owner, req=_create_req())
    created = await svc.create_event(user_id=owner, club_id=club.id, data=_event_data())

    await svc.delete_event(event_id=created.id, user_id=owner)
    assert await repo.get_event(created.id) is None


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
    svc, _ = _svc()
    owner = uuid4()
    club = await svc.create_club(user_id=owner, req=_create_req())
    created = await svc.create_event(user_id=owner, club_id=club.id, data=_event_data())
    outsider = uuid4()

    with pytest.raises(PermissionDeniedError):
        await svc.rsvp(user_id=outsider, event_id=created.id, status="going")


@pytest.mark.asyncio
async def test_rsvp_member_succeeds() -> None:
    svc, _ = _svc()
    owner = uuid4()
    club = await svc.create_club(user_id=owner, req=_create_req())
    created = await svc.create_event(user_id=owner, club_id=club.id, data=_event_data())

    # Should not raise
    await svc.rsvp(user_id=owner, event_id=created.id, status="going")

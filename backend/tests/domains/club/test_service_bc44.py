"""Unit tests for ClubService — BC-44 (club session lifecycle).

Covers:
- create_session: host-only, presenter must be a club member
- set_session_presenter: host-only, assign/clear, presenter must be a member
- transition_session_status: host-only, valid forward transitions,
  rejects skip/backward/no-op transitions
- list_sessions / get_session: member access, public-club open access,
  private-club non-member rejection, book_id filtering

Uses an in-memory fake repository — no DB required.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError, NotFoundError, PermissionDeniedError
from app.domains.club.models import ClubRole, SessionStatus
from app.domains.club.schemas import ClubSessionCreate
from app.domains.club.service import ClubService

# ---------------------------------------------------------------------------
# Fake domain objects
# ---------------------------------------------------------------------------


@dataclass
class _FakeClub:
    id: UUID = field(default_factory=uuid4)
    owner_id: UUID = field(default_factory=uuid4)
    is_public: bool = False
    created_at: datetime = field(default_factory=datetime.now)


@dataclass
class _FakeSession:
    id: UUID
    club_id: UUID
    book_id: UUID
    title: str
    scope: str | None
    presenter_id: UUID | None
    scheduled_at: datetime | None
    status: str
    created_by: UUID
    created_at: datetime = field(default_factory=datetime.now)


# ---------------------------------------------------------------------------
# Fake repository
# ---------------------------------------------------------------------------


class FakeClubRepository:
    def __init__(self) -> None:
        self._clubs: dict[UUID, _FakeClub] = {}
        self._members: dict[tuple[UUID, UUID], str] = {}
        self._sessions: dict[UUID, _FakeSession] = {}

    # --- test helpers ---

    def add_club(self, *, owner_id: UUID | None = None, is_public: bool = False) -> _FakeClub:
        owner_id = owner_id if owner_id is not None else uuid4()
        club = _FakeClub(owner_id=owner_id, is_public=is_public)
        self._clubs[club.id] = club
        self._members[(club.id, owner_id)] = ClubRole.OWNER
        return club

    def add_member(self, club_id: UUID, user_id: UUID, *, role: str = ClubRole.MEMBER) -> None:
        self._members[(club_id, user_id)] = role

    # --- ClubRepository interface ---

    async def get_by_id(self, club_id: UUID) -> _FakeClub | None:
        return self._clubs.get(club_id)

    async def is_member(self, club_id: UUID, user_id: UUID) -> bool:
        return (club_id, user_id) in self._members

    async def get_member_role(self, club_id: UUID, user_id: UUID) -> str | None:
        return self._members.get((club_id, user_id))

    async def create_session(
        self,
        *,
        club_id: UUID,
        book_id: UUID,
        title: str,
        scope: str | None,
        presenter_id: UUID | None,
        scheduled_at: datetime | None,
        created_by: UUID,
    ) -> _FakeSession:
        session_row = _FakeSession(
            id=uuid4(),
            club_id=club_id,
            book_id=book_id,
            title=title,
            scope=scope,
            presenter_id=presenter_id,
            scheduled_at=scheduled_at,
            status=SessionStatus.DRAFT,
            created_by=created_by,
        )
        self._sessions[session_row.id] = session_row
        return session_row

    async def get_session(self, session_id: UUID) -> _FakeSession | None:
        return self._sessions.get(session_id)

    async def list_sessions(
        self, club_id: UUID, *, book_id: UUID | None = None
    ) -> list[_FakeSession]:
        rows = [s for s in self._sessions.values() if s.club_id == club_id]
        if book_id is not None:
            rows = [s for s in rows if s.book_id == book_id]
        rows.sort(key=lambda s: (str(s.book_id), s.created_at), reverse=False)
        return rows

    async def update_session_status(self, session_id: UUID, status: str) -> _FakeSession | None:
        session_row = self._sessions.get(session_id)
        if session_row is None:
            return None
        session_row.status = status
        return session_row

    async def update_session_presenter(
        self, session_id: UUID, presenter_id: UUID | None
    ) -> _FakeSession | None:
        session_row = self._sessions.get(session_id)
        if session_row is None:
            return None
        session_row.presenter_id = presenter_id
        return session_row


# ---------------------------------------------------------------------------
# Factory
# ---------------------------------------------------------------------------


def _svc() -> tuple[ClubService, FakeClubRepository]:
    repo = FakeClubRepository()
    return ClubService(repo=repo), repo  # type: ignore[arg-type]


def _create_req(book_id: UUID, **overrides: object) -> ClubSessionCreate:
    defaults: dict[str, object] = {"book_id": book_id, "title": "1장~3장"}
    defaults.update(overrides)
    return ClubSessionCreate(**defaults)  # type: ignore[arg-type]


# ---------------------------------------------------------------------------
# create_session
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_create_session_success_by_host() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    book_id = uuid4()

    result = await svc.create_session(club_id=club.id, user_id=owner, req=_create_req(book_id))

    assert result.club_id == club.id
    assert result.book_id == book_id
    assert result.status == SessionStatus.DRAFT
    assert result.created_by == owner


@pytest.mark.asyncio
async def test_create_session_rejects_non_host() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    member = uuid4()
    repo.add_member(club.id, member)

    with pytest.raises(PermissionDeniedError):
        await svc.create_session(club_id=club.id, user_id=member, req=_create_req(uuid4()))


@pytest.mark.asyncio
async def test_create_session_rejects_non_club_member() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    stranger = uuid4()

    with pytest.raises(PermissionDeniedError):
        await svc.create_session(club_id=club.id, user_id=stranger, req=_create_req(uuid4()))


@pytest.mark.asyncio
async def test_create_session_unknown_club_rejected() -> None:
    svc, _repo = _svc()

    with pytest.raises(NotFoundError):
        await svc.create_session(club_id=uuid4(), user_id=uuid4(), req=_create_req(uuid4()))


@pytest.mark.asyncio
async def test_create_session_rejects_non_member_presenter() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    outsider = uuid4()

    with pytest.raises(ConflictError) as exc:
        await svc.create_session(
            club_id=club.id,
            user_id=owner,
            req=_create_req(uuid4(), presenter_id=outsider),
        )
    assert exc.value.code == "PRESENTER_NOT_MEMBER"


@pytest.mark.asyncio
async def test_create_session_allows_member_presenter() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    presenter = uuid4()
    repo.add_member(club.id, presenter)

    result = await svc.create_session(
        club_id=club.id,
        user_id=owner,
        req=_create_req(uuid4(), presenter_id=presenter),
    )

    assert result.presenter_id == presenter


# ---------------------------------------------------------------------------
# set_session_presenter
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_set_presenter_success() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    presenter = uuid4()
    repo.add_member(club.id, presenter)
    created = await svc.create_session(club_id=club.id, user_id=owner, req=_create_req(uuid4()))

    updated = await svc.set_session_presenter(
        club_id=club.id, session_id=created.id, user_id=owner, presenter_id=presenter
    )

    assert updated.presenter_id == presenter


@pytest.mark.asyncio
async def test_set_presenter_can_clear() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    presenter = uuid4()
    repo.add_member(club.id, presenter)
    created = await svc.create_session(
        club_id=club.id, user_id=owner, req=_create_req(uuid4(), presenter_id=presenter)
    )

    updated = await svc.set_session_presenter(
        club_id=club.id, session_id=created.id, user_id=owner, presenter_id=None
    )

    assert updated.presenter_id is None


@pytest.mark.asyncio
async def test_set_presenter_rejects_non_host() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    member = uuid4()
    repo.add_member(club.id, member)
    created = await svc.create_session(club_id=club.id, user_id=owner, req=_create_req(uuid4()))

    with pytest.raises(PermissionDeniedError):
        await svc.set_session_presenter(
            club_id=club.id, session_id=created.id, user_id=member, presenter_id=member
        )


@pytest.mark.asyncio
async def test_set_presenter_rejects_non_member() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    created = await svc.create_session(club_id=club.id, user_id=owner, req=_create_req(uuid4()))
    outsider = uuid4()

    with pytest.raises(ConflictError) as exc:
        await svc.set_session_presenter(
            club_id=club.id, session_id=created.id, user_id=owner, presenter_id=outsider
        )
    assert exc.value.code == "PRESENTER_NOT_MEMBER"


@pytest.mark.asyncio
async def test_set_presenter_unknown_session_rejected() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)

    with pytest.raises(NotFoundError):
        await svc.set_session_presenter(
            club_id=club.id, session_id=uuid4(), user_id=owner, presenter_id=None
        )


# ---------------------------------------------------------------------------
# transition_session_status
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_transition_draft_to_open_success() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    created = await svc.create_session(club_id=club.id, user_id=owner, req=_create_req(uuid4()))

    updated = await svc.transition_session_status(
        club_id=club.id, session_id=created.id, user_id=owner, status=SessionStatus.OPEN
    )

    assert updated.status == SessionStatus.OPEN


@pytest.mark.asyncio
async def test_transition_open_to_closed_success() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    created = await svc.create_session(club_id=club.id, user_id=owner, req=_create_req(uuid4()))
    await svc.transition_session_status(
        club_id=club.id, session_id=created.id, user_id=owner, status=SessionStatus.OPEN
    )

    updated = await svc.transition_session_status(
        club_id=club.id, session_id=created.id, user_id=owner, status=SessionStatus.CLOSED
    )

    assert updated.status == SessionStatus.CLOSED


@pytest.mark.asyncio
async def test_transition_rejects_skip_draft_to_closed() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    created = await svc.create_session(club_id=club.id, user_id=owner, req=_create_req(uuid4()))

    with pytest.raises(ConflictError) as exc:
        await svc.transition_session_status(
            club_id=club.id, session_id=created.id, user_id=owner, status=SessionStatus.CLOSED
        )
    assert exc.value.code == "INVALID_STATUS_TRANSITION"


@pytest.mark.asyncio
async def test_transition_rejects_backward() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    created = await svc.create_session(club_id=club.id, user_id=owner, req=_create_req(uuid4()))
    await svc.transition_session_status(
        club_id=club.id, session_id=created.id, user_id=owner, status=SessionStatus.OPEN
    )

    with pytest.raises(ConflictError) as exc:
        await svc.transition_session_status(
            club_id=club.id, session_id=created.id, user_id=owner, status=SessionStatus.DRAFT
        )
    assert exc.value.code == "INVALID_STATUS_TRANSITION"


@pytest.mark.asyncio
async def test_transition_rejects_no_op() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    created = await svc.create_session(club_id=club.id, user_id=owner, req=_create_req(uuid4()))

    with pytest.raises(ConflictError) as exc:
        await svc.transition_session_status(
            club_id=club.id, session_id=created.id, user_id=owner, status=SessionStatus.DRAFT
        )
    assert exc.value.code == "INVALID_STATUS_TRANSITION"


@pytest.mark.asyncio
async def test_transition_rejects_non_host() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    member = uuid4()
    repo.add_member(club.id, member)
    created = await svc.create_session(club_id=club.id, user_id=owner, req=_create_req(uuid4()))

    with pytest.raises(PermissionDeniedError):
        await svc.transition_session_status(
            club_id=club.id, session_id=created.id, user_id=member, status=SessionStatus.OPEN
        )


# ---------------------------------------------------------------------------
# list_sessions / get_session
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_list_sessions_grouped_by_book() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    book_a, book_b = uuid4(), uuid4()
    await svc.create_session(club_id=club.id, user_id=owner, req=_create_req(book_a))
    await svc.create_session(club_id=club.id, user_id=owner, req=_create_req(book_b))
    await svc.create_session(club_id=club.id, user_id=owner, req=_create_req(book_a))

    items = await svc.list_sessions(club_id=club.id, caller_user_id=owner)

    book_ids = [item.book_id for item in items]
    # Rows for the same book are contiguous — ready to group without re-sorting.
    assert book_ids == sorted(book_ids, key=str)


@pytest.mark.asyncio
async def test_list_sessions_filter_by_book() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    book_a, book_b = uuid4(), uuid4()
    await svc.create_session(club_id=club.id, user_id=owner, req=_create_req(book_a))
    await svc.create_session(club_id=club.id, user_id=owner, req=_create_req(book_b))

    items = await svc.list_sessions(club_id=club.id, caller_user_id=owner, book_id=book_a)

    assert len(items) == 1
    assert items[0].book_id == book_a


@pytest.mark.asyncio
async def test_list_sessions_private_club_rejects_non_member() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner, is_public=False)
    stranger = uuid4()

    with pytest.raises(PermissionDeniedError):
        await svc.list_sessions(club_id=club.id, caller_user_id=stranger)


@pytest.mark.asyncio
async def test_list_sessions_public_club_allows_non_member() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner, is_public=True)
    await svc.create_session(club_id=club.id, user_id=owner, req=_create_req(uuid4()))
    stranger = uuid4()

    items = await svc.list_sessions(club_id=club.id, caller_user_id=stranger)

    assert len(items) == 1


@pytest.mark.asyncio
async def test_get_session_private_club_member_allowed() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner, is_public=False)
    created = await svc.create_session(club_id=club.id, user_id=owner, req=_create_req(uuid4()))

    result = await svc.get_session(club_id=club.id, session_id=created.id, caller_user_id=owner)

    assert result.id == created.id


@pytest.mark.asyncio
async def test_get_session_unknown_rejected() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)

    with pytest.raises(NotFoundError):
        await svc.get_session(club_id=club.id, session_id=uuid4(), caller_user_id=owner)

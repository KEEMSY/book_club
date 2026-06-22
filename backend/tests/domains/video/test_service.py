"""Unit tests for VideoSessionService — in-memory fakes, no DB (CLAUDE.md §5).

Covers the M68 video-call rules: the Pro-club-owner gate, single-live-session
reuse, host-only end, and the active-session lookup.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import UTC, datetime
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError, NotFoundError, PermissionDeniedError
from app.domains.video.service import VideoSessionService


@dataclass
class _FakeSession:
    id: UUID
    club_id: UUID
    host_id: UUID
    agora_channel: str
    max_participants: int
    started_at: datetime = field(default_factory=lambda: datetime.now(tz=UTC))
    ended_at: datetime | None = None


@dataclass
class FakeVideoRepository:
    owners: dict[UUID, UUID] = field(default_factory=dict)
    pro_users: set[UUID] = field(default_factory=set)
    sessions: dict[UUID, _FakeSession] = field(default_factory=dict)

    async def get_club_owner_id(self, club_id: UUID) -> UUID | None:
        return self.owners.get(club_id)

    async def get_user_is_pro(self, user_id: UUID) -> bool:
        return user_id in self.pro_users

    async def get_active_session(self, club_id: UUID) -> _FakeSession | None:
        for s in self.sessions.values():
            if s.club_id == club_id and s.ended_at is None:
                return s
        return None

    async def get_session(self, session_id: UUID) -> _FakeSession | None:
        return self.sessions.get(session_id)

    async def create_session(
        self, *, club_id: UUID, host_id: UUID, agora_channel: str, max_participants: int
    ) -> _FakeSession:
        s = _FakeSession(
            id=uuid4(),
            club_id=club_id,
            host_id=host_id,
            agora_channel=agora_channel,
            max_participants=max_participants,
        )
        self.sessions[s.id] = s
        return s

    async def end_session(self, session_id: UUID) -> _FakeSession | None:
        s = self.sessions.get(session_id)
        if s is None:
            return None
        if s.ended_at is None:
            s.ended_at = datetime.now(tz=UTC)
        return s


class _FakeTokenProvider:
    def issue_token(self, *, club_id: UUID, session_id: UUID, channel: str) -> str:
        return f"STUB_{club_id}_{session_id}"


def _svc(
    repo: FakeVideoRepository | None = None,
) -> tuple[VideoSessionService, FakeVideoRepository]:
    r = repo or FakeVideoRepository()
    return VideoSessionService(repo=r, token_provider=_FakeTokenProvider()), r  # type: ignore[arg-type]


def _pro_owned_club() -> tuple[FakeVideoRepository, UUID, UUID]:
    """A repo with one club owned by a Pro user. Returns (repo, club_id, owner)."""
    club_id, owner = uuid4(), uuid4()
    repo = FakeVideoRepository(owners={club_id: owner}, pro_users={owner})
    return repo, club_id, owner


# ---------------------------------------------------------------------------
# start_session — gate
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_start_session_by_pro_owner_creates_and_returns_token() -> None:
    repo, club_id, owner = _pro_owned_club()
    svc, _ = _svc(repo)

    res = await svc.start_session(club_id=club_id, host_id=owner)

    assert res.host_id == owner
    assert res.club_id == club_id
    assert res.ended_at is None
    assert res.agora_token == f"STUB_{club_id}_{res.id}"
    assert res.channel == res.agora_channel
    assert len(repo.sessions) == 1


@pytest.mark.asyncio
async def test_start_session_unknown_club_raises_not_found() -> None:
    svc, _ = _svc()
    with pytest.raises(NotFoundError) as exc:
        await svc.start_session(club_id=uuid4(), host_id=uuid4())
    assert exc.value.code == "CLUB_NOT_FOUND"


@pytest.mark.asyncio
async def test_start_session_non_owner_denied() -> None:
    repo, club_id, _ = _pro_owned_club()
    svc, _ = _svc(repo)
    with pytest.raises(PermissionDeniedError) as exc:
        await svc.start_session(club_id=club_id, host_id=uuid4())
    assert exc.value.code == "PERMISSION_DENIED"


@pytest.mark.asyncio
async def test_start_session_owner_without_pro_raises_pro_required() -> None:
    club_id, owner = uuid4(), uuid4()
    repo = FakeVideoRepository(owners={club_id: owner})  # owner not Pro
    svc, _ = _svc(repo)
    with pytest.raises(ConflictError) as exc:
        await svc.start_session(club_id=club_id, host_id=owner)
    assert exc.value.code == "PRO_REQUIRED"


@pytest.mark.asyncio
async def test_start_session_reuses_existing_active_session() -> None:
    repo, club_id, owner = _pro_owned_club()
    svc, _ = _svc(repo)

    first = await svc.start_session(club_id=club_id, host_id=owner)
    second = await svc.start_session(club_id=club_id, host_id=owner)

    assert first.id == second.id
    assert len(repo.sessions) == 1


# ---------------------------------------------------------------------------
# end_session
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_end_session_by_host_stamps_ended_at() -> None:
    repo, club_id, owner = _pro_owned_club()
    svc, _ = _svc(repo)
    started = await svc.start_session(club_id=club_id, host_id=owner)

    await svc.end_session(club_id=club_id, session_id=started.id, user_id=owner)

    assert repo.sessions[started.id].ended_at is not None


@pytest.mark.asyncio
async def test_end_session_unknown_raises_not_found() -> None:
    repo, club_id, owner = _pro_owned_club()
    svc, _ = _svc(repo)
    with pytest.raises(NotFoundError) as exc:
        await svc.end_session(club_id=club_id, session_id=uuid4(), user_id=owner)
    assert exc.value.code == "VIDEO_SESSION_NOT_FOUND"


@pytest.mark.asyncio
async def test_end_session_wrong_club_raises_not_found() -> None:
    repo, club_id, owner = _pro_owned_club()
    svc, _ = _svc(repo)
    started = await svc.start_session(club_id=club_id, host_id=owner)
    with pytest.raises(NotFoundError) as exc:
        await svc.end_session(club_id=uuid4(), session_id=started.id, user_id=owner)
    assert exc.value.code == "VIDEO_SESSION_NOT_FOUND"


@pytest.mark.asyncio
async def test_end_session_non_host_denied() -> None:
    repo, club_id, owner = _pro_owned_club()
    svc, _ = _svc(repo)
    started = await svc.start_session(club_id=club_id, host_id=owner)
    with pytest.raises(PermissionDeniedError) as exc:
        await svc.end_session(club_id=club_id, session_id=started.id, user_id=uuid4())
    assert exc.value.code == "PERMISSION_DENIED"


# ---------------------------------------------------------------------------
# get_active_session
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_get_active_session_returns_live_session() -> None:
    repo, club_id, owner = _pro_owned_club()
    svc, _ = _svc(repo)
    started = await svc.start_session(club_id=club_id, host_id=owner)

    active = await svc.get_active_session(club_id=club_id)

    assert active.id == started.id


@pytest.mark.asyncio
async def test_get_active_session_none_raises_not_found() -> None:
    repo, club_id, _ = _pro_owned_club()
    svc, _ = _svc(repo)
    with pytest.raises(NotFoundError) as exc:
        await svc.get_active_session(club_id=club_id)
    assert exc.value.code == "NO_ACTIVE_VIDEO_SESSION"


@pytest.mark.asyncio
async def test_get_active_session_excludes_ended() -> None:
    repo, club_id, owner = _pro_owned_club()
    svc, _ = _svc(repo)
    started = await svc.start_session(club_id=club_id, host_id=owner)
    await svc.end_session(club_id=club_id, session_id=started.id, user_id=owner)

    with pytest.raises(NotFoundError):
        await svc.get_active_session(club_id=club_id)

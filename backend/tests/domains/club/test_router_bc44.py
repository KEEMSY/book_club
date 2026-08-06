"""HTTP contract tests for the club session endpoints (BC-44).

Uses ``app.dependency_overrides`` to swap ``get_club_service`` with an
in-memory fake — no DB required. Focuses on the request/response contract
and domain-error -> HTTP-status mapping; permission/state-machine logic
itself is covered by tests/domains/club/test_service_bc44.py.
"""

from __future__ import annotations

from collections.abc import AsyncIterator
from datetime import datetime
from typing import Any
from uuid import UUID, uuid4

import pytest
import pytest_asyncio
from app.core.exceptions import ConflictError, NotFoundError, PermissionDeniedError
from app.core.security import create_access_token
from app.domains.club.providers import get_club_service
from app.domains.club.schemas import ClubSessionCreate, ClubSessionPublic
from app.main import create_app
from httpx import ASGITransport, AsyncClient


def _session_public(club_id: UUID, **overrides: Any) -> ClubSessionPublic:
    defaults: dict[str, Any] = {
        "id": uuid4(),
        "club_id": club_id,
        "book_id": uuid4(),
        "title": "1장~3장",
        "scope": None,
        "presenter_id": None,
        "scheduled_at": None,
        "status": "draft",
        "created_by": uuid4(),
        "created_at": datetime.now(),
    }
    defaults.update(overrides)
    return ClubSessionPublic(**defaults)


class FakeClubService:
    def __init__(self) -> None:
        self.calls: list[tuple[str, dict[str, Any]]] = []
        self.raise_error: Exception | None = None

    async def create_session(
        self, *, club_id: UUID, user_id: UUID, req: ClubSessionCreate
    ) -> ClubSessionPublic:
        self.calls.append(("create_session", {"club_id": club_id, "user_id": user_id}))
        if self.raise_error is not None:
            raise self.raise_error
        return _session_public(club_id, book_id=req.book_id, title=req.title, created_by=user_id)

    async def list_sessions(
        self, *, club_id: UUID, caller_user_id: UUID, book_id: UUID | None = None
    ) -> list[ClubSessionPublic]:
        self.calls.append(("list_sessions", {"club_id": club_id, "book_id": book_id}))
        if self.raise_error is not None:
            raise self.raise_error
        return [_session_public(club_id)]

    async def get_session(
        self, *, club_id: UUID, session_id: UUID, caller_user_id: UUID
    ) -> ClubSessionPublic:
        self.calls.append(("get_session", {"club_id": club_id, "session_id": session_id}))
        if self.raise_error is not None:
            raise self.raise_error
        return _session_public(club_id, id=session_id)

    async def set_session_presenter(
        self,
        *,
        club_id: UUID,
        session_id: UUID,
        user_id: UUID,
        presenter_id: UUID | None,
    ) -> ClubSessionPublic:
        self.calls.append(("set_presenter", {"session_id": session_id}))
        if self.raise_error is not None:
            raise self.raise_error
        return _session_public(club_id, id=session_id, presenter_id=presenter_id)

    async def transition_session_status(
        self, *, club_id: UUID, session_id: UUID, user_id: UUID, status: str
    ) -> ClubSessionPublic:
        self.calls.append(("transition_status", {"session_id": session_id, "status": status}))
        if self.raise_error is not None:
            raise self.raise_error
        return _session_public(club_id, id=session_id, status=status)


@pytest_asyncio.fixture
async def client_and_fake() -> AsyncIterator[tuple[AsyncClient, FakeClubService, UUID]]:
    app = create_app()
    fake = FakeClubService()
    app.dependency_overrides[get_club_service] = lambda: fake
    transport = ASGITransport(app=app)
    user_id = uuid4()
    async with AsyncClient(transport=transport, base_url="http://testserver") as client:
        yield client, fake, user_id
    app.dependency_overrides.clear()


def _auth(user_id: UUID) -> dict[str, str]:
    return {"Authorization": f"Bearer {create_access_token(str(user_id))}"}


# ---------- create ---------- #


@pytest.mark.asyncio
async def test_create_session_201_and_requires_auth(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    club_id = uuid4()
    book_id = uuid4()

    r = await client.post(
        f"/clubs/{club_id}/sessions", json={"book_id": str(book_id), "title": "1장"}
    )
    assert r.status_code == 401

    r = await client.post(
        f"/clubs/{club_id}/sessions",
        json={"book_id": str(book_id), "title": "1장"},
        headers=_auth(user_id),
    )
    assert r.status_code == 201
    body = r.json()
    assert UUID(body["book_id"]) == book_id
    assert body["status"] == "draft"
    assert fake.calls[0][0] == "create_session"


@pytest.mark.asyncio
async def test_create_session_403_non_host(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.raise_error = PermissionDeniedError("호스트만 가능합니다", code="PERMISSION_DENIED")

    r = await client.post(
        f"/clubs/{uuid4()}/sessions",
        json={"book_id": str(uuid4()), "title": "1장"},
        headers=_auth(user_id),
    )
    assert r.status_code == 403
    assert r.json()["error"]["code"] == "PERMISSION_DENIED"


@pytest.mark.asyncio
async def test_create_session_422_blank_title(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, _fake, user_id = client_and_fake

    r = await client.post(
        f"/clubs/{uuid4()}/sessions",
        json={"book_id": str(uuid4()), "title": ""},
        headers=_auth(user_id),
    )
    assert r.status_code == 422


# ---------- list / get ---------- #


@pytest.mark.asyncio
async def test_list_sessions_200(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, _fake, user_id = client_and_fake
    club_id = uuid4()

    r = await client.get(f"/clubs/{club_id}/sessions", headers=_auth(user_id))
    assert r.status_code == 200
    assert len(r.json()["items"]) == 1


@pytest.mark.asyncio
async def test_list_sessions_403_private_non_member(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.raise_error = PermissionDeniedError("클럽 멤버만 조회할 수 있습니다", code="NOT_MEMBER")

    r = await client.get(f"/clubs/{uuid4()}/sessions", headers=_auth(user_id))
    assert r.status_code == 403
    assert r.json()["error"]["code"] == "NOT_MEMBER"


@pytest.mark.asyncio
async def test_get_session_404(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.raise_error = NotFoundError("session not found", code="SESSION_NOT_FOUND")

    r = await client.get(f"/clubs/{uuid4()}/sessions/{uuid4()}", headers=_auth(user_id))
    assert r.status_code == 404
    assert r.json()["error"]["code"] == "SESSION_NOT_FOUND"


# ---------- presenter ---------- #


@pytest.mark.asyncio
async def test_set_presenter_200(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, _fake, user_id = client_and_fake
    club_id = uuid4()
    session_id = uuid4()
    presenter_id = uuid4()

    r = await client.patch(
        f"/clubs/{club_id}/sessions/{session_id}/presenter",
        json={"presenter_id": str(presenter_id)},
        headers=_auth(user_id),
    )
    assert r.status_code == 200
    assert UUID(r.json()["presenter_id"]) == presenter_id


@pytest.mark.asyncio
async def test_set_presenter_409_non_member_presenter(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.raise_error = ConflictError("발제자는 클럽 멤버여야 합니다", code="PRESENTER_NOT_MEMBER")

    r = await client.patch(
        f"/clubs/{uuid4()}/sessions/{uuid4()}/presenter",
        json={"presenter_id": str(uuid4())},
        headers=_auth(user_id),
    )
    assert r.status_code == 409
    assert r.json()["error"]["code"] == "PRESENTER_NOT_MEMBER"


# ---------- status transition ---------- #


@pytest.mark.asyncio
async def test_update_status_200(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, _fake, user_id = client_and_fake

    r = await client.patch(
        f"/clubs/{uuid4()}/sessions/{uuid4()}/status",
        json={"status": "open"},
        headers=_auth(user_id),
    )
    assert r.status_code == 200
    assert r.json()["status"] == "open"


@pytest.mark.asyncio
async def test_update_status_409_invalid_transition(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.raise_error = ConflictError(
        "draft에서 closed로 전이할 수 없습니다", code="INVALID_STATUS_TRANSITION"
    )

    r = await client.patch(
        f"/clubs/{uuid4()}/sessions/{uuid4()}/status",
        json={"status": "closed"},
        headers=_auth(user_id),
    )
    assert r.status_code == 409
    assert r.json()["error"]["code"] == "INVALID_STATUS_TRANSITION"


@pytest.mark.asyncio
async def test_update_status_422_invalid_value(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, _fake, user_id = client_and_fake

    r = await client.patch(
        f"/clubs/{uuid4()}/sessions/{uuid4()}/status",
        json={"status": "bogus"},
        headers=_auth(user_id),
    )
    assert r.status_code == 422

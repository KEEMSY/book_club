"""HTTP contract tests for the session-agenda/topic endpoints (BC-45).

Uses ``app.dependency_overrides`` to swap ``get_club_service`` with an
in-memory fake — no DB required. Focuses on the request/response contract
and domain-error -> HTTP-status mapping; permission/state-machine logic
itself is covered by tests/domains/club/test_service_bc45.py.
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
from app.domains.club.schemas import (
    AgendaTopicCreate,
    AgendaTopicPublic,
    AgendaTopicUpdate,
    SessionAgendaCreate,
    SessionAgendaPublic,
    SessionAgendaUpdate,
)
from app.main import create_app
from httpx import ASGITransport, AsyncClient


def _topic_public(agenda_id: UUID, **overrides: Any) -> AgendaTopicPublic:
    defaults: dict[str, Any] = {
        "id": uuid4(),
        "agenda_id": agenda_id,
        "position": 0,
        "prompt": "논제 1",
        "created_at": datetime.now(),
    }
    defaults.update(overrides)
    return AgendaTopicPublic(**defaults)


def _agenda_public(session_id: UUID, **overrides: Any) -> SessionAgendaPublic:
    defaults: dict[str, Any] = {
        "id": uuid4(),
        "session_id": session_id,
        "author_id": uuid4(),
        "body": "발제문 본문",
        "status": "draft",
        "published_at": None,
        "created_at": datetime.now(),
        "topics": [],
    }
    defaults.update(overrides)
    return SessionAgendaPublic(**defaults)


class FakeClubService:
    def __init__(self) -> None:
        self.calls: list[tuple[str, dict[str, Any]]] = []
        self.raise_error: Exception | None = None

    async def create_agenda(
        self, *, club_id: UUID, session_id: UUID, user_id: UUID, req: SessionAgendaCreate
    ) -> SessionAgendaPublic:
        self.calls.append(("create_agenda", {"session_id": session_id, "user_id": user_id}))
        if self.raise_error is not None:
            raise self.raise_error
        return _agenda_public(session_id, body=req.body, author_id=user_id)

    async def list_agendas(
        self, *, club_id: UUID, session_id: UUID, caller_user_id: UUID
    ) -> list[SessionAgendaPublic]:
        self.calls.append(("list_agendas", {"session_id": session_id}))
        if self.raise_error is not None:
            raise self.raise_error
        return [_agenda_public(session_id)]

    async def get_agenda(
        self, *, club_id: UUID, session_id: UUID, agenda_id: UUID, caller_user_id: UUID
    ) -> SessionAgendaPublic:
        self.calls.append(("get_agenda", {"agenda_id": agenda_id}))
        if self.raise_error is not None:
            raise self.raise_error
        return _agenda_public(session_id, id=agenda_id)

    async def update_agenda(
        self,
        *,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        user_id: UUID,
        req: SessionAgendaUpdate,
    ) -> SessionAgendaPublic:
        self.calls.append(("update_agenda", {"agenda_id": agenda_id}))
        if self.raise_error is not None:
            raise self.raise_error
        return _agenda_public(session_id, id=agenda_id, body=req.body)

    async def publish_agenda(
        self, *, club_id: UUID, session_id: UUID, agenda_id: UUID, user_id: UUID
    ) -> SessionAgendaPublic:
        self.calls.append(("publish_agenda", {"agenda_id": agenda_id}))
        if self.raise_error is not None:
            raise self.raise_error
        return _agenda_public(
            session_id, id=agenda_id, status="published", published_at=datetime.now()
        )

    async def add_topic(
        self,
        *,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        user_id: UUID,
        req: AgendaTopicCreate,
    ) -> AgendaTopicPublic:
        self.calls.append(("add_topic", {"agenda_id": agenda_id}))
        if self.raise_error is not None:
            raise self.raise_error
        return _topic_public(agenda_id, prompt=req.prompt)

    async def update_topic(
        self,
        *,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        topic_id: UUID,
        user_id: UUID,
        req: AgendaTopicUpdate,
    ) -> AgendaTopicPublic:
        self.calls.append(("update_topic", {"topic_id": topic_id}))
        if self.raise_error is not None:
            raise self.raise_error
        return _topic_public(agenda_id, id=topic_id, prompt=req.prompt)

    async def delete_topic(
        self,
        *,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        topic_id: UUID,
        user_id: UUID,
    ) -> None:
        self.calls.append(("delete_topic", {"topic_id": topic_id}))
        if self.raise_error is not None:
            raise self.raise_error

    async def reorder_topics(
        self,
        *,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        user_id: UUID,
        topic_ids: list[UUID],
    ) -> list[AgendaTopicPublic]:
        self.calls.append(("reorder_topics", {"agenda_id": agenda_id, "topic_ids": topic_ids}))
        if self.raise_error is not None:
            raise self.raise_error
        return [_topic_public(agenda_id, id=tid, position=i) for i, tid in enumerate(topic_ids)]


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


# ---------- create / list / get agenda ---------- #


@pytest.mark.asyncio
async def test_create_agenda_201_and_requires_auth(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    club_id, session_id = uuid4(), uuid4()

    r = await client.post(
        f"/clubs/{club_id}/sessions/{session_id}/agendas", json={"body": "발제문 본문"}
    )
    assert r.status_code == 401

    r = await client.post(
        f"/clubs/{club_id}/sessions/{session_id}/agendas",
        json={"body": "발제문 본문"},
        headers=_auth(user_id),
    )
    assert r.status_code == 201
    body = r.json()
    assert body["body"] == "발제문 본문"
    assert body["status"] == "draft"
    assert fake.calls[0][0] == "create_agenda"


@pytest.mark.asyncio
async def test_create_agenda_403_non_host_non_presenter(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.raise_error = PermissionDeniedError(
        "호스트 또는 발제자만 발제문을 작성할 수 있습니다", code="PERMISSION_DENIED"
    )

    r = await client.post(
        f"/clubs/{uuid4()}/sessions/{uuid4()}/agendas",
        json={"body": "발제문 본문"},
        headers=_auth(user_id),
    )
    assert r.status_code == 403
    assert r.json()["error"]["code"] == "PERMISSION_DENIED"


@pytest.mark.asyncio
async def test_create_agenda_422_blank_body(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, _fake, user_id = client_and_fake

    r = await client.post(
        f"/clubs/{uuid4()}/sessions/{uuid4()}/agendas",
        json={"body": ""},
        headers=_auth(user_id),
    )
    assert r.status_code == 422


@pytest.mark.asyncio
async def test_list_agendas_200(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, _fake, user_id = client_and_fake

    r = await client.get(f"/clubs/{uuid4()}/sessions/{uuid4()}/agendas", headers=_auth(user_id))
    assert r.status_code == 200
    assert len(r.json()["items"]) == 1


@pytest.mark.asyncio
async def test_list_agendas_403_private_non_member(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.raise_error = PermissionDeniedError("클럽 멤버만 조회할 수 있습니다", code="NOT_MEMBER")

    r = await client.get(f"/clubs/{uuid4()}/sessions/{uuid4()}/agendas", headers=_auth(user_id))
    assert r.status_code == 403
    assert r.json()["error"]["code"] == "NOT_MEMBER"


@pytest.mark.asyncio
async def test_get_agenda_404(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.raise_error = NotFoundError("agenda not found", code="AGENDA_NOT_FOUND")

    r = await client.get(
        f"/clubs/{uuid4()}/sessions/{uuid4()}/agendas/{uuid4()}", headers=_auth(user_id)
    )
    assert r.status_code == 404
    assert r.json()["error"]["code"] == "AGENDA_NOT_FOUND"


# ---------- update / publish agenda ---------- #


@pytest.mark.asyncio
async def test_update_agenda_200(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, _fake, user_id = client_and_fake

    r = await client.patch(
        f"/clubs/{uuid4()}/sessions/{uuid4()}/agendas/{uuid4()}",
        json={"body": "수정된 본문"},
        headers=_auth(user_id),
    )
    assert r.status_code == 200
    assert r.json()["body"] == "수정된 본문"


@pytest.mark.asyncio
async def test_publish_agenda_200(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, _fake, user_id = client_and_fake

    r = await client.post(
        f"/clubs/{uuid4()}/sessions/{uuid4()}/agendas/{uuid4()}/publish",
        headers=_auth(user_id),
    )
    assert r.status_code == 200
    body = r.json()
    assert body["status"] == "published"
    assert body["published_at"] is not None


@pytest.mark.asyncio
async def test_publish_agenda_409_already_published(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.raise_error = ConflictError("이미 게시된 발제문입니다", code="ALREADY_PUBLISHED")

    r = await client.post(
        f"/clubs/{uuid4()}/sessions/{uuid4()}/agendas/{uuid4()}/publish",
        headers=_auth(user_id),
    )
    assert r.status_code == 409
    assert r.json()["error"]["code"] == "ALREADY_PUBLISHED"


# ---------- topics ---------- #


@pytest.mark.asyncio
async def test_add_topic_201(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake

    r = await client.post(
        f"/clubs/{uuid4()}/sessions/{uuid4()}/agendas/{uuid4()}/topics",
        json={"prompt": "논제 1"},
        headers=_auth(user_id),
    )
    assert r.status_code == 201
    assert r.json()["prompt"] == "논제 1"
    assert fake.calls[0][0] == "add_topic"


@pytest.mark.asyncio
async def test_add_topic_403_non_author(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.raise_error = PermissionDeniedError(
        "발제문 작성자만 논제를 관리할 수 있습니다", code="PERMISSION_DENIED"
    )

    r = await client.post(
        f"/clubs/{uuid4()}/sessions/{uuid4()}/agendas/{uuid4()}/topics",
        json={"prompt": "논제 시도"},
        headers=_auth(user_id),
    )
    assert r.status_code == 403
    assert r.json()["error"]["code"] == "PERMISSION_DENIED"


@pytest.mark.asyncio
async def test_update_topic_200(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, _fake, user_id = client_and_fake
    topic_id = uuid4()

    r = await client.patch(
        f"/clubs/{uuid4()}/sessions/{uuid4()}/agendas/{uuid4()}/topics/{topic_id}",
        json={"prompt": "수정됨"},
        headers=_auth(user_id),
    )
    assert r.status_code == 200
    assert r.json()["prompt"] == "수정됨"
    assert UUID(r.json()["id"]) == topic_id


@pytest.mark.asyncio
async def test_delete_topic_204(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake

    r = await client.delete(
        f"/clubs/{uuid4()}/sessions/{uuid4()}/agendas/{uuid4()}/topics/{uuid4()}",
        headers=_auth(user_id),
    )
    assert r.status_code == 204
    assert fake.calls[0][0] == "delete_topic"


@pytest.mark.asyncio
async def test_reorder_topics_200_routes_before_topic_id_patch(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    """Regression guard: PATCH .../topics/reorder must hit reorder_topics, not
    update_topic with topic_id="reorder" (which would 422 on UUID parsing)."""
    client, fake, user_id = client_and_fake
    t1, t2 = uuid4(), uuid4()

    r = await client.patch(
        f"/clubs/{uuid4()}/sessions/{uuid4()}/agendas/{uuid4()}/topics/reorder",
        json={"topic_ids": [str(t2), str(t1)]},
        headers=_auth(user_id),
    )
    assert r.status_code == 200
    items = r.json()["items"]
    assert [UUID(i["id"]) for i in items] == [t2, t1]
    assert fake.calls[0][0] == "reorder_topics"


@pytest.mark.asyncio
async def test_reorder_topics_409_invalid_set(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.raise_error = ConflictError("논제 목록이 일치하지 않습니다", code="INVALID_TOPIC_SET")

    r = await client.patch(
        f"/clubs/{uuid4()}/sessions/{uuid4()}/agendas/{uuid4()}/topics/reorder",
        json={"topic_ids": [str(uuid4())]},
        headers=_auth(user_id),
    )
    assert r.status_code == 409
    assert r.json()["error"]["code"] == "INVALID_TOPIC_SET"


@pytest.mark.asyncio
async def test_reorder_topics_422_empty_list(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, _fake, user_id = client_and_fake

    r = await client.patch(
        f"/clubs/{uuid4()}/sessions/{uuid4()}/agendas/{uuid4()}/topics/reorder",
        json={"topic_ids": []},
        headers=_auth(user_id),
    )
    assert r.status_code == 422

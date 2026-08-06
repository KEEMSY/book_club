"""HTTP contract tests for the AI 논제 초안 추천 endpoint (BC-53).

Uses ``app.dependency_overrides`` to swap ``get_club_service`` with an
in-memory fake — no DB, no Claude/network call. Focuses on the request/
response contract and domain-error -> HTTP-status mapping; permission logic
itself is covered by tests/domains/club/test_service_bc53.py.
"""

from __future__ import annotations

from collections.abc import AsyncIterator
from uuid import UUID, uuid4

import pytest
import pytest_asyncio
from app.core.exceptions import NotConfiguredError, NotFoundError, PermissionDeniedError
from app.core.security import create_access_token
from app.domains.club.providers import get_club_service
from app.main import create_app
from httpx import ASGITransport, AsyncClient


class FakeClubService:
    def __init__(self) -> None:
        self.calls: list[tuple[str, dict[str, object]]] = []
        self.raise_error: Exception | None = None
        self.topics: list[str] = ["논제 1", "논제 2", "논제 3"]

    async def recommend_topic_drafts(
        self,
        *,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        user_id: UUID,
        book_id: UUID,
        scope: str,
    ) -> list[str]:
        self.calls.append(
            ("recommend_topic_drafts", {"agenda_id": agenda_id, "book_id": book_id, "scope": scope})
        )
        if self.raise_error is not None:
            raise self.raise_error
        return self.topics


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


@pytest.mark.asyncio
async def test_recommend_topic_drafts_200(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    book_id = uuid4()

    r = await client.post(
        f"/clubs/{uuid4()}/sessions/{uuid4()}/agendas/{uuid4()}/topics/recommendations",
        json={"book_id": str(book_id), "scope": "1~3장"},
        headers=_auth(user_id),
    )

    assert r.status_code == 200
    assert r.json()["topics"] == ["논제 1", "논제 2", "논제 3"]
    assert fake.calls[0][0] == "recommend_topic_drafts"
    assert fake.calls[0][1]["book_id"] == book_id
    assert fake.calls[0][1]["scope"] == "1~3장"


@pytest.mark.asyncio
async def test_recommend_topic_drafts_403_non_author(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.raise_error = PermissionDeniedError(
        "발제문 작성자만 논제를 관리할 수 있습니다", code="PERMISSION_DENIED"
    )

    r = await client.post(
        f"/clubs/{uuid4()}/sessions/{uuid4()}/agendas/{uuid4()}/topics/recommendations",
        json={"book_id": str(uuid4()), "scope": "1~3장"},
        headers=_auth(user_id),
    )

    assert r.status_code == 403
    assert r.json()["error"]["code"] == "PERMISSION_DENIED"


@pytest.mark.asyncio
async def test_recommend_topic_drafts_404_unknown_agenda(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.raise_error = NotFoundError("agenda not found", code="AGENDA_NOT_FOUND")

    r = await client.post(
        f"/clubs/{uuid4()}/sessions/{uuid4()}/agendas/{uuid4()}/topics/recommendations",
        json={"book_id": str(uuid4()), "scope": "1~3장"},
        headers=_auth(user_id),
    )

    assert r.status_code == 404
    assert r.json()["error"]["code"] == "AGENDA_NOT_FOUND"


@pytest.mark.asyncio
async def test_recommend_topic_drafts_503_when_ai_not_configured(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.raise_error = NotConfiguredError(
        "AI 논제 추천 기능을 사용할 수 없습니다", code="AGENDA_AI_UNAVAILABLE"
    )

    r = await client.post(
        f"/clubs/{uuid4()}/sessions/{uuid4()}/agendas/{uuid4()}/topics/recommendations",
        json={"book_id": str(uuid4()), "scope": "1~3장"},
        headers=_auth(user_id),
    )

    assert r.status_code == 503
    assert r.json()["error"]["code"] == "AGENDA_AI_UNAVAILABLE"


@pytest.mark.asyncio
async def test_recommend_topic_drafts_422_blank_scope(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, _fake, user_id = client_and_fake

    r = await client.post(
        f"/clubs/{uuid4()}/sessions/{uuid4()}/agendas/{uuid4()}/topics/recommendations",
        json={"book_id": str(uuid4()), "scope": ""},
        headers=_auth(user_id),
    )

    assert r.status_code == 422

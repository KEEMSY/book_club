"""HTTP contract tests for the topic-comment endpoints (BC-46).

Uses ``app.dependency_overrides`` to swap ``get_club_service`` with an
in-memory fake — no DB required. Focuses on the request/response contract
and domain-error -> HTTP-status mapping; permission/depth logic itself is
covered by tests/domains/club/test_service_bc46.py.
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
    TopicCommentCreate,
    TopicCommentPublic,
    TopicCommentThreadPublic,
    TopicCommentUpdate,
)
from app.main import create_app
from httpx import ASGITransport, AsyncClient


def _comment_public(topic_id: UUID, **overrides: Any) -> TopicCommentPublic:
    defaults: dict[str, Any] = {
        "id": uuid4(),
        "topic_id": topic_id,
        "author_id": uuid4(),
        "parent_comment_id": None,
        "body": "답글 본문",
        "created_at": datetime.now(),
        "edited_at": None,
    }
    defaults.update(overrides)
    return TopicCommentPublic(**defaults)


def _thread_public(topic_id: UUID, **overrides: Any) -> TopicCommentThreadPublic:
    defaults: dict[str, Any] = {
        "id": uuid4(),
        "topic_id": topic_id,
        "author_id": uuid4(),
        "body": "루트 답글",
        "created_at": datetime.now(),
        "edited_at": None,
        "replies": [],
    }
    defaults.update(overrides)
    return TopicCommentThreadPublic(**defaults)


class FakeClubService:
    def __init__(self) -> None:
        self.calls: list[tuple[str, dict[str, Any]]] = []
        self.raise_error: Exception | None = None

    async def add_comment(
        self,
        *,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        topic_id: UUID,
        user_id: UUID,
        req: TopicCommentCreate,
    ) -> TopicCommentPublic:
        self.calls.append(("add_comment", {"topic_id": topic_id, "user_id": user_id}))
        if self.raise_error is not None:
            raise self.raise_error
        return _comment_public(
            topic_id,
            author_id=user_id,
            body=req.body,
            parent_comment_id=req.parent_comment_id,
        )

    async def list_comments(
        self,
        *,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        topic_id: UUID,
        caller_user_id: UUID,
    ) -> list[TopicCommentThreadPublic]:
        self.calls.append(("list_comments", {"topic_id": topic_id}))
        if self.raise_error is not None:
            raise self.raise_error
        return [_thread_public(topic_id)]

    async def update_comment(
        self,
        *,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        topic_id: UUID,
        comment_id: UUID,
        user_id: UUID,
        req: TopicCommentUpdate,
    ) -> TopicCommentPublic:
        self.calls.append(("update_comment", {"comment_id": comment_id, "user_id": user_id}))
        if self.raise_error is not None:
            raise self.raise_error
        return _comment_public(topic_id, id=comment_id, body=req.body, edited_at=datetime.now())

    async def delete_comment(
        self,
        *,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        topic_id: UUID,
        comment_id: UUID,
        user_id: UUID,
    ) -> None:
        self.calls.append(("delete_comment", {"comment_id": comment_id, "user_id": user_id}))
        if self.raise_error is not None:
            raise self.raise_error


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


def _comments_path(club_id: UUID, session_id: UUID, agenda_id: UUID, topic_id: UUID) -> str:
    return f"/clubs/{club_id}/sessions/{session_id}/agendas/{agenda_id}/topics/{topic_id}/comments"


# ---------- add_comment ---------- #


@pytest.mark.asyncio
async def test_add_comment_201_and_requires_auth(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    path = _comments_path(uuid4(), uuid4(), uuid4(), uuid4())

    r = await client.post(path, json={"body": "답글 본문"})
    assert r.status_code == 401

    r = await client.post(path, json={"body": "답글 본문"}, headers=_auth(user_id))
    assert r.status_code == 201
    body = r.json()
    assert body["body"] == "답글 본문"
    assert body["author_id"] == str(user_id)
    assert body["parent_comment_id"] is None
    assert fake.calls[0][0] == "add_comment"


@pytest.mark.asyncio
async def test_add_comment_with_parent_id(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, _fake, user_id = client_and_fake
    parent_id = uuid4()
    path = _comments_path(uuid4(), uuid4(), uuid4(), uuid4())

    r = await client.post(
        path,
        json={"body": "대댓글", "parent_comment_id": str(parent_id)},
        headers=_auth(user_id),
    )
    assert r.status_code == 201
    assert r.json()["parent_comment_id"] == str(parent_id)


@pytest.mark.asyncio
async def test_add_comment_403_non_member(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.raise_error = PermissionDeniedError(
        "클럽 멤버만 답글을 작성할 수 있습니다", code="NOT_MEMBER"
    )

    r = await client.post(
        _comments_path(uuid4(), uuid4(), uuid4(), uuid4()),
        json={"body": "답글 시도"},
        headers=_auth(user_id),
    )
    assert r.status_code == 403
    assert r.json()["error"]["code"] == "NOT_MEMBER"


@pytest.mark.asyncio
async def test_add_comment_409_max_reply_depth(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.raise_error = ConflictError(
        "대댓글에는 답글을 달 수 없습니다", code="MAX_REPLY_DEPTH_EXCEEDED"
    )

    r = await client.post(
        _comments_path(uuid4(), uuid4(), uuid4(), uuid4()),
        json={"body": "2단계 시도", "parent_comment_id": str(uuid4())},
        headers=_auth(user_id),
    )
    assert r.status_code == 409
    assert r.json()["error"]["code"] == "MAX_REPLY_DEPTH_EXCEEDED"


@pytest.mark.asyncio
async def test_add_comment_422_blank_body(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, _fake, user_id = client_and_fake

    r = await client.post(
        _comments_path(uuid4(), uuid4(), uuid4(), uuid4()),
        json={"body": ""},
        headers=_auth(user_id),
    )
    assert r.status_code == 422


@pytest.mark.asyncio
async def test_add_comment_404_unknown_topic(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.raise_error = NotFoundError("topic not found", code="TOPIC_NOT_FOUND")

    r = await client.post(
        _comments_path(uuid4(), uuid4(), uuid4(), uuid4()),
        json={"body": "답글"},
        headers=_auth(user_id),
    )
    assert r.status_code == 404
    assert r.json()["error"]["code"] == "TOPIC_NOT_FOUND"


# ---------- list_comments ---------- #


@pytest.mark.asyncio
async def test_list_comments_200(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, _fake, user_id = client_and_fake

    r = await client.get(_comments_path(uuid4(), uuid4(), uuid4(), uuid4()), headers=_auth(user_id))
    assert r.status_code == 200
    items = r.json()["items"]
    assert len(items) == 1
    assert items[0]["replies"] == []


@pytest.mark.asyncio
async def test_list_comments_403_private_non_member(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.raise_error = PermissionDeniedError("클럽 멤버만 조회할 수 있습니다", code="NOT_MEMBER")

    r = await client.get(_comments_path(uuid4(), uuid4(), uuid4(), uuid4()), headers=_auth(user_id))
    assert r.status_code == 403
    assert r.json()["error"]["code"] == "NOT_MEMBER"


# ---------- update_comment ---------- #


@pytest.mark.asyncio
async def test_update_comment_200(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, _fake, user_id = client_and_fake
    comment_id = uuid4()
    path = _comments_path(uuid4(), uuid4(), uuid4(), uuid4()) + f"/{comment_id}"

    r = await client.patch(path, json={"body": "수정됨"}, headers=_auth(user_id))
    assert r.status_code == 200
    body = r.json()
    assert body["body"] == "수정됨"
    assert body["id"] == str(comment_id)
    assert body["edited_at"] is not None


@pytest.mark.asyncio
async def test_update_comment_403_not_author_or_host(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.raise_error = PermissionDeniedError(
        "본인 또는 호스트만 답글을 수정·삭제할 수 있습니다", code="PERMISSION_DENIED"
    )
    path = _comments_path(uuid4(), uuid4(), uuid4(), uuid4()) + f"/{uuid4()}"

    r = await client.patch(path, json={"body": "수정 시도"}, headers=_auth(user_id))
    assert r.status_code == 403
    assert r.json()["error"]["code"] == "PERMISSION_DENIED"


@pytest.mark.asyncio
async def test_update_comment_404_unknown(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.raise_error = NotFoundError("comment not found", code="COMMENT_NOT_FOUND")
    path = _comments_path(uuid4(), uuid4(), uuid4(), uuid4()) + f"/{uuid4()}"

    r = await client.patch(path, json={"body": "수정 시도"}, headers=_auth(user_id))
    assert r.status_code == 404
    assert r.json()["error"]["code"] == "COMMENT_NOT_FOUND"


# ---------- delete_comment ---------- #


@pytest.mark.asyncio
async def test_delete_comment_204(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    path = _comments_path(uuid4(), uuid4(), uuid4(), uuid4()) + f"/{uuid4()}"

    r = await client.delete(path, headers=_auth(user_id))
    assert r.status_code == 204
    assert fake.calls[0][0] == "delete_comment"


@pytest.mark.asyncio
async def test_delete_comment_403_not_author_or_host(
    client_and_fake: tuple[AsyncClient, FakeClubService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.raise_error = PermissionDeniedError(
        "본인 또는 호스트만 답글을 수정·삭제할 수 있습니다", code="PERMISSION_DENIED"
    )
    path = _comments_path(uuid4(), uuid4(), uuid4(), uuid4()) + f"/{uuid4()}"

    r = await client.delete(path, headers=_auth(user_id))
    assert r.status_code == 403
    assert r.json()["error"]["code"] == "PERMISSION_DENIED"

"""HTTP contract tests for the feed router.

Uses FastAPI ``app.dependency_overrides`` to swap ``get_feed_service`` /
``get_feed_user_query`` with in-memory fakes. No DB, no R2, no auth
backend.

Coverage:
- 200 happy on list/comments/reaction toggle
- 201 on create_post / create_comment
- 204 on delete_post / delete_comment
- 401 without auth header
- 404 on unknown book_id / post_id / comment_id (also for non-owner)
- 422 schema validation (oversize content, unknown post_type)
- 409 COMMENT_DEPTH_EXCEEDED + UNSUPPORTED_CONTENT_TYPE
- 200 presign-image happy + 422 on unsupported content_type
"""

from __future__ import annotations

from collections.abc import AsyncIterator
from datetime import UTC, datetime
from uuid import UUID, uuid4

import pytest
import pytest_asyncio
from app.core.exceptions import ConflictError, NotFoundError
from app.core.security import create_access_token
from app.domains.feed.models import Comment, Post, PostType, ReactionType
from app.domains.feed.ports import AuthorView, PostFeedItem, PresignedUpload
from app.domains.feed.providers import (
    get_feed_service,
    get_feed_user_query,
)
from app.domains.feed.service import (
    CommentPage,
    FeedPage,
    ReactionToggleResult,
)
from app.main import create_app
from httpx import ASGITransport, AsyncClient


def _post_row(user_id: UUID, book_id: UUID) -> Post:
    post = Post(
        user_id=user_id,
        book_id=book_id,
        post_type=PostType.THOUGHT,
        content="hello",
        image_keys=["feed/x/abc.jpg"],
    )
    post.id = uuid4()
    post.created_at = datetime.now(tz=UTC)
    post.updated_at = post.created_at
    post.deleted_at = None
    return post


def _comment_row(user_id: UUID, post_id: UUID, parent_id: UUID | None = None) -> Comment:
    c = Comment(user_id=user_id, post_id=post_id, parent_id=parent_id, content="hi")
    c.id = uuid4()
    c.created_at = datetime.now(tz=UTC)
    c.updated_at = c.created_at
    c.deleted_at = None
    return c


class FakeFeedService:
    def __init__(self) -> None:
        self.book_id: UUID = uuid4()
        self.user_id: UUID = uuid4()
        self.post = _post_row(self.user_id, self.book_id)
        self.comment = _comment_row(self.user_id, self.post.id)
        self.unsupported_content_type = False
        self.create_post_book_missing = False
        self.create_post_oversize = False
        self.delete_post_not_found = False
        self.delete_comment_not_found = False
        self.toggle_post_missing = False
        self.toggle_state = "added"
        self.toggle_counts: dict[ReactionType, int] = {ReactionType.IDEA: 1}
        self.add_comment_depth_exceeded = False
        self.add_comment_post_missing = False
        self.calls: list[tuple[str, dict[str, object]]] = []

    async def request_image_upload(self, *, user_id: UUID, content_type: str) -> PresignedUpload:
        self.calls.append(
            ("request_image_upload", {"user_id": user_id, "content_type": content_type})
        )
        if self.unsupported_content_type:
            raise ConflictError("bad ct", code="UNSUPPORTED_CONTENT_TYPE")
        return PresignedUpload(
            url="https://r2.example.com/PUT/feed/x.jpg",
            key="feed/x.jpg",
            headers={"Content-Type": content_type},
            expires_in=600,
        )

    async def create_post(
        self,
        *,
        user_id: UUID,
        book_id: UUID,
        post_type: PostType,
        content: str,
        image_keys: list[str],
    ) -> Post:
        self.calls.append(
            (
                "create_post",
                {
                    "user_id": user_id,
                    "book_id": book_id,
                    "post_type": post_type,
                    "content_len": len(content),
                    "image_keys": image_keys,
                },
            )
        )
        if self.create_post_book_missing:
            raise NotFoundError("book not found", code="BOOK_NOT_FOUND")
        if self.create_post_oversize:
            raise ConflictError("too long", code="CONTENT_TOO_LONG")
        post = _post_row(user_id, book_id)
        post.content = content
        post.image_keys = list(image_keys)
        post.post_type = post_type
        return post

    async def list_posts_by_book(
        self,
        *,
        book_id: UUID,
        viewer_id: UUID,
        cursor: str | None,
        limit: int,
    ) -> FeedPage:
        self.calls.append(
            (
                "list_posts_by_book",
                {
                    "book_id": book_id,
                    "viewer_id": viewer_id,
                    "cursor": cursor,
                    "limit": limit,
                },
            )
        )
        item = PostFeedItem(
            post=self.post,
            reactions={ReactionType.IDEA: 2},
            my_reactions={ReactionType.IDEA},
            comment_count=3,
            image_urls=["https://r2.example.com/GET/feed/x.jpg"],
        )
        return FeedPage(items=[item], next_cursor=None)

    async def delete_post(self, *, user_id: UUID, post_id: UUID) -> None:
        self.calls.append(("delete_post", {"user_id": user_id, "post_id": post_id}))
        if self.delete_post_not_found:
            raise NotFoundError("post not found", code="POST_NOT_FOUND")

    async def toggle_reaction(
        self,
        *,
        user_id: UUID,
        post_id: UUID,
        reaction_type: ReactionType,
    ) -> ReactionToggleResult:
        self.calls.append(
            (
                "toggle_reaction",
                {"user_id": user_id, "post_id": post_id, "reaction_type": reaction_type},
            )
        )
        if self.toggle_post_missing:
            raise NotFoundError("post not found", code="POST_NOT_FOUND")
        return ReactionToggleResult(state=self.toggle_state, counts=self.toggle_counts)

    async def add_comment(
        self,
        *,
        user_id: UUID,
        post_id: UUID,
        parent_id: UUID | None,
        content: str,
    ) -> Comment:
        self.calls.append(
            (
                "add_comment",
                {
                    "user_id": user_id,
                    "post_id": post_id,
                    "parent_id": parent_id,
                    "content_len": len(content),
                },
            )
        )
        if self.add_comment_post_missing:
            raise NotFoundError("post not found", code="POST_NOT_FOUND")
        if self.add_comment_depth_exceeded:
            raise ConflictError("depth", code="COMMENT_DEPTH_EXCEEDED")
        c = _comment_row(user_id, post_id, parent_id=parent_id)
        c.content = content
        return c

    async def list_comments(
        self,
        *,
        post_id: UUID,
        cursor: str | None,
        limit: int,
    ) -> CommentPage:
        self.calls.append(("list_comments", {"post_id": post_id, "cursor": cursor, "limit": limit}))
        return CommentPage(items=[self.comment], next_cursor=None)

    async def delete_comment(self, *, user_id: UUID, comment_id: UUID) -> None:
        self.calls.append(("delete_comment", {"user_id": user_id, "comment_id": comment_id}))
        if self.delete_comment_not_found:
            raise NotFoundError("comment not found", code="COMMENT_NOT_FOUND")


class FakeUserQuery:
    def __init__(self, nicknames: dict[UUID, str] | None = None) -> None:
        self.nicknames = nicknames or {}

    async def get_authors(self, user_ids: list[UUID]) -> dict[UUID, AuthorView]:
        return {
            uid: AuthorView(
                id=uid,
                nickname=self.nicknames.get(uid, f"user-{str(uid)[:6]}"),
                profile_image_url=None,
            )
            for uid in user_ids
        }


@pytest_asyncio.fixture
async def client_and_fake() -> AsyncIterator[tuple[AsyncClient, FakeFeedService, UUID]]:
    app = create_app()
    fake = FakeFeedService()
    user_query = FakeUserQuery()
    app.dependency_overrides[get_feed_service] = lambda: fake
    app.dependency_overrides[get_feed_user_query] = lambda: user_query
    transport = ASGITransport(app=app)
    user_id = uuid4()
    async with AsyncClient(transport=transport, base_url="http://testserver") as client:
        yield client, fake, user_id
    app.dependency_overrides.clear()


def _auth(user_id: UUID) -> dict[str, str]:
    return {"Authorization": f"Bearer {create_access_token(str(user_id))}"}


# ---------------------------------------------------------------------------
# /uploads/presign-image
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_presign_image_requires_auth(
    client_and_fake: tuple[AsyncClient, FakeFeedService, UUID],
) -> None:
    client, _, _ = client_and_fake
    response = await client.post("/uploads/presign-image", json={"content_type": "image/jpeg"})
    assert response.status_code == 401


@pytest.mark.asyncio
async def test_presign_image_happy(
    client_and_fake: tuple[AsyncClient, FakeFeedService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    response = await client.post(
        "/uploads/presign-image",
        json={"content_type": "image/jpeg"},
        headers=_auth(user_id),
    )
    assert response.status_code == 200
    body = response.json()
    assert body["url"].startswith("https://r2.example.com/PUT/")
    assert body["key"] == "feed/x.jpg"
    assert body["headers"]["Content-Type"] == "image/jpeg"
    assert body["expires_in"] == 600
    assert fake.calls[0][0] == "request_image_upload"


@pytest.mark.asyncio
async def test_presign_image_rejects_unsupported_content_type(
    client_and_fake: tuple[AsyncClient, FakeFeedService, UUID],
) -> None:
    client, _, user_id = client_and_fake
    response = await client.post(
        "/uploads/presign-image",
        json={"content_type": "image/gif"},
        headers=_auth(user_id),
    )
    # 422 from pydantic (Literal mismatch).
    assert response.status_code == 422


# ---------------------------------------------------------------------------
# GET /books/{book_id}/posts
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_list_book_posts_happy(
    client_and_fake: tuple[AsyncClient, FakeFeedService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    response = await client.get(
        f"/books/{fake.book_id}/posts",
        headers=_auth(user_id),
    )
    assert response.status_code == 200
    body = response.json()
    assert len(body["items"]) == 1
    item = body["items"][0]
    assert item["id"] == str(fake.post.id)
    assert item["reactions"] == {"idea": 2}
    assert item["my_reactions"] == ["idea"]
    assert item["comment_count"] == 3
    assert item["image_urls"] == ["https://r2.example.com/GET/feed/x.jpg"]
    assert item["user"]["id"] == str(fake.post.user_id)
    assert body["next_cursor"] is None


@pytest.mark.asyncio
async def test_list_book_posts_requires_auth(
    client_and_fake: tuple[AsyncClient, FakeFeedService, UUID],
) -> None:
    client, fake, _ = client_and_fake
    response = await client.get(f"/books/{fake.book_id}/posts")
    assert response.status_code == 401


# ---------------------------------------------------------------------------
# POST /books/{book_id}/posts
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_create_book_post_happy_201(
    client_and_fake: tuple[AsyncClient, FakeFeedService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    response = await client.post(
        f"/books/{fake.book_id}/posts",
        json={
            "book_id": str(fake.book_id),
            "post_type": "highlight",
            "content": "memorable line",
            "image_keys": [],
        },
        headers=_auth(user_id),
    )
    assert response.status_code == 201
    body = response.json()
    assert body["post_type"] == "highlight"
    assert body["content"] == "memorable line"


@pytest.mark.asyncio
async def test_create_book_post_returns_404_for_missing_book(
    client_and_fake: tuple[AsyncClient, FakeFeedService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.create_post_book_missing = True
    response = await client.post(
        f"/books/{fake.book_id}/posts",
        json={
            "book_id": str(fake.book_id),
            "post_type": "thought",
            "content": "x",
            "image_keys": [],
        },
        headers=_auth(user_id),
    )
    assert response.status_code == 404
    assert response.json()["error"]["code"] == "BOOK_NOT_FOUND"


@pytest.mark.asyncio
async def test_create_book_post_rejects_unknown_post_type_with_422(
    client_and_fake: tuple[AsyncClient, FakeFeedService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    response = await client.post(
        f"/books/{fake.book_id}/posts",
        json={
            "book_id": str(fake.book_id),
            "post_type": "rant",
            "content": "x",
            "image_keys": [],
        },
        headers=_auth(user_id),
    )
    assert response.status_code == 422


@pytest.mark.asyncio
async def test_create_book_post_rejects_oversize_content_with_422(
    client_and_fake: tuple[AsyncClient, FakeFeedService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    response = await client.post(
        f"/books/{fake.book_id}/posts",
        json={
            "book_id": str(fake.book_id),
            "post_type": "thought",
            "content": "x" * 2001,
            "image_keys": [],
        },
        headers=_auth(user_id),
    )
    assert response.status_code == 422


# ---------------------------------------------------------------------------
# DELETE /posts/{id}
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_delete_post_happy_204(
    client_and_fake: tuple[AsyncClient, FakeFeedService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    response = await client.delete(f"/posts/{fake.post.id}", headers=_auth(user_id))
    assert response.status_code == 204


@pytest.mark.asyncio
async def test_delete_post_404_when_not_owner(
    client_and_fake: tuple[AsyncClient, FakeFeedService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.delete_post_not_found = True
    response = await client.delete(f"/posts/{uuid4()}", headers=_auth(user_id))
    assert response.status_code == 404
    assert response.json()["error"]["code"] == "POST_NOT_FOUND"


# ---------------------------------------------------------------------------
# POST /posts/{id}/reactions
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_toggle_reaction_happy(
    client_and_fake: tuple[AsyncClient, FakeFeedService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    response = await client.post(
        f"/posts/{fake.post.id}/reactions",
        json={"reaction_type": "idea"},
        headers=_auth(user_id),
    )
    assert response.status_code == 200
    body = response.json()
    assert body["state"] == "added"
    assert body["counts"] == {"idea": 1}


@pytest.mark.asyncio
async def test_toggle_reaction_404_when_post_missing(
    client_and_fake: tuple[AsyncClient, FakeFeedService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.toggle_post_missing = True
    response = await client.post(
        f"/posts/{uuid4()}/reactions",
        json={"reaction_type": "fire"},
        headers=_auth(user_id),
    )
    assert response.status_code == 404


@pytest.mark.asyncio
async def test_toggle_reaction_rejects_unknown_type(
    client_and_fake: tuple[AsyncClient, FakeFeedService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    response = await client.post(
        f"/posts/{fake.post.id}/reactions",
        json={"reaction_type": "thumbs_up"},
        headers=_auth(user_id),
    )
    assert response.status_code == 422


# ---------------------------------------------------------------------------
# GET / POST /posts/{id}/comments
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_list_comments_happy(
    client_and_fake: tuple[AsyncClient, FakeFeedService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    response = await client.get(
        f"/posts/{fake.post.id}/comments",
        headers=_auth(user_id),
    )
    assert response.status_code == 200
    body = response.json()
    assert len(body["items"]) == 1
    assert body["items"][0]["id"] == str(fake.comment.id)
    assert body["items"][0]["parent_id"] is None
    assert body["next_cursor"] is None


@pytest.mark.asyncio
async def test_create_comment_happy_201(
    client_and_fake: tuple[AsyncClient, FakeFeedService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    response = await client.post(
        f"/posts/{fake.post.id}/comments",
        json={"content": "first"},
        headers=_auth(user_id),
    )
    assert response.status_code == 201
    body = response.json()
    assert body["content"] == "first"
    assert body["parent_id"] is None


@pytest.mark.asyncio
async def test_create_comment_409_on_depth_exceeded(
    client_and_fake: tuple[AsyncClient, FakeFeedService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.add_comment_depth_exceeded = True
    response = await client.post(
        f"/posts/{fake.post.id}/comments",
        json={"parent_id": str(uuid4()), "content": "deep"},
        headers=_auth(user_id),
    )
    assert response.status_code == 409
    assert response.json()["error"]["code"] == "COMMENT_DEPTH_EXCEEDED"


@pytest.mark.asyncio
async def test_create_comment_404_when_post_missing(
    client_and_fake: tuple[AsyncClient, FakeFeedService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.add_comment_post_missing = True
    response = await client.post(
        f"/posts/{uuid4()}/comments",
        json={"content": "x"},
        headers=_auth(user_id),
    )
    assert response.status_code == 404


@pytest.mark.asyncio
async def test_create_comment_rejects_oversize_with_422(
    client_and_fake: tuple[AsyncClient, FakeFeedService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    response = await client.post(
        f"/posts/{fake.post.id}/comments",
        json={"content": "x" * 1001},
        headers=_auth(user_id),
    )
    assert response.status_code == 422


# ---------------------------------------------------------------------------
# DELETE /comments/{id}
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_delete_comment_happy_204(
    client_and_fake: tuple[AsyncClient, FakeFeedService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    response = await client.delete(
        f"/comments/{fake.comment.id}",
        headers=_auth(user_id),
    )
    assert response.status_code == 204


@pytest.mark.asyncio
async def test_delete_comment_404_when_not_owner(
    client_and_fake: tuple[AsyncClient, FakeFeedService, UUID],
) -> None:
    client, fake, user_id = client_and_fake
    fake.delete_comment_not_found = True
    response = await client.delete(
        f"/comments/{uuid4()}",
        headers=_auth(user_id),
    )
    assert response.status_code == 404
    assert response.json()["error"]["code"] == "COMMENT_NOT_FOUND"


@pytest.mark.asyncio
async def test_delete_comment_requires_auth(
    client_and_fake: tuple[AsyncClient, FakeFeedService, UUID],
) -> None:
    client, fake, _ = client_and_fake
    response = await client.delete(f"/comments/{fake.comment.id}")
    assert response.status_code == 401

"""Unit tests for FeedService with in-memory fakes for every Port.

No DB, no HTTP — every collaborator is a dict-backed stub that
implements the Port Protocol shape. Covers the business rules owned by
the service:
- request_image_upload validates the content-type allowlist and emits a
  per-user prefixed key
- create_post enforces content/image limits, image-key prefix ownership,
  and book existence
- list_posts_by_book composes reaction aggregates / my reactions /
  comment counts / signed image URLs into PostFeedItem; emits next_cursor
  on full pages only
- delete_post returns 404 (not 403) when the caller is not the owner
- toggle_reaction flips the (user, post, type) triple — same type
  removes, otherwise adds; counts reflect the new state
- add_comment caps content length, validates parent membership, enforces
  depth=1 (1단계 답글)
- list_comments returns a flat list ordered ASC; cursor only emitted on
  full pages
- delete_comment is owner-gated with 404 leakage protection
"""

from __future__ import annotations

import uuid as uuid_lib
from collections import defaultdict
from collections.abc import Iterable
from datetime import UTC, datetime, timedelta
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError, NotFoundError
from app.domains.feed.models import Comment, Post, PostType, Reaction, ReactionType
from app.domains.feed.ports import PresignedUpload
from app.domains.feed.service import FeedService


class FakePostRepo:
    def __init__(self) -> None:
        self.by_id: dict[UUID, Post] = {}

    async def create(
        self,
        *,
        user_id: UUID,
        book_id: UUID,
        post_type: PostType,
        content: str,
        image_keys: list[str],
    ) -> Post:
        post = Post(
            user_id=user_id,
            book_id=book_id,
            post_type=post_type,
            content=content,
            image_keys=list(image_keys),
        )
        post.id = uuid4()
        post.created_at = datetime.now(tz=UTC)
        post.updated_at = post.created_at
        post.deleted_at = None
        self.by_id[post.id] = post
        return post

    async def get_by_id(self, post_id: UUID) -> Post | None:
        post = self.by_id.get(post_id)
        if post is None or post.deleted_at is not None:
            return None
        return post

    async def list_by_book(
        self,
        book_id: UUID,
        *,
        cursor: datetime | None,
        limit: int,
    ) -> list[Post]:
        rows = [p for p in self.by_id.values() if p.book_id == book_id and p.deleted_at is None]
        if cursor is not None:
            rows = [p for p in rows if p.created_at < cursor]
        rows.sort(key=lambda p: (p.created_at, p.id), reverse=True)
        return rows[:limit]

    async def soft_delete(self, post_id: UUID, at: datetime) -> None:
        post = self.by_id.get(post_id)
        if post is None:
            return
        post.deleted_at = at

    async def comment_counts_for(self, post_ids: list[UUID]) -> dict[UUID, int]:
        # Service injects this; counts live on the Comment fake — wired
        # by ``_build_service`` to the comment fake directly when needed.
        return {pid: 0 for pid in post_ids}


class FakeReactionRepo:
    def __init__(self) -> None:
        self.rows: list[tuple[UUID, UUID, ReactionType]] = []

    async def add(self, *, post_id: UUID, user_id: UUID, reaction_type: ReactionType) -> Reaction:
        triple = (post_id, user_id, reaction_type)
        if triple not in self.rows:
            self.rows.append(triple)
        row = Reaction(post_id=post_id, user_id=user_id, reaction_type=reaction_type)
        row.id = uuid4()
        row.created_at = datetime.now(tz=UTC)
        return row

    async def remove(self, *, post_id: UUID, user_id: UUID, reaction_type: ReactionType) -> int:
        triple = (post_id, user_id, reaction_type)
        if triple in self.rows:
            self.rows.remove(triple)
            return 1
        return 0

    async def aggregate_for_post(self, post_id: UUID) -> dict[ReactionType, int]:
        bucket: dict[ReactionType, int] = defaultdict(int)
        for pid, _uid, rt in self.rows:
            if pid == post_id:
                bucket[rt] += 1
        return dict(bucket)

    async def reactions_by_user(self, post_id: UUID, user_id: UUID) -> set[ReactionType]:
        return {rt for pid, uid, rt in self.rows if pid == post_id and uid == user_id}

    async def aggregates_for_posts(
        self, post_ids: list[UUID]
    ) -> dict[UUID, dict[ReactionType, int]]:
        out: dict[UUID, dict[ReactionType, int]] = {pid: {} for pid in post_ids}
        for pid, _uid, rt in self.rows:
            if pid in out:
                out[pid][rt] = out[pid].get(rt, 0) + 1
        return out

    async def my_reactions_for_posts(
        self, post_ids: list[UUID], user_id: UUID
    ) -> dict[UUID, set[ReactionType]]:
        out: dict[UUID, set[ReactionType]] = {pid: set() for pid in post_ids}
        for pid, uid, rt in self.rows:
            if pid in out and uid == user_id:
                out[pid].add(rt)
        return out


class FakeCommentRepo:
    def __init__(self) -> None:
        self.by_id: dict[UUID, Comment] = {}

    async def create(
        self,
        *,
        user_id: UUID,
        post_id: UUID,
        parent_id: UUID | None,
        content: str,
    ) -> Comment:
        c = Comment(
            user_id=user_id,
            post_id=post_id,
            parent_id=parent_id,
            content=content,
        )
        c.id = uuid4()
        c.created_at = datetime.now(tz=UTC)
        c.updated_at = c.created_at
        c.deleted_at = None
        self.by_id[c.id] = c
        return c

    async def get_by_id(self, comment_id: UUID) -> Comment | None:
        c = self.by_id.get(comment_id)
        if c is None or c.deleted_at is not None:
            return None
        return c

    async def list_by_post(
        self,
        post_id: UUID,
        *,
        cursor: datetime | None,
        limit: int,
    ) -> list[Comment]:
        rows = [c for c in self.by_id.values() if c.post_id == post_id and c.deleted_at is None]
        if cursor is not None:
            rows = [c for c in rows if c.created_at > cursor]
        rows.sort(key=lambda c: (c.created_at, c.id))
        return rows[:limit]

    async def soft_delete(self, comment_id: UUID, at: datetime) -> None:
        c = self.by_id.get(comment_id)
        if c is None:
            return
        c.deleted_at = at


class FakeImageStorage:
    def __init__(self) -> None:
        self.presign_calls: list[tuple[str, str, int]] = []

    async def presign_upload(
        self,
        key: str,
        *,
        content_type: str,
        expires_in: int = 600,
    ) -> PresignedUpload:
        self.presign_calls.append((key, content_type, expires_in))
        return PresignedUpload(
            url=f"https://r2.example.com/PUT/{key}",
            key=key,
            headers={"Content-Type": content_type},
            expires_in=expires_in,
        )

    async def public_url(self, key: str) -> str:
        return f"https://r2.example.com/GET/{key}"


class FakeBookQuery:
    def __init__(self, existing: Iterable[UUID] = ()) -> None:
        self.existing = set(existing)

    async def book_exists(self, book_id: UUID) -> bool:
        return book_id in self.existing


def _build_service(
    *,
    books: Iterable[UUID] = (),
) -> tuple[
    FeedService,
    FakePostRepo,
    FakeReactionRepo,
    FakeCommentRepo,
    FakeImageStorage,
    FakeBookQuery,
]:
    posts = FakePostRepo()
    reactions = FakeReactionRepo()
    comments = FakeCommentRepo()
    storage = FakeImageStorage()
    book_query = FakeBookQuery(existing=books)

    # Patch FakePostRepo.comment_counts_for to use the shared comments fake
    # so list_posts_by_book sees real counts in tests.
    async def _counts(post_ids: list[UUID]) -> dict[UUID, int]:
        bucket: dict[UUID, int] = {pid: 0 for pid in post_ids}
        for c in comments.by_id.values():
            if c.post_id in bucket and c.deleted_at is None:
                bucket[c.post_id] += 1
        return bucket

    posts.comment_counts_for = _counts  # type: ignore[method-assign]
    service = FeedService(
        posts=posts,
        reactions=reactions,
        comments=comments,
        image_storage=storage,
        book_query=book_query,
    )
    return service, posts, reactions, comments, storage, book_query


# ---------------------------------------------------------------------------
# request_image_upload
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_request_image_upload_returns_presigned_with_user_prefixed_key() -> None:
    service, _, _, _, storage, _ = _build_service()
    user_id = uuid4()

    presigned = await service.request_image_upload(user_id=user_id, content_type="image/jpeg")

    assert presigned.key.startswith(f"feed/{user_id}/")
    assert presigned.key.endswith(".jpg")
    assert storage.presign_calls[0][1] == "image/jpeg"


@pytest.mark.asyncio
async def test_request_image_upload_rejects_unsupported_content_type() -> None:
    service, _, _, _, _, _ = _build_service()
    with pytest.raises(ConflictError) as exc_info:
        await service.request_image_upload(user_id=uuid4(), content_type="application/pdf")
    assert exc_info.value.code == "UNSUPPORTED_CONTENT_TYPE"


# ---------------------------------------------------------------------------
# create_post
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_create_post_happy_persists_with_image_keys() -> None:
    book_id = uuid4()
    service, posts, _, _, _, _ = _build_service(books=[book_id])
    user_id = uuid4()

    post = await service.create_post(
        user_id=user_id,
        book_id=book_id,
        post_type=PostType.HIGHLIGHT,
        content="hello",
        image_keys=[f"feed/{user_id}/{uuid_lib.uuid4()}.jpg"],
    )
    assert post.user_id == user_id
    assert post.book_id == book_id
    assert post.post_type is PostType.HIGHLIGHT
    assert post.id in posts.by_id


@pytest.mark.asyncio
async def test_create_post_rejects_oversize_content() -> None:
    book_id = uuid4()
    service, _, _, _, _, _ = _build_service(books=[book_id])
    with pytest.raises(ConflictError) as exc_info:
        await service.create_post(
            user_id=uuid4(),
            book_id=book_id,
            post_type=PostType.THOUGHT,
            content="x" * 2001,
            image_keys=[],
        )
    assert exc_info.value.code == "CONTENT_TOO_LONG"


@pytest.mark.asyncio
async def test_create_post_rejects_too_many_images() -> None:
    book_id = uuid4()
    service, _, _, _, _, _ = _build_service(books=[book_id])
    user_id = uuid4()
    with pytest.raises(ConflictError) as exc_info:
        await service.create_post(
            user_id=user_id,
            book_id=book_id,
            post_type=PostType.THOUGHT,
            content="ok",
            image_keys=[f"feed/{user_id}/{i}.jpg" for i in range(5)],
        )
    assert exc_info.value.code == "TOO_MANY_IMAGES"


@pytest.mark.asyncio
async def test_create_post_rejects_image_key_outside_user_prefix() -> None:
    book_id = uuid4()
    service, _, _, _, _, _ = _build_service(books=[book_id])
    user_id = uuid4()
    other_id = uuid4()
    with pytest.raises(ConflictError) as exc_info:
        await service.create_post(
            user_id=user_id,
            book_id=book_id,
            post_type=PostType.THOUGHT,
            content="ok",
            image_keys=[f"feed/{other_id}/x.jpg"],
        )
    assert exc_info.value.code == "IMAGE_KEY_FORBIDDEN"


@pytest.mark.asyncio
async def test_create_post_rejects_unknown_book() -> None:
    service, _, _, _, _, _ = _build_service()
    with pytest.raises(NotFoundError) as exc_info:
        await service.create_post(
            user_id=uuid4(),
            book_id=uuid4(),
            post_type=PostType.QUESTION,
            content="ok",
            image_keys=[],
        )
    assert exc_info.value.code == "BOOK_NOT_FOUND"


# ---------------------------------------------------------------------------
# list_posts_by_book
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_list_posts_by_book_materialises_feed_items() -> None:
    book_id = uuid4()
    service, _posts, reactions, comments, _, _ = _build_service(books=[book_id])
    author = uuid4()
    viewer = uuid4()
    post = await service.create_post(
        user_id=author,
        book_id=book_id,
        post_type=PostType.THOUGHT,
        content="hi",
        image_keys=[f"feed/{author}/x.jpg"],
    )
    await reactions.add(post_id=post.id, user_id=viewer, reaction_type=ReactionType.IDEA)
    await reactions.add(post_id=post.id, user_id=author, reaction_type=ReactionType.FIRE)
    await comments.create(user_id=viewer, post_id=post.id, parent_id=None, content="c")

    page = await service.list_posts_by_book(
        book_id=book_id, viewer_id=viewer, cursor=None, limit=20
    )
    assert len(page.items) == 1
    item = page.items[0]
    assert item.post.id == post.id
    assert item.reactions == {ReactionType.IDEA: 1, ReactionType.FIRE: 1}
    assert item.my_reactions == {ReactionType.IDEA}
    assert item.comment_count == 1
    assert item.image_urls == [f"https://r2.example.com/GET/feed/{author}/x.jpg"]
    assert page.next_cursor is None  # fewer items than limit


@pytest.mark.asyncio
async def test_list_posts_by_book_emits_next_cursor_on_full_page() -> None:
    book_id = uuid4()
    service, _posts, _, _, _, _ = _build_service(books=[book_id])
    user_id = uuid4()
    base = datetime.now(tz=UTC)
    for i in range(3):
        p = await service.create_post(
            user_id=user_id,
            book_id=book_id,
            post_type=PostType.THOUGHT,
            content=f"p-{i}",
            image_keys=[],
        )
        # Spread created_at descending to make ordering deterministic.
        p.created_at = base - timedelta(minutes=i)

    page = await service.list_posts_by_book(
        book_id=book_id, viewer_id=user_id, cursor=None, limit=2
    )
    assert len(page.items) == 2
    assert page.next_cursor is not None  # full page → cursor provided


# ---------------------------------------------------------------------------
# delete_post
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_delete_post_owner_soft_deletes() -> None:
    book_id = uuid4()
    service, posts, _, _, _, _ = _build_service(books=[book_id])
    user_id = uuid4()
    post = await service.create_post(
        user_id=user_id,
        book_id=book_id,
        post_type=PostType.THOUGHT,
        content="x",
        image_keys=[],
    )
    await service.delete_post(user_id=user_id, post_id=post.id)
    assert posts.by_id[post.id].deleted_at is not None


@pytest.mark.asyncio
async def test_delete_post_returns_404_for_non_owner() -> None:
    book_id = uuid4()
    service, _, _, _, _, _ = _build_service(books=[book_id])
    owner = uuid4()
    attacker = uuid4()
    post = await service.create_post(
        user_id=owner,
        book_id=book_id,
        post_type=PostType.THOUGHT,
        content="x",
        image_keys=[],
    )
    with pytest.raises(NotFoundError) as exc_info:
        await service.delete_post(user_id=attacker, post_id=post.id)
    assert exc_info.value.code == "POST_NOT_FOUND"


# ---------------------------------------------------------------------------
# toggle_reaction
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_toggle_reaction_adds_then_removes() -> None:
    book_id = uuid4()
    service, _, _, _, _, _ = _build_service(books=[book_id])
    user_id = uuid4()
    post = await service.create_post(
        user_id=user_id,
        book_id=book_id,
        post_type=PostType.THOUGHT,
        content="x",
        image_keys=[],
    )
    first = await service.toggle_reaction(
        user_id=user_id, post_id=post.id, reaction_type=ReactionType.IDEA
    )
    assert first.state == "added"
    assert first.counts == {ReactionType.IDEA: 1}

    second = await service.toggle_reaction(
        user_id=user_id, post_id=post.id, reaction_type=ReactionType.IDEA
    )
    assert second.state == "removed"
    assert second.counts == {}


@pytest.mark.asyncio
async def test_toggle_reaction_404_when_post_missing() -> None:
    service, _, _, _, _, _ = _build_service()
    with pytest.raises(NotFoundError):
        await service.toggle_reaction(
            user_id=uuid4(), post_id=uuid4(), reaction_type=ReactionType.HEART
        )


# ---------------------------------------------------------------------------
# add_comment + list_comments + delete_comment
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_add_comment_root_then_reply_at_depth_one_succeeds() -> None:
    book_id = uuid4()
    service, _, _, _, _, _ = _build_service(books=[book_id])
    user_id = uuid4()
    post = await service.create_post(
        user_id=user_id,
        book_id=book_id,
        post_type=PostType.DISCUSSION,
        content="d",
        image_keys=[],
    )
    root = await service.add_comment(
        user_id=user_id, post_id=post.id, parent_id=None, content="root"
    )
    reply = await service.add_comment(
        user_id=user_id, post_id=post.id, parent_id=root.id, content="r"
    )
    assert reply.parent_id == root.id


@pytest.mark.asyncio
async def test_add_comment_reply_to_reply_raises_depth_exceeded() -> None:
    book_id = uuid4()
    service, _, _, _, _, _ = _build_service(books=[book_id])
    user_id = uuid4()
    post = await service.create_post(
        user_id=user_id,
        book_id=book_id,
        post_type=PostType.DISCUSSION,
        content="d",
        image_keys=[],
    )
    root = await service.add_comment(
        user_id=user_id, post_id=post.id, parent_id=None, content="root"
    )
    reply = await service.add_comment(
        user_id=user_id, post_id=post.id, parent_id=root.id, content="r"
    )

    with pytest.raises(ConflictError) as exc_info:
        await service.add_comment(
            user_id=user_id, post_id=post.id, parent_id=reply.id, content="rr"
        )
    assert exc_info.value.code == "COMMENT_DEPTH_EXCEEDED"


@pytest.mark.asyncio
async def test_add_comment_parent_must_belong_to_same_post() -> None:
    book_id = uuid4()
    service, _, _, _, _, _ = _build_service(books=[book_id])
    user_id = uuid4()
    p1 = await service.create_post(
        user_id=user_id,
        book_id=book_id,
        post_type=PostType.QUESTION,
        content="q1",
        image_keys=[],
    )
    p2 = await service.create_post(
        user_id=user_id,
        book_id=book_id,
        post_type=PostType.QUESTION,
        content="q2",
        image_keys=[],
    )
    root = await service.add_comment(user_id=user_id, post_id=p1.id, parent_id=None, content="root")
    with pytest.raises(NotFoundError) as exc_info:
        await service.add_comment(
            user_id=user_id, post_id=p2.id, parent_id=root.id, content="cross"
        )
    assert exc_info.value.code == "COMMENT_NOT_FOUND"


@pytest.mark.asyncio
async def test_add_comment_rejects_oversize() -> None:
    book_id = uuid4()
    service, _, _, _, _, _ = _build_service(books=[book_id])
    user_id = uuid4()
    post = await service.create_post(
        user_id=user_id,
        book_id=book_id,
        post_type=PostType.THOUGHT,
        content="x",
        image_keys=[],
    )
    with pytest.raises(ConflictError) as exc_info:
        await service.add_comment(
            user_id=user_id,
            post_id=post.id,
            parent_id=None,
            content="x" * 1001,
        )
    assert exc_info.value.code == "CONTENT_TOO_LONG"


@pytest.mark.asyncio
async def test_list_comments_returns_flat_list_ascending() -> None:
    book_id = uuid4()
    service, _, _, _, _, _ = _build_service(books=[book_id])
    user_id = uuid4()
    post = await service.create_post(
        user_id=user_id,
        book_id=book_id,
        post_type=PostType.DISCUSSION,
        content="d",
        image_keys=[],
    )
    base = datetime.now(tz=UTC)
    for i in range(3):
        c = await service.add_comment(
            user_id=user_id, post_id=post.id, parent_id=None, content=f"c-{i}"
        )
        c.created_at = base + timedelta(seconds=i)

    page = await service.list_comments(post_id=post.id, cursor=None, limit=10)
    assert len(page.items) == 3
    assert [c.content for c in page.items] == ["c-0", "c-1", "c-2"]


@pytest.mark.asyncio
async def test_delete_comment_owner_only() -> None:
    book_id = uuid4()
    service, _, _, comments, _, _ = _build_service(books=[book_id])
    owner = uuid4()
    attacker = uuid4()
    post = await service.create_post(
        user_id=owner,
        book_id=book_id,
        post_type=PostType.THOUGHT,
        content="x",
        image_keys=[],
    )
    c = await service.add_comment(user_id=owner, post_id=post.id, parent_id=None, content="c")
    with pytest.raises(NotFoundError):
        await service.delete_comment(user_id=attacker, comment_id=c.id)

    await service.delete_comment(user_id=owner, comment_id=c.id)
    assert comments.by_id[c.id].deleted_at is not None

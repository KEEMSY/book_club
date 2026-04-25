"""Integration tests for the feed repository adapters (async Postgres).

Verifies:
- Post.create + list_by_book ordering (created_at DESC, id DESC)
- Post cursor pagination + soft_delete excludes from listings
- Reaction.add is idempotent on duplicate triple
- Reaction aggregate counts grouped by reaction_type
- Reaction reactions_by_user filters per-user reactions
- Reaction batch aggregates_for_posts / my_reactions_for_posts
- Comment.create root + reply
- Comment list_by_post ordering by created_at ASC
- comment_counts_for excludes soft-deleted children
"""

from __future__ import annotations

from datetime import UTC, datetime, timedelta
from uuid import UUID, uuid4

import pytest
from app.domains.auth.models import AuthProvider
from app.domains.auth.repository import UserRepository
from app.domains.book.models import BookSource
from app.domains.book.repository import BookRepository
from app.domains.feed.models import PostType, ReactionType
from app.domains.feed.repository import (
    CommentRepository,
    PostRepository,
    ReactionRepository,
)
from sqlalchemy.ext.asyncio import AsyncSession


async def _create_user(session: AsyncSession, *, sub: str) -> UUID:
    user_repo = UserRepository(session)
    user = await user_repo.create(
        provider=AuthProvider.KAKAO,
        sub=sub,
        email=None,
        nickname=f"user-{sub}",
        profile_image_url=None,
    )
    return user.id


async def _create_book(session: AsyncSession, *, isbn13: str) -> UUID:
    book_repo = BookRepository(session)
    book = await book_repo.upsert_by_isbn(
        isbn13=isbn13,
        title=f"book-{isbn13[-3:]}",
        author="저자",
        publisher=None,
        cover_url=None,
        description=None,
        source=BookSource.NAVER,
    )
    return book.id


@pytest.mark.asyncio
async def test_post_create_and_list_by_book_order_desc(session: AsyncSession) -> None:
    user_id = await _create_user(session, sub="post-author")
    book_id = await _create_book(session, isbn13="9788937460111")
    repo = PostRepository(session)

    now = datetime.now(tz=UTC)
    posts = []
    for i in range(3):
        post = await repo.create(
            user_id=user_id,
            book_id=book_id,
            post_type=PostType.THOUGHT,
            content=f"post-{i}",
            image_keys=[],
        )
        # Spread created_at so ordering is unambiguous.
        post.created_at = now - timedelta(minutes=i)
        await session.flush()
        posts.append(post)

    rows = await repo.list_by_book(book_id, cursor=None, limit=10)
    # Newest first.
    assert [p.id for p in rows] == [posts[0].id, posts[1].id, posts[2].id]


@pytest.mark.asyncio
async def test_post_list_cursor_pagination_and_soft_delete_excluded(
    session: AsyncSession,
) -> None:
    user_id = await _create_user(session, sub="post-cur")
    book_id = await _create_book(session, isbn13="9788937460112")
    repo = PostRepository(session)

    now = datetime.now(tz=UTC)
    posts = []
    for i in range(5):
        post = await repo.create(
            user_id=user_id,
            book_id=book_id,
            post_type=PostType.HIGHLIGHT,
            content=f"p-{i}",
            image_keys=[f"feed/{user_id}/{i}.jpg"],
        )
        post.created_at = now - timedelta(minutes=i)
        await session.flush()
        posts.append(post)

    page1 = await repo.list_by_book(book_id, cursor=None, limit=2)
    assert [p.id for p in page1] == [posts[0].id, posts[1].id]

    page2 = await repo.list_by_book(book_id, cursor=page1[-1].created_at, limit=2)
    assert [p.id for p in page2] == [posts[2].id, posts[3].id]

    # Soft-deleting the second-page head removes it from listings.
    await repo.soft_delete(posts[2].id, datetime.now(tz=UTC))
    page2_again = await repo.list_by_book(book_id, cursor=page1[-1].created_at, limit=2)
    assert [p.id for p in page2_again] == [posts[3].id, posts[4].id]
    assert await repo.get_by_id(posts[2].id) is None


@pytest.mark.asyncio
async def test_reaction_add_is_idempotent_on_duplicate(session: AsyncSession) -> None:
    user_id = await _create_user(session, sub="rx-user")
    book_id = await _create_book(session, isbn13="9788937460113")
    posts = PostRepository(session)
    post = await posts.create(
        user_id=user_id,
        book_id=book_id,
        post_type=PostType.THOUGHT,
        content="x",
        image_keys=[],
    )

    rx = ReactionRepository(session)
    first = await rx.add(post_id=post.id, user_id=user_id, reaction_type=ReactionType.IDEA)
    second = await rx.add(post_id=post.id, user_id=user_id, reaction_type=ReactionType.IDEA)
    assert first.id == second.id


@pytest.mark.asyncio
async def test_reaction_aggregate_counts_per_type(session: AsyncSession) -> None:
    author = await _create_user(session, sub="agg-author")
    u1 = await _create_user(session, sub="agg-u1")
    u2 = await _create_user(session, sub="agg-u2")
    book_id = await _create_book(session, isbn13="9788937460114")
    posts = PostRepository(session)
    post = await posts.create(
        user_id=author,
        book_id=book_id,
        post_type=PostType.QUESTION,
        content="?",
        image_keys=[],
    )
    rx = ReactionRepository(session)

    await rx.add(post_id=post.id, user_id=u1, reaction_type=ReactionType.IDEA)
    await rx.add(post_id=post.id, user_id=u2, reaction_type=ReactionType.IDEA)
    await rx.add(post_id=post.id, user_id=u1, reaction_type=ReactionType.FIRE)

    counts = await rx.aggregate_for_post(post.id)
    assert counts[ReactionType.IDEA] == 2
    assert counts[ReactionType.FIRE] == 1
    assert ReactionType.HEART not in counts


@pytest.mark.asyncio
async def test_reaction_remove_and_reactions_by_user(session: AsyncSession) -> None:
    user_id = await _create_user(session, sub="remove-user")
    book_id = await _create_book(session, isbn13="9788937460115")
    posts = PostRepository(session)
    post = await posts.create(
        user_id=user_id,
        book_id=book_id,
        post_type=PostType.HIGHLIGHT,
        content="h",
        image_keys=[],
    )

    rx = ReactionRepository(session)
    await rx.add(post_id=post.id, user_id=user_id, reaction_type=ReactionType.CLAP)
    await rx.add(post_id=post.id, user_id=user_id, reaction_type=ReactionType.HEART)

    mine = await rx.reactions_by_user(post.id, user_id)
    assert mine == {ReactionType.CLAP, ReactionType.HEART}

    removed = await rx.remove(post_id=post.id, user_id=user_id, reaction_type=ReactionType.CLAP)
    assert removed == 1
    mine_after = await rx.reactions_by_user(post.id, user_id)
    assert mine_after == {ReactionType.HEART}


@pytest.mark.asyncio
async def test_reaction_batch_aggregates_and_my_reactions(session: AsyncSession) -> None:
    author = await _create_user(session, sub="batch-author")
    viewer = await _create_user(session, sub="batch-viewer")
    book_id = await _create_book(session, isbn13="9788937460116")
    posts = PostRepository(session)
    p1 = await posts.create(
        user_id=author,
        book_id=book_id,
        post_type=PostType.THOUGHT,
        content="1",
        image_keys=[],
    )
    p2 = await posts.create(
        user_id=author,
        book_id=book_id,
        post_type=PostType.THOUGHT,
        content="2",
        image_keys=[],
    )
    rx = ReactionRepository(session)
    await rx.add(post_id=p1.id, user_id=viewer, reaction_type=ReactionType.IDEA)
    await rx.add(post_id=p1.id, user_id=author, reaction_type=ReactionType.FIRE)
    await rx.add(post_id=p2.id, user_id=viewer, reaction_type=ReactionType.HEART)

    aggs = await rx.aggregates_for_posts([p1.id, p2.id])
    assert aggs[p1.id] == {ReactionType.IDEA: 1, ReactionType.FIRE: 1}
    assert aggs[p2.id] == {ReactionType.HEART: 1}

    mine = await rx.my_reactions_for_posts([p1.id, p2.id], viewer)
    assert mine[p1.id] == {ReactionType.IDEA}
    assert mine[p2.id] == {ReactionType.HEART}


@pytest.mark.asyncio
async def test_comment_create_root_and_reply(session: AsyncSession) -> None:
    user_id = await _create_user(session, sub="comment-user")
    book_id = await _create_book(session, isbn13="9788937460117")
    posts = PostRepository(session)
    post = await posts.create(
        user_id=user_id,
        book_id=book_id,
        post_type=PostType.DISCUSSION,
        content="d",
        image_keys=[],
    )
    comments = CommentRepository(session)

    root = await comments.create(user_id=user_id, post_id=post.id, parent_id=None, content="root")
    reply = await comments.create(
        user_id=user_id, post_id=post.id, parent_id=root.id, content="reply"
    )
    assert root.parent_id is None
    assert reply.parent_id == root.id


@pytest.mark.asyncio
async def test_comment_list_by_post_orders_asc_and_excludes_deleted(
    session: AsyncSession,
) -> None:
    user_id = await _create_user(session, sub="list-comments")
    book_id = await _create_book(session, isbn13="9788937460118")
    posts = PostRepository(session)
    post = await posts.create(
        user_id=user_id,
        book_id=book_id,
        post_type=PostType.QUESTION,
        content="q",
        image_keys=[],
    )

    comments = CommentRepository(session)
    now = datetime.now(tz=UTC)
    rows = []
    for i in range(3):
        c = await comments.create(
            user_id=user_id,
            post_id=post.id,
            parent_id=None,
            content=f"c-{i}",
        )
        c.created_at = now + timedelta(seconds=i)
        await session.flush()
        rows.append(c)

    listed = await comments.list_by_post(post.id, cursor=None, limit=10)
    assert [c.id for c in listed] == [rows[0].id, rows[1].id, rows[2].id]

    await comments.soft_delete(rows[1].id, datetime.now(tz=UTC))
    after_delete = await comments.list_by_post(post.id, cursor=None, limit=10)
    assert [c.id for c in after_delete] == [rows[0].id, rows[2].id]


@pytest.mark.asyncio
async def test_post_comment_counts_for_excludes_deleted(session: AsyncSession) -> None:
    user_id = await _create_user(session, sub="counts-user")
    book_id = await _create_book(session, isbn13="9788937460119")
    posts = PostRepository(session)
    p1 = await posts.create(
        user_id=user_id,
        book_id=book_id,
        post_type=PostType.THOUGHT,
        content="x",
        image_keys=[],
    )
    p2 = await posts.create(
        user_id=user_id,
        book_id=book_id,
        post_type=PostType.THOUGHT,
        content="y",
        image_keys=[],
    )
    comments = CommentRepository(session)
    a = await comments.create(user_id=user_id, post_id=p1.id, parent_id=None, content="a")
    await comments.create(user_id=user_id, post_id=p1.id, parent_id=None, content="b")
    await comments.create(user_id=user_id, post_id=p2.id, parent_id=None, content="c")

    counts = await posts.comment_counts_for([p1.id, p2.id])
    assert counts == {p1.id: 2, p2.id: 1}

    await comments.soft_delete(a.id, datetime.now(tz=UTC))
    counts_after = await posts.comment_counts_for([p1.id, p2.id])
    assert counts_after == {p1.id: 1, p2.id: 1}


@pytest.mark.asyncio
async def test_post_get_by_id_hides_soft_deleted(session: AsyncSession) -> None:
    user_id = await _create_user(session, sub="hide-user")
    book_id = await _create_book(session, isbn13="9788937460120")
    posts = PostRepository(session)
    post = await posts.create(
        user_id=user_id,
        book_id=book_id,
        post_type=PostType.HIGHLIGHT,
        content="content",
        image_keys=["feed/x.jpg"],
    )

    fetched = await posts.get_by_id(post.id)
    assert fetched is not None
    assert fetched.image_keys == ["feed/x.jpg"]

    await posts.soft_delete(post.id, datetime.now(tz=UTC))
    assert await posts.get_by_id(post.id) is None
    # A second soft_delete on a missing/already-gone row is a noop.
    await posts.soft_delete(uuid4(), datetime.now(tz=UTC))

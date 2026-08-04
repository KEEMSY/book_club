"""Integration tests for topic-comment repository queries (BC-46).

Verifies the structural behavior the service layer depends on:
- create_comment persists a top-level or reply comment (parent_comment_id
  optional)
- list_comments_by_topic returns rows oldest-first, scoped to the topic
- update_comment_body / delete_comment mutate/remove in place and return
  None for an unknown comment id
- deleting a top-level comment cascades to its replies (ON DELETE CASCADE on
  parent_comment_id, design §4 — the DB does this, not the service)
"""

from __future__ import annotations

from uuid import UUID, uuid4

import pytest
from app.domains.auth.models import AuthProvider
from app.domains.auth.repository import UserRepository
from app.domains.book.models import BookSource
from app.domains.book.repository import BookRepository
from app.domains.club.repository import ClubRepository
from sqlalchemy.ext.asyncio import AsyncSession


async def _setup_topic(session: AsyncSession, *, tag: str) -> tuple[UUID, UUID]:
    """Create an owner user, a book, a club, a session, an agenda, and a
    topic; return (owner_id, topic_id)."""
    user_repo = UserRepository(session)
    owner = await user_repo.create(
        provider=AuthProvider.KAKAO,
        sub=f"owner-{tag}",
        email=None,
        nickname=f"owner-{tag}",
        profile_image_url=None,
    )
    book_repo = BookRepository(session)
    book = await book_repo.upsert_by_isbn(
        isbn13=f"97889377{hash(tag) % 100000:05d}",
        title=f"book-{tag}",
        author="a",
        publisher=None,
        cover_url=None,
        description=None,
        source=BookSource.NAVER,
    )
    club_repo = ClubRepository(session)
    club = await club_repo.create(
        owner_id=owner.id,
        name=f"club-{tag}",
        description=None,
        book_id=None,
        max_members=10,
    )
    session_row = await club_repo.create_session(
        club_id=club.id,
        book_id=book.id,
        title=f"session-{tag}",
        scope=None,
        presenter_id=None,
        scheduled_at=None,
        created_by=owner.id,
    )
    agenda = await club_repo.create_agenda(
        session_id=session_row.id, author_id=owner.id, body="발제문 본문"
    )
    topic = await club_repo.create_topic(agenda_id=agenda.id, position=0, prompt="논제 1")
    return owner.id, topic.id


@pytest.mark.asyncio
async def test_create_comment_top_level_and_reply(session: AsyncSession) -> None:
    owner_id, topic_id = await _setup_topic(session, tag="create")
    repo = ClubRepository(session)

    root = await repo.create_comment(
        topic_id=topic_id, author_id=owner_id, parent_comment_id=None, body="루트 답글"
    )
    assert root.parent_comment_id is None
    assert root.edited_at is None

    reply = await repo.create_comment(
        topic_id=topic_id, author_id=owner_id, parent_comment_id=root.id, body="대댓글"
    )
    assert reply.parent_comment_id == root.id

    fetched = await repo.get_comment(root.id)
    assert fetched is not None
    assert fetched.body == "루트 답글"


@pytest.mark.asyncio
async def test_get_comment_unknown_returns_none(session: AsyncSession) -> None:
    repo = ClubRepository(session)
    assert await repo.get_comment(uuid4()) is None


@pytest.mark.asyncio
async def test_list_comments_by_topic_orders_oldest_first(session: AsyncSession) -> None:
    owner_id, topic_id = await _setup_topic(session, tag="list")
    repo = ClubRepository(session)
    first = await repo.create_comment(
        topic_id=topic_id, author_id=owner_id, parent_comment_id=None, body="첫 답글"
    )
    second = await repo.create_comment(
        topic_id=topic_id, author_id=owner_id, parent_comment_id=None, body="둘째 답글"
    )

    rows = await repo.list_comments_by_topic(topic_id)

    assert [r.id for r in rows] == [first.id, second.id]


@pytest.mark.asyncio
async def test_list_comments_by_topic_scoped_to_topic(session: AsyncSession) -> None:
    owner_id, topic_id = await _setup_topic(session, tag="scope-a")
    _other_owner, other_topic_id = await _setup_topic(session, tag="scope-b")
    repo = ClubRepository(session)
    await repo.create_comment(
        topic_id=topic_id, author_id=owner_id, parent_comment_id=None, body="topic A"
    )
    await repo.create_comment(
        topic_id=other_topic_id, author_id=owner_id, parent_comment_id=None, body="topic B"
    )

    rows = await repo.list_comments_by_topic(topic_id)

    assert [r.body for r in rows] == ["topic A"]


@pytest.mark.asyncio
async def test_update_comment_body(session: AsyncSession) -> None:
    owner_id, topic_id = await _setup_topic(session, tag="update")
    repo = ClubRepository(session)
    comment = await repo.create_comment(
        topic_id=topic_id, author_id=owner_id, parent_comment_id=None, body="초안"
    )

    from datetime import datetime

    edited_at = datetime.now()
    updated = await repo.update_comment_body(comment.id, "수정된 답글", edited_at=edited_at)

    assert updated is not None
    assert updated.body == "수정된 답글"
    assert updated.edited_at == edited_at
    assert await repo.update_comment_body(uuid4(), "x", edited_at=edited_at) is None


@pytest.mark.asyncio
async def test_delete_comment_cascades_to_replies(session: AsyncSession) -> None:
    owner_id, topic_id = await _setup_topic(session, tag="delete")
    repo = ClubRepository(session)
    root = await repo.create_comment(
        topic_id=topic_id, author_id=owner_id, parent_comment_id=None, body="루트"
    )
    reply = await repo.create_comment(
        topic_id=topic_id, author_id=owner_id, parent_comment_id=root.id, body="대댓글"
    )
    root_id, reply_id = root.id, reply.id

    await repo.delete_comment(root_id)
    # The reply's DB row is removed by CASCADE, but SQLAlchemy never inspects
    # FK constraints — the ORM has no way to know a row it didn't directly
    # target vanished, so its identity map still holds the stale object.
    # Expire so get_comment() below re-queries the DB instead of returning it
    # (ids were captured above — touching an expired instance's attributes
    # would itself trigger a synchronous, un-awaited refresh).
    await session.run_sync(lambda sync_session: sync_session.expire_all())

    assert await repo.get_comment(root_id) is None
    # ON DELETE CASCADE on parent_comment_id (design §4) removes the reply too.
    assert await repo.get_comment(reply_id) is None


@pytest.mark.asyncio
async def test_delete_comment_unknown_is_noop(session: AsyncSession) -> None:
    repo = ClubRepository(session)
    await repo.delete_comment(uuid4())  # must not raise

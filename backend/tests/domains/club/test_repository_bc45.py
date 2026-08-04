"""Integration tests for session-agenda/topic repository queries (BC-45).

Verifies the structural behavior the service layer depends on:
- create_agenda defaults to draft status with no published_at
- get_agenda_with_topics / list_agendas_by_session eager-load topics via
  selectinload (no N+1) and topics come back ordered by position
- update_agenda_body / publish_agenda mutate in place, return None for an
  unknown agenda id
- create_topic / update_topic_prompt / delete_topic / reorder_topics mutate
  agenda_topics rows and reorder_topics reassigns positions per the given
  topic-id order
"""

from __future__ import annotations

from uuid import UUID, uuid4

import pytest
from app.domains.auth.models import AuthProvider
from app.domains.auth.repository import UserRepository
from app.domains.book.models import BookSource
from app.domains.book.repository import BookRepository
from app.domains.club.models import AgendaStatus
from app.domains.club.repository import ClubRepository
from sqlalchemy.ext.asyncio import AsyncSession


async def _setup_session(session: AsyncSession, *, tag: str) -> tuple[UUID, UUID]:
    """Create an owner user, a book, a club, and a club session; return (owner_id, session_id)."""
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
        isbn13=f"97889376{hash(tag) % 100000:05d}",
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
    return owner.id, session_row.id


@pytest.mark.asyncio
async def test_create_agenda_defaults_to_draft(session: AsyncSession) -> None:
    owner_id, session_id = await _setup_session(session, tag="create")
    repo = ClubRepository(session)

    agenda = await repo.create_agenda(session_id=session_id, author_id=owner_id, body="발제문 본문")

    assert agenda.status == AgendaStatus.DRAFT
    assert agenda.published_at is None
    fetched = await repo.get_agenda(agenda.id)
    assert fetched is not None
    assert fetched.body == "발제문 본문"
    assert fetched.session_id == session_id


@pytest.mark.asyncio
async def test_get_agenda_unknown_returns_none(session: AsyncSession) -> None:
    repo = ClubRepository(session)
    assert await repo.get_agenda(uuid4()) is None


@pytest.mark.asyncio
async def test_get_agenda_with_topics_eager_loads(session: AsyncSession) -> None:
    owner_id, session_id = await _setup_session(session, tag="eager")
    repo = ClubRepository(session)
    agenda = await repo.create_agenda(session_id=session_id, author_id=owner_id, body="본문")
    await repo.create_topic(agenda_id=agenda.id, position=1, prompt="논제 2")
    await repo.create_topic(agenda_id=agenda.id, position=0, prompt="논제 1")

    fetched = await repo.get_agenda_with_topics(agenda.id)

    assert fetched is not None
    assert [t.prompt for t in fetched.topics] == ["논제 1", "논제 2"]


@pytest.mark.asyncio
async def test_list_agendas_by_session_orders_oldest_first(session: AsyncSession) -> None:
    owner_id, session_id = await _setup_session(session, tag="list")
    repo = ClubRepository(session)
    first = await repo.create_agenda(session_id=session_id, author_id=owner_id, body="첫 발제문")
    second = await repo.create_agenda(session_id=session_id, author_id=owner_id, body="둘째 발제문")

    rows = await repo.list_agendas_by_session(session_id)

    assert [r.id for r in rows] == [first.id, second.id]


@pytest.mark.asyncio
async def test_update_agenda_body_and_publish(session: AsyncSession) -> None:
    owner_id, session_id = await _setup_session(session, tag="update")
    repo = ClubRepository(session)
    agenda = await repo.create_agenda(session_id=session_id, author_id=owner_id, body="초안")

    updated = await repo.update_agenda_body(agenda.id, "수정된 본문")
    assert updated is not None
    assert updated.body == "수정된 본문"

    from datetime import datetime

    published_at = datetime.now()
    published = await repo.publish_agenda(agenda.id, published_at=published_at)
    assert published is not None
    assert published.status == AgendaStatus.PUBLISHED
    assert published.published_at == published_at

    assert await repo.update_agenda_body(uuid4(), "x") is None
    assert await repo.publish_agenda(uuid4(), published_at=published_at) is None


@pytest.mark.asyncio
async def test_topic_crud_and_position_helpers(session: AsyncSession) -> None:
    owner_id, session_id = await _setup_session(session, tag="topic")
    repo = ClubRepository(session)
    agenda = await repo.create_agenda(session_id=session_id, author_id=owner_id, body="본문")

    assert await repo.get_next_topic_position(agenda.id) == 0
    topic_a = await repo.create_topic(agenda_id=agenda.id, position=0, prompt="A")
    assert await repo.get_next_topic_position(agenda.id) == 1
    topic_b = await repo.create_topic(agenda_id=agenda.id, position=1, prompt="B")

    rows = await repo.list_topics_by_agenda(agenda.id)
    assert [r.id for r in rows] == [topic_a.id, topic_b.id]

    updated = await repo.update_topic_prompt(topic_a.id, "A 수정")
    assert updated is not None
    assert updated.prompt == "A 수정"
    assert await repo.update_topic_prompt(uuid4(), "x") is None

    await repo.delete_topic(topic_b.id)
    remaining = await repo.list_topics_by_agenda(agenda.id)
    assert [r.id for r in remaining] == [topic_a.id]


@pytest.mark.asyncio
async def test_reorder_topics_reassigns_positions(session: AsyncSession) -> None:
    owner_id, session_id = await _setup_session(session, tag="reorder")
    repo = ClubRepository(session)
    agenda = await repo.create_agenda(session_id=session_id, author_id=owner_id, body="본문")
    topic_a = await repo.create_topic(agenda_id=agenda.id, position=0, prompt="A")
    topic_b = await repo.create_topic(agenda_id=agenda.id, position=1, prompt="B")
    topic_c = await repo.create_topic(agenda_id=agenda.id, position=2, prompt="C")

    reordered = await repo.reorder_topics(agenda.id, [topic_c.id, topic_a.id, topic_b.id])

    assert [t.id for t in reordered] == [topic_c.id, topic_a.id, topic_b.id]
    assert [t.position for t in reordered] == [0, 1, 2]

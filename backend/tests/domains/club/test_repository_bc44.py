"""Integration tests for club session repository queries (BC-44).

Verifies the structural behavior the service layer depends on:
- create_session defaults to draft status
- list_sessions orders by book_id then created_at desc (책별 그룹 목록),
  and its book_id filter narrows to one book
- update_session_status / update_session_presenter mutate in place and
  return None for an unknown session id
"""

from __future__ import annotations

from uuid import UUID

import pytest
from app.domains.auth.models import AuthProvider
from app.domains.auth.repository import UserRepository
from app.domains.book.models import BookSource
from app.domains.book.repository import BookRepository
from app.domains.club.models import SessionStatus
from app.domains.club.repository import ClubRepository
from sqlalchemy.ext.asyncio import AsyncSession


async def _setup_club_with_book(session: AsyncSession, *, tag: str) -> tuple[UUID, UUID, UUID]:
    """Create an owner user, a book, and a club owned by that user."""
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
        isbn13=f"97889375{hash(tag) % 100000:05d}",
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
    return owner.id, book.id, club.id


@pytest.mark.asyncio
async def test_create_session_defaults_to_draft(session: AsyncSession) -> None:
    owner_id, book_id, club_id = await _setup_club_with_book(session, tag="create")
    repo = ClubRepository(session)

    row = await repo.create_session(
        club_id=club_id,
        book_id=book_id,
        title="1장~3장",
        scope="1장~3장 발제",
        presenter_id=None,
        scheduled_at=None,
        created_by=owner_id,
    )

    assert row.status == SessionStatus.DRAFT
    fetched = await repo.get_session(row.id)
    assert fetched is not None
    assert fetched.title == "1장~3장"
    assert fetched.club_id == club_id
    assert fetched.book_id == book_id


@pytest.mark.asyncio
async def test_get_session_unknown_returns_none(session: AsyncSession) -> None:
    from uuid import uuid4

    repo = ClubRepository(session)
    assert await repo.get_session(uuid4()) is None


@pytest.mark.asyncio
async def test_list_sessions_orders_by_book_and_filters(session: AsyncSession) -> None:
    owner_id, book_id, club_id = await _setup_club_with_book(session, tag="list")
    book_repo = BookRepository(session)
    other_book = await book_repo.upsert_by_isbn(
        isbn13="9788937598888",
        title="other book",
        author="b",
        publisher=None,
        cover_url=None,
        description=None,
        source=BookSource.NAVER,
    )
    repo = ClubRepository(session)
    session_a = await repo.create_session(
        club_id=club_id,
        book_id=book_id,
        title="A",
        scope=None,
        presenter_id=None,
        scheduled_at=None,
        created_by=owner_id,
    )
    session_b = await repo.create_session(
        club_id=club_id,
        book_id=other_book.id,
        title="B",
        scope=None,
        presenter_id=None,
        scheduled_at=None,
        created_by=owner_id,
    )

    rows = await repo.list_sessions(club_id)
    assert {r.id for r in rows} == {session_a.id, session_b.id}

    filtered = await repo.list_sessions(club_id, book_id=book_id)
    assert [r.id for r in filtered] == [session_a.id]


@pytest.mark.asyncio
async def test_update_session_status_and_presenter(session: AsyncSession) -> None:
    from uuid import uuid4

    owner_id, book_id, club_id = await _setup_club_with_book(session, tag="update")
    repo = ClubRepository(session)
    row = await repo.create_session(
        club_id=club_id,
        book_id=book_id,
        title="A",
        scope=None,
        presenter_id=None,
        scheduled_at=None,
        created_by=owner_id,
    )

    updated_status = await repo.update_session_status(row.id, SessionStatus.OPEN)
    assert updated_status is not None
    assert updated_status.status == SessionStatus.OPEN

    updated_presenter = await repo.update_session_presenter(row.id, owner_id)
    assert updated_presenter is not None
    assert updated_presenter.presenter_id == owner_id

    cleared = await repo.update_session_presenter(row.id, None)
    assert cleared is not None
    assert cleared.presenter_id is None

    assert await repo.update_session_status(uuid4(), SessionStatus.CLOSED) is None
    assert await repo.update_session_presenter(uuid4(), owner_id) is None

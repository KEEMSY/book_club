"""Unit tests for ClubService — BC-45 (session agendas & topics).

Covers:
- create_agenda / update_agenda / publish_agenda: host-or-presenter-of-session
  permission (design §5 row 2), draft->published transition + published_at,
  rejects re-publish.
- list_agendas / get_agenda: member access, public-club open access, private
  club non-member rejection.
- add_topic / update_topic / delete_topic / reorder_topics: agenda-author-only
  permission (design §5 row 3 — narrower than "host or presenter of session";
  it is whoever actually authored *this* agenda), position assignment on
  append, and full-set validation on reorder.

Uses an in-memory fake repository — no DB required.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError, NotFoundError, PermissionDeniedError
from app.domains.club.models import AgendaStatus, ClubRole
from app.domains.club.repository import AgendaWithContext
from app.domains.club.schemas import (
    AgendaTopicCreate,
    AgendaTopicUpdate,
    SessionAgendaCreate,
    SessionAgendaUpdate,
)
from app.domains.club.service import ClubService

# ---------------------------------------------------------------------------
# Fake domain objects
# ---------------------------------------------------------------------------


@dataclass
class _FakeClub:
    id: UUID = field(default_factory=uuid4)
    owner_id: UUID = field(default_factory=uuid4)
    is_public: bool = False
    name: str = "테스트 모임"


@dataclass
class _FakeSession:
    id: UUID
    club_id: UUID
    presenter_id: UUID | None = None
    title: str = "1회차"


@dataclass
class _FakeTopic:
    id: UUID
    agenda_id: UUID
    position: int
    prompt: str
    created_at: datetime = field(default_factory=datetime.now)


@dataclass
class _FakeAgenda:
    id: UUID
    session_id: UUID
    author_id: UUID
    body: str
    status: str = AgendaStatus.DRAFT
    published_at: datetime | None = None
    created_at: datetime = field(default_factory=datetime.now)
    topics: list[_FakeTopic] = field(default_factory=list)


# ---------------------------------------------------------------------------
# Fake repository (subset of ClubRepository used by BC-45 service methods)
# ---------------------------------------------------------------------------


class FakeClubRepository:
    def __init__(self) -> None:
        self._clubs: dict[UUID, _FakeClub] = {}
        self._members: dict[tuple[UUID, UUID], str] = {}
        self._sessions: dict[UUID, _FakeSession] = {}
        self._agendas: dict[UUID, _FakeAgenda] = {}
        self._topics: dict[UUID, _FakeTopic] = {}

    # --- test helpers ---

    def add_club(self, *, owner_id: UUID | None = None, is_public: bool = False) -> _FakeClub:
        owner_id = owner_id if owner_id is not None else uuid4()
        club = _FakeClub(owner_id=owner_id, is_public=is_public)
        self._clubs[club.id] = club
        self._members[(club.id, owner_id)] = ClubRole.OWNER
        return club

    def add_member(self, club_id: UUID, user_id: UUID, *, role: str = ClubRole.MEMBER) -> None:
        self._members[(club_id, user_id)] = role

    def add_session(self, club_id: UUID, *, presenter_id: UUID | None = None) -> _FakeSession:
        session_row = _FakeSession(id=uuid4(), club_id=club_id, presenter_id=presenter_id)
        self._sessions[session_row.id] = session_row
        return session_row

    # --- ClubRepository interface ---

    async def get_by_id(self, club_id: UUID) -> _FakeClub | None:
        return self._clubs.get(club_id)

    async def is_member(self, club_id: UUID, user_id: UUID) -> bool:
        return (club_id, user_id) in self._members

    async def get_member_role(self, club_id: UUID, user_id: UUID) -> str | None:
        return self._members.get((club_id, user_id))

    async def get_session(self, session_id: UUID) -> _FakeSession | None:
        return self._sessions.get(session_id)

    async def create_agenda(self, *, session_id: UUID, author_id: UUID, body: str) -> _FakeAgenda:
        agenda = _FakeAgenda(id=uuid4(), session_id=session_id, author_id=author_id, body=body)
        self._agendas[agenda.id] = agenda
        return agenda

    async def get_agenda(self, agenda_id: UUID) -> _FakeAgenda | None:
        return self._agendas.get(agenda_id)

    async def get_agenda_with_topics(self, agenda_id: UUID) -> _FakeAgenda | None:
        return self._agendas.get(agenda_id)

    async def list_agendas_by_session(self, session_id: UUID) -> list[_FakeAgenda]:
        rows = [a for a in self._agendas.values() if a.session_id == session_id]
        rows.sort(key=lambda a: a.created_at)
        return rows

    async def list_agendas_by_author(
        self, user_id: UUID, *, limit: int, offset: int
    ) -> list[AgendaWithContext]:
        rows = [a for a in self._agendas.values() if a.author_id == user_id]
        rows.sort(key=lambda a: a.created_at, reverse=True)
        page = rows[offset : offset + limit]
        out: list[AgendaWithContext] = []
        for agenda in page:
            session_row = self._sessions[agenda.session_id]
            club = self._clubs[session_row.club_id]
            out.append(
                AgendaWithContext(
                    agenda=agenda,  # type: ignore[arg-type]
                    club_id=club.id,
                    club_name=club.name,
                    session_title=session_row.title,
                )
            )
        return out

    async def count_agendas_by_author(self, user_id: UUID) -> int:
        return len([a for a in self._agendas.values() if a.author_id == user_id])

    async def update_agenda_body(self, agenda_id: UUID, body: str) -> _FakeAgenda | None:
        agenda = self._agendas.get(agenda_id)
        if agenda is None:
            return None
        agenda.body = body
        return agenda

    async def publish_agenda(
        self, agenda_id: UUID, *, published_at: datetime
    ) -> _FakeAgenda | None:
        agenda = self._agendas.get(agenda_id)
        if agenda is None:
            return None
        agenda.status = AgendaStatus.PUBLISHED
        agenda.published_at = published_at
        return agenda

    async def create_topic(self, *, agenda_id: UUID, position: int, prompt: str) -> _FakeTopic:
        topic = _FakeTopic(id=uuid4(), agenda_id=agenda_id, position=position, prompt=prompt)
        self._topics[topic.id] = topic
        agenda = self._agendas.get(agenda_id)
        if agenda is not None:
            agenda.topics.append(topic)
        return topic

    async def get_topic(self, topic_id: UUID) -> _FakeTopic | None:
        return self._topics.get(topic_id)

    async def list_topics_by_agenda(self, agenda_id: UUID) -> list[_FakeTopic]:
        rows = [t for t in self._topics.values() if t.agenda_id == agenda_id]
        rows.sort(key=lambda t: t.position)
        return rows

    async def get_next_topic_position(self, agenda_id: UUID) -> int:
        rows = await self.list_topics_by_agenda(agenda_id)
        return 0 if not rows else max(t.position for t in rows) + 1

    async def update_topic_prompt(self, topic_id: UUID, prompt: str) -> _FakeTopic | None:
        topic = self._topics.get(topic_id)
        if topic is None:
            return None
        topic.prompt = prompt
        return topic

    async def delete_topic(self, topic_id: UUID) -> None:
        topic = self._topics.pop(topic_id, None)
        if topic is not None:
            agenda = self._agendas.get(topic.agenda_id)
            if agenda is not None:
                agenda.topics = [t for t in agenda.topics if t.id != topic_id]

    async def reorder_topics(self, agenda_id: UUID, topic_id_order: list[UUID]) -> list[_FakeTopic]:
        rows = await self.list_topics_by_agenda(agenda_id)
        by_id = {t.id: t for t in rows}
        for position, topic_id in enumerate(topic_id_order):
            topic = by_id.get(topic_id)
            if topic is not None:
                topic.position = position
        return await self.list_topics_by_agenda(agenda_id)


# ---------------------------------------------------------------------------
# Factory
# ---------------------------------------------------------------------------


def _svc() -> tuple[ClubService, FakeClubRepository]:
    repo = FakeClubRepository()
    return ClubService(repo=repo), repo  # type: ignore[arg-type]


# ---------------------------------------------------------------------------
# create_agenda
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_create_agenda_success_by_host() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)

    result = await svc.create_agenda(
        club_id=club.id,
        session_id=session_row.id,
        user_id=owner,
        req=SessionAgendaCreate(body="발제문 본문"),
    )

    assert result.session_id == session_row.id
    assert result.author_id == owner
    assert result.status == AgendaStatus.DRAFT
    assert result.published_at is None
    assert result.topics == []


@pytest.mark.asyncio
async def test_create_agenda_success_by_presenter() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    presenter = uuid4()
    repo.add_member(club.id, presenter)
    session_row = repo.add_session(club.id, presenter_id=presenter)

    result = await svc.create_agenda(
        club_id=club.id,
        session_id=session_row.id,
        user_id=presenter,
        req=SessionAgendaCreate(body="발제문 본문"),
    )

    assert result.author_id == presenter


@pytest.mark.asyncio
async def test_create_agenda_rejects_non_host_non_presenter() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    member = uuid4()
    repo.add_member(club.id, member)
    session_row = repo.add_session(club.id)

    with pytest.raises(PermissionDeniedError):
        await svc.create_agenda(
            club_id=club.id,
            session_id=session_row.id,
            user_id=member,
            req=SessionAgendaCreate(body="본문"),
        )


@pytest.mark.asyncio
async def test_create_agenda_unknown_session_rejected() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)

    with pytest.raises(NotFoundError):
        await svc.create_agenda(
            club_id=club.id,
            session_id=uuid4(),
            user_id=owner,
            req=SessionAgendaCreate(body="본문"),
        )


@pytest.mark.asyncio
async def test_create_agenda_unknown_club_rejected() -> None:
    svc, _repo = _svc()

    with pytest.raises(NotFoundError):
        await svc.create_agenda(
            club_id=uuid4(),
            session_id=uuid4(),
            user_id=uuid4(),
            req=SessionAgendaCreate(body="본문"),
        )


# ---------------------------------------------------------------------------
# update_agenda / publish_agenda
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_update_agenda_by_presenter_allowed() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    presenter = uuid4()
    repo.add_member(club.id, presenter)
    session_row = repo.add_session(club.id, presenter_id=presenter)
    created = await svc.create_agenda(
        club_id=club.id,
        session_id=session_row.id,
        user_id=owner,
        req=SessionAgendaCreate(body="초안"),
    )

    updated = await svc.update_agenda(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=created.id,
        user_id=presenter,
        req=SessionAgendaUpdate(body="수정된 본문"),
    )

    assert updated.body == "수정된 본문"


@pytest.mark.asyncio
async def test_update_agenda_rejects_non_host_non_presenter() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    member = uuid4()
    repo.add_member(club.id, member)
    session_row = repo.add_session(club.id)
    created = await svc.create_agenda(
        club_id=club.id,
        session_id=session_row.id,
        user_id=owner,
        req=SessionAgendaCreate(body="초안"),
    )

    with pytest.raises(PermissionDeniedError):
        await svc.update_agenda(
            club_id=club.id,
            session_id=session_row.id,
            agenda_id=created.id,
            user_id=member,
            req=SessionAgendaUpdate(body="수정 시도"),
        )


@pytest.mark.asyncio
async def test_update_agenda_unknown_agenda_rejected() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)

    with pytest.raises(NotFoundError):
        await svc.update_agenda(
            club_id=club.id,
            session_id=session_row.id,
            agenda_id=uuid4(),
            user_id=owner,
            req=SessionAgendaUpdate(body="수정 시도"),
        )


@pytest.mark.asyncio
async def test_publish_agenda_sets_status_and_published_at() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)
    created = await svc.create_agenda(
        club_id=club.id,
        session_id=session_row.id,
        user_id=owner,
        req=SessionAgendaCreate(body="초안"),
    )
    assert created.status == AgendaStatus.DRAFT
    assert created.published_at is None

    published = await svc.publish_agenda(
        club_id=club.id, session_id=session_row.id, agenda_id=created.id, user_id=owner
    )

    assert published.status == AgendaStatus.PUBLISHED
    assert published.published_at is not None


@pytest.mark.asyncio
async def test_publish_agenda_rejects_already_published() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)
    created = await svc.create_agenda(
        club_id=club.id,
        session_id=session_row.id,
        user_id=owner,
        req=SessionAgendaCreate(body="초안"),
    )
    await svc.publish_agenda(
        club_id=club.id, session_id=session_row.id, agenda_id=created.id, user_id=owner
    )

    with pytest.raises(ConflictError) as exc:
        await svc.publish_agenda(
            club_id=club.id, session_id=session_row.id, agenda_id=created.id, user_id=owner
        )
    assert exc.value.code == "ALREADY_PUBLISHED"


@pytest.mark.asyncio
async def test_publish_agenda_rejects_non_host_non_presenter() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    member = uuid4()
    repo.add_member(club.id, member)
    session_row = repo.add_session(club.id)
    created = await svc.create_agenda(
        club_id=club.id,
        session_id=session_row.id,
        user_id=owner,
        req=SessionAgendaCreate(body="초안"),
    )

    with pytest.raises(PermissionDeniedError):
        await svc.publish_agenda(
            club_id=club.id, session_id=session_row.id, agenda_id=created.id, user_id=member
        )


# ---------------------------------------------------------------------------
# list_agendas / get_agenda
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_list_agendas_private_club_rejects_non_member() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner, is_public=False)
    session_row = repo.add_session(club.id)
    stranger = uuid4()

    with pytest.raises(PermissionDeniedError):
        await svc.list_agendas(club_id=club.id, session_id=session_row.id, caller_user_id=stranger)


@pytest.mark.asyncio
async def test_list_agendas_public_club_allows_non_member() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner, is_public=True)
    session_row = repo.add_session(club.id)
    await svc.create_agenda(
        club_id=club.id,
        session_id=session_row.id,
        user_id=owner,
        req=SessionAgendaCreate(body="본문"),
    )
    stranger = uuid4()

    items = await svc.list_agendas(
        club_id=club.id, session_id=session_row.id, caller_user_id=stranger
    )

    assert len(items) == 1


@pytest.mark.asyncio
async def test_get_agenda_member_allowed() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner, is_public=False)
    session_row = repo.add_session(club.id)
    created = await svc.create_agenda(
        club_id=club.id,
        session_id=session_row.id,
        user_id=owner,
        req=SessionAgendaCreate(body="본문"),
    )

    result = await svc.get_agenda(
        club_id=club.id, session_id=session_row.id, agenda_id=created.id, caller_user_id=owner
    )

    assert result.id == created.id


@pytest.mark.asyncio
async def test_get_agenda_unknown_rejected() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)

    with pytest.raises(NotFoundError):
        await svc.get_agenda(
            club_id=club.id, session_id=session_row.id, agenda_id=uuid4(), caller_user_id=owner
        )


# ---------------------------------------------------------------------------
# topics
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_add_topic_by_agenda_author_success() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)
    created = await svc.create_agenda(
        club_id=club.id,
        session_id=session_row.id,
        user_id=owner,
        req=SessionAgendaCreate(body="본문"),
    )

    topic = await svc.add_topic(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=created.id,
        user_id=owner,
        req=AgendaTopicCreate(prompt="논제 1"),
    )

    assert topic.position == 0
    assert topic.prompt == "논제 1"


@pytest.mark.asyncio
async def test_add_topic_rejects_non_author() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    presenter = uuid4()
    repo.add_member(club.id, presenter)
    session_row = repo.add_session(club.id, presenter_id=presenter)
    # Owner authors the agenda even though a presenter is assigned to the
    # session — topic permission narrows to the agenda's actual author
    # (design §5 row 3), not "host or presenter of the session" generally.
    created = await svc.create_agenda(
        club_id=club.id,
        session_id=session_row.id,
        user_id=owner,
        req=SessionAgendaCreate(body="본문"),
    )

    with pytest.raises(PermissionDeniedError):
        await svc.add_topic(
            club_id=club.id,
            session_id=session_row.id,
            agenda_id=created.id,
            user_id=presenter,
            req=AgendaTopicCreate(prompt="논제 시도"),
        )


@pytest.mark.asyncio
async def test_add_topic_appends_after_existing_positions() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)
    created = await svc.create_agenda(
        club_id=club.id,
        session_id=session_row.id,
        user_id=owner,
        req=SessionAgendaCreate(body="본문"),
    )
    await svc.add_topic(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=created.id,
        user_id=owner,
        req=AgendaTopicCreate(prompt="논제 1"),
    )

    second = await svc.add_topic(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=created.id,
        user_id=owner,
        req=AgendaTopicCreate(prompt="논제 2"),
    )

    assert second.position == 1


@pytest.mark.asyncio
async def test_update_topic_success() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)
    created = await svc.create_agenda(
        club_id=club.id,
        session_id=session_row.id,
        user_id=owner,
        req=SessionAgendaCreate(body="본문"),
    )
    topic = await svc.add_topic(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=created.id,
        user_id=owner,
        req=AgendaTopicCreate(prompt="원본"),
    )

    updated = await svc.update_topic(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=created.id,
        topic_id=topic.id,
        user_id=owner,
        req=AgendaTopicUpdate(prompt="수정됨"),
    )

    assert updated.prompt == "수정됨"


@pytest.mark.asyncio
async def test_update_topic_rejects_non_author() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)
    created = await svc.create_agenda(
        club_id=club.id,
        session_id=session_row.id,
        user_id=owner,
        req=SessionAgendaCreate(body="본문"),
    )
    topic = await svc.add_topic(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=created.id,
        user_id=owner,
        req=AgendaTopicCreate(prompt="원본"),
    )
    stranger = uuid4()

    with pytest.raises(PermissionDeniedError):
        await svc.update_topic(
            club_id=club.id,
            session_id=session_row.id,
            agenda_id=created.id,
            topic_id=topic.id,
            user_id=stranger,
            req=AgendaTopicUpdate(prompt="수정 시도"),
        )


@pytest.mark.asyncio
async def test_delete_topic_success() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)
    created = await svc.create_agenda(
        club_id=club.id,
        session_id=session_row.id,
        user_id=owner,
        req=SessionAgendaCreate(body="본문"),
    )
    topic = await svc.add_topic(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=created.id,
        user_id=owner,
        req=AgendaTopicCreate(prompt="논제"),
    )

    await svc.delete_topic(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=created.id,
        topic_id=topic.id,
        user_id=owner,
    )

    remaining = await repo.list_topics_by_agenda(created.id)
    assert remaining == []


@pytest.mark.asyncio
async def test_delete_topic_rejects_non_author() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)
    created = await svc.create_agenda(
        club_id=club.id,
        session_id=session_row.id,
        user_id=owner,
        req=SessionAgendaCreate(body="본문"),
    )
    topic = await svc.add_topic(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=created.id,
        user_id=owner,
        req=AgendaTopicCreate(prompt="논제"),
    )
    stranger = uuid4()

    with pytest.raises(PermissionDeniedError):
        await svc.delete_topic(
            club_id=club.id,
            session_id=session_row.id,
            agenda_id=created.id,
            topic_id=topic.id,
            user_id=stranger,
        )


@pytest.mark.asyncio
async def test_reorder_topics_success() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)
    created = await svc.create_agenda(
        club_id=club.id,
        session_id=session_row.id,
        user_id=owner,
        req=SessionAgendaCreate(body="본문"),
    )
    t1 = await svc.add_topic(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=created.id,
        user_id=owner,
        req=AgendaTopicCreate(prompt="A"),
    )
    t2 = await svc.add_topic(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=created.id,
        user_id=owner,
        req=AgendaTopicCreate(prompt="B"),
    )

    reordered = await svc.reorder_topics(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=created.id,
        user_id=owner,
        topic_ids=[t2.id, t1.id],
    )

    assert [t.id for t in reordered] == [t2.id, t1.id]
    assert reordered[0].position == 0
    assert reordered[1].position == 1


@pytest.mark.asyncio
async def test_reorder_topics_rejects_mismatched_set() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)
    created = await svc.create_agenda(
        club_id=club.id,
        session_id=session_row.id,
        user_id=owner,
        req=SessionAgendaCreate(body="본문"),
    )
    t1 = await svc.add_topic(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=created.id,
        user_id=owner,
        req=AgendaTopicCreate(prompt="A"),
    )

    with pytest.raises(ConflictError) as exc:
        await svc.reorder_topics(
            club_id=club.id,
            session_id=session_row.id,
            agenda_id=created.id,
            user_id=owner,
            topic_ids=[t1.id, uuid4()],
        )
    assert exc.value.code == "INVALID_TOPIC_SET"


@pytest.mark.asyncio
async def test_reorder_topics_rejects_non_author() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)
    created = await svc.create_agenda(
        club_id=club.id,
        session_id=session_row.id,
        user_id=owner,
        req=SessionAgendaCreate(body="본문"),
    )
    t1 = await svc.add_topic(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=created.id,
        user_id=owner,
        req=AgendaTopicCreate(prompt="A"),
    )
    stranger = uuid4()

    with pytest.raises(PermissionDeniedError):
        await svc.reorder_topics(
            club_id=club.id,
            session_id=session_row.id,
            agenda_id=created.id,
            user_id=stranger,
            topic_ids=[t1.id],
        )


# ---------------------------------------------------------------------------
# list_my_agendas (BC-80 — GET /clubs/me/agendas)
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_list_my_agendas_newest_first_with_club_session_context() -> None:
    svc, repo = _svc()
    author = uuid4()
    club = repo.add_club(owner_id=author)
    session_row = repo.add_session(club.id)
    older = await svc.create_agenda(
        club_id=club.id,
        session_id=session_row.id,
        user_id=author,
        req=SessionAgendaCreate(body="첫 발제문"),
    )
    repo._agendas[older.id].created_at = datetime(2026, 1, 1)
    newer = await svc.create_agenda(
        club_id=club.id,
        session_id=session_row.id,
        user_id=author,
        req=SessionAgendaCreate(body="둘째 발제문"),
    )
    repo._agendas[newer.id].created_at = datetime(2026, 6, 1)

    total, items = await svc.list_my_agendas(user_id=author)

    assert total == 2
    assert [i.id for i in items] == [newer.id, older.id]
    assert items[0].club_id == club.id
    assert items[0].club_name == club.name
    assert items[0].session_title == session_row.title


@pytest.mark.asyncio
async def test_list_my_agendas_excludes_other_authors() -> None:
    svc, repo = _svc()
    author, other = uuid4(), uuid4()
    club = repo.add_club(owner_id=author)
    repo.add_member(club.id, other)
    session_row = repo.add_session(club.id)
    other_session = repo.add_session(club.id, presenter_id=other)
    mine = await svc.create_agenda(
        club_id=club.id,
        session_id=session_row.id,
        user_id=author,
        req=SessionAgendaCreate(body="내 발제문"),
    )
    await svc.create_agenda(
        club_id=club.id,
        session_id=other_session.id,
        user_id=other,
        req=SessionAgendaCreate(body="남의 발제문"),
    )

    total, items = await svc.list_my_agendas(user_id=author)

    assert total == 1
    assert [i.id for i in items] == [mine.id]


@pytest.mark.asyncio
async def test_list_my_agendas_empty_when_none() -> None:
    svc, _repo = _svc()
    total, items = await svc.list_my_agendas(user_id=uuid4())
    assert total == 0
    assert items == []

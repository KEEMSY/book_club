"""Unit tests for ClubService — BC-47 (feed integration for session/agenda/discussion).

Covers (design §6.1):
- transition_session_status(status="open") records a session_opened event
  with {club_id, session_id, book_id}; transitioning to "closed" does not.
- publish_agenda records an agenda_published event with
  {club_id, session_id, agenda_id}.
- add_comment records a discussion_commented event with
  {club_id, session_id, agenda_id, topic_id, comment_id, parent_comment_id},
  correctly carrying a None or a set parent_comment_id.
- feed_service=None is a silent no-op for all three hooks — the primary
  write still succeeds.

Uses an in-memory fake repository and a fake FeedClubPort — no DB required.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime
from uuid import UUID, uuid4

import pytest
from app.domains.club.models import AgendaStatus, ClubRole, SessionStatus
from app.domains.club.schemas import TopicCommentCreate
from app.domains.club.service import ClubService

# ---------------------------------------------------------------------------
# Fake domain objects
# ---------------------------------------------------------------------------


@dataclass
class _FakeClub:
    id: UUID = field(default_factory=uuid4)
    owner_id: UUID = field(default_factory=uuid4)
    is_public: bool = False


@dataclass
class _FakeSession:
    id: UUID
    club_id: UUID
    book_id: UUID
    title: str = "회차"
    scope: str | None = None
    presenter_id: UUID | None = None
    scheduled_at: datetime | None = None
    status: str = SessionStatus.DRAFT
    created_by: UUID = field(default_factory=uuid4)
    created_at: datetime = field(default_factory=datetime.now)


@dataclass
class _FakeAgenda:
    id: UUID
    session_id: UUID
    author_id: UUID
    body: str = "발제문"
    status: str = AgendaStatus.DRAFT
    published_at: datetime | None = None
    created_at: datetime = field(default_factory=datetime.now)


@dataclass
class _FakeTopic:
    id: UUID
    agenda_id: UUID
    position: int = 0
    prompt: str = "논제"
    created_at: datetime = field(default_factory=datetime.now)


@dataclass
class _FakeComment:
    id: UUID
    topic_id: UUID
    author_id: UUID
    parent_comment_id: UUID | None
    body: str = "답글"
    created_at: datetime = field(default_factory=datetime.now)
    edited_at: datetime | None = None


# ---------------------------------------------------------------------------
# Fake repository (subset of ClubRepository used by the BC-47 hook points)
# ---------------------------------------------------------------------------


class FakeClubRepository:
    def __init__(self) -> None:
        self._clubs: dict[UUID, _FakeClub] = {}
        self._members: dict[tuple[UUID, UUID], str] = {}
        self._sessions: dict[UUID, _FakeSession] = {}
        self._agendas: dict[UUID, _FakeAgenda] = {}
        self._topics: dict[UUID, _FakeTopic] = {}
        self._comments: dict[UUID, _FakeComment] = {}

    # --- test helpers ---

    def add_club(self, *, owner_id: UUID | None = None, is_public: bool = False) -> _FakeClub:
        owner_id = owner_id if owner_id is not None else uuid4()
        club = _FakeClub(owner_id=owner_id, is_public=is_public)
        self._clubs[club.id] = club
        self._members[(club.id, owner_id)] = ClubRole.OWNER
        return club

    def add_member(self, club_id: UUID, user_id: UUID, *, role: str = ClubRole.MEMBER) -> None:
        self._members[(club_id, user_id)] = role

    def add_session(
        self,
        club_id: UUID,
        *,
        book_id: UUID | None = None,
        presenter_id: UUID | None = None,
        status: str = SessionStatus.DRAFT,
    ) -> _FakeSession:
        session_row = _FakeSession(
            id=uuid4(),
            club_id=club_id,
            book_id=book_id if book_id is not None else uuid4(),
            presenter_id=presenter_id,
            status=status,
        )
        self._sessions[session_row.id] = session_row
        return session_row

    def add_agenda(
        self, session_id: UUID, *, author_id: UUID, status: str = AgendaStatus.DRAFT
    ) -> _FakeAgenda:
        agenda = _FakeAgenda(id=uuid4(), session_id=session_id, author_id=author_id, status=status)
        self._agendas[agenda.id] = agenda
        return agenda

    def add_topic(self, agenda_id: UUID) -> _FakeTopic:
        topic = _FakeTopic(id=uuid4(), agenda_id=agenda_id)
        self._topics[topic.id] = topic
        return topic

    # --- ClubRepository interface ---

    async def get_by_id(self, club_id: UUID) -> _FakeClub | None:
        return self._clubs.get(club_id)

    async def is_member(self, club_id: UUID, user_id: UUID) -> bool:
        return (club_id, user_id) in self._members

    async def get_member_role(self, club_id: UUID, user_id: UUID) -> str | None:
        return self._members.get((club_id, user_id))

    async def get_session(self, session_id: UUID) -> _FakeSession | None:
        return self._sessions.get(session_id)

    async def update_session_status(self, session_id: UUID, status: str) -> _FakeSession | None:
        session_row = self._sessions.get(session_id)
        if session_row is None:
            return None
        session_row.status = status
        return session_row

    async def get_agenda(self, agenda_id: UUID) -> _FakeAgenda | None:
        return self._agendas.get(agenda_id)

    async def publish_agenda(
        self, agenda_id: UUID, *, published_at: datetime
    ) -> _FakeAgenda | None:
        agenda = self._agendas.get(agenda_id)
        if agenda is None:
            return None
        agenda.status = AgendaStatus.PUBLISHED
        agenda.published_at = published_at
        return agenda

    async def list_topics_by_agenda(self, agenda_id: UUID) -> list[_FakeTopic]:
        return [t for t in self._topics.values() if t.agenda_id == agenda_id]

    async def get_topic(self, topic_id: UUID) -> _FakeTopic | None:
        return self._topics.get(topic_id)

    async def create_comment(
        self,
        *,
        topic_id: UUID,
        author_id: UUID,
        parent_comment_id: UUID | None,
        body: str,
    ) -> _FakeComment:
        comment = _FakeComment(
            id=uuid4(),
            topic_id=topic_id,
            author_id=author_id,
            parent_comment_id=parent_comment_id,
            body=body,
        )
        self._comments[comment.id] = comment
        return comment

    async def get_comment(self, comment_id: UUID) -> _FakeComment | None:
        return self._comments.get(comment_id)


# ---------------------------------------------------------------------------
# Fake FeedClubPort
# ---------------------------------------------------------------------------


@dataclass
class _RecordedCall:
    kind: str
    kwargs: dict[str, object]


class FakeFeedService:
    def __init__(self) -> None:
        self.calls: list[_RecordedCall] = []

    async def record_club_joined(self, *, user_id: UUID, club_id: UUID) -> None:
        self.calls.append(_RecordedCall("club_joined", {"user_id": user_id, "club_id": club_id}))

    async def record_session_opened(
        self, *, user_id: UUID, club_id: UUID, session_id: UUID, book_id: UUID
    ) -> None:
        self.calls.append(
            _RecordedCall(
                "session_opened",
                {
                    "user_id": user_id,
                    "club_id": club_id,
                    "session_id": session_id,
                    "book_id": book_id,
                },
            )
        )

    async def record_agenda_published(
        self, *, user_id: UUID, club_id: UUID, session_id: UUID, agenda_id: UUID
    ) -> None:
        self.calls.append(
            _RecordedCall(
                "agenda_published",
                {
                    "user_id": user_id,
                    "club_id": club_id,
                    "session_id": session_id,
                    "agenda_id": agenda_id,
                },
            )
        )

    async def record_discussion_commented(
        self,
        *,
        user_id: UUID,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        topic_id: UUID,
        comment_id: UUID,
        parent_comment_id: UUID | None,
    ) -> None:
        self.calls.append(
            _RecordedCall(
                "discussion_commented",
                {
                    "user_id": user_id,
                    "club_id": club_id,
                    "session_id": session_id,
                    "agenda_id": agenda_id,
                    "topic_id": topic_id,
                    "comment_id": comment_id,
                    "parent_comment_id": parent_comment_id,
                },
            )
        )


# ---------------------------------------------------------------------------
# Factory
# ---------------------------------------------------------------------------


def _svc(feed_service: FakeFeedService | None) -> tuple[ClubService, FakeClubRepository]:
    repo = FakeClubRepository()
    return ClubService(repo=repo, feed_service=feed_service), repo  # type: ignore[arg-type]


# ---------------------------------------------------------------------------
# transition_session_status -> session_opened
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_transition_to_open_records_session_opened() -> None:
    feed = FakeFeedService()
    svc, repo = _svc(feed)
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)

    await svc.transition_session_status(
        club_id=club.id, session_id=session_row.id, user_id=owner, status=SessionStatus.OPEN
    )

    assert len(feed.calls) == 1
    call = feed.calls[0]
    assert call.kind == "session_opened"
    assert call.kwargs == {
        "user_id": owner,
        "club_id": club.id,
        "session_id": session_row.id,
        "book_id": session_row.book_id,
    }


@pytest.mark.asyncio
async def test_transition_to_closed_does_not_record_session_opened() -> None:
    feed = FakeFeedService()
    svc, repo = _svc(feed)
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id, status=SessionStatus.OPEN)

    await svc.transition_session_status(
        club_id=club.id, session_id=session_row.id, user_id=owner, status=SessionStatus.CLOSED
    )

    assert feed.calls == []


@pytest.mark.asyncio
async def test_transition_to_open_skips_silently_when_feed_service_none() -> None:
    svc, repo = _svc(None)
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)

    result = await svc.transition_session_status(
        club_id=club.id, session_id=session_row.id, user_id=owner, status=SessionStatus.OPEN
    )

    assert result.status == SessionStatus.OPEN


# ---------------------------------------------------------------------------
# publish_agenda -> agenda_published
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_publish_agenda_records_agenda_published() -> None:
    feed = FakeFeedService()
    svc, repo = _svc(feed)
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)
    agenda = repo.add_agenda(session_row.id, author_id=owner)

    await svc.publish_agenda(
        club_id=club.id, session_id=session_row.id, agenda_id=agenda.id, user_id=owner
    )

    assert len(feed.calls) == 1
    call = feed.calls[0]
    assert call.kind == "agenda_published"
    assert call.kwargs == {
        "user_id": owner,
        "club_id": club.id,
        "session_id": session_row.id,
        "agenda_id": agenda.id,
    }


@pytest.mark.asyncio
async def test_publish_agenda_skips_silently_when_feed_service_none() -> None:
    svc, repo = _svc(None)
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)
    agenda = repo.add_agenda(session_row.id, author_id=owner)

    result = await svc.publish_agenda(
        club_id=club.id, session_id=session_row.id, agenda_id=agenda.id, user_id=owner
    )

    assert result.status == AgendaStatus.PUBLISHED


# ---------------------------------------------------------------------------
# add_comment -> discussion_commented
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_add_comment_records_discussion_commented_top_level() -> None:
    feed = FakeFeedService()
    svc, repo = _svc(feed)
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    member = uuid4()
    repo.add_member(club.id, member)
    session_row = repo.add_session(club.id)
    agenda = repo.add_agenda(session_row.id, author_id=owner)
    topic = repo.add_topic(agenda.id)

    comment = await svc.add_comment(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=agenda.id,
        topic_id=topic.id,
        user_id=member,
        req=TopicCommentCreate(body="답글"),
    )

    assert len(feed.calls) == 1
    call = feed.calls[0]
    assert call.kind == "discussion_commented"
    assert call.kwargs == {
        "user_id": member,
        "club_id": club.id,
        "session_id": session_row.id,
        "agenda_id": agenda.id,
        "topic_id": topic.id,
        "comment_id": comment.id,
        "parent_comment_id": None,
    }


@pytest.mark.asyncio
async def test_add_comment_records_discussion_commented_reply_with_parent() -> None:
    feed = FakeFeedService()
    svc, repo = _svc(feed)
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)
    agenda = repo.add_agenda(session_row.id, author_id=owner)
    topic = repo.add_topic(agenda.id)
    root = await svc.add_comment(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=agenda.id,
        topic_id=topic.id,
        user_id=owner,
        req=TopicCommentCreate(body="루트 답글"),
    )
    feed.calls.clear()

    reply = await svc.add_comment(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=agenda.id,
        topic_id=topic.id,
        user_id=owner,
        req=TopicCommentCreate(body="대댓글", parent_comment_id=root.id),
    )

    assert len(feed.calls) == 1
    call = feed.calls[0]
    assert call.kwargs["comment_id"] == reply.id
    assert call.kwargs["parent_comment_id"] == root.id


@pytest.mark.asyncio
async def test_add_comment_skips_silently_when_feed_service_none() -> None:
    svc, repo = _svc(None)
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    member = uuid4()
    repo.add_member(club.id, member)
    session_row = repo.add_session(club.id)
    agenda = repo.add_agenda(session_row.id, author_id=owner)
    topic = repo.add_topic(agenda.id)

    result = await svc.add_comment(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=agenda.id,
        topic_id=topic.id,
        user_id=member,
        req=TopicCommentCreate(body="답글"),
    )

    assert result.body == "답글"

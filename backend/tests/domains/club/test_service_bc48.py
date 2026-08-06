"""Unit tests for ClubService — BC-48 (notification integration for agenda/discussion).

Covers (design §6.2):
- publish_agenda pushes to every club member except the publisher.
- add_comment pushes to the agenda author (top-level reply), excluding the
  commenter when the commenter is the agenda author.
- add_comment on a reply-to-a-reply-target (parent_comment_id set) pushes to
  both the agenda author and the parent comment's author, deduplicated when
  they are the same person, excluding the commenter.
- notification_service=None is a silent no-op for both hooks — the primary
  write still succeeds.

Uses an in-memory fake repository and a fake NotificationClubPort — no DB
required (CLAUDE.md §5).
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
# Fake repository (subset of ClubRepository used by the BC-48 hook points)
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

    async def get_member_ids(self, club_id: UUID) -> list[UUID]:
        return [uid for (cid, uid) in self._members if cid == club_id]

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
# Fake NotificationClubPort
# ---------------------------------------------------------------------------


@dataclass
class _RecordedCall:
    kind: str
    kwargs: dict[str, object]


class FakeNotificationService:
    def __init__(self) -> None:
        self.calls: list[_RecordedCall] = []

    async def notify_agenda_published(
        self,
        *,
        actor_id: UUID,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        recipient_ids: list[UUID],
    ) -> None:
        self.calls.append(
            _RecordedCall(
                "agenda_published",
                {
                    "actor_id": actor_id,
                    "club_id": club_id,
                    "session_id": session_id,
                    "agenda_id": agenda_id,
                    "recipient_ids": set(recipient_ids),
                },
            )
        )

    async def notify_topic_comment_added(
        self,
        *,
        actor_id: UUID,
        club_id: UUID,
        session_id: UUID,
        agenda_id: UUID,
        topic_id: UUID,
        comment_id: UUID,
        recipient_ids: list[UUID],
    ) -> None:
        self.calls.append(
            _RecordedCall(
                "topic_comment_added",
                {
                    "actor_id": actor_id,
                    "club_id": club_id,
                    "session_id": session_id,
                    "agenda_id": agenda_id,
                    "topic_id": topic_id,
                    "comment_id": comment_id,
                    "recipient_ids": set(recipient_ids),
                },
            )
        )


# ---------------------------------------------------------------------------
# Factory
# ---------------------------------------------------------------------------


def _svc(
    notification_service: FakeNotificationService | None,
) -> tuple[ClubService, FakeClubRepository]:
    repo = FakeClubRepository()
    return (
        ClubService(repo=repo, notification_service=notification_service),  # type: ignore[arg-type]
        repo,
    )


# ---------------------------------------------------------------------------
# publish_agenda -> notify_agenda_published
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_publish_agenda_notifies_all_members_except_publisher() -> None:
    notif = FakeNotificationService()
    svc, repo = _svc(notif)
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    member_a = uuid4()
    member_b = uuid4()
    repo.add_member(club.id, member_a)
    repo.add_member(club.id, member_b)
    session_row = repo.add_session(club.id)
    agenda = repo.add_agenda(session_row.id, author_id=owner)

    await svc.publish_agenda(
        club_id=club.id, session_id=session_row.id, agenda_id=agenda.id, user_id=owner
    )

    assert len(notif.calls) == 1
    call = notif.calls[0]
    assert call.kind == "agenda_published"
    assert call.kwargs["actor_id"] == owner
    assert call.kwargs["club_id"] == club.id
    assert call.kwargs["session_id"] == session_row.id
    assert call.kwargs["agenda_id"] == agenda.id
    # 발제자 본인(owner)은 제외, 나머지 멤버 전원 포함.
    assert call.kwargs["recipient_ids"] == {member_a, member_b}


@pytest.mark.asyncio
async def test_publish_agenda_by_presenter_excludes_only_presenter() -> None:
    """게시자가 presenter인 경우에도 게시자 본인만 제외되고 host는 포함된다."""
    notif = FakeNotificationService()
    svc, repo = _svc(notif)
    owner = uuid4()
    presenter = uuid4()
    club = repo.add_club(owner_id=owner)
    repo.add_member(club.id, presenter)
    session_row = repo.add_session(club.id, presenter_id=presenter)
    agenda = repo.add_agenda(session_row.id, author_id=presenter)

    await svc.publish_agenda(
        club_id=club.id, session_id=session_row.id, agenda_id=agenda.id, user_id=presenter
    )

    assert len(notif.calls) == 1
    assert notif.calls[0].kwargs["recipient_ids"] == {owner}


@pytest.mark.asyncio
async def test_publish_agenda_skips_when_no_other_members() -> None:
    """발제자 본인만 멤버인 경우 알림 호출 자체가 발생하지 않는다."""
    notif = FakeNotificationService()
    svc, repo = _svc(notif)
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)
    agenda = repo.add_agenda(session_row.id, author_id=owner)

    await svc.publish_agenda(
        club_id=club.id, session_id=session_row.id, agenda_id=agenda.id, user_id=owner
    )

    assert notif.calls == []


@pytest.mark.asyncio
async def test_publish_agenda_skips_silently_when_notification_service_none() -> None:
    svc, repo = _svc(None)
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    repo.add_member(club.id, uuid4())
    session_row = repo.add_session(club.id)
    agenda = repo.add_agenda(session_row.id, author_id=owner)

    result = await svc.publish_agenda(
        club_id=club.id, session_id=session_row.id, agenda_id=agenda.id, user_id=owner
    )

    assert result.status == AgendaStatus.PUBLISHED


# ---------------------------------------------------------------------------
# add_comment -> notify_topic_comment_added
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_add_comment_top_level_notifies_agenda_author() -> None:
    notif = FakeNotificationService()
    svc, repo = _svc(notif)
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

    assert len(notif.calls) == 1
    call = notif.calls[0]
    assert call.kind == "topic_comment_added"
    assert call.kwargs["actor_id"] == member
    assert call.kwargs["comment_id"] == comment.id
    assert call.kwargs["recipient_ids"] == {owner}


@pytest.mark.asyncio
async def test_add_comment_top_level_by_agenda_author_notifies_no_one() -> None:
    """발제문 author 본인이 답글을 달면 자기 자신에게는 알림이 가지 않는다."""
    notif = FakeNotificationService()
    svc, repo = _svc(notif)
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)
    agenda = repo.add_agenda(session_row.id, author_id=owner)
    topic = repo.add_topic(agenda.id)

    await svc.add_comment(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=agenda.id,
        topic_id=topic.id,
        user_id=owner,
        req=TopicCommentCreate(body="답글"),
    )

    assert notif.calls == []


@pytest.mark.asyncio
async def test_add_comment_reply_notifies_agenda_author_and_parent_author() -> None:
    notif = FakeNotificationService()
    svc, repo = _svc(notif)
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    root_author = uuid4()
    replier = uuid4()
    repo.add_member(club.id, root_author)
    repo.add_member(club.id, replier)
    session_row = repo.add_session(club.id)
    agenda = repo.add_agenda(session_row.id, author_id=owner)
    topic = repo.add_topic(agenda.id)

    root = await svc.add_comment(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=agenda.id,
        topic_id=topic.id,
        user_id=root_author,
        req=TopicCommentCreate(body="루트 답글"),
    )
    notif.calls.clear()

    reply = await svc.add_comment(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=agenda.id,
        topic_id=topic.id,
        user_id=replier,
        req=TopicCommentCreate(body="대댓글", parent_comment_id=root.id),
    )

    assert len(notif.calls) == 1
    call = notif.calls[0]
    assert call.kwargs["comment_id"] == reply.id
    # 발제문 author(owner) + 부모 댓글 author(root_author) 모두 수신, 답글 작성자 제외.
    assert call.kwargs["recipient_ids"] == {owner, root_author}


@pytest.mark.asyncio
async def test_add_comment_reply_dedupes_when_agenda_author_is_parent_author() -> None:
    """부모 댓글 author == 발제문 author 인 경우 한 번만 수신한다."""
    notif = FakeNotificationService()
    svc, repo = _svc(notif)
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    replier = uuid4()
    repo.add_member(club.id, replier)
    session_row = repo.add_session(club.id)
    agenda = repo.add_agenda(session_row.id, author_id=owner)
    topic = repo.add_topic(agenda.id)

    root = await svc.add_comment(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=agenda.id,
        topic_id=topic.id,
        user_id=owner,  # 발제문 author 본인이 루트 답글 작성
        req=TopicCommentCreate(body="루트 답글"),
    )
    notif.calls.clear()

    await svc.add_comment(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=agenda.id,
        topic_id=topic.id,
        user_id=replier,
        req=TopicCommentCreate(body="대댓글", parent_comment_id=root.id),
    )

    assert len(notif.calls) == 1
    assert notif.calls[0].kwargs["recipient_ids"] == {owner}


@pytest.mark.asyncio
async def test_add_comment_reply_by_parent_author_excludes_self_keeps_agenda_author() -> None:
    """대댓글 작성자가 부모 댓글 author 본인이면 자신은 제외되고 발제문 author만 수신."""
    notif = FakeNotificationService()
    svc, repo = _svc(notif)
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    root_author = uuid4()
    repo.add_member(club.id, root_author)
    session_row = repo.add_session(club.id)
    agenda = repo.add_agenda(session_row.id, author_id=owner)
    topic = repo.add_topic(agenda.id)

    root = await svc.add_comment(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=agenda.id,
        topic_id=topic.id,
        user_id=root_author,
        req=TopicCommentCreate(body="루트 답글"),
    )
    notif.calls.clear()

    await svc.add_comment(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=agenda.id,
        topic_id=topic.id,
        user_id=root_author,  # 본인 댓글에 스스로 대댓글
        req=TopicCommentCreate(body="셀프 대댓글", parent_comment_id=root.id),
    )

    assert len(notif.calls) == 1
    assert notif.calls[0].kwargs["recipient_ids"] == {owner}


@pytest.mark.asyncio
async def test_add_comment_skips_silently_when_notification_service_none() -> None:
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

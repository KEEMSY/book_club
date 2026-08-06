"""Unit tests for ClubService — BC-46 (topic-thread discussion / replies).

Covers (design §5, §2 비목표):
- add_comment: club-membership-only permission (host counts as a member via
  add_club, but a non-member — even one who could view a public club — is
  rejected), single-level reply depth enforcement (replying to a reply is
  rejected), unknown parent/topic/agenda/session/club rejection.
- update_comment / delete_comment: author-or-host permission (a third-party
  member is rejected).
- list_comments: groups the topic's flat comment rows into top-level threads
  with their replies attached, and reuses the same view rule as agendas/
  topics (member-only on a private club, open on a public one).

Uses an in-memory fake repository — no DB required.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError, NotFoundError, PermissionDeniedError
from app.domains.club.models import ClubRole
from app.domains.club.schemas import TopicCommentCreate, TopicCommentUpdate
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
    presenter_id: UUID | None = None


@dataclass
class _FakeAgenda:
    id: UUID
    session_id: UUID


@dataclass
class _FakeTopic:
    id: UUID
    agenda_id: UUID


@dataclass
class _FakeComment:
    id: UUID
    topic_id: UUID
    author_id: UUID
    parent_comment_id: UUID | None
    body: str
    created_at: datetime = field(default_factory=datetime.now)
    edited_at: datetime | None = None


# ---------------------------------------------------------------------------
# Fake repository (subset of ClubRepository used by BC-46 service methods)
# ---------------------------------------------------------------------------


class FakeClubRepository:
    def __init__(self) -> None:
        self._clubs: dict[UUID, _FakeClub] = {}
        self._members: dict[tuple[UUID, UUID], str] = {}
        self._sessions: dict[UUID, _FakeSession] = {}
        self._agendas: dict[UUID, _FakeAgenda] = {}
        self._topics: dict[UUID, _FakeTopic] = {}
        # Insertion order stands in for created_at ascending — mirrors what
        # ClubRepository.list_comments_by_topic guarantees via ORDER BY.
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

    def add_session(self, club_id: UUID, *, presenter_id: UUID | None = None) -> _FakeSession:
        session_row = _FakeSession(id=uuid4(), club_id=club_id, presenter_id=presenter_id)
        self._sessions[session_row.id] = session_row
        return session_row

    def add_agenda(self, session_id: UUID) -> _FakeAgenda:
        agenda = _FakeAgenda(id=uuid4(), session_id=session_id)
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

    async def get_session(self, session_id: UUID) -> _FakeSession | None:
        return self._sessions.get(session_id)

    async def get_agenda(self, agenda_id: UUID) -> _FakeAgenda | None:
        return self._agendas.get(agenda_id)

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

    async def list_comments_by_topic(self, topic_id: UUID) -> list[_FakeComment]:
        return [c for c in self._comments.values() if c.topic_id == topic_id]

    async def update_comment_body(
        self, comment_id: UUID, body: str, *, edited_at: datetime
    ) -> _FakeComment | None:
        comment = self._comments.get(comment_id)
        if comment is None:
            return None
        comment.body = body
        comment.edited_at = edited_at
        return comment

    async def delete_comment(self, comment_id: UUID) -> None:
        comment = self._comments.pop(comment_id, None)
        if comment is None:
            return
        # Mirrors the DB's ON DELETE CASCADE on parent_comment_id (design §4).
        child_ids = [cid for cid, c in self._comments.items() if c.parent_comment_id == comment_id]
        for cid in child_ids:
            self._comments.pop(cid, None)


# ---------------------------------------------------------------------------
# Factory
# ---------------------------------------------------------------------------


def _svc() -> tuple[ClubService, FakeClubRepository]:
    repo = FakeClubRepository()
    return ClubService(repo=repo), repo  # type: ignore[arg-type]


def _setup_topic(repo: FakeClubRepository, club: _FakeClub) -> tuple[UUID, UUID, UUID, _FakeTopic]:
    """Build a session/agenda/topic chain under *club*; return the ids the
    service needs to scope its lookups plus the topic itself."""
    session_row = repo.add_session(club.id)
    agenda = repo.add_agenda(session_row.id)
    topic = repo.add_topic(agenda.id)
    return club.id, session_row.id, agenda.id, topic


# ---------------------------------------------------------------------------
# add_comment
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_add_comment_rejects_non_member() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    club_id, session_id, agenda_id, topic = _setup_topic(repo, club)
    stranger = uuid4()

    with pytest.raises(PermissionDeniedError):
        await svc.add_comment(
            club_id=club_id,
            session_id=session_id,
            agenda_id=agenda_id,
            topic_id=topic.id,
            user_id=stranger,
            req=TopicCommentCreate(body="답글 시도"),
        )


@pytest.mark.asyncio
async def test_add_comment_rejects_non_member_even_on_public_club() -> None:
    """공개 클럽 열람자라도 답글 작성은 멤버만 — design §5 명시 사항."""
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner, is_public=True)
    club_id, session_id, agenda_id, topic = _setup_topic(repo, club)
    viewer = uuid4()

    with pytest.raises(PermissionDeniedError) as exc:
        await svc.add_comment(
            club_id=club_id,
            session_id=session_id,
            agenda_id=agenda_id,
            topic_id=topic.id,
            user_id=viewer,
            req=TopicCommentCreate(body="답글 시도"),
        )
    assert exc.value.code == "NOT_MEMBER"


@pytest.mark.asyncio
async def test_add_comment_allows_member() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    member = uuid4()
    repo.add_member(club.id, member)
    club_id, session_id, agenda_id, topic = _setup_topic(repo, club)

    result = await svc.add_comment(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic.id,
        user_id=member,
        req=TopicCommentCreate(body="첫 답글"),
    )

    assert result.topic_id == topic.id
    assert result.author_id == member
    assert result.parent_comment_id is None
    assert result.edited_at is None


@pytest.mark.asyncio
async def test_add_comment_reply_to_root_allowed() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    club_id, session_id, agenda_id, topic = _setup_topic(repo, club)
    root = await svc.add_comment(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic.id,
        user_id=owner,
        req=TopicCommentCreate(body="루트 답글"),
    )

    reply = await svc.add_comment(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic.id,
        user_id=owner,
        req=TopicCommentCreate(body="대댓글", parent_comment_id=root.id),
    )

    assert reply.parent_comment_id == root.id


@pytest.mark.asyncio
async def test_add_comment_rejects_reply_to_reply() -> None:
    """1단계 대댓글까지만 허용 — design §2 비목표."""
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    club_id, session_id, agenda_id, topic = _setup_topic(repo, club)
    root = await svc.add_comment(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic.id,
        user_id=owner,
        req=TopicCommentCreate(body="루트 답글"),
    )
    reply = await svc.add_comment(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic.id,
        user_id=owner,
        req=TopicCommentCreate(body="대댓글", parent_comment_id=root.id),
    )

    with pytest.raises(ConflictError) as exc:
        await svc.add_comment(
            club_id=club_id,
            session_id=session_id,
            agenda_id=agenda_id,
            topic_id=topic.id,
            user_id=owner,
            req=TopicCommentCreate(body="2단계 시도", parent_comment_id=reply.id),
        )
    assert exc.value.code == "MAX_REPLY_DEPTH_EXCEEDED"


@pytest.mark.asyncio
async def test_add_comment_unknown_parent_rejected() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    club_id, session_id, agenda_id, topic = _setup_topic(repo, club)

    with pytest.raises(NotFoundError):
        await svc.add_comment(
            club_id=club_id,
            session_id=session_id,
            agenda_id=agenda_id,
            topic_id=topic.id,
            user_id=owner,
            req=TopicCommentCreate(body="답글", parent_comment_id=uuid4()),
        )


@pytest.mark.asyncio
async def test_add_comment_unknown_topic_rejected() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)
    agenda = repo.add_agenda(session_row.id)

    with pytest.raises(NotFoundError):
        await svc.add_comment(
            club_id=club.id,
            session_id=session_row.id,
            agenda_id=agenda.id,
            topic_id=uuid4(),
            user_id=owner,
            req=TopicCommentCreate(body="답글"),
        )


@pytest.mark.asyncio
async def test_add_comment_unknown_club_rejected() -> None:
    svc, _repo = _svc()

    with pytest.raises(NotFoundError):
        await svc.add_comment(
            club_id=uuid4(),
            session_id=uuid4(),
            agenda_id=uuid4(),
            topic_id=uuid4(),
            user_id=uuid4(),
            req=TopicCommentCreate(body="답글"),
        )


# ---------------------------------------------------------------------------
# update_comment / delete_comment
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_update_comment_by_author_allowed() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    member = uuid4()
    repo.add_member(club.id, member)
    club_id, session_id, agenda_id, topic = _setup_topic(repo, club)
    comment = await svc.add_comment(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic.id,
        user_id=member,
        req=TopicCommentCreate(body="원본"),
    )

    updated = await svc.update_comment(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic.id,
        comment_id=comment.id,
        user_id=member,
        req=TopicCommentUpdate(body="수정됨"),
    )

    assert updated.body == "수정됨"
    assert updated.edited_at is not None


@pytest.mark.asyncio
async def test_update_comment_by_host_allowed_even_when_not_author() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    member = uuid4()
    repo.add_member(club.id, member)
    club_id, session_id, agenda_id, topic = _setup_topic(repo, club)
    comment = await svc.add_comment(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic.id,
        user_id=member,
        req=TopicCommentCreate(body="원본"),
    )

    updated = await svc.update_comment(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic.id,
        comment_id=comment.id,
        user_id=owner,
        req=TopicCommentUpdate(body="호스트가 수정"),
    )

    assert updated.body == "호스트가 수정"


@pytest.mark.asyncio
async def test_update_comment_rejects_other_member() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    author = uuid4()
    other = uuid4()
    repo.add_member(club.id, author)
    repo.add_member(club.id, other)
    club_id, session_id, agenda_id, topic = _setup_topic(repo, club)
    comment = await svc.add_comment(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic.id,
        user_id=author,
        req=TopicCommentCreate(body="원본"),
    )

    with pytest.raises(PermissionDeniedError):
        await svc.update_comment(
            club_id=club_id,
            session_id=session_id,
            agenda_id=agenda_id,
            topic_id=topic.id,
            comment_id=comment.id,
            user_id=other,
            req=TopicCommentUpdate(body="수정 시도"),
        )


@pytest.mark.asyncio
async def test_update_comment_unknown_rejected() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    club_id, session_id, agenda_id, topic = _setup_topic(repo, club)

    with pytest.raises(NotFoundError):
        await svc.update_comment(
            club_id=club_id,
            session_id=session_id,
            agenda_id=agenda_id,
            topic_id=topic.id,
            comment_id=uuid4(),
            user_id=owner,
            req=TopicCommentUpdate(body="수정 시도"),
        )


@pytest.mark.asyncio
async def test_delete_comment_by_author_allowed() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    member = uuid4()
    repo.add_member(club.id, member)
    club_id, session_id, agenda_id, topic = _setup_topic(repo, club)
    comment = await svc.add_comment(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic.id,
        user_id=member,
        req=TopicCommentCreate(body="원본"),
    )

    await svc.delete_comment(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic.id,
        comment_id=comment.id,
        user_id=member,
    )

    assert await repo.get_comment(comment.id) is None


@pytest.mark.asyncio
async def test_delete_comment_by_host_allowed() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    member = uuid4()
    repo.add_member(club.id, member)
    club_id, session_id, agenda_id, topic = _setup_topic(repo, club)
    comment = await svc.add_comment(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic.id,
        user_id=member,
        req=TopicCommentCreate(body="원본"),
    )

    await svc.delete_comment(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic.id,
        comment_id=comment.id,
        user_id=owner,
    )

    assert await repo.get_comment(comment.id) is None


@pytest.mark.asyncio
async def test_delete_comment_rejects_other_member() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    author = uuid4()
    other = uuid4()
    repo.add_member(club.id, author)
    repo.add_member(club.id, other)
    club_id, session_id, agenda_id, topic = _setup_topic(repo, club)
    comment = await svc.add_comment(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic.id,
        user_id=author,
        req=TopicCommentCreate(body="원본"),
    )

    with pytest.raises(PermissionDeniedError):
        await svc.delete_comment(
            club_id=club_id,
            session_id=session_id,
            agenda_id=agenda_id,
            topic_id=topic.id,
            comment_id=comment.id,
            user_id=other,
        )

    assert await repo.get_comment(comment.id) is not None


# ---------------------------------------------------------------------------
# list_comments
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_list_comments_builds_thread_tree() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    member = uuid4()
    repo.add_member(club.id, member)
    club_id, session_id, agenda_id, topic = _setup_topic(repo, club)

    root1 = await svc.add_comment(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic.id,
        user_id=owner,
        req=TopicCommentCreate(body="루트 1"),
    )
    await svc.add_comment(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic.id,
        user_id=member,
        req=TopicCommentCreate(body="루트 1에 대댓글", parent_comment_id=root1.id),
    )
    root2 = await svc.add_comment(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic.id,
        user_id=member,
        req=TopicCommentCreate(body="루트 2"),
    )

    threads = await svc.list_comments(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic.id,
        caller_user_id=member,
    )

    assert [t.id for t in threads] == [root1.id, root2.id]
    assert len(threads[0].replies) == 1
    assert threads[0].replies[0].body == "루트 1에 대댓글"
    assert threads[1].replies == []


@pytest.mark.asyncio
async def test_list_comments_private_club_rejects_non_member() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner, is_public=False)
    club_id, session_id, agenda_id, topic = _setup_topic(repo, club)
    stranger = uuid4()

    with pytest.raises(PermissionDeniedError):
        await svc.list_comments(
            club_id=club_id,
            session_id=session_id,
            agenda_id=agenda_id,
            topic_id=topic.id,
            caller_user_id=stranger,
        )


@pytest.mark.asyncio
async def test_list_comments_public_club_allows_non_member() -> None:
    svc, repo = _svc()
    owner = uuid4()
    club = repo.add_club(owner_id=owner, is_public=True)
    club_id, session_id, agenda_id, topic = _setup_topic(repo, club)
    await svc.add_comment(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic.id,
        user_id=owner,
        req=TopicCommentCreate(body="공개 답글"),
    )
    viewer = uuid4()

    threads = await svc.list_comments(
        club_id=club_id,
        session_id=session_id,
        agenda_id=agenda_id,
        topic_id=topic.id,
        caller_user_id=viewer,
    )

    assert len(threads) == 1

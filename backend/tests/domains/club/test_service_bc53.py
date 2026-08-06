"""Unit tests for ClubService.recommend_topic_drafts — BC-53 (AI 논제 초안 추천).

Covers:
- Permission: gated by agenda-author (design §5 row 3, same as add_topic) —
  host/presenter of the *session* who did not author *this* agenda is rejected.
- Success: returns whatever the injected Fake AI port produces (3~5 candidate
  strings), unchanged and un-persisted — no repository write happens.
- Not-configured: when ``agenda_ai`` is unwired, a clear 503 is raised instead
  of silently degrading (unlike feed_service/notification_service, which are
  fire-and-forget).
- Input pass-through: book_id/scope/user_id reach the port exactly as given.

Uses an in-memory fake repository (same shape as test_service_bc45.py) and a
Fake AI port — no DB, no Claude/network call.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import NotConfiguredError, NotFoundError, PermissionDeniedError
from app.domains.club.models import AgendaStatus, ClubRole
from app.domains.club.service import AgendaTopicAiPort, ClubService

# ---------------------------------------------------------------------------
# Fake domain objects (mirrors test_service_bc45.py)
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
    author_id: UUID
    body: str
    status: str = AgendaStatus.DRAFT
    published_at: datetime | None = None
    created_at: datetime = field(default_factory=datetime.now)
    topics: list[object] = field(default_factory=list)


class FakeClubRepository:
    def __init__(self) -> None:
        self._clubs: dict[UUID, _FakeClub] = {}
        self._members: dict[tuple[UUID, UUID], str] = {}
        self._sessions: dict[UUID, _FakeSession] = {}
        self._agendas: dict[UUID, _FakeAgenda] = {}

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

    def add_agenda(self, session_id: UUID, *, author_id: UUID) -> _FakeAgenda:
        agenda = _FakeAgenda(id=uuid4(), session_id=session_id, author_id=author_id, body="본문")
        self._agendas[agenda.id] = agenda
        return agenda

    # --- ClubRepository interface (subset used by recommend_topic_drafts) ---

    async def get_by_id(self, club_id: UUID) -> _FakeClub | None:
        return self._clubs.get(club_id)

    async def is_member(self, club_id: UUID, user_id: UUID) -> bool:
        return (club_id, user_id) in self._members

    async def get_member_role(self, club_id: UUID, user_id: UUID) -> str | None:
        return self._members.get((club_id, user_id))

    async def get_session(self, session_id: UUID) -> _FakeSession | None:
        return self._sessions.get(session_id)

    async def get_agenda(self, agenda_id: UUID) -> _FakeAgenda | None:
        return self._agendas.get(agenda_id)


class FakeAgendaAiPort(AgendaTopicAiPort):
    """Records the call it received and returns a fixed set of drafts."""

    def __init__(self, topics: list[str] | None = None) -> None:
        self.topics = topics if topics is not None else ["논제 1", "논제 2", "논제 3"]
        self.calls: list[dict[str, object]] = []

    async def generate_topic_drafts(self, *, user_id: UUID, book_id: UUID, scope: str) -> list[str]:
        self.calls.append({"user_id": user_id, "book_id": book_id, "scope": scope})
        return self.topics


# ---------------------------------------------------------------------------
# Factory
# ---------------------------------------------------------------------------


def _svc(*, agenda_ai: AgendaTopicAiPort | None) -> tuple[ClubService, FakeClubRepository]:
    repo = FakeClubRepository()
    return ClubService(repo=repo, agenda_ai=agenda_ai), repo  # type: ignore[arg-type]


# ---------------------------------------------------------------------------
# recommend_topic_drafts
# ---------------------------------------------------------------------------


async def test_recommend_topic_drafts_success_by_agenda_author() -> None:
    ai = FakeAgendaAiPort(topics=["논제 A", "논제 B", "논제 C", "논제 D"])
    svc, repo = _svc(agenda_ai=ai)
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)
    agenda = repo.add_agenda(session_row.id, author_id=owner)
    book_id = uuid4()

    result = await svc.recommend_topic_drafts(
        club_id=club.id,
        session_id=session_row.id,
        agenda_id=agenda.id,
        user_id=owner,
        book_id=book_id,
        scope="1~3장",
    )

    assert result == ["논제 A", "논제 B", "논제 C", "논제 D"]
    assert 3 <= len(result) <= 5
    assert ai.calls == [{"user_id": owner, "book_id": book_id, "scope": "1~3장"}]


async def test_recommend_topic_drafts_rejects_non_author_presenter() -> None:
    """Session presenter who did not author *this* agenda is still rejected —

    narrower than "host or presenter of the session" (mirrors add_topic,
    design §5 row 3): the gate is whoever actually authored the agenda.
    """
    ai = FakeAgendaAiPort()
    svc, repo = _svc(agenda_ai=ai)
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    presenter = uuid4()
    repo.add_member(club.id, presenter)
    session_row = repo.add_session(club.id, presenter_id=presenter)
    agenda = repo.add_agenda(session_row.id, author_id=owner)

    with pytest.raises(PermissionDeniedError):
        await svc.recommend_topic_drafts(
            club_id=club.id,
            session_id=session_row.id,
            agenda_id=agenda.id,
            user_id=presenter,
            book_id=uuid4(),
            scope="1~3장",
        )
    assert ai.calls == []  # rejected before spending an AI call


async def test_recommend_topic_drafts_rejects_stranger() -> None:
    ai = FakeAgendaAiPort()
    svc, repo = _svc(agenda_ai=ai)
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)
    agenda = repo.add_agenda(session_row.id, author_id=owner)
    stranger = uuid4()

    with pytest.raises(PermissionDeniedError):
        await svc.recommend_topic_drafts(
            club_id=club.id,
            session_id=session_row.id,
            agenda_id=agenda.id,
            user_id=stranger,
            book_id=uuid4(),
            scope="1~3장",
        )


async def test_recommend_topic_drafts_unknown_agenda_raises_not_found() -> None:
    ai = FakeAgendaAiPort()
    svc, repo = _svc(agenda_ai=ai)
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)

    with pytest.raises(NotFoundError):
        await svc.recommend_topic_drafts(
            club_id=club.id,
            session_id=session_row.id,
            agenda_id=uuid4(),
            user_id=owner,
            book_id=uuid4(),
            scope="1~3장",
        )


async def test_recommend_topic_drafts_unknown_session_raises_not_found() -> None:
    ai = FakeAgendaAiPort()
    svc, repo = _svc(agenda_ai=ai)
    owner = uuid4()
    club = repo.add_club(owner_id=owner)

    with pytest.raises(NotFoundError):
        await svc.recommend_topic_drafts(
            club_id=club.id,
            session_id=uuid4(),
            agenda_id=uuid4(),
            user_id=owner,
            book_id=uuid4(),
            scope="1~3장",
        )


async def test_recommend_topic_drafts_without_agenda_ai_raises_not_configured() -> None:
    svc, repo = _svc(agenda_ai=None)
    owner = uuid4()
    club = repo.add_club(owner_id=owner)
    session_row = repo.add_session(club.id)
    agenda = repo.add_agenda(session_row.id, author_id=owner)

    with pytest.raises(NotConfiguredError) as exc:
        await svc.recommend_topic_drafts(
            club_id=club.id,
            session_id=session_row.id,
            agenda_id=agenda.id,
            user_id=owner,
            book_id=uuid4(),
            scope="1~3장",
        )
    assert exc.value.code == "AGENDA_AI_UNAVAILABLE"

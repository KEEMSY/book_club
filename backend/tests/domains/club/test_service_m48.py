"""Unit tests for ClubService — M48 additions.

Covers:
- list_public_clubs (no filter, category filter, tag filter)
- get_recommended_clubs (taste profile match, no profile fallback, padding)
- create_club with tags/category (creation, tag persistence)

Uses FakeClubRepository (in-memory) — no DB or Redis required.
"""

from __future__ import annotations

import secrets
from dataclasses import dataclass, field
from datetime import UTC, datetime
from uuid import UUID, uuid4

import pytest

from app.domains.club.schemas import CreateClubRequest
from app.domains.club.service import ClubService


# ---------------------------------------------------------------------------
# Fake domain objects (duck-type ReadingClub without an ORM session)
# ---------------------------------------------------------------------------


@dataclass
class _FakeClub:
    id: UUID = field(default_factory=uuid4)
    name: str = "Test Club"
    description: str | None = None
    owner_id: UUID = field(default_factory=uuid4)
    book_id: UUID | None = None
    invite_code: str = field(default_factory=lambda: secrets.token_urlsafe(6).upper()[:8])
    max_members: int = 10
    is_public: bool = True
    category: str | None = None
    created_at: datetime = field(default_factory=lambda: datetime.now(tz=UTC))


# ---------------------------------------------------------------------------
# FakeClubRepository
# ---------------------------------------------------------------------------


class FakeClubRepository:
    """In-memory implementation of the ClubRepository interface for M48 tests."""

    def __init__(self) -> None:
        self._clubs: dict[UUID, _FakeClub] = {}
        self._by_code: dict[str, _FakeClub] = {}
        self._members: dict[UUID, dict[UUID, str]] = {}  # club_id → {user_id: role}
        self._tags: dict[UUID, list[str]] = {}  # club_id → tags
        # Simulated taste profile: user_id → genre_vector dict
        self._taste_profiles: dict[UUID, dict[str, int]] = {}

    # --- helpers used by tests ---

    def _add_club(
        self,
        *,
        owner_id: UUID | None = None,
        name: str = "Club",
        is_public: bool = True,
        category: str | None = None,
        tags: list[str] | None = None,
    ) -> _FakeClub:
        """Directly insert a fake club (bypasses create() so tests control all fields)."""
        oid = owner_id or uuid4()
        club = _FakeClub(owner_id=oid, name=name, is_public=is_public, category=category)
        self._clubs[club.id] = club
        self._by_code[club.invite_code] = club
        self._members[club.id] = {oid: "owner"}
        if tags:
            self._tags[club.id] = list(tags)
        return club

    def set_taste_profile(self, user_id: UUID, genre_vector: dict[str, int]) -> None:
        self._taste_profiles[user_id] = genre_vector

    # --- ClubRepository interface ---

    async def create(
        self,
        *,
        owner_id: UUID,
        name: str,
        description: str | None,
        book_id: UUID | None,
        max_members: int,
        is_public: bool = False,
        category: str | None = None,
        tags: list[str] | None = None,
    ) -> _FakeClub:
        club = _FakeClub(
            owner_id=owner_id,
            name=name,
            description=description,
            book_id=book_id,
            max_members=max_members,
            is_public=is_public,
            category=category,
        )
        self._clubs[club.id] = club
        self._by_code[club.invite_code] = club
        self._members[club.id] = {owner_id: "owner"}
        if tags:
            self._tags[club.id] = list(tags)
        return club

    async def get_by_id(self, club_id: UUID) -> _FakeClub | None:
        return self._clubs.get(club_id)

    async def get_by_invite_code(self, code: str) -> _FakeClub | None:
        return self._by_code.get(code)

    async def list_by_user(self, user_id: UUID) -> list[_FakeClub]:
        return [c for c in self._clubs.values() if user_id in self._members.get(c.id, {})]

    async def list_public(
        self,
        *,
        search: str | None,
        sort: str,
        cursor: datetime | None,
        limit: int,
    ) -> list[_FakeClub]:
        clubs = [c for c in self._clubs.values() if c.is_public]
        return clubs[:limit]

    async def list_public_clubs(
        self,
        *,
        category: str | None = None,
        tag: str | None = None,
        sort: str = "popular",
        limit: int = 20,
        cursor: str | None = None,
    ) -> list[_FakeClub]:
        clubs = [c for c in self._clubs.values() if c.is_public]
        if category is not None:
            clubs = [c for c in clubs if c.category == category]
        if tag is not None:
            clubs = [c for c in clubs if tag in self._tags.get(c.id, [])]
        return clubs[:limit]

    async def recommended_clubs(
        self,
        *,
        user_id: UUID,
        limit: int = 6,
    ) -> list[_FakeClub]:
        """Mirrors the real repo logic: genre match → popular fallback."""
        public = [c for c in self._clubs.values() if c.is_public]
        profile = self._taste_profiles.get(user_id)

        if not profile:
            # No taste profile — return popular (insertion order here)
            return public[:limit]

        top_genres = [
            g
            for g, _ in sorted(profile.items(), key=lambda kv: kv[1], reverse=True)[:2]
        ]
        matched = [c for c in public if c.category in top_genres]
        if len(matched) < limit:
            existing_ids = {c.id for c in matched}
            fill = [c for c in public if c.id not in existing_ids]
            matched = (matched + fill)[:limit]
        return matched[:limit]

    async def set_club_tags(self, club_id: UUID, tags: list[str]) -> None:
        self._tags[club_id] = list(tags)

    async def get_club_tags(self, club_id: UUID) -> list[str]:
        return list(self._tags.get(club_id, []))

    async def member_count(self, club_id: UUID) -> int:
        return len(self._members.get(club_id, {}))

    async def is_member(self, club_id: UUID, user_id: UUID) -> bool:
        return user_id in self._members.get(club_id, {})

    async def get_member_role(self, club_id: UUID, user_id: UUID) -> str | None:
        return self._members.get(club_id, {}).get(user_id)

    async def join(self, club_id: UUID, user_id: UUID) -> None:
        self._members.setdefault(club_id, {})[user_id] = "member"

    async def leave(self, club_id: UUID, user_id: UUID) -> None:
        self._members.get(club_id, {}).pop(user_id, None)

    async def set_book(self, club_id: UUID, book_id: UUID | None) -> _FakeClub:
        club = self._clubs[club_id]
        club.book_id = book_id
        return club

    # Stubs for methods used by other ClubService operations (not under test here)

    async def create_event(self, **_kwargs):  # type: ignore[override]
        raise NotImplementedError

    async def get_events(self, club_id: UUID, *, upcoming_only: bool = True) -> list:
        return []

    async def get_event(self, event_id: UUID):
        return None

    async def update_event(self, event_id: UUID, **_kwargs):
        return None

    async def delete_event(self, event_id: UUID) -> None:
        pass

    async def upsert_rsvp(self, **_kwargs) -> None:
        pass

    async def get_attendees(self, event_id: UUID) -> list:
        return []

    async def get_attendee_counts(self, event_id: UUID):
        from app.domains.club.schemas import AttendeeCount
        return AttendeeCount(going=0, maybe=0, not_going=0)

    async def get_my_rsvp_status(self, event_id: UUID, user_id: UUID) -> str | None:
        return None

    async def create_message(self, **_kwargs):
        raise NotImplementedError

    async def list_messages(self, club_id: UUID, *, cursor, limit: int, room_id=None) -> list:
        return []

    async def get_message(self, message_id: UUID):
        return None

    async def update_message_content(self, **_kwargs) -> None:
        pass

    async def soft_delete_message(self, **_kwargs) -> None:
        pass

    async def upsert_message_read(self, **_kwargs) -> None:
        pass

    async def create_room(self, **_kwargs):
        raise NotImplementedError

    async def get_rooms(self, club_id: UUID) -> list:
        return []

    async def get_room(self, room_id: UUID):
        return None

    async def delete_room(self, room_id: UUID) -> None:
        pass

    async def get_user_chapter_for_club(self, user_id: UUID, club_id: UUID) -> int:
        return 0


# ---------------------------------------------------------------------------
# Factories
# ---------------------------------------------------------------------------


def _svc() -> tuple[ClubService, FakeClubRepository]:
    repo = FakeClubRepository()
    return ClubService(repo=repo), repo  # type: ignore[arg-type]


def _req(
    name: str = "My Club",
    is_public: bool = True,
    category: str | None = None,
    tags: list[str] | None = None,
) -> CreateClubRequest:
    return CreateClubRequest(
        name=name,
        description=None,
        book_id=None,
        max_members=10,
        is_public=is_public,
        category=category,
        tags=tags or [],
    )


# ---------------------------------------------------------------------------
# list_public_clubs
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_list_public_no_filter() -> None:
    """No filter returns all public clubs."""
    svc, repo = _svc()
    repo._add_club(name="Alpha", is_public=True)
    repo._add_club(name="Beta", is_public=True)
    repo._add_club(name="Private", is_public=False)

    results = await svc.list_public_clubs()

    names = {c.name for c in results}
    assert "Alpha" in names
    assert "Beta" in names
    # Private club must not appear
    assert "Private" not in names


@pytest.mark.asyncio
async def test_list_public_category_filter() -> None:
    """category='소설' filter returns only clubs in that category."""
    svc, repo = _svc()
    repo._add_club(name="Novel Club", is_public=True, category="소설")
    repo._add_club(name="Self Help", is_public=True, category="자기계발")
    repo._add_club(name="Sci Club", is_public=True, category="과학")

    results = await svc.list_public_clubs(category="소설")

    assert len(results) == 1
    assert results[0].name == "Novel Club"


@pytest.mark.asyncio
async def test_list_public_tag_filter() -> None:
    """tag='한국소설' filter returns only clubs tagged accordingly."""
    svc, repo = _svc()
    repo._add_club(name="KR Novel", is_public=True, tags=["한국소설", "현대소설"])
    repo._add_club(name="EN Novel", is_public=True, tags=["영미소설"])
    repo._add_club(name="No Tags", is_public=True)

    results = await svc.list_public_clubs(tag="한국소설")

    assert len(results) == 1
    assert results[0].name == "KR Novel"


# ---------------------------------------------------------------------------
# get_recommended_clubs
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_recommended_clubs_with_taste_profile() -> None:
    """User with a '소설' taste profile gets back clubs in that category first."""
    svc, repo = _svc()
    user_id = uuid4()
    repo.set_taste_profile(user_id, {"소설": 10, "자기계발": 3})

    repo._add_club(name="Novel A", is_public=True, category="소설")
    repo._add_club(name="Novel B", is_public=True, category="소설")
    repo._add_club(name="Science", is_public=True, category="과학")

    results = await svc.get_recommended_clubs(user_id, limit=6)

    names = [c.name for c in results]
    # Both novel clubs must be present; science club may or may not appear
    assert "Novel A" in names
    assert "Novel B" in names


@pytest.mark.asyncio
async def test_recommended_clubs_no_profile() -> None:
    """User without a taste profile falls back to popular public clubs."""
    svc, repo = _svc()
    user_id = uuid4()
    # No taste profile set

    repo._add_club(name="Popular A", is_public=True, category="소설")
    repo._add_club(name="Popular B", is_public=True, category="자기계발")

    results = await svc.get_recommended_clubs(user_id, limit=6)

    # Should return public clubs even without a profile
    assert len(results) >= 2
    names = {c.name for c in results}
    assert "Popular A" in names
    assert "Popular B" in names


@pytest.mark.asyncio
async def test_recommended_clubs_padding() -> None:
    """When genre-matched clubs are fewer than limit, popular clubs pad the result."""
    svc, repo = _svc()
    user_id = uuid4()
    # User strongly prefers '시' (poetry) but there is only 1 poetry club
    repo.set_taste_profile(user_id, {"시": 20})

    repo._add_club(name="Poetry", is_public=True, category="시")
    repo._add_club(name="Filler 1", is_public=True, category="소설")
    repo._add_club(name="Filler 2", is_public=True, category="자기계발")
    repo._add_club(name="Filler 3", is_public=True, category="과학")

    results = await svc.get_recommended_clubs(user_id, limit=3)

    assert len(results) == 3
    names = {c.name for c in results}
    # The matched poetry club must be included
    assert "Poetry" in names
    # At least two filler clubs pad the rest
    fillers = names - {"Poetry"}
    assert len(fillers) == 2


# ---------------------------------------------------------------------------
# create_club with tags and category
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_create_club_with_tags_and_category() -> None:
    """create_club forwards category and tags to the repository."""
    svc, repo = _svc()
    owner = uuid4()

    club = await svc.create_club(
        user_id=owner,
        req=_req(name="Tagged Club", category="소설", tags=["한국소설", "현대문학"]),
    )

    assert club.name == "Tagged Club"
    assert club.category == "소설"
    # Owner should be registered as a member
    assert await repo.is_member(club.id, owner)


@pytest.mark.asyncio
async def test_create_club_tags_saved() -> None:
    """Tags passed at creation are persisted and retrievable via get_club_tags."""
    svc, repo = _svc()
    owner = uuid4()

    club = await svc.create_club(
        user_id=owner,
        req=_req(name="Tag Test Club", tags=["SF", "디스토피아"]),
    )

    saved_tags = await repo.get_club_tags(club.id)
    assert set(saved_tags) == {"SF", "디스토피아"}

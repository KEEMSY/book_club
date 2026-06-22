"""Unit tests for DiscoveryService — M69 curation channels.

Covers the four book-recommendation channels:
- taste_match  (delegates to the existing genre-vector strategy)
- trending     (most reading sessions in the last 7 days)
- club_picks   (books read by the user's clubs)
- ai_picks     (Claude suggestions resolved to catalog rows, with fallbacks)

All tests use in-memory fakes — no DB and no network (CLAUDE.md §5).
"""

from __future__ import annotations

from dataclasses import dataclass, field
from uuid import UUID, uuid4

import pytest
from app.domains.discovery.ai_port import AIBookSuggestion, CompletedBook
from app.domains.discovery.service import DiscoveryService
from app.domains.discovery.strategies import RecommendationChannel

_Row4 = tuple[UUID, str, str, str | None]


@dataclass
class _FakeProfile:
    user_id: UUID
    genre_vector: dict[str, int]
    author_vector: dict[str, int] = field(default_factory=dict)


class _FakeTasteProfiles:
    def __init__(self, profiles: list[_FakeProfile] | None = None) -> None:
        self._profiles = {p.user_id: p for p in (profiles or [])}

    async def get(self, user_id: UUID) -> _FakeProfile | None:
        return self._profiles.get(user_id)

    async def list_all(self) -> list[_FakeProfile]:
        return list(self._profiles.values())


class _FakeOnboarding:
    async def list_for_user(self, user_id: UUID) -> list[object]:
        return []


class FakeChannelRepository:
    """In-memory DiscoveryRepository covering the M69 channel methods."""

    def __init__(
        self,
        *,
        trending: list[_Row4] | None = None,
        club_picks: list[_Row4] | None = None,
        completed: list[tuple[str, str]] | None = None,
        catalog: dict[str, _Row4] | None = None,
        profiles: list[_FakeProfile] | None = None,
        books_by_genre: list[tuple[UUID, str, str, str | None, str]] | None = None,
    ) -> None:
        self.taste_profiles = _FakeTasteProfiles(profiles)
        self.onboarding_interests = _FakeOnboarding()
        self._trending = trending or []
        self._club_picks = club_picks or []
        self._completed = completed or []
        # title-substring (lowercased) -> catalog row
        self._catalog = catalog or {}
        self._books_by_genre = books_by_genre or []
        self.recommend_calls: list[list[CompletedBook]] = []

    async def trending(self, *, user_id: UUID, days: int = 7, limit: int = 10) -> list[_Row4]:
        return self._trending[:limit]

    async def club_picks(self, *, user_id: UUID, limit: int = 10) -> list[_Row4]:
        return self._club_picks[:limit]

    async def recent_completed_books(
        self, user_id: UUID, *, limit: int = 5
    ) -> list[tuple[str, str]]:
        return self._completed[:limit]

    async def find_book_by_title(
        self, title: str, *, user_id: UUID, exclude_ids: set[UUID]
    ) -> _Row4 | None:
        row = self._catalog.get(title.lower())
        if row is None or row[0] in exclude_ids:
            return None
        return row

    async def books_by_genre_match(
        self, *, user_id: UUID, genre_keywords: list[str], limit: int = 10
    ) -> list[tuple[UUID, str, str, str | None, str]]:
        return [r for r in self._books_by_genre if r[4] in genre_keywords][:limit]

    async def community_popular(
        self, *, user_id: UUID, days: int = 7, limit: int = 6
    ) -> list[_Row4]:
        return []


class FakeAIRecommender:
    def __init__(self, suggestions: list[AIBookSuggestion]) -> None:
        self._suggestions = suggestions
        self.calls: list[list[CompletedBook]] = []

    async def recommend_books(
        self, *, completed_books: list[CompletedBook]
    ) -> list[AIBookSuggestion]:
        self.calls.append(completed_books)
        return self._suggestions


def _book(title: str = "Book") -> _Row4:
    return (uuid4(), title, "Author", None)


# ---------------------------------------------------------------------------
# trending
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_channel_trending_returns_books_with_reason() -> None:
    repo = FakeChannelRepository(trending=[_book("Hot Book")])
    svc = DiscoveryService(repo=repo)  # type: ignore[arg-type]

    items = await svc.get_channel_recommendations(uuid4(), channel=RecommendationChannel.TRENDING)

    assert len(items) == 1
    assert items[0]["title"] == "Hot Book"
    assert items[0]["reason"]
    assert "id" in items[0] and "strategy" not in items[0]


# ---------------------------------------------------------------------------
# club_picks
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_channel_club_picks_returns_books() -> None:
    repo = FakeChannelRepository(club_picks=[_book("Club Book")])
    svc = DiscoveryService(repo=repo)  # type: ignore[arg-type]

    items = await svc.get_channel_recommendations(uuid4(), channel=RecommendationChannel.CLUB_PICKS)

    assert [i["title"] for i in items] == ["Club Book"]
    assert items[0]["reason"] == "내가 속한 클럽에서 읽는 책"


# ---------------------------------------------------------------------------
# taste_match channel delegates to the genre strategy
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_channel_taste_match_delegates_to_strategy() -> None:
    user_id = uuid4()
    profile = _FakeProfile(user_id=user_id, genre_vector={"소설": 5})
    bid = uuid4()
    repo = FakeChannelRepository(
        profiles=[profile],
        books_by_genre=[(bid, "Novel", "Author", None, "소설")],
    )
    svc = DiscoveryService(repo=repo)  # type: ignore[arg-type]

    items = await svc.get_channel_recommendations(
        user_id, channel=RecommendationChannel.TASTE_MATCH
    )

    assert items[0]["title"] == "Novel"
    assert "소설" in items[0]["reason"]


# ---------------------------------------------------------------------------
# ai_picks — happy path resolves AI titles to catalog rows
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_channel_ai_picks_resolves_titles() -> None:
    user_id = uuid4()
    matched = _book("미움받을 용기")
    repo = FakeChannelRepository(
        completed=[("불안", "알랭 드 보통")],
        catalog={"미움받을 용기": matched},
    )
    ai = FakeAIRecommender(
        [
            AIBookSuggestion(title="미움받을 용기", author="기시미", reason="추천 이유"),
            AIBookSuggestion(title="존재하지 않는 책", author="X", reason="없음"),
        ]
    )
    svc = DiscoveryService(repo=repo, ai_recommender=ai)  # type: ignore[arg-type]

    items = await svc.get_channel_recommendations(user_id, channel=RecommendationChannel.AI_PICKS)

    # Only the catalog-matched suggestion is kept; the unmatched one is dropped.
    assert len(items) == 1
    assert items[0]["title"] == "미움받을 용기"
    assert items[0]["reason"] == "추천 이유"
    # The reader's completed history was forwarded to the adapter.
    assert ai.calls[0][0].title == "불안"


# ---------------------------------------------------------------------------
# ai_picks — fallbacks
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_channel_ai_picks_falls_back_without_history() -> None:
    """No completed books → fall back to trending without calling the adapter."""
    repo = FakeChannelRepository(completed=[], trending=[_book("Trending")])
    ai = FakeAIRecommender([])
    svc = DiscoveryService(repo=repo, ai_recommender=ai)  # type: ignore[arg-type]

    items = await svc.get_channel_recommendations(uuid4(), channel=RecommendationChannel.AI_PICKS)

    assert items[0]["title"] == "Trending"
    assert ai.calls == []  # adapter never invoked


@pytest.mark.asyncio
async def test_channel_ai_picks_falls_back_when_no_catalog_match() -> None:
    """AI suggested only unknown titles → fall back to trending."""
    repo = FakeChannelRepository(
        completed=[("어떤 책", "저자")],
        catalog={},
        trending=[_book("Trending")],
    )
    ai = FakeAIRecommender([AIBookSuggestion(title="없는 책", author="X", reason="없음")])
    svc = DiscoveryService(repo=repo, ai_recommender=ai)  # type: ignore[arg-type]

    items = await svc.get_channel_recommendations(uuid4(), channel=RecommendationChannel.AI_PICKS)

    assert items[0]["title"] == "Trending"


@pytest.mark.asyncio
async def test_channel_ai_picks_falls_back_without_adapter() -> None:
    """No AI adapter wired → fall back to trending."""
    repo = FakeChannelRepository(completed=[("어떤 책", "저자")], trending=[_book("Trending")])
    svc = DiscoveryService(repo=repo)  # type: ignore[arg-type]

    items = await svc.get_channel_recommendations(uuid4(), channel=RecommendationChannel.AI_PICKS)

    assert items[0]["title"] == "Trending"

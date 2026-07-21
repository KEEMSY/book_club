"""Unit tests for DiscoveryService — M44 strategy coverage.

Covers the four strategies added in M44:
- similar_readers  (cosine-similarity on taste vectors)
- taste_match      (genre-vector based)
- cold_start       (onboarding interests)
- cold_start auto-downgrade (insufficient reading history)

All tests use an in-memory FakeDiscoveryRepository — no DB required (CLAUDE.md §5).
"""

from __future__ import annotations

from dataclasses import dataclass, field
from uuid import UUID, uuid4

import pytest
from app.domains.discovery.service import DiscoveryService
from app.domains.discovery.strategies import RecommendationStrategy, cosine_similarity

# ---------------------------------------------------------------------------
# Minimal stubs for ORM models
# ---------------------------------------------------------------------------


@dataclass
class _FakeProfile:
    """Mirrors UserTasteProfile fields used by DiscoveryService."""

    user_id: UUID
    genre_vector: dict[str, int]
    author_vector: dict[str, int] = field(default_factory=dict)


@dataclass
class _FakeInterest:
    """Mirrors UserOnboardingInterest fields used by DiscoveryService."""

    category: str
    value: str


# ---------------------------------------------------------------------------
# Fake sub-repositories
# ---------------------------------------------------------------------------


class FakeTasteProfilesRepository:
    """Simulates TasteProfileRepository used via repo.taste_profiles.*."""

    def __init__(
        self,
        profiles: list[_FakeProfile] | None = None,
    ) -> None:
        self._profiles: dict[UUID, _FakeProfile] = {p.user_id: p for p in (profiles or [])}

    async def get(self, user_id: UUID) -> _FakeProfile | None:
        return self._profiles.get(user_id)

    async def list_all(self) -> list[_FakeProfile]:
        return list(self._profiles.values())


class FakeOnboardingInterestsRepository:
    """Simulates OnboardingInterestRepository used via repo.onboarding_interests.*."""

    def __init__(
        self,
        interests_by_user: dict[UUID, list[_FakeInterest]] | None = None,
    ) -> None:
        self._data: dict[UUID, list[_FakeInterest]] = interests_by_user or {}

    async def list_for_user(self, user_id: UUID) -> list[_FakeInterest]:
        return list(self._data.get(user_id, []))


# ---------------------------------------------------------------------------
# Row type aliases (match repository return shapes)
# ---------------------------------------------------------------------------

# (book_id, title, author, cover_url)
_Row4 = tuple[UUID, str, str, str | None]

# (book_id, title, author, cover_url, reader_count)
_Row5 = tuple[UUID, str, str, str | None, int]

# (book_id, title, author, cover_url, matched_genre)
_RowGenre = tuple[UUID, str, str, str | None, str]


# ---------------------------------------------------------------------------
# Fake top-level repository
# ---------------------------------------------------------------------------


class FakeDiscoveryRepository:
    """In-memory DiscoveryRepository for M44 strategy unit tests.

    Each strategy method is independently controllable via constructor args.
    """

    def __init__(
        self,
        *,
        profiles: list[_FakeProfile] | None = None,
        interests_by_user: dict[UUID, list[_FakeInterest]] | None = None,
        books_read_by_users_result: list[_Row5] | None = None,
        books_by_genre_result: list[_RowGenre] | None = None,
        community_popular_result: list[_Row4] | None = None,
        completed_count: int = 5,
    ) -> None:
        self.taste_profiles = FakeTasteProfilesRepository(profiles)
        self.onboarding_interests = FakeOnboardingInterestsRepository(interests_by_user)
        self._books_read_by_users: list[_Row5] = books_read_by_users_result or []
        self._books_by_genre: list[_RowGenre] = books_by_genre_result or []
        self._community_popular: list[_Row4] = community_popular_result or []
        self._completed_count = completed_count

    async def count_completed_books(self, user_id: UUID) -> int:
        return self._completed_count

    async def books_read_by_users(
        self,
        similar_user_ids: list[UUID],
        *,
        exclude_user_id: UUID,
        limit: int = 10,
    ) -> list[_Row5]:
        return self._books_read_by_users[:limit]

    async def books_by_genre_match(
        self,
        *,
        user_id: UUID,
        genre_keywords: list[str],
        limit: int = 10,
    ) -> list[_RowGenre]:
        # Filter to keywords requested so tests can assert on correct genre routing.
        return [r for r in self._books_by_genre if r[4] in genre_keywords][:limit]

    async def community_popular(
        self,
        *,
        user_id: UUID,
        days: int = 7,
        limit: int = 6,
    ) -> list[_Row4]:
        return self._community_popular[:limit]

    # similar_readers / recently_added are the old rule-based helpers used by
    # _rule_based(); they are not exercised by the M44 strategy tests but must
    # exist so _rule_based() doesn't AttributeError when called as fallback.

    async def similar_readers(self, *, user_id: UUID) -> list[_Row4]:
        return []

    async def recently_added(self, *, user_id: UUID) -> list[_Row4]:
        return []


# ---------------------------------------------------------------------------
# Factory helpers
# ---------------------------------------------------------------------------


def _book4(title: str = "Book", genre: str = "소설") -> tuple[_Row4, _RowGenre, _Row5]:
    """Return a triple of the same book in each row shape for convenience."""
    bid = uuid4()
    return (
        (bid, title, "Author", None),
        (bid, title, "Author", None, genre),
        (bid, title, "Author", None, 1),
    )


def _svc(repo: FakeDiscoveryRepository) -> DiscoveryService:
    return DiscoveryService(repo=repo)  # type: ignore[arg-type]


# ---------------------------------------------------------------------------
# Test 4 — similar_readers strategy returns books
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_strategy_similar_readers_returns_books() -> None:
    """similar_readers strategy returns books read by taste-similar users."""
    user_id = uuid4()
    other_id = uuid4()

    my_profile = _FakeProfile(user_id=user_id, genre_vector={"소설": 3, "에세이": 1})
    other_profile = _FakeProfile(user_id=other_id, genre_vector={"소설": 2, "에세이": 2})

    _, _genre_row, read_row = _book4("Similar User Book", "소설")

    repo = FakeDiscoveryRepository(
        profiles=[my_profile, other_profile],
        books_read_by_users_result=[read_row],
        completed_count=5,  # above threshold → no downgrade
    )
    svc = _svc(repo)

    results = await svc.get_recommendations(
        user_id=user_id,
        strategy=RecommendationStrategy.SIMILAR_READERS,
    )

    assert len(results) == 1
    assert results[0]["title"] == "Similar User Book"
    assert results[0]["strategy"] == RecommendationStrategy.SIMILAR_READERS


# ---------------------------------------------------------------------------
# Test 5 — taste_match uses genre vector
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_strategy_taste_match_uses_genre_vector() -> None:
    """taste_match picks books whose genre matches the user's top genre_vector keys."""
    user_id = uuid4()
    my_profile = _FakeProfile(user_id=user_id, genre_vector={"자기계발": 5, "소설": 2})

    _, genre_row, _ = _book4("Self-Help Book", "자기계발")

    repo = FakeDiscoveryRepository(
        profiles=[my_profile],
        books_by_genre_result=[genre_row],
        completed_count=5,
    )
    svc = _svc(repo)

    results = await svc.get_recommendations(
        user_id=user_id,
        strategy=RecommendationStrategy.TASTE_MATCH,
    )

    assert len(results) == 1
    assert results[0]["title"] == "Self-Help Book"
    assert results[0]["strategy"] == RecommendationStrategy.TASTE_MATCH
    # Reason should mention the matched genre.
    assert "자기계발" in results[0]["reason"]


# ---------------------------------------------------------------------------
# Test 6 — cold_start uses onboarding interests
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_strategy_cold_start_uses_onboarding() -> None:
    """cold_start recommends books matching the user's onboarding genre interests."""
    user_id = uuid4()
    interests = {user_id: [_FakeInterest(category="genre", value="에세이")]}

    _, genre_row, _ = _book4("Essay Book", "에세이")

    repo = FakeDiscoveryRepository(
        interests_by_user=interests,
        books_by_genre_result=[genre_row],
        completed_count=0,
    )
    svc = _svc(repo)

    results = await svc.get_recommendations(
        user_id=user_id,
        strategy=RecommendationStrategy.COLD_START,
    )

    assert len(results) == 1
    assert results[0]["title"] == "Essay Book"
    assert results[0]["strategy"] == RecommendationStrategy.COLD_START
    assert "에세이" in results[0]["reason"]


# ---------------------------------------------------------------------------
# Test 7 — cold_start auto-downgrade for users without a profile
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_cold_start_fallback_when_no_profile() -> None:
    """Users with < 3 completed books are auto-downgraded to cold_start."""
    user_id = uuid4()
    interests = {user_id: [_FakeInterest(category="genre", value="소설")]}

    _, genre_row, _ = _book4("Novel", "소설")

    # completed_count=1 is below _COLD_START_THRESHOLD=3 → auto-downgrade
    repo = FakeDiscoveryRepository(
        interests_by_user=interests,
        books_by_genre_result=[genre_row],
        completed_count=1,
    )
    svc = _svc(repo)

    # Request SIMILAR_READERS but expect cold_start downgrade.
    results = await svc.get_recommendations(
        user_id=user_id,
        strategy=RecommendationStrategy.SIMILAR_READERS,
    )

    assert len(results) == 1
    assert results[0]["strategy"] == RecommendationStrategy.COLD_START


# ---------------------------------------------------------------------------
# Test 8 — reason text is present for each strategy
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_similar_readers_reason_text() -> None:
    """Each strategy attaches a non-empty, strategy-appropriate reason string."""
    user_id = uuid4()
    other_id = uuid4()

    my_profile = _FakeProfile(user_id=user_id, genre_vector={"소설": 3})
    other_profile = _FakeProfile(user_id=other_id, genre_vector={"소설": 2})

    _, _, read_row = _book4("Some Book", "소설")

    repo = FakeDiscoveryRepository(
        profiles=[my_profile, other_profile],
        books_read_by_users_result=[read_row],
        completed_count=5,
    )
    svc = _svc(repo)

    results = await svc.get_recommendations(
        user_id=user_id,
        strategy=RecommendationStrategy.SIMILAR_READERS,
    )

    assert results, "Expected at least one recommendation"
    for item in results:
        assert item["reason"], "reason must not be empty"
        assert len(item["reason"]) > 0


# ---------------------------------------------------------------------------
# Test 9 — cosine_similarity handles zero vectors safely
# ---------------------------------------------------------------------------


def test_cosine_similarity_zero_vectors() -> None:
    """cosine_similarity returns 0.0 for empty or all-zero vectors without error."""
    # Both vectors empty
    assert cosine_similarity({}, {}) == 0.0

    # One side empty
    assert cosine_similarity({"소설": 3}, {}) == 0.0
    assert cosine_similarity({}, {"에세이": 2}) == 0.0

    # No shared keys (dot product == 0)
    assert cosine_similarity({"소설": 1}, {"에세이": 1}) == 0.0

    # Normal case: identical vectors → similarity == 1.0
    import math

    result = cosine_similarity({"소설": 2, "에세이": 1}, {"소설": 2, "에세이": 1})
    assert math.isclose(result, 1.0, rel_tol=1e-6)

"""Unit tests for DiscoveryService — collaborative (rule-based) strategy.

Uses a FakeDiscoveryRepository (in-memory) — no DB required (CLAUDE.md §5).

Updated for M44: the repository interface gained count_completed_books,
taste_profiles, and onboarding_interests.  The fake supplies stubs for all
three so the collaborative strategy tests can still run without a real DB.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from uuid import UUID, uuid4

import pytest
from app.domains.discovery.service import DiscoveryService

# ---------------------------------------------------------------------------
# Minimal stubs
# ---------------------------------------------------------------------------


@dataclass
class _FakeProfile:
    user_id: UUID
    genre_vector: dict[str, int] = field(default_factory=dict)
    author_vector: dict[str, int] = field(default_factory=dict)


class _FakeTasteProfilesRepo:
    async def get(self, user_id: UUID) -> _FakeProfile | None:
        return None

    async def list_all(self) -> list[_FakeProfile]:
        return []


class _FakeOnboardingInterestsRepo:
    async def list_for_user(self, user_id: UUID) -> list:
        return []


# ---------------------------------------------------------------------------
# Fake repository
# ---------------------------------------------------------------------------

_Row = tuple[UUID, str, str, str | None]


class FakeDiscoveryRepository:
    """In-memory fake for the collaborative (rule-based) strategy tests.

    Provides the minimum surface required by DiscoveryService:
    - count_completed_books  (M44 addition — returns a fixed high value so
      the dispatcher never downgrades to cold_start)
    - taste_profiles / onboarding_interests  (M44 additions — empty stubs)
    - community_popular / similar_readers / recently_added
    """

    def __init__(
        self,
        *,
        popular: list[_Row] | None = None,
        similar: list[_Row] | None = None,
        recent: list[_Row] | None = None,
    ) -> None:
        self._popular = popular or []
        self._similar = similar or []
        self._recent = recent or []
        self.taste_profiles = _FakeTasteProfilesRepo()
        self.onboarding_interests = _FakeOnboardingInterestsRepo()

    async def count_completed_books(self, user_id: UUID) -> int:
        # Return a value above the cold-start threshold (3) so the dispatcher
        # never auto-downgrades these collaborative-strategy tests.
        return 10

    async def community_popular(self, *, user_id: UUID, **kwargs) -> list[_Row]:
        return list(self._popular)

    async def similar_readers(self, *, user_id: UUID, **kwargs) -> list[_Row]:
        return list(self._similar)

    async def recently_added(self, *, user_id: UUID, **kwargs) -> list[_Row]:
        return list(self._recent)

    async def books_read_by_users(self, similar_user_ids, *, exclude_user_id, limit=10):
        return []

    async def books_by_genre_match(self, *, user_id, genre_keywords, limit=10):
        return []


def _row(title: str = "Book", author: str = "Author") -> _Row:
    return (uuid4(), title, author, None)


def _svc(
    popular: list[_Row] | None = None,
    similar: list[_Row] | None = None,
    recent: list[_Row] | None = None,
) -> DiscoveryService:
    return DiscoveryService(
        repo=FakeDiscoveryRepository(popular=popular, similar=similar, recent=recent)
    )  # type: ignore[arg-type]


# ---------------------------------------------------------------------------
# Tests
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_empty_sources_returns_empty_list() -> None:
    svc = _svc()
    result = await svc.get_recommendations(user_id=uuid4())
    assert result == []


@pytest.mark.asyncio
async def test_popular_books_get_reason_community_popular() -> None:
    row = _row("Popular Book")
    svc = _svc(popular=[row])
    result = await svc.get_recommendations(user_id=uuid4())
    assert len(result) == 1
    # M44: reason strings are Korean UI text.
    assert "커뮤니티" in result[0]["reason"]
    assert result[0]["title"] == "Popular Book"


@pytest.mark.asyncio
async def test_similar_readers_reason_label() -> None:
    row = _row("Similar Book")
    svc = _svc(similar=[row])
    result = await svc.get_recommendations(user_id=uuid4())
    assert "비슷한" in result[0]["reason"]


@pytest.mark.asyncio
async def test_recently_added_reason_label() -> None:
    row = _row("Recent Book")
    svc = _svc(recent=[row])
    result = await svc.get_recommendations(user_id=uuid4())
    assert "최근" in result[0]["reason"]


@pytest.mark.asyncio
async def test_deduplication_across_sources() -> None:
    shared_id = uuid4()
    shared: _Row = (shared_id, "Shared", "Author", None)
    unique_popular: _Row = (uuid4(), "Only Popular", "A", None)
    unique_similar: _Row = (uuid4(), "Only Similar", "B", None)

    svc = _svc(popular=[shared, unique_popular], similar=[shared, unique_similar])
    result = await svc.get_recommendations(user_id=uuid4())

    ids = [r["id"] for r in result]
    assert ids.count(str(shared_id)) == 1
    assert len(result) == 3


@pytest.mark.asyncio
async def test_priority_order_popular_then_similar_then_recent() -> None:
    popular_row = _row("Pop")
    similar_row = _row("Sim")
    recent_row = _row("Rec")

    svc = _svc(popular=[popular_row], similar=[similar_row], recent=[recent_row])
    result = await svc.get_recommendations(user_id=uuid4())

    titles = [r["title"] for r in result]
    assert titles == ["Pop", "Sim", "Rec"]


@pytest.mark.asyncio
async def test_result_capped_at_limit() -> None:
    """get_recommendations respects the limit parameter (default 10)."""
    rows = [_row(f"Book {i}") for i in range(20)]
    svc = _svc(popular=rows)
    result = await svc.get_recommendations(user_id=uuid4())
    assert len(result) <= 10


@pytest.mark.asyncio
async def test_result_capped_at_custom_limit() -> None:
    rows = [_row(f"Book {i}") for i in range(20)]
    svc = _svc(popular=rows)
    result = await svc.get_recommendations(user_id=uuid4(), limit=5)
    assert len(result) <= 5

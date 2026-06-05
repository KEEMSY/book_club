"""Unit tests for DiscoveryService.

Uses a FakeDiscoveryRepository (in-memory) — no DB required.
"""

from __future__ import annotations

from uuid import UUID, uuid4

import pytest
from app.domains.discovery.service import DiscoveryService


# ---------------------------------------------------------------------------
# Fake repository
# ---------------------------------------------------------------------------

_Row = tuple[UUID, str, str, str | None]


class FakeDiscoveryRepository:
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

    async def community_popular(self, *, user_id: UUID) -> list[_Row]:
        return list(self._popular)

    async def similar_readers(self, *, user_id: UUID) -> list[_Row]:
        return list(self._similar)

    async def recently_added(self, *, user_id: UUID) -> list[_Row]:
        return list(self._recent)


def _row(title: str = "Book", author: str = "Author") -> _Row:
    return (uuid4(), title, author, None)


def _svc(
    popular: list[_Row] | None = None,
    similar: list[_Row] | None = None,
    recent: list[_Row] | None = None,
) -> DiscoveryService:
    return DiscoveryService(repo=FakeDiscoveryRepository(popular=popular, similar=similar, recent=recent))  # type: ignore[arg-type]


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
    assert result[0]["reason"] == "community_popular"
    assert result[0]["title"] == "Popular Book"


@pytest.mark.asyncio
async def test_similar_readers_reason_label() -> None:
    row = _row("Similar Book")
    svc = _svc(similar=[row])
    result = await svc.get_recommendations(user_id=uuid4())
    assert result[0]["reason"] == "similar_readers"


@pytest.mark.asyncio
async def test_recently_added_reason_label() -> None:
    row = _row("Recent Book")
    svc = _svc(recent=[row])
    result = await svc.get_recommendations(user_id=uuid4())
    assert result[0]["reason"] == "recently_added"


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

    reasons = [r["reason"] for r in result]
    assert reasons == ["community_popular", "similar_readers", "recently_added"]


@pytest.mark.asyncio
async def test_result_capped_at_15() -> None:
    rows = [_row(f"Book {i}") for i in range(20)]
    svc = _svc(popular=rows)
    result = await svc.get_recommendations(user_id=uuid4())
    assert len(result) <= 15

"""Unit tests for CommunityService.get_my_activity (BC-80 — "내 활동").

Covers the aggregation logic only — each Activity*QueryPort is faked in
memory, no DB. The unrelated CommunityService dependencies (post feed,
profile) are stubbed with no-op fakes since ``get_my_activity`` never
touches them.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import UTC, datetime
from uuid import UUID, uuid4

import pytest
from app.domains.community.ports import (
    ActivityAgendaItem,
    ActivityBookItem,
    ActivityClubItem,
    ActivityHighlightItem,
    ActivityReviewItem,
)
from app.domains.community.service import CommunityService

# ---------------------------------------------------------------------------
# No-op fakes for the CommunityService fields get_my_activity never touches.
# ---------------------------------------------------------------------------


class _UnusedAdapter:
    """Placeholder satisfying a Port's shape without implementing any method —
    ``get_my_activity`` never calls these collaborators."""


# ---------------------------------------------------------------------------
# Fakes for the 5 Activity*QueryPort collaborators
# ---------------------------------------------------------------------------


@dataclass
class FakeActivityReviewQuery:
    items: list[ActivityReviewItem] = field(default_factory=list)
    total: int = 0

    async def preview(self, user_id: UUID, limit: int) -> tuple[int, list[ActivityReviewItem]]:
        return self.total, self.items[:limit]


@dataclass
class FakeActivityHighlightQuery:
    items: list[ActivityHighlightItem] = field(default_factory=list)
    total: int = 0

    async def preview(self, user_id: UUID, limit: int) -> tuple[int, list[ActivityHighlightItem]]:
        return self.total, self.items[:limit]


@dataclass
class FakeActivityAgendaQuery:
    items: list[ActivityAgendaItem] = field(default_factory=list)
    total: int = 0

    async def preview(self, user_id: UUID, limit: int) -> tuple[int, list[ActivityAgendaItem]]:
        return self.total, self.items[:limit]


@dataclass
class FakeActivityClubQuery:
    items: list[ActivityClubItem] = field(default_factory=list)

    async def preview(self, user_id: UUID, limit: int) -> tuple[int, list[ActivityClubItem]]:
        return len(self.items), self.items[:limit]


@dataclass
class FakeActivityLibraryQuery:
    items: list[ActivityBookItem] = field(default_factory=list)
    total: int = 0

    async def preview(self, user_id: UUID, limit: int) -> tuple[int, list[ActivityBookItem]]:
        return self.total, self.items[:limit]


def _make_svc(
    *,
    reviews: FakeActivityReviewQuery | None = None,
    highlights: FakeActivityHighlightQuery | None = None,
    agendas: FakeActivityAgendaQuery | None = None,
    clubs: FakeActivityClubQuery | None = None,
    library: FakeActivityLibraryQuery | None = None,
) -> CommunityService:
    return CommunityService(
        community_repo=_UnusedAdapter(),  # type: ignore[arg-type]
        post_repo=_UnusedAdapter(),  # type: ignore[arg-type]
        reactions=_UnusedAdapter(),  # type: ignore[arg-type]
        image_storage=_UnusedAdapter(),  # type: ignore[arg-type]
        user_repo=_UnusedAdapter(),  # type: ignore[arg-type]
        reading_query=_UnusedAdapter(),  # type: ignore[arg-type]
        challenge_query=_UnusedAdapter(),  # type: ignore[arg-type]
        highlight_query=_UnusedAdapter(),  # type: ignore[arg-type]
        activity_reviews=reviews or FakeActivityReviewQuery(),
        activity_highlights=highlights or FakeActivityHighlightQuery(),
        activity_agendas=agendas or FakeActivityAgendaQuery(),
        activity_clubs=clubs or FakeActivityClubQuery(),
        activity_library=library or FakeActivityLibraryQuery(),
    )


def _review(book_title: str = "책") -> ActivityReviewItem:
    return ActivityReviewItem(
        id=uuid4(),
        book_id=uuid4(),
        book_title=book_title,
        book_cover_url=None,
        rating=4.5,
        body="좋아요",
        created_at=datetime.now(tz=UTC),
    )


def _highlight() -> ActivityHighlightItem:
    return ActivityHighlightItem(
        id=uuid4(),
        book_id=uuid4(),
        book_title="책",
        book_cover_url=None,
        quote_text="문장",
        created_at=datetime.now(tz=UTC),
    )


def _agenda() -> ActivityAgendaItem:
    return ActivityAgendaItem(
        id=uuid4(),
        club_id=uuid4(),
        club_name="모임",
        session_id=uuid4(),
        session_title="1회차",
        status="published",
        published_at=datetime.now(tz=UTC),
        created_at=datetime.now(tz=UTC),
    )


def _club() -> ActivityClubItem:
    return ActivityClubItem(id=uuid4(), name="모임", created_at=datetime.now(tz=UTC))


def _book() -> ActivityBookItem:
    return ActivityBookItem(
        user_book_id=uuid4(),
        book_id=uuid4(),
        title="책",
        cover_url=None,
        current_chapter=3,
        started_at=datetime.now(tz=UTC),
    )


@pytest.mark.asyncio
async def test_get_my_activity_aggregates_all_categories() -> None:
    svc = _make_svc(
        reviews=FakeActivityReviewQuery(items=[_review()], total=1),
        highlights=FakeActivityHighlightQuery(items=[_highlight(), _highlight()], total=2),
        agendas=FakeActivityAgendaQuery(items=[_agenda()], total=1),
        clubs=FakeActivityClubQuery(items=[_club()]),
        library=FakeActivityLibraryQuery(items=[_book()], total=1),
    )

    summary = await svc.get_my_activity(user_id=uuid4())

    assert summary.counts.reviews == 1
    assert summary.counts.highlights == 2
    assert summary.counts.agendas == 1
    assert summary.counts.clubs == 1
    assert summary.counts.reading_books == 1
    assert len(summary.reviews) == 1
    assert len(summary.highlights) == 2
    assert len(summary.agendas) == 1
    assert len(summary.clubs) == 1
    assert len(summary.reading_books) == 1


@pytest.mark.asyncio
async def test_get_my_activity_empty_when_no_activity() -> None:
    svc = _make_svc()

    summary = await svc.get_my_activity(user_id=uuid4())

    assert summary.counts.reviews == 0
    assert summary.counts.highlights == 0
    assert summary.counts.agendas == 0
    assert summary.counts.clubs == 0
    assert summary.counts.reading_books == 0
    assert summary.reviews == []
    assert summary.highlights == []
    assert summary.agendas == []
    assert summary.clubs == []
    assert summary.reading_books == []


@pytest.mark.asyncio
async def test_get_my_activity_preview_truncates_but_count_reflects_total() -> None:
    """Count reflects the true total even when the preview list is capped."""
    many_reviews = [_review() for _ in range(9)]
    svc = _make_svc(reviews=FakeActivityReviewQuery(items=many_reviews, total=9))

    summary = await svc.get_my_activity(user_id=uuid4())

    assert summary.counts.reviews == 9
    assert len(summary.reviews) == 5  # _ACTIVITY_PREVIEW_SIZE

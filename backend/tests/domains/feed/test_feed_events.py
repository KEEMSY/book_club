"""Unit tests for M37 FeedService activity-event methods.

Tests use a minimal FakeEventRepo that satisfies FeedEventRepositoryPort and
a minimal FeedService constructed with only the feed_events field wired.
All other ports are omitted — the milestone methods do not use them.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from uuid import UUID, uuid4

import pytest
from app.domains.feed.ports import FeedEventRepositoryPort
from app.domains.feed.service import FeedService


# ---------------------------------------------------------------------------
# Minimal fake
# ---------------------------------------------------------------------------


@dataclass
class FakeFeedEventRepo:
    events: list[dict] = field(default_factory=list)

    async def create_event(
        self,
        *,
        user_id: UUID,
        event_type: str,
        metadata: dict | None,
    ) -> object:
        self.events.append(
            {"user_id": user_id, "event_type": event_type, "metadata": metadata}
        )
        return object()


def _svc() -> tuple[FeedService, FakeFeedEventRepo]:
    repo = FakeFeedEventRepo()
    svc = FeedService(  # type: ignore[call-arg]
        posts=None,  # type: ignore[arg-type]
        reactions=None,  # type: ignore[arg-type]
        comments=None,  # type: ignore[arg-type]
        image_storage=None,  # type: ignore[arg-type]
        book_query=None,  # type: ignore[arg-type]
        highlights=None,  # type: ignore[arg-type]
        feed_events=repo,  # type: ignore[arg-type]
    )
    return svc, repo


# ---------------------------------------------------------------------------
# record_chapter_milestone
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_chapter_milestone_fires_on_multiple_of_5() -> None:
    svc, repo = _svc()
    await svc.record_chapter_milestone(user_id=uuid4(), book_id=uuid4(), chapter=5)
    assert len(repo.events) == 1
    assert repo.events[0]["event_type"] == "CHAPTER_MILESTONE"
    assert repo.events[0]["metadata"]["chapter"] == 5


@pytest.mark.asyncio
async def test_chapter_milestone_skips_non_multiple_of_5() -> None:
    svc, repo = _svc()
    for chapter in (1, 2, 3, 4, 6, 7, 8, 9, 11):
        await svc.record_chapter_milestone(user_id=uuid4(), book_id=uuid4(), chapter=chapter)
    assert len(repo.events) == 0


@pytest.mark.asyncio
async def test_chapter_milestone_fires_at_10_20_etc() -> None:
    svc, repo = _svc()
    user = uuid4()
    book = uuid4()
    for chapter in (5, 10, 15, 20):
        await svc.record_chapter_milestone(user_id=user, book_id=book, chapter=chapter)
    assert len(repo.events) == 4


@pytest.mark.asyncio
async def test_chapter_milestone_no_op_when_feed_events_not_wired() -> None:
    svc = FeedService(  # type: ignore[call-arg]
        posts=None,  # type: ignore[arg-type]
        reactions=None,  # type: ignore[arg-type]
        comments=None,  # type: ignore[arg-type]
        image_storage=None,  # type: ignore[arg-type]
        book_query=None,  # type: ignore[arg-type]
        highlights=None,  # type: ignore[arg-type]
    )
    # Should not raise even though feed_events is None
    await svc.record_chapter_milestone(user_id=uuid4(), book_id=uuid4(), chapter=5)


# ---------------------------------------------------------------------------
# record_streak_milestone
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
@pytest.mark.parametrize("streak", [3, 7, 14, 30, 60, 100])
async def test_streak_milestone_fires_for_threshold_values(streak: int) -> None:
    svc, repo = _svc()
    await svc.record_streak_milestone(user_id=uuid4(), streak_days=streak)
    assert len(repo.events) == 1
    assert repo.events[0]["event_type"] == "STREAK_MILESTONE"
    assert repo.events[0]["metadata"]["streak_days"] == streak


@pytest.mark.asyncio
@pytest.mark.parametrize("streak", [1, 2, 4, 5, 6, 8, 50, 99, 101])
async def test_streak_milestone_skips_non_threshold_values(streak: int) -> None:
    svc, repo = _svc()
    await svc.record_streak_milestone(user_id=uuid4(), streak_days=streak)
    assert len(repo.events) == 0


# ---------------------------------------------------------------------------
# record_book_completed
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_book_completed_records_event() -> None:
    svc, repo = _svc()
    user = uuid4()
    book = uuid4()
    await svc.record_book_completed(user_id=user, book_id=book)
    assert len(repo.events) == 1
    ev = repo.events[0]
    assert ev["event_type"] == "BOOK_COMPLETED"
    assert ev["metadata"]["book_id"] == str(book)
    assert ev["user_id"] == user


# ---------------------------------------------------------------------------
# record_club_joined
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_club_joined_records_event() -> None:
    svc, repo = _svc()
    user = uuid4()
    club = uuid4()
    await svc.record_club_joined(user_id=user, club_id=club)
    assert len(repo.events) == 1
    ev = repo.events[0]
    assert ev["event_type"] == "CLUB_JOINED"
    assert ev["metadata"]["club_id"] == str(club)

"""Unit tests for M51 FeedService highlight-sharing methods.

Covers update_highlight_visibility, share_highlight_to_feed, and
get_explore_highlights with in-memory fakes — no DB, no HTTP. Fakes
implement only the Port methods the service calls (per the M47 convention).
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import UTC, datetime, timedelta
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError, NotFoundError
from app.domains.feed.models import FeedEvent, FeedEventType, PostHighlight
from app.domains.feed.ports import ExploreHighlightItem
from app.domains.feed.service import FeedService

_BOOK_ID = uuid4()


def _make_highlight(
    *,
    user_id: UUID,
    visibility: str = "private",
    shared_at: datetime | None = None,
    deleted_at: datetime | None = None,
    created_at: datetime | None = None,
    quote_text: str = "quote",
) -> PostHighlight:
    # ORM constructor initialises SQLAlchemy instrumentation; setting via
    # __new__ would leave attributes unbound.
    h = PostHighlight(
        user_id=user_id,
        user_book_id=uuid4(),
        quote_text=quote_text,
        page_number=42,
        note_text=None,
    )
    h.id = uuid4()
    h.visibility = visibility
    h.shared_at = shared_at
    h.deleted_at = deleted_at
    h.created_at = created_at or datetime.now(tz=UTC)
    return h


@dataclass
class FakeHighlightRepo:
    """In-memory HighlightRepositoryPort for M51 tests."""

    by_id: dict[UUID, PostHighlight] = field(default_factory=dict)
    reaction_counts: dict[UUID, int] = field(default_factory=dict)

    def seed(self, highlight: PostHighlight) -> PostHighlight:
        self.by_id[highlight.id] = highlight
        return highlight

    async def get_by_id(self, highlight_id: UUID) -> PostHighlight | None:
        return self.by_id.get(highlight_id)

    async def set_visibility(self, highlight_id: UUID, visibility: str) -> None:
        self.by_id[highlight_id].visibility = visibility

    async def mark_shared(self, highlight_id: UUID, *, shared_at: datetime) -> None:
        row = self.by_id[highlight_id]
        row.shared_at = shared_at
        row.visibility = "public"

    async def list_public(self, *, limit: int, sort: str) -> list[ExploreHighlightItem]:
        rows = [h for h in self.by_id.values() if h.visibility == "public" and h.deleted_at is None]
        if sort == "popular":
            rows.sort(
                key=lambda h: (self.reaction_counts.get(h.id, 0), h.created_at),
                reverse=True,
            )
        else:
            rows.sort(key=lambda h: h.created_at, reverse=True)
        return [
            ExploreHighlightItem(
                highlight=h,
                book_id=_BOOK_ID,
                book_title="Book",
                book_cover_url=None,
                reaction_count=self.reaction_counts.get(h.id, 0),
            )
            for h in rows[:limit]
        ]


@dataclass
class FakeFeedEventRepo:
    """In-memory FeedEventRepositoryPort for M51 tests."""

    events: list[FeedEvent] = field(default_factory=list)

    async def create_event(
        self, *, user_id: UUID, event_type: str, metadata: dict | None
    ) -> object:
        ev = FeedEvent(user_id=user_id, event_type=event_type, event_metadata=metadata)
        ev.id = uuid4()
        ev.created_at = datetime.now(tz=UTC)
        self.events.append(ev)
        return ev

    async def find_highlight_share(self, highlight_id: UUID) -> FeedEvent | None:
        for ev in self.events:
            md = ev.event_metadata or {}
            if ev.event_type == FeedEventType.HIGHLIGHT_SHARED.value and md.get(
                "highlight_id"
            ) == str(highlight_id):
                return ev
        return None


def _make_svc(
    highlights: FakeHighlightRepo | None = None,
    feed_events: FakeFeedEventRepo | None = None,
) -> FeedService:
    return FeedService(  # type: ignore[call-arg]
        posts=None,  # type: ignore[arg-type]
        reactions=None,  # type: ignore[arg-type]
        comments=None,  # type: ignore[arg-type]
        image_storage=None,  # type: ignore[arg-type]
        book_query=None,  # type: ignore[arg-type]
        highlights=highlights or FakeHighlightRepo(),
        feed_events=feed_events or FakeFeedEventRepo(),
    )


# ---------------------------------------------------------------------------
# update_highlight_visibility
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_update_visibility_success() -> None:
    user_id = uuid4()
    repo = FakeHighlightRepo()
    highlight = repo.seed(_make_highlight(user_id=user_id))
    svc = _make_svc(highlights=repo)

    result = await svc.update_highlight_visibility(user_id, highlight.id, "followers")

    assert result.visibility == "followers"
    assert repo.by_id[highlight.id].visibility == "followers"


@pytest.mark.asyncio
async def test_update_visibility_other_user_forbidden() -> None:
    owner_id, attacker_id = uuid4(), uuid4()
    repo = FakeHighlightRepo()
    highlight = repo.seed(_make_highlight(user_id=owner_id))
    svc = _make_svc(highlights=repo)

    with pytest.raises(NotFoundError):
        await svc.update_highlight_visibility(attacker_id, highlight.id, "public")

    # The visibility must remain untouched.
    assert repo.by_id[highlight.id].visibility == "private"


@pytest.mark.asyncio
async def test_update_visibility_rejects_unknown_value() -> None:
    user_id = uuid4()
    repo = FakeHighlightRepo()
    highlight = repo.seed(_make_highlight(user_id=user_id))
    svc = _make_svc(highlights=repo)

    with pytest.raises(ConflictError):
        await svc.update_highlight_visibility(user_id, highlight.id, "everyone")


# ---------------------------------------------------------------------------
# share_highlight_to_feed
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_share_highlight_creates_event() -> None:
    user_id = uuid4()
    repo = FakeHighlightRepo()
    events = FakeFeedEventRepo()
    highlight = repo.seed(_make_highlight(user_id=user_id))
    svc = _make_svc(highlights=repo, feed_events=events)

    event = await svc.share_highlight_to_feed(user_id, highlight.id)

    assert event.event_type == FeedEventType.HIGHLIGHT_SHARED.value
    assert len(events.events) == 1
    assert (event.event_metadata or {})["highlight_id"] == str(highlight.id)


@pytest.mark.asyncio
async def test_share_highlight_sets_public_and_shared_at() -> None:
    user_id = uuid4()
    repo = FakeHighlightRepo()
    highlight = repo.seed(_make_highlight(user_id=user_id))
    svc = _make_svc(highlights=repo)

    await svc.share_highlight_to_feed(user_id, highlight.id)

    stored = repo.by_id[highlight.id]
    assert stored.visibility == "public"
    assert stored.shared_at is not None


@pytest.mark.asyncio
async def test_share_highlight_idempotent_returns_existing_event() -> None:
    user_id = uuid4()
    repo = FakeHighlightRepo()
    events = FakeFeedEventRepo()
    highlight = repo.seed(_make_highlight(user_id=user_id))
    svc = _make_svc(highlights=repo, feed_events=events)

    first = await svc.share_highlight_to_feed(user_id, highlight.id)
    second = await svc.share_highlight_to_feed(user_id, highlight.id)

    assert first.id == second.id
    assert len(events.events) == 1  # no duplicate event created


@pytest.mark.asyncio
async def test_share_highlight_other_user_forbidden() -> None:
    owner_id, attacker_id = uuid4(), uuid4()
    repo = FakeHighlightRepo()
    highlight = repo.seed(_make_highlight(user_id=owner_id))
    svc = _make_svc(highlights=repo)

    with pytest.raises(NotFoundError):
        await svc.share_highlight_to_feed(attacker_id, highlight.id)


# ---------------------------------------------------------------------------
# get_explore_highlights
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_explore_recent_sort_newest_first() -> None:
    user_id = uuid4()
    repo = FakeHighlightRepo()
    now = datetime.now(tz=UTC)
    older = repo.seed(
        _make_highlight(user_id=user_id, visibility="public", created_at=now - timedelta(hours=1))
    )
    newer = repo.seed(_make_highlight(user_id=user_id, visibility="public", created_at=now))
    svc = _make_svc(highlights=repo)

    items = await svc.get_explore_highlights(sort="recent")

    assert [i.highlight.id for i in items] == [newer.id, older.id]


@pytest.mark.asyncio
async def test_explore_excludes_private_highlights() -> None:
    user_id = uuid4()
    repo = FakeHighlightRepo()
    repo.seed(_make_highlight(user_id=user_id, visibility="private"))
    repo.seed(_make_highlight(user_id=user_id, visibility="followers"))
    public = repo.seed(_make_highlight(user_id=user_id, visibility="public"))
    svc = _make_svc(highlights=repo)

    items = await svc.get_explore_highlights()

    assert [i.highlight.id for i in items] == [public.id]


@pytest.mark.asyncio
async def test_explore_popular_sort_by_reaction_count() -> None:
    user_id = uuid4()
    repo = FakeHighlightRepo()
    low = repo.seed(_make_highlight(user_id=user_id, visibility="public"))
    high = repo.seed(_make_highlight(user_id=user_id, visibility="public"))
    repo.reaction_counts[low.id] = 1
    repo.reaction_counts[high.id] = 9
    svc = _make_svc(highlights=repo)

    items = await svc.get_explore_highlights(sort="popular")

    assert [i.highlight.id for i in items] == [high.id, low.id]
    assert items[0].reaction_count == 9


@pytest.mark.asyncio
async def test_explore_clamps_limit_to_max() -> None:
    user_id = uuid4()
    repo = FakeHighlightRepo()
    for _ in range(55):
        repo.seed(_make_highlight(user_id=user_id, visibility="public"))
    svc = _make_svc(highlights=repo)

    items = await svc.get_explore_highlights(limit=1000)

    assert len(items) == 50  # _EXPLORE_PAGE_MAX

"""Unit tests for EventService — in-memory fakes, no DB (CLAUDE.md §5).

Covers the three behaviours called out in the M64 spec — nearby distance
maths, waitlist capacity overflow, and review duplicate-prevention — plus the
surrounding edge cases (radius cutoff, sorting, pagination, unknown entities).
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import UTC, datetime, timedelta
from decimal import Decimal
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError, NotFoundError
from app.domains.event.repository import EventWithCount
from app.domains.event.service import EventService, haversine_km

# Seoul City Hall — the default mobile query origin.
_SEOUL = (37.5663, 126.9779)


# ---------------------------------------------------------------------------
# Fakes
# ---------------------------------------------------------------------------


@dataclass
class _FakeEvent:
    id: UUID
    title: str
    event_at: datetime
    lat: float | None = None
    lng: float | None = None
    description: str | None = None
    address: str | None = None
    category: str | None = None
    max_attendees: int | None = None
    is_public: bool = True
    club_id: UUID | None = None
    book_id: UUID | None = None
    deleted_at: datetime | None = None
    created_at: datetime = field(default_factory=lambda: datetime.now(tz=UTC))


@dataclass
class _FakeReview:
    id: UUID
    event_id: UUID
    reviewer_id: UUID
    rating: Decimal
    body: str | None
    created_at: datetime = field(default_factory=lambda: datetime.now(tz=UTC))


@dataclass
class FakeEventRepository:
    events: dict[UUID, _FakeEvent] = field(default_factory=dict)
    # event_id -> ordered list of (user_id) in join order.
    waitlist: dict[UUID, list[UUID]] = field(default_factory=dict)
    reviews: list[_FakeReview] = field(default_factory=list)

    def add(self, event: _FakeEvent) -> None:
        self.events[event.id] = event

    async def create_event(self, **kwargs: object) -> _FakeEvent:
        event = _FakeEvent(
            id=uuid4(),
            title=kwargs["title"],  # type: ignore[arg-type]
            event_at=kwargs["event_at"],  # type: ignore[arg-type]
            lat=kwargs["lat"],  # type: ignore[arg-type]
            lng=kwargs["lng"],  # type: ignore[arg-type]
            description=kwargs["description"],  # type: ignore[arg-type]
            address=kwargs["address"],  # type: ignore[arg-type]
            category=kwargs["category"],  # type: ignore[arg-type]
            max_attendees=kwargs["max_attendees"],  # type: ignore[arg-type]
            is_public=kwargs["is_public"],  # type: ignore[arg-type]
            club_id=kwargs["club_id"],  # type: ignore[arg-type]
            book_id=kwargs["book_id"],  # type: ignore[arg-type]
        )
        self.add(event)
        return event

    async def get_event(self, event_id: UUID) -> _FakeEvent | None:
        ev = self.events.get(event_id)
        return ev if ev is not None and ev.deleted_at is None else None

    async def list_candidates_in_bbox(
        self,
        *,
        min_lat: float,
        max_lat: float,
        min_lng: float,
        max_lng: float,
        category: str | None = None,
        after: datetime | None = None,
    ) -> list[EventWithCount]:
        out: list[EventWithCount] = []
        for ev in self.events.values():
            if ev.deleted_at is not None or not ev.is_public:
                continue
            if ev.lat is None or ev.lng is None:
                continue
            if not (min_lat <= ev.lat <= max_lat and min_lng <= ev.lng <= max_lng):
                continue
            if category is not None and ev.category != category:
                continue
            if after is not None and ev.event_at < after:
                continue
            out.append(EventWithCount(event=ev, joined_count=len(self.waitlist.get(ev.id, []))))  # type: ignore[arg-type]
        return out

    async def joined_count(self, event_id: UUID) -> int:
        return len(self.waitlist.get(event_id, []))

    async def is_on_waitlist(self, event_id: UUID, user_id: UUID) -> bool:
        return user_id in self.waitlist.get(event_id, [])

    async def add_to_waitlist(self, event_id: UUID, user_id: UUID) -> None:
        self.waitlist.setdefault(event_id, []).append(user_id)

    async def remove_from_waitlist(self, event_id: UUID, user_id: UUID) -> bool:
        queue = self.waitlist.get(event_id, [])
        if user_id in queue:
            queue.remove(user_id)
            return True
        return False

    async def has_review(self, event_id: UUID, reviewer_id: UUID) -> bool:
        return any(r.event_id == event_id and r.reviewer_id == reviewer_id for r in self.reviews)

    async def create_review(
        self, *, event_id: UUID, reviewer_id: UUID, rating: Decimal, body: str | None
    ) -> _FakeReview:
        review = _FakeReview(
            id=uuid4(), event_id=event_id, reviewer_id=reviewer_id, rating=rating, body=body
        )
        self.reviews.append(review)
        return review

    async def list_reviews(self, event_id: UUID) -> list[_FakeReview]:
        return [r for r in self.reviews if r.event_id == event_id]


def _svc(repo: FakeEventRepository | None = None) -> tuple[EventService, FakeEventRepository]:
    r = repo or FakeEventRepository()
    return EventService(repo=r), r  # type: ignore[arg-type]


def _past() -> datetime:
    return datetime.now(tz=UTC) - timedelta(days=1)


def _future() -> datetime:
    return datetime.now(tz=UTC) + timedelta(days=7)


# ---------------------------------------------------------------------------
# haversine
# ---------------------------------------------------------------------------


def test_haversine_known_distance_seoul_busan() -> None:
    # Seoul → Busan is ~325 km as the crow flies.
    km = haversine_km(37.5663, 126.9779, 35.1796, 129.0756)
    assert 320 <= km <= 330


def test_haversine_zero_for_same_point() -> None:
    assert haversine_km(*_SEOUL, *_SEOUL) == pytest.approx(0.0, abs=1e-6)


# ---------------------------------------------------------------------------
# get_nearby_events
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_nearby_computes_distance_and_excludes_outside_radius() -> None:
    svc, repo = _svc()
    # ~1 km north of origin.
    near = _FakeEvent(
        id=uuid4(), title="가까운 모임", event_at=_future(), lat=37.5753, lng=126.9779
    )
    # Inside the 5 km bounding box corner but ~7 km away — must be filtered out
    # by the precise Haversine pass even though it passes the box prefilter.
    box_corner = _FakeEvent(
        id=uuid4(), title="박스 모서리", event_at=_future(), lat=37.6050, lng=127.0330
    )
    # ~12 km away — outside the box entirely.
    far = _FakeEvent(id=uuid4(), title="먼 모임", event_at=_future(), lat=37.6700, lng=126.9779)
    for ev in (near, box_corner, far):
        repo.add(ev)

    res = await svc.get_nearby_events(lat=_SEOUL[0], lng=_SEOUL[1], radius_km=5.0)

    titles = [i.title for i in res.items]
    assert titles == ["가까운 모임"]
    assert res.items[0].distance_km == pytest.approx(1.0, abs=0.3)
    assert res.has_more is False


@pytest.mark.asyncio
async def test_nearby_sorts_nearest_first() -> None:
    svc, repo = _svc()
    closer = _FakeEvent(id=uuid4(), title="A", event_at=_future(), lat=37.5700, lng=126.9779)
    farther = _FakeEvent(id=uuid4(), title="B", event_at=_future(), lat=37.5900, lng=126.9779)
    repo.add(farther)
    repo.add(closer)

    res = await svc.get_nearby_events(lat=_SEOUL[0], lng=_SEOUL[1], radius_km=10.0)

    assert [i.title for i in res.items] == ["A", "B"]
    assert res.items[0].distance_km < res.items[1].distance_km


@pytest.mark.asyncio
async def test_nearby_paginates() -> None:
    svc, repo = _svc()
    # 25 events tightly clustered, all within radius.
    for i in range(25):
        repo.add(
            _FakeEvent(
                id=uuid4(),
                title=f"E{i}",
                event_at=_future(),
                lat=37.5663 + i * 0.0001,
                lng=126.9779,
            )
        )

    page1 = await svc.get_nearby_events(lat=_SEOUL[0], lng=_SEOUL[1], radius_km=10.0, page=1)
    page2 = await svc.get_nearby_events(lat=_SEOUL[0], lng=_SEOUL[1], radius_km=10.0, page=2)

    assert len(page1.items) == 20
    assert page1.has_more is True
    assert len(page2.items) == 5
    assert page2.has_more is False


@pytest.mark.asyncio
async def test_nearby_excludes_private_events() -> None:
    svc, repo = _svc()
    repo.add(
        _FakeEvent(
            id=uuid4(),
            title="비공개",
            event_at=_future(),
            lat=37.5700,
            lng=126.9779,
            is_public=False,
        )
    )
    res = await svc.get_nearby_events(lat=_SEOUL[0], lng=_SEOUL[1], radius_km=5.0)
    assert res.items == []


@pytest.mark.asyncio
async def test_nearby_category_filter() -> None:
    svc, repo = _svc()
    repo.add(
        _FakeEvent(
            id=uuid4(), title="소설", event_at=_future(), lat=37.57, lng=126.978, category="소설"
        )
    )
    repo.add(
        _FakeEvent(
            id=uuid4(), title="과학", event_at=_future(), lat=37.57, lng=126.978, category="과학"
        )
    )
    res = await svc.get_nearby_events(lat=_SEOUL[0], lng=_SEOUL[1], radius_km=5.0, category="소설")
    assert [i.title for i in res.items] == ["소설"]


# ---------------------------------------------------------------------------
# create_event
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_create_event_without_club_is_allowed() -> None:
    svc, repo = _svc()
    res = await svc.create_event(
        creator_id=uuid4(),
        title="번개 독서 모임",
        description=None,
        address="강남역 스타벅스",
        lat=37.4979,
        lng=127.0276,
        category="자기계발",
        event_at=_future(),
        max_attendees=8,
        is_public=True,
        club_id=None,
        book_id=None,
    )
    assert res.club_id is None
    assert res.joined_count == 0
    assert res.distance_km is None
    assert len(repo.events) == 1


# ---------------------------------------------------------------------------
# join / leave waitlist
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_join_within_capacity_is_confirmed() -> None:
    svc, repo = _svc()
    ev = _FakeEvent(id=uuid4(), title="정원 2", event_at=_future(), max_attendees=2)
    repo.add(ev)

    first = await svc.join_waitlist(user_id=uuid4(), event_id=ev.id)
    second = await svc.join_waitlist(user_id=uuid4(), event_id=ev.id)

    assert (first.position, first.confirmed) == (1, True)
    assert (second.position, second.confirmed) == (2, True)


@pytest.mark.asyncio
async def test_join_over_capacity_is_queued() -> None:
    svc, repo = _svc()
    ev = _FakeEvent(id=uuid4(), title="정원 2", event_at=_future(), max_attendees=2)
    repo.add(ev)
    await svc.join_waitlist(user_id=uuid4(), event_id=ev.id)
    await svc.join_waitlist(user_id=uuid4(), event_id=ev.id)

    third = await svc.join_waitlist(user_id=uuid4(), event_id=ev.id)

    assert third.position == 3
    assert third.confirmed is False


@pytest.mark.asyncio
async def test_join_unlimited_capacity_always_confirmed() -> None:
    svc, repo = _svc()
    ev = _FakeEvent(id=uuid4(), title="무제한", event_at=_future(), max_attendees=None)
    repo.add(ev)
    for _ in range(5):
        res = await svc.join_waitlist(user_id=uuid4(), event_id=ev.id)
        assert res.confirmed is True


@pytest.mark.asyncio
async def test_join_twice_raises_conflict() -> None:
    svc, repo = _svc()
    ev = _FakeEvent(id=uuid4(), title="중복", event_at=_future(), max_attendees=10)
    repo.add(ev)
    user = uuid4()
    await svc.join_waitlist(user_id=user, event_id=ev.id)
    with pytest.raises(ConflictError) as exc:
        await svc.join_waitlist(user_id=user, event_id=ev.id)
    assert exc.value.code == "ALREADY_JOINED"


@pytest.mark.asyncio
async def test_join_unknown_event_raises_not_found() -> None:
    svc, _ = _svc()
    with pytest.raises(NotFoundError) as exc:
        await svc.join_waitlist(user_id=uuid4(), event_id=uuid4())
    assert exc.value.code == "EVENT_NOT_FOUND"


@pytest.mark.asyncio
async def test_leave_waitlist_removes_member() -> None:
    svc, repo = _svc()
    ev = _FakeEvent(id=uuid4(), title="나가기", event_at=_future(), max_attendees=10)
    repo.add(ev)
    user = uuid4()
    await svc.join_waitlist(user_id=user, event_id=ev.id)

    await svc.leave_waitlist(user_id=user, event_id=ev.id)

    assert await repo.joined_count(ev.id) == 0


@pytest.mark.asyncio
async def test_leave_when_not_joined_raises_not_found() -> None:
    svc, repo = _svc()
    ev = _FakeEvent(id=uuid4(), title="미참여", event_at=_future(), max_attendees=10)
    repo.add(ev)
    with pytest.raises(NotFoundError) as exc:
        await svc.leave_waitlist(user_id=uuid4(), event_id=ev.id)
    assert exc.value.code == "NOT_ON_WAITLIST"


# ---------------------------------------------------------------------------
# reviews
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_create_review_persists() -> None:
    svc, repo = _svc()
    ev = _FakeEvent(id=uuid4(), title="지난 모임", event_at=_past())
    repo.add(ev)
    res = await svc.create_review(reviewer_id=uuid4(), event_id=ev.id, rating=4.5, body="좋았어요")
    assert res.rating == 4.5
    assert res.body == "좋았어요"
    assert len(repo.reviews) == 1


@pytest.mark.asyncio
async def test_create_review_duplicate_raises_conflict() -> None:
    svc, repo = _svc()
    ev = _FakeEvent(id=uuid4(), title="지난 모임", event_at=_past())
    repo.add(ev)
    reviewer = uuid4()
    await svc.create_review(reviewer_id=reviewer, event_id=ev.id, rating=5.0, body=None)
    with pytest.raises(ConflictError) as exc:
        await svc.create_review(reviewer_id=reviewer, event_id=ev.id, rating=3.0, body=None)
    assert exc.value.code == "ALREADY_REVIEWED"
    assert len(repo.reviews) == 1


@pytest.mark.asyncio
async def test_create_review_before_event_raises_too_early() -> None:
    svc, repo = _svc()
    ev = _FakeEvent(id=uuid4(), title="아직 안 열림", event_at=_future())
    repo.add(ev)
    with pytest.raises(ConflictError) as exc:
        await svc.create_review(reviewer_id=uuid4(), event_id=ev.id, rating=5.0, body=None)
    assert exc.value.code == "REVIEW_TOO_EARLY"


@pytest.mark.asyncio
async def test_create_review_unknown_event_raises_not_found() -> None:
    svc, _ = _svc()
    with pytest.raises(NotFoundError) as exc:
        await svc.create_review(reviewer_id=uuid4(), event_id=uuid4(), rating=5.0, body=None)
    assert exc.value.code == "EVENT_NOT_FOUND"


@pytest.mark.asyncio
async def test_get_reviews_averages_ratings() -> None:
    svc, repo = _svc()
    ev = _FakeEvent(id=uuid4(), title="지난 모임", event_at=_past())
    repo.add(ev)
    await svc.create_review(reviewer_id=uuid4(), event_id=ev.id, rating=5.0, body=None)
    await svc.create_review(reviewer_id=uuid4(), event_id=ev.id, rating=4.0, body=None)

    res = await svc.get_reviews(ev.id)

    assert res.count == 2
    assert res.average_rating == 4.5


@pytest.mark.asyncio
async def test_get_reviews_empty_has_no_average() -> None:
    svc, repo = _svc()
    ev = _FakeEvent(id=uuid4(), title="리뷰 없음", event_at=_past())
    repo.add(ev)
    res = await svc.get_reviews(ev.id)
    assert res.count == 0
    assert res.average_rating is None

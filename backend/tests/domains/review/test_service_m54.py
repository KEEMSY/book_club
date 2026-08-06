"""Unit tests for M54 ReviewService.

Covers create/update/delete/report/list with in-memory fakes — no DB, no
HTTP. Fakes implement only the Port methods the service calls (per the M47/M51
convention). Rating-range validation lives in the Pydantic schema, so those
cases assert against CreateReviewRequest directly.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import UTC, datetime
from decimal import Decimal
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError, NotFoundError, PermissionDeniedError
from app.domains.review.models import BookReview
from app.domains.review.ports import MyReviewRow, ReviewAggregate
from app.domains.review.schemas import CreateReviewRequest
from app.domains.review.service import REPORT_HIDE_THRESHOLD, ReviewService
from pydantic import ValidationError


def _make_review(
    *,
    user_id: UUID,
    book_id: UUID,
    rating: float = 4.0,
    body: str | None = "good",
    report_count: int = 0,
    hidden_at: datetime | None = None,
) -> BookReview:
    review = BookReview(user_id=user_id, book_id=book_id, rating=Decimal(str(rating)), body=body)
    review.id = uuid4()
    review.report_count = report_count
    review.hidden_at = hidden_at
    review.created_at = datetime.now(tz=UTC)
    review.updated_at = datetime.now(tz=UTC)
    return review


@dataclass
class FakeReviewRepo:
    """In-memory ReviewRepositoryPort."""

    by_id: dict[UUID, BookReview] = field(default_factory=dict)
    # book_id -> (title, cover_url), used only by list_by_user (BC-80).
    book_info: dict[UUID, tuple[str | None, str | None]] = field(default_factory=dict)

    def seed(self, review: BookReview) -> BookReview:
        self.by_id[review.id] = review
        return review

    async def create(
        self, *, user_id: UUID, book_id: UUID, rating: Decimal, body: str | None
    ) -> BookReview:
        review = _make_review(user_id=user_id, book_id=book_id, rating=float(rating), body=body)
        self.by_id[review.id] = review
        return review

    async def get_by_id(self, review_id: UUID) -> BookReview | None:
        return self.by_id.get(review_id)

    async def get_by_user_book(self, user_id: UUID, book_id: UUID) -> BookReview | None:
        for r in self.by_id.values():
            if r.user_id == user_id and r.book_id == book_id:
                return r
        return None

    async def update(
        self, review_id: UUID, *, rating: Decimal | None, body: str | None
    ) -> BookReview:
        review = self.by_id[review_id]
        if rating is not None:
            review.rating = rating
        review.body = body
        return review

    async def delete(self, review_id: UUID) -> None:
        self.by_id.pop(review_id, None)

    async def increment_report(self, review_id: UUID, *, hide_threshold: int) -> BookReview:
        review = self.by_id[review_id]
        review.report_count += 1
        if review.report_count >= hide_threshold and review.hidden_at is None:
            review.hidden_at = datetime.now(tz=UTC)
        return review

    async def list_by_book(self, book_id: UUID, *, limit: int, offset: int) -> list[BookReview]:
        rows = [r for r in self.by_id.values() if r.book_id == book_id and r.hidden_at is None]
        rows.sort(key=lambda r: r.created_at, reverse=True)
        return rows[offset : offset + limit]

    async def list_by_user(self, user_id: UUID, *, limit: int, offset: int) -> list[MyReviewRow]:
        rows = [r for r in self.by_id.values() if r.user_id == user_id and r.hidden_at is None]
        rows.sort(key=lambda r: r.created_at, reverse=True)
        page = rows[offset : offset + limit]
        return [
            MyReviewRow(
                review=r,
                book_title=self.book_info.get(r.book_id, (None, None))[0],
                book_cover_url=self.book_info.get(r.book_id, (None, None))[1],
            )
            for r in page
        ]

    async def count_by_user(self, user_id: UUID) -> int:
        return len([r for r in self.by_id.values() if r.user_id == user_id and r.hidden_at is None])

    async def get_book_summary(self, book_id: UUID) -> ReviewAggregate:
        rows = [r for r in self.by_id.values() if r.book_id == book_id and r.hidden_at is None]
        distribution: dict[str, int] = {}
        total = 0.0
        for r in rows:
            key = f"{float(r.rating):.1f}"
            distribution[key] = distribution.get(key, 0) + 1
            total += float(r.rating)
        avg = round(total / len(rows), 2) if rows else 0.0
        return ReviewAggregate(
            average_rating=avg, rating_count=len(rows), distribution=distribution
        )


@dataclass
class FakeUserBooks:
    """In-memory UserBookQueryPort — set of (user_id, book_id) completed pairs."""

    completed: set[tuple[UUID, UUID]] = field(default_factory=set)

    async def is_completed(self, user_id: UUID, book_id: UUID) -> bool:
        return (user_id, book_id) in self.completed


@dataclass
class FakeFeedEvents:
    """In-memory ReviewFeedEventPort capturing published events."""

    events: list[dict[str, object]] = field(default_factory=list)

    async def create_event(
        self,
        *,
        user_id: UUID,
        event_type: str,
        metadata: dict[str, object] | None = None,
    ) -> object:
        ev = {"user_id": user_id, "event_type": event_type, "metadata": metadata}
        self.events.append(ev)
        return ev


def _make_svc(
    reviews: FakeReviewRepo | None = None,
    user_books: FakeUserBooks | None = None,
    feed_events: FakeFeedEvents | None = None,
) -> ReviewService:
    return ReviewService(
        reviews=reviews or FakeReviewRepo(),
        user_books=user_books or FakeUserBooks(),
        feed_events=feed_events if feed_events is not None else FakeFeedEvents(),
    )


# ---------------------------------------------------------------------------
# create_review
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_create_review_success() -> None:
    user_id, book_id = uuid4(), uuid4()
    user_books = FakeUserBooks(completed={(user_id, book_id)})
    svc = _make_svc(user_books=user_books)

    review = await svc.create_review(user_id=user_id, book_id=book_id, rating=4.5, body="좋아요")

    assert review.user_id == user_id
    assert float(review.rating) == 4.5
    assert review.body == "좋아요"


@pytest.mark.asyncio
async def test_create_review_publishes_feed_event() -> None:
    user_id, book_id = uuid4(), uuid4()
    user_books = FakeUserBooks(completed={(user_id, book_id)})
    feed = FakeFeedEvents()
    svc = _make_svc(user_books=user_books, feed_events=feed)

    review = await svc.create_review(user_id=user_id, book_id=book_id, rating=3.0, body=None)

    assert len(feed.events) == 1
    event = feed.events[0]
    assert event["event_type"] == "BOOK_REVIEWED"
    metadata = event["metadata"]
    assert isinstance(metadata, dict)
    assert metadata["review_id"] == str(review.id)
    assert metadata["book_id"] == str(book_id)


@pytest.mark.asyncio
async def test_create_review_not_completed_raises_conflict() -> None:
    user_id, book_id = uuid4(), uuid4()
    svc = _make_svc()  # no completed pairs

    with pytest.raises(ConflictError):
        await svc.create_review(user_id=user_id, book_id=book_id, rating=4.0, body=None)


@pytest.mark.asyncio
async def test_create_review_duplicate_raises_conflict() -> None:
    user_id, book_id = uuid4(), uuid4()
    repo = FakeReviewRepo()
    repo.seed(_make_review(user_id=user_id, book_id=book_id))
    user_books = FakeUserBooks(completed={(user_id, book_id)})
    svc = _make_svc(reviews=repo, user_books=user_books)

    with pytest.raises(ConflictError):
        await svc.create_review(user_id=user_id, book_id=book_id, rating=2.0, body=None)


# ---------------------------------------------------------------------------
# rating validation (Pydantic schema)
# ---------------------------------------------------------------------------


def test_rating_below_range_rejected() -> None:
    with pytest.raises(ValidationError):
        CreateReviewRequest(rating=0.3, body=None)


def test_rating_above_range_rejected() -> None:
    with pytest.raises(ValidationError):
        CreateReviewRequest(rating=5.5, body=None)


def test_rating_non_half_step_rejected() -> None:
    with pytest.raises(ValidationError):
        CreateReviewRequest(rating=3.7, body=None)


def test_body_over_500_chars_rejected() -> None:
    with pytest.raises(ValidationError):
        CreateReviewRequest(rating=4.0, body="x" * 501)


# ---------------------------------------------------------------------------
# update_review
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_update_review_owner_success() -> None:
    user_id, book_id = uuid4(), uuid4()
    repo = FakeReviewRepo()
    review = repo.seed(_make_review(user_id=user_id, book_id=book_id, rating=2.0))
    svc = _make_svc(reviews=repo)

    updated = await svc.update_review(
        user_id=user_id, review_id=review.id, rating=5.0, body="수정됨"
    )

    assert float(updated.rating) == 5.0
    assert updated.body == "수정됨"


@pytest.mark.asyncio
async def test_update_review_other_user_forbidden() -> None:
    owner_id, attacker_id, book_id = uuid4(), uuid4(), uuid4()
    repo = FakeReviewRepo()
    review = repo.seed(_make_review(user_id=owner_id, book_id=book_id))
    svc = _make_svc(reviews=repo)

    with pytest.raises(PermissionDeniedError):
        await svc.update_review(user_id=attacker_id, review_id=review.id, rating=1.0, body="삭제해")


# ---------------------------------------------------------------------------
# delete_review
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_delete_review_owner_success() -> None:
    user_id, book_id = uuid4(), uuid4()
    repo = FakeReviewRepo()
    review = repo.seed(_make_review(user_id=user_id, book_id=book_id))
    svc = _make_svc(reviews=repo)

    await svc.delete_review(user_id=user_id, review_id=review.id)

    assert review.id not in repo.by_id


@pytest.mark.asyncio
async def test_delete_review_other_user_forbidden() -> None:
    owner_id, attacker_id, book_id = uuid4(), uuid4(), uuid4()
    repo = FakeReviewRepo()
    review = repo.seed(_make_review(user_id=owner_id, book_id=book_id))
    svc = _make_svc(reviews=repo)

    with pytest.raises(PermissionDeniedError):
        await svc.delete_review(user_id=attacker_id, review_id=review.id)
    assert review.id in repo.by_id


# ---------------------------------------------------------------------------
# report_review
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_report_review_hides_after_threshold() -> None:
    owner_id, reporter_id, book_id = uuid4(), uuid4(), uuid4()
    repo = FakeReviewRepo()
    review = repo.seed(
        _make_review(user_id=owner_id, book_id=book_id, report_count=REPORT_HIDE_THRESHOLD - 1)
    )
    svc = _make_svc(reviews=repo)

    result = await svc.report_review(reporter_id=reporter_id, review_id=review.id)

    assert result.report_count == REPORT_HIDE_THRESHOLD
    assert result.hidden_at is not None


@pytest.mark.asyncio
async def test_report_review_below_threshold_stays_visible() -> None:
    owner_id, reporter_id, book_id = uuid4(), uuid4(), uuid4()
    repo = FakeReviewRepo()
    review = repo.seed(_make_review(user_id=owner_id, book_id=book_id, report_count=0))
    svc = _make_svc(reviews=repo)

    result = await svc.report_review(reporter_id=reporter_id, review_id=review.id)

    assert result.report_count == 1
    assert result.hidden_at is None


@pytest.mark.asyncio
async def test_report_own_review_forbidden() -> None:
    owner_id, book_id = uuid4(), uuid4()
    repo = FakeReviewRepo()
    review = repo.seed(_make_review(user_id=owner_id, book_id=book_id))
    svc = _make_svc(reviews=repo)

    with pytest.raises(PermissionDeniedError):
        await svc.report_review(reporter_id=owner_id, review_id=review.id)
    assert review.report_count == 0


@pytest.mark.asyncio
async def test_report_missing_review_raises_not_found() -> None:
    svc = _make_svc()
    with pytest.raises(NotFoundError):
        await svc.report_review(reporter_id=uuid4(), review_id=uuid4())


# ---------------------------------------------------------------------------
# list_book_reviews
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_list_book_reviews_aggregates_average() -> None:
    book_id = uuid4()
    repo = FakeReviewRepo()
    repo.seed(_make_review(user_id=uuid4(), book_id=book_id, rating=4.0))
    repo.seed(_make_review(user_id=uuid4(), book_id=book_id, rating=5.0))
    repo.seed(_make_review(user_id=uuid4(), book_id=book_id, rating=3.0))
    svc = _make_svc(reviews=repo)

    summary, reviews = await svc.list_book_reviews(book_id=book_id)

    assert summary.rating_count == 3
    assert summary.average_rating == 4.0
    assert summary.distribution == {"4.0": 1, "5.0": 1, "3.0": 1}
    assert len(reviews) == 3


@pytest.mark.asyncio
async def test_list_book_reviews_excludes_hidden() -> None:
    book_id = uuid4()
    repo = FakeReviewRepo()
    repo.seed(_make_review(user_id=uuid4(), book_id=book_id, rating=4.0))
    repo.seed(
        _make_review(
            user_id=uuid4(),
            book_id=book_id,
            rating=1.0,
            hidden_at=datetime.now(tz=UTC),
        )
    )
    svc = _make_svc(reviews=repo)

    summary, reviews = await svc.list_book_reviews(book_id=book_id)

    assert summary.rating_count == 1
    assert summary.average_rating == 4.0
    assert len(reviews) == 1


# ---------------------------------------------------------------------------
# list_my_reviews (BC-80 — GET /me/reviews)
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_list_my_reviews_newest_first_with_book_info() -> None:
    user_id = uuid4()
    book_a, book_b = uuid4(), uuid4()
    repo = FakeReviewRepo()
    repo.book_info[book_a] = ("책 A", "https://example.com/a.jpg")
    repo.book_info[book_b] = ("책 B", "https://example.com/b.jpg")
    older = repo.seed(_make_review(user_id=user_id, book_id=book_a, rating=3.0))
    older.created_at = datetime(2026, 1, 1, tzinfo=UTC)
    newer = repo.seed(_make_review(user_id=user_id, book_id=book_b, rating=5.0))
    newer.created_at = datetime(2026, 6, 1, tzinfo=UTC)
    svc = _make_svc(reviews=repo)

    total, rows = await svc.list_my_reviews(user_id=user_id)

    assert total == 2
    assert [r.review.id for r in rows] == [newer.id, older.id]
    assert rows[0].book_title == "책 B"
    assert rows[0].book_cover_url == "https://example.com/b.jpg"


@pytest.mark.asyncio
async def test_list_my_reviews_excludes_other_users_and_hidden() -> None:
    user_id, other_id, book_id = uuid4(), uuid4(), uuid4()
    repo = FakeReviewRepo()
    repo.seed(_make_review(user_id=other_id, book_id=book_id))
    repo.seed(_make_review(user_id=user_id, book_id=book_id, hidden_at=datetime.now(tz=UTC)))
    mine = repo.seed(_make_review(user_id=user_id, book_id=book_id, rating=4.0))
    svc = _make_svc(reviews=repo)

    total, rows = await svc.list_my_reviews(user_id=user_id)

    assert total == 1
    assert [r.review.id for r in rows] == [mine.id]


@pytest.mark.asyncio
async def test_list_my_reviews_pagination() -> None:
    user_id = uuid4()
    repo = FakeReviewRepo()
    for i in range(5):
        r = repo.seed(_make_review(user_id=user_id, book_id=uuid4()))
        r.created_at = datetime(2026, 1, 1 + i, tzinfo=UTC)
    svc = _make_svc(reviews=repo)

    total, page1 = await svc.list_my_reviews(user_id=user_id, limit=2, offset=0)
    _, page2 = await svc.list_my_reviews(user_id=user_id, limit=2, offset=2)

    assert total == 5
    assert len(page1) == 2
    assert len(page2) == 2
    assert {r.review.id for r in page1}.isdisjoint({r.review.id for r in page2})

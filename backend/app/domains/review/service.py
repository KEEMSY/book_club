"""Domain logic for book reviews & ratings (M54).

Orchestrates review CRUD, community reporting, and the BOOK_REVIEWED feed
event. Cross-domain reads (completion gating, feed publishing) go through
Ports — the service never touches another domain's repository directly
(CLAUDE.md §3.3).
"""

from __future__ import annotations

from decimal import Decimal
from uuid import UUID

from app.core.exceptions import ConflictError, NotFoundError, PermissionDeniedError
from app.domains.review.models import BookReview
from app.domains.review.ports import (
    MyReviewRow,
    ReviewAggregate,
    ReviewFeedEventPort,
    ReviewRepositoryPort,
    ReviewRow,
    UserBookQueryPort,
)

# Auto-hide a review once it accrues this many reports.
REPORT_HIDE_THRESHOLD = 5

# Matches feed.models.FeedEventType.BOOK_REVIEWED — kept as a literal so the
# review service need not import the feed domain's model (§3.3).
_BOOK_REVIEWED_EVENT = "BOOK_REVIEWED"

_LIST_LIMIT_MAX = 50


class ReviewService:
    """Application service for the review domain."""

    def __init__(
        self,
        *,
        reviews: ReviewRepositoryPort,
        user_books: UserBookQueryPort,
        feed_events: ReviewFeedEventPort | None = None,
    ) -> None:
        self._reviews = reviews
        self._user_books = user_books
        self._feed_events = feed_events

    async def create_review(
        self, *, user_id: UUID, book_id: UUID, rating: float, body: str | None
    ) -> BookReview:
        """Create a review for a finished book.

        Raises ConflictError if the user has not completed the book or has
        already reviewed it. On success a BOOK_REVIEWED feed event is published
        so followers see the activity.
        """
        if not await self._user_books.is_completed(user_id, book_id):
            raise ConflictError("완독한 책만 리뷰할 수 있습니다", code="BOOK_NOT_COMPLETED")
        existing = await self._reviews.get_by_user_book(user_id, book_id)
        if existing is not None:
            raise ConflictError("이미 작성한 리뷰가 있습니다", code="REVIEW_ALREADY_EXISTS")

        review = await self._reviews.create(
            user_id=user_id, book_id=book_id, rating=Decimal(str(rating)), body=body
        )

        if self._feed_events is not None:
            await self._feed_events.create_event(
                user_id=user_id,
                event_type=_BOOK_REVIEWED_EVENT,
                metadata={
                    "review_id": str(review.id),
                    "book_id": str(book_id),
                    "rating": float(rating),
                },
            )
        return review

    async def update_review(
        self, *, user_id: UUID, review_id: UUID, rating: float | None, body: str | None
    ) -> BookReview:
        """Edit the caller's own review. Others' reviews are 403."""
        review = await self._load_owned(user_id, review_id)
        new_rating = Decimal(str(rating)) if rating is not None else None
        return await self._reviews.update(review.id, rating=new_rating, body=body)

    async def delete_review(self, *, user_id: UUID, review_id: UUID) -> None:
        """Delete the caller's own review. Others' reviews are 403."""
        review = await self._load_owned(user_id, review_id)
        await self._reviews.delete(review.id)

    async def get_my_review(self, *, user_id: UUID, book_id: UUID) -> BookReview:
        """Resolve the caller's review for a book (404 if none).

        Lets the ``/reviews/me`` routes address a review without exposing its
        id in the URL.
        """
        review = await self._reviews.get_by_user_book(user_id, book_id)
        if review is None:
            raise NotFoundError("review not found", code="REVIEW_NOT_FOUND")
        return review

    async def list_book_reviews(
        self, *, book_id: UUID, limit: int = 20, offset: int = 0
    ) -> tuple[ReviewAggregate, list[ReviewRow]]:
        """Return the rating aggregate plus a page of visible reviews."""
        clamped = max(1, min(limit, _LIST_LIMIT_MAX))
        safe_offset = max(0, offset)
        summary = await self._reviews.get_book_summary(book_id)
        reviews = await self._reviews.list_by_book(book_id, limit=clamped, offset=safe_offset)
        return summary, reviews

    async def list_my_reviews(
        self, *, user_id: UUID, limit: int = 20, offset: int = 0
    ) -> tuple[int, list[MyReviewRow]]:
        """내 활동 > 내 리뷰 (BC-80) — total count plus a page, newest first."""
        clamped = max(1, min(limit, _LIST_LIMIT_MAX))
        safe_offset = max(0, offset)
        total = await self._reviews.count_by_user(user_id)
        rows = await self._reviews.list_by_user(user_id, limit=clamped, offset=safe_offset)
        return total, rows

    async def report_review(self, *, reporter_id: UUID, review_id: UUID) -> BookReview:
        """Flag a review. Self-reporting is forbidden; the repo auto-hides
        once the report count crosses the threshold."""
        review = await self._reviews.get_by_id(review_id)
        if review is None:
            raise NotFoundError("review not found", code="REVIEW_NOT_FOUND")
        if review.user_id == reporter_id:
            raise PermissionDeniedError(
                "자신의 리뷰는 신고할 수 없습니다", code="CANNOT_REPORT_OWN_REVIEW"
            )
        return await self._reviews.increment_report(review_id, hide_threshold=REPORT_HIDE_THRESHOLD)

    async def _load_owned(self, user_id: UUID, review_id: UUID) -> BookReview:
        review = await self._reviews.get_by_id(review_id)
        if review is None:
            raise NotFoundError("review not found", code="REVIEW_NOT_FOUND")
        if review.user_id != user_id:
            raise PermissionDeniedError("리뷰 소유자가 아닙니다", code="NOT_REVIEW_OWNER")
        return review

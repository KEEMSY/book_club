"""Persistence adapter for the review domain (CLAUDE.md §3.1).

Self DB (Postgres) access only — no business rules beyond the mechanical
report-count → hidden_at transition, which is a pure data update driven by a
threshold passed in by the service.
"""

from __future__ import annotations

from decimal import Decimal
from uuid import UUID

from sqlalchemy import func, select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.exceptions import ConflictError, NotFoundError
from app.domains.review.models import BookReview
from app.domains.review.ports import ReviewAggregate


class BookReviewRepository:
    """Implements :class:`ReviewRepositoryPort`."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def create(
        self, *, user_id: UUID, book_id: UUID, rating: Decimal, body: str | None
    ) -> BookReview:
        review = BookReview(user_id=user_id, book_id=book_id, rating=rating, body=body)
        self._session.add(review)
        try:
            await self._session.flush()
        except IntegrityError as exc:
            await self._session.rollback()
            raise ConflictError(
                "이미 작성한 리뷰가 있습니다", code="REVIEW_ALREADY_EXISTS"
            ) from exc
        await self._session.refresh(review)
        return review

    async def get_by_id(self, review_id: UUID) -> BookReview | None:
        return await self._session.get(BookReview, review_id)

    async def get_by_user_book(self, user_id: UUID, book_id: UUID) -> BookReview | None:
        stmt = select(BookReview).where(
            BookReview.user_id == user_id, BookReview.book_id == book_id
        )
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()

    async def update(
        self, review_id: UUID, *, rating: Decimal | None, body: str | None
    ) -> BookReview:
        review = await self._session.get(BookReview, review_id)
        if review is None:
            raise NotFoundError("review not found", code="REVIEW_NOT_FOUND")
        if rating is not None:
            review.rating = rating
        review.body = body
        await self._session.flush()
        await self._session.refresh(review)
        return review

    async def delete(self, review_id: UUID) -> None:
        review = await self._session.get(BookReview, review_id)
        if review is None:
            raise NotFoundError("review not found", code="REVIEW_NOT_FOUND")
        await self._session.delete(review)
        await self._session.flush()

    async def increment_report(self, review_id: UUID, *, hide_threshold: int) -> BookReview:
        review = await self._session.get(BookReview, review_id)
        if review is None:
            raise NotFoundError("review not found", code="REVIEW_NOT_FOUND")
        review.report_count += 1
        if review.report_count >= hide_threshold and review.hidden_at is None:
            review.hidden_at = func.now()
        await self._session.flush()
        await self._session.refresh(review)
        return review

    async def list_by_book(self, book_id: UUID, *, limit: int, offset: int) -> list[BookReview]:
        stmt = (
            select(BookReview)
            .where(BookReview.book_id == book_id, BookReview.hidden_at.is_(None))
            .order_by(BookReview.created_at.desc())
            .limit(limit)
            .offset(offset)
        )
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

    async def get_book_summary(self, book_id: UUID) -> ReviewAggregate:
        stmt = (
            select(BookReview.rating, func.count())
            .where(BookReview.book_id == book_id, BookReview.hidden_at.is_(None))
            .group_by(BookReview.rating)
        )
        result = await self._session.execute(stmt)
        rows = result.all()

        distribution: dict[str, int] = {}
        total_count = 0
        weighted_sum = 0.0
        for rating, count in rows:
            key = f"{float(rating):.1f}"
            distribution[key] = count
            total_count += count
            weighted_sum += float(rating) * count

        average = round(weighted_sum / total_count, 2) if total_count else 0.0
        return ReviewAggregate(
            average_rating=average,
            rating_count=total_count,
            distribution=distribution,
        )

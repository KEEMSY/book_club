"""HTTP surface for the review domain (M54).

Routes (thin DTO → service → DTO per CLAUDE.md §3.1):
  POST   /books/{book_id}/reviews              — create a review
  PATCH  /books/{book_id}/reviews/me           — edit own review
  DELETE /books/{book_id}/reviews/me           — delete own review
  GET    /books/{book_id}/reviews              — list reviews + rating summary
  POST   /books/{book_id}/reviews/{review_id}/report — report a review
"""

from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, Query, status

from app.core.deps import get_current_user_id
from app.domains.review.models import BookReview
from app.domains.review.ports import ReviewRow
from app.domains.review.providers import get_review_service
from app.domains.review.schemas import (
    BookReviewSummary,
    CreateReviewRequest,
    ReviewResponse,
    UpdateReviewRequest,
)
from app.domains.review.service import ReviewService

router = APIRouter(prefix="/books/{book_id}/reviews", tags=["review"])


def _to_response(review: BookReview) -> ReviewResponse:
    return ReviewResponse(
        id=review.id,
        user_id=review.user_id,
        book_id=review.book_id,
        rating=float(review.rating),
        body=review.body,
        report_count=review.report_count,
        created_at=review.created_at,
        updated_at=review.updated_at,
    )


def _row_to_response(row: ReviewRow) -> ReviewResponse:
    r = row.review
    return ReviewResponse(
        id=r.id,
        user_id=r.user_id,
        book_id=r.book_id,
        rating=float(r.rating),
        body=r.body,
        report_count=r.report_count,
        created_at=r.created_at,
        updated_at=r.updated_at,
        author_nickname=row.author_nickname,
        author_profile_image_url=row.author_profile_image_url,
    )


@router.post("", response_model=ReviewResponse, status_code=status.HTTP_201_CREATED)
async def create_review(
    book_id: UUID,
    body: CreateReviewRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReviewService, Depends(get_review_service)],
) -> ReviewResponse:
    review = await service.create_review(
        user_id=UUID(user_id), book_id=book_id, rating=body.rating, body=body.body
    )
    return _to_response(review)


@router.patch("/me", response_model=ReviewResponse)
async def update_my_review(
    book_id: UUID,
    body: UpdateReviewRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReviewService, Depends(get_review_service)],
) -> ReviewResponse:
    uid = UUID(user_id)
    existing = await service.get_my_review(user_id=uid, book_id=book_id)
    review = await service.update_review(
        user_id=uid, review_id=existing.id, rating=body.rating, body=body.body
    )
    return _to_response(review)


@router.delete("/me", status_code=status.HTTP_204_NO_CONTENT)
async def delete_my_review(
    book_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReviewService, Depends(get_review_service)],
) -> None:
    uid = UUID(user_id)
    existing = await service.get_my_review(user_id=uid, book_id=book_id)
    await service.delete_review(user_id=uid, review_id=existing.id)


@router.get("", response_model=BookReviewSummary)
async def list_book_reviews(
    book_id: UUID,
    service: Annotated[ReviewService, Depends(get_review_service)],
    limit: Annotated[int, Query(ge=1, le=50)] = 20,
    offset: Annotated[int, Query(ge=0)] = 0,
) -> BookReviewSummary:
    summary, reviews = await service.list_book_reviews(book_id=book_id, limit=limit, offset=offset)
    return BookReviewSummary(
        average_rating=summary.average_rating,
        rating_count=summary.rating_count,
        distribution=summary.distribution,
        reviews=[_row_to_response(r) for r in reviews],
    )


@router.post("/{review_id}/report", response_model=ReviewResponse)
async def report_review(
    book_id: UUID,
    review_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReviewService, Depends(get_review_service)],
) -> ReviewResponse:
    review = await service.report_review(reporter_id=UUID(user_id), review_id=review_id)
    return _to_response(review)

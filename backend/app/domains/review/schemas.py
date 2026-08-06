"""Pydantic v2 request / response schemas for the review domain (M54)."""

from __future__ import annotations

from datetime import datetime
from uuid import UUID

from pydantic import BaseModel, Field, field_validator

_MAX_BODY = 500
_MIN_RATING = 1.0
_MAX_RATING = 5.0


def _validate_rating(value: float) -> float:
    """Enforce the 1.0..5.0 half-star scale shared by create and update."""
    if value < _MIN_RATING or value > _MAX_RATING:
        raise ValueError("rating must be between 1.0 and 5.0")
    # Half-star granularity: 2 * rating must be a whole number.
    if (value * 2) % 1 != 0:
        raise ValueError("rating must be in 0.5 increments")
    return value


class CreateReviewRequest(BaseModel):
    """Body for POST /books/{book_id}/reviews."""

    rating: float
    body: str | None = Field(default=None, max_length=_MAX_BODY)

    @field_validator("rating")
    @classmethod
    def _check_rating(cls, value: float) -> float:
        return _validate_rating(value)


class UpdateReviewRequest(BaseModel):
    """Body for PATCH /books/{book_id}/reviews/me. Both fields optional."""

    rating: float | None = None
    body: str | None = Field(default=None, max_length=_MAX_BODY)

    @field_validator("rating")
    @classmethod
    def _check_rating(cls, value: float | None) -> float | None:
        if value is None:
            return None
        return _validate_rating(value)


class ReviewResponse(BaseModel):
    """A single review row as returned to clients."""

    id: UUID
    user_id: UUID
    book_id: UUID
    rating: float
    body: str | None
    report_count: int
    created_at: datetime
    updated_at: datetime
    author_nickname: str | None = None
    author_profile_image_url: str | None = None


class BookReviewSummary(BaseModel):
    """Aggregate rating view for a book plus a page of its reviews."""

    average_rating: float
    rating_count: int
    # Keyed by the rating value as a string ("1.0".."5.0") → number of reviews.
    distribution: dict[str, int]
    reviews: list[ReviewResponse]


class MyReviewItem(BaseModel):
    """A single row in the caller's own review list (BC-80 — GET /me/reviews)."""

    id: UUID
    book_id: UUID
    book_title: str | None = None
    book_cover_url: str | None = None
    rating: float
    body: str | None
    created_at: datetime


class MyReviewListResponse(BaseModel):
    """Page of the caller's own reviews, newest first."""

    items: list[MyReviewItem]
    total: int
    has_more: bool

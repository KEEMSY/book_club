"""Port Protocols for the review domain (CLAUDE.md §3.2).

The review service never imports another domain's repository or model
directly (§3.3). Cross-domain reads — "did this user finish the book?" and
"publish a feed event" — go through the Protocols below; their concrete
adapters are wired in ``providers.py``.
"""

from __future__ import annotations

from dataclasses import dataclass, field
from decimal import Decimal
from typing import Protocol
from uuid import UUID

from app.domains.review.models import BookReview


@dataclass
class ReviewRow:
    """Review plus author display info (populated by JOIN in the repository)."""

    review: BookReview
    author_nickname: str | None
    author_profile_image_url: str | None


@dataclass
class ReviewAggregate:
    """Aggregate rating view for a single book."""

    average_rating: float
    rating_count: int
    # Keyed by rating value as a string ("1.0".."5.0") → count.
    distribution: dict[str, int] = field(default_factory=dict)


class ReviewRepositoryPort(Protocol):
    """Persistence boundary for :class:`BookReview`."""

    async def create(
        self, *, user_id: UUID, book_id: UUID, rating: Decimal, body: str | None
    ) -> BookReview: ...

    async def get_by_id(self, review_id: UUID) -> BookReview | None: ...

    async def get_by_user_book(self, user_id: UUID, book_id: UUID) -> BookReview | None: ...

    async def update(
        self, review_id: UUID, *, rating: Decimal | None, body: str | None
    ) -> BookReview: ...

    async def delete(self, review_id: UUID) -> None: ...

    async def increment_report(self, review_id: UUID, *, hide_threshold: int) -> BookReview: ...

    async def list_by_book(self, book_id: UUID, *, limit: int, offset: int) -> list[ReviewRow]: ...

    async def get_book_summary(self, book_id: UUID) -> ReviewAggregate: ...


class UserBookQueryPort(Protocol):
    """Read-only view into the book domain — review gating depends only on
    whether the user has finished the book."""

    async def is_completed(self, user_id: UUID, book_id: UUID) -> bool: ...


class ReviewFeedEventPort(Protocol):
    """Append-only feed event publisher (BOOK_REVIEWED)."""

    async def create_event(
        self,
        *,
        user_id: UUID,
        event_type: str,
        metadata: dict[str, object] | None = None,
    ) -> object: ...


__all__ = [
    "ReviewAggregate",
    "ReviewFeedEventPort",
    "ReviewRepositoryPort",
    "ReviewRow",
    "UserBookQueryPort",
]

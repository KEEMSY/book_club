"""Business logic for the curation domain.

Rules enforced here:
- A book may have at most ``MAX_CARDS_PER_BOOK`` (5) curation cards. Exceeding
  the limit raises ``ConflictError`` so the router surfaces HTTP 409 with a
  stable machine-readable code.
- Deleting a card that does not exist raises ``NotFoundError`` → HTTP 404.

The service depends only on ``CurationRepository``; no external adapter or
cross-domain service call is required for the M42 scope.
"""

from __future__ import annotations

from dataclasses import dataclass
from uuid import UUID

from app.core.exceptions import ConflictError, NotFoundError
from app.domains.curation.repository import (
    CurationFeedbackRepository,
    CurationRepository,
)
from app.domains.curation.schemas import CreateCurationCardRequest, CurationCardPublic


@dataclass(slots=True)
class CurationService:
    """Orchestrates curation card lifecycle for a book."""

    repo: CurationRepository
    feedback_repo: CurationFeedbackRepository | None = None

    MAX_CARDS_PER_BOOK: int = 5

    # A reader who skips/dismisses a card type this many times stops seeing it
    # surfaced first (M67 feedback loop).
    DEPRIORITIZE_THRESHOLD: int = 3

    async def list_cards(self, book_id: UUID) -> list[CurationCardPublic]:
        """Return all curation cards for *book_id* in display order."""
        cards = await self.repo.list_by_book(book_id)
        return [CurationCardPublic.model_validate(c) for c in cards]

    async def create_card(
        self,
        *,
        book_id: UUID,
        req: CreateCurationCardRequest,
    ) -> CurationCardPublic:
        """Create a new curation card, enforcing the per-book limit."""
        existing = await self.repo.list_by_book(book_id)
        if len(existing) >= self.MAX_CARDS_PER_BOOK:
            raise ConflictError(
                "책당 최대 5장까지 등록 가능해요.",
                code="CURATION_CARD_LIMIT",
            )
        card = await self.repo.create(
            book_id=book_id,
            card_type=req.card_type,
            title=req.title,
            body=req.body,
            order_index=req.order_index,
        )
        return CurationCardPublic.model_validate(card)

    async def delete_card(self, card_id: UUID) -> None:
        """Delete a curation card by its primary key."""
        deleted = await self.repo.delete(card_id)
        if not deleted:
            raise NotFoundError(
                "카드를 찾을 수 없어요.",
                code="CURATION_CARD_NOT_FOUND",
            )

    async def get_first_card(
        self, book_id: UUID, *, user_id: UUID | None = None
    ) -> CurationCardPublic | None:
        """Return the first card for *book_id*, personalized for *user_id*.

        Without a user (anonymous request) this is the lowest-``order_index``
        card. With a user whose feedback history deprioritizes one or more card
        types, those types sort last so a card the reader still engages with is
        surfaced first; ties keep the original ``order_index`` order.
        """
        if user_id is None or self.feedback_repo is None:
            card = await self.repo.get_first_for_book(book_id)
            return CurationCardPublic.model_validate(card) if card is not None else None

        cards = await self.repo.list_by_book(book_id)
        if not cards:
            return None

        deprioritized = await self.feedback_repo.deprioritized_card_types(
            user_id=user_id, threshold=self.DEPRIORITIZE_THRESHOLD
        )
        if deprioritized:
            cards = sorted(cards, key=lambda c: c.card_type in deprioritized)
        return CurationCardPublic.model_validate(cards[0])

    async def record_feedback(
        self, *, user_id: UUID, card_id: UUID, action: str
    ) -> None:
        """Persist a reader's reaction to a curation card.

        Raises ``NotFoundError`` when the card does not exist so the router
        surfaces HTTP 404 rather than leaving a dangling-FK insert to fail.
        """
        if self.feedback_repo is None:  # pragma: no cover - always wired in prod
            raise RuntimeError("feedback_repo not configured")
        card = await self.repo.get_by_id(card_id)
        if card is None:
            raise NotFoundError(
                "카드를 찾을 수 없어요.",
                code="CURATION_CARD_NOT_FOUND",
            )
        await self.feedback_repo.upsert_feedback(
            user_id=user_id, card_id=card_id, action=action
        )

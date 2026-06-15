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
from app.domains.curation.repository import CurationRepository
from app.domains.curation.schemas import CreateCurationCardRequest, CurationCardPublic


@dataclass(slots=True)
class CurationService:
    """Orchestrates curation card lifecycle for a book."""

    repo: CurationRepository

    MAX_CARDS_PER_BOOK: int = 5

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

    async def get_first_card(self, book_id: UUID) -> CurationCardPublic | None:
        """Return the first (lowest order_index) card for *book_id*, or ``None``."""
        card = await self.repo.get_first_for_book(book_id)
        if card is None:
            return None
        return CurationCardPublic.model_validate(card)

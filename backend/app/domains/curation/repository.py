"""SQLAlchemy async repository for the curation domain.

Queries are ordered by ``order_index ASC`` so the service and router layers
receive cards in display order without additional sorting.
"""

from __future__ import annotations

from uuid import UUID

from sqlalchemy import func, select
from sqlalchemy.dialects.postgresql import insert as pg_insert
from sqlalchemy.ext.asyncio import AsyncSession

from app.domains.curation.models import CurationCard, CurationCardFeedback


class CurationRepository:
    """Persistence adapter for :class:`CurationCard`."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def list_by_book(self, book_id: UUID) -> list[CurationCard]:
        """Return all cards for *book_id* ordered by ``order_index`` ascending."""
        stmt = (
            select(CurationCard)
            .where(CurationCard.book_id == book_id)
            .order_by(CurationCard.order_index.asc(), CurationCard.created_at.asc())
        )
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

    async def create(
        self,
        *,
        book_id: UUID,
        card_type: str,
        title: str,
        body: str,
        order_index: int,
    ) -> CurationCard:
        """Persist a new curation card and return the flushed ORM instance."""
        card = CurationCard(
            book_id=book_id,
            card_type=card_type,
            title=title,
            body=body,
            order_index=order_index,
        )
        self._session.add(card)
        await self._session.flush()
        await self._session.refresh(card)
        return card

    async def get_by_id(self, card_id: UUID) -> CurationCard | None:
        """Return the card by primary key, or ``None`` when it does not exist."""
        return await self._session.get(CurationCard, card_id)

    async def delete(self, card_id: UUID) -> bool:
        """Delete the card by primary key.

        Returns ``True`` when a row was deleted, ``False`` when it did not exist.

        Uses SELECT-then-DELETE rather than relying on ``rowcount`` because
        async backends may report unreliable rowcount values on some drivers.
        """
        card = await self._session.get(CurationCard, card_id)
        if card is None:
            return False
        await self._session.delete(card)
        await self._session.flush()
        return True

    async def get_first_for_book(self, book_id: UUID) -> CurationCard | None:
        """Return the card with the lowest ``order_index`` for *book_id*, or ``None``."""
        stmt = (
            select(CurationCard)
            .where(CurationCard.book_id == book_id)
            .order_by(CurationCard.order_index.asc(), CurationCard.created_at.asc())
            .limit(1)
        )
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()


class CurationFeedbackRepository:
    """Persistence adapter for :class:`CurationCardFeedback` (M67)."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def upsert_feedback(self, *, user_id: UUID, card_id: UUID, action: str) -> None:
        """Record (or flip) the reader's reaction to a card.

        Idempotent on ``(user_id, card_id)``: a second tap with a different
        action overwrites the stored one rather than inserting a duplicate.
        """
        stmt = (
            pg_insert(CurationCardFeedback)
            .values(user_id=user_id, card_id=card_id, action=action)
            .on_conflict_do_update(
                index_elements=[CurationCardFeedback.user_id, CurationCardFeedback.card_id],
                set_={"action": action},
            )
        )
        await self._session.execute(stmt)
        await self._session.flush()

    async def deprioritized_card_types(self, *, user_id: UUID, threshold: int) -> set[str]:
        """Return card types this user has skipped/dismissed at least *threshold* times.

        Joins feedback → cards so the count is grouped by the card's type, not
        the individual card: a reader who skips three different ``quote`` cards
        has signalled they dislike quotes, and all ``quote`` cards drop in rank.
        """
        stmt = (
            select(CurationCard.card_type)
            .select_from(CurationCardFeedback)
            .join(CurationCard, CurationCard.id == CurationCardFeedback.card_id)
            .where(
                CurationCardFeedback.user_id == user_id,
                CurationCardFeedback.action.in_(("skip", "dismiss")),
            )
            .group_by(CurationCard.card_type)
            .having(func.count() >= threshold)
        )
        result = await self._session.execute(stmt)
        return {row[0] for row in result.all()}

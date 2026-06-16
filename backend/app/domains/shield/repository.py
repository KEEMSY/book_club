"""SQLAlchemy async repository for shield purchases."""

from __future__ import annotations

from datetime import UTC, datetime
from uuid import UUID

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.exceptions import NotFoundError
from app.domains.shield.models import ShieldPurchase


class ShieldPurchaseRepository:
    """Persistence adapter for :class:`ShieldPurchase`."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def create(
        self,
        *,
        user_id: UUID,
        product_id: str,
        shields_granted: int,
        receipt_data: str,
    ) -> ShieldPurchase:
        row = ShieldPurchase(
            user_id=user_id,
            product_id=product_id,
            shields_granted=shields_granted,
            receipt_data=receipt_data,
        )
        self._session.add(row)
        await self._session.flush()
        await self._session.refresh(row)
        return row

    async def refund(self, purchase_id: UUID) -> None:
        """Set ``refunded_at`` to now; raise NotFoundError if the row is missing."""
        row = await self._session.get(ShieldPurchase, purchase_id)
        if row is None:
            raise NotFoundError("구매 내역을 찾을 수 없어요.", code="PURCHASE_NOT_FOUND")
        row.refunded_at = datetime.now(tz=UTC)
        await self._session.flush()

    async def get_by_id(self, purchase_id: UUID) -> ShieldPurchase | None:
        return await self._session.get(ShieldPurchase, purchase_id)

    async def get_by_user(self, user_id: UUID) -> list[ShieldPurchase]:
        stmt = (
            select(ShieldPurchase)
            .where(ShieldPurchase.user_id == user_id)
            .order_by(ShieldPurchase.purchased_at.desc())
        )
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

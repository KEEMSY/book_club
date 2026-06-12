"""SQLAlchemy async repository for the subscription domain.

Reads and writes the Pro subscription columns on the ``users`` table directly
to avoid an extra join table for a simple 1:1 relationship.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
from uuid import UUID

from sqlalchemy import select, update
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.exceptions import NotFoundError
from app.domains.auth.models import User


@dataclass(slots=True)
class SubscriptionRepository:
    """Concrete repository — subscription column I/O on the users table."""

    session: AsyncSession

    async def get_subscription_status(self, user_id: UUID) -> dict[str, object]:
        """Return is_pro, pro_expires_at, pro_product_id for the given user.

        Raises ``NotFoundError`` when the user does not exist.
        """
        result = await self.session.execute(
            select(User.is_pro, User.pro_expires_at, User.pro_product_id).where(
                User.id == user_id
            )
        )
        row = result.one_or_none()
        if row is None:
            raise NotFoundError(f"user {user_id} not found", code="USER_NOT_FOUND")
        is_pro, pro_expires_at, pro_product_id = row
        return {
            "is_pro": is_pro,
            "pro_expires_at": pro_expires_at,
            "pro_product_id": pro_product_id,
        }

    async def update_subscription(
        self,
        user_id: UUID,
        *,
        is_pro: bool,
        expires_at: datetime | None,
        product_id: str | None,
    ) -> None:
        """Write Pro subscription fields for the given user."""
        await self.session.execute(
            update(User)
            .where(User.id == user_id)
            .values(
                is_pro=is_pro,
                pro_expires_at=expires_at,
                pro_product_id=product_id,
            )
        )
        await self.session.flush()

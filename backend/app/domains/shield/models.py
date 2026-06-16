"""SQLAlchemy ORM model for shield purchases.

``shield_purchases`` records every consumable IAP transaction so we can
reconstruct shield balances, process refunds, and answer support queries
without touching the IAP store directly.

``refunded_at`` is set (non-NULL) by the refund webhook handler; the service
layer decrements ``user_grades.streak_shields`` accordingly.
"""

from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, Index, Integer, String, func
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column

from app.core.db import Base


class ShieldPurchase(Base):
    """One consumable IAP transaction for streak shields."""

    __tablename__ = "shield_purchases"
    __table_args__ = (
        # Most queries filter by user and sort reverse-chronologically.
        Index("idx_shield_purchases_user", "user_id", "purchased_at"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        primary_key=True,
        server_default=func.gen_random_uuid(),
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    product_id: Mapped[str] = mapped_column(String(64), nullable=False)
    shields_granted: Mapped[int] = mapped_column(Integer, nullable=False)
    receipt_data: Mapped[str] = mapped_column(String, nullable=False)
    purchased_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )
    refunded_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )

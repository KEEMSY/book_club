"""SQLAlchemy ORM models for the subscription domain (M65).

- ``SubscriptionPromo`` is a time-boxed discount campaign (e.g. the early-bird
  annual offer). ``PromoService`` exposes the single live one to the paywall.
- ``SubscriptionEvent`` is a thin funnel/revenue event log. The paywall emits
  ``paywall_view`` / ``paywall_click`` rows and RevenueCat webhooks land
  ``subscription`` / ``churn`` rows; the admin dashboard aggregates over it.

Pro subscription *state* still lives on the ``users`` table (read/written by
``SubscriptionRepository``); these tables capture campaigns and events only.
"""

from __future__ import annotations

import uuid
from datetime import datetime
from decimal import Decimal

from sqlalchemy import (
    Boolean,
    ForeignKey,
    Index,
    Integer,
    Numeric,
    String,
    UniqueConstraint,
    func,
)
from sqlalchemy.dialects.postgresql import TIMESTAMP as PGTIMESTAMP
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column

from app.core.db import Base


class SubscriptionPromo(Base):
    """A time-boxed promotional discount on a Pro plan."""

    __tablename__ = "subscription_promos"
    __table_args__ = (UniqueConstraint("promo_code", name="uq_subscription_promos_code"),)

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    promo_code: Mapped[str] = mapped_column(String(32), nullable=False)
    discount_pct: Mapped[int] = mapped_column(Integer, nullable=False)
    valid_from: Mapped[datetime] = mapped_column(PGTIMESTAMP(timezone=True), nullable=False)
    valid_until: Mapped[datetime] = mapped_column(PGTIMESTAMP(timezone=True), nullable=False)
    is_active: Mapped[bool] = mapped_column(Boolean, nullable=False, server_default="true")
    created_at: Mapped[datetime] = mapped_column(
        PGTIMESTAMP(timezone=True), nullable=False, server_default=func.now()
    )


class DiscountCoupon(Base):
    """A single-use discount code (M70 re-engagement campaign).

    ``code`` is the natural primary key. ``used_by`` / ``used_at`` are NULL
    until redeemed; redemption marks both. The D+7 expiry batch issues
    ``REJOIN_*`` codes here before pushing them to lapsed users.
    """

    __tablename__ = "discount_coupons"

    code: Mapped[str] = mapped_column(String(32), primary_key=True)
    discount_pct: Mapped[int] = mapped_column(Integer, nullable=False)
    valid_days: Mapped[int] = mapped_column(Integer, nullable=False, server_default="30")
    used_by: Mapped[uuid.UUID | None] = mapped_column(
        PGUUID(as_uuid=True), ForeignKey("users.id"), nullable=True
    )
    used_at: Mapped[datetime | None] = mapped_column(PGTIMESTAMP(timezone=True), nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        PGTIMESTAMP(timezone=True), nullable=False, server_default=func.now()
    )


class SubscriptionEvent(Base):
    """A single paywall/subscription lifecycle event for funnel analytics."""

    __tablename__ = "subscription_events"
    __table_args__ = (Index("idx_subscription_events_type_created", "event_type", "created_at"),)

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    # paywall_view | paywall_click | subscription | churn
    event_type: Mapped[str] = mapped_column(String(32), nullable=False)
    product_id: Mapped[str | None] = mapped_column(String(64), nullable=True)
    revenue_amount: Mapped[Decimal] = mapped_column(
        Numeric(precision=12, scale=2), nullable=False, server_default="0"
    )
    created_at: Mapped[datetime] = mapped_column(
        PGTIMESTAMP(timezone=True), nullable=False, server_default=func.now()
    )

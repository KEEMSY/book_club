"""SQLAlchemy ORM model for the referral domain.

``Referral`` tracks each invitation link usage.  A row is created when a new
user applies a referral code (``apply_referral``).  ``completed_at`` is set
when the referee completes their first qualifying reading session (≥ 60 s via
timer), marking the referral as converted.
"""

from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy import ForeignKey, String, func
from sqlalchemy.dialects.postgresql import TIMESTAMP
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column

from app.core.db import Base


class Referral(Base):
    """One row per referral code application (referee signs up via a link)."""

    __tablename__ = "referrals"

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    # The user who shared the invite link.
    referrer_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    # The user who used the invite link; NULL if the code was clicked but the
    # sign-up was never completed (future: pre-claim tokens).
    referee_id: Mapped[uuid.UUID | None] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="SET NULL"),
        nullable=True,
    )
    # Snapshot of the code used — kept for audit even if the code later
    # changes (e.g. referrer regenerates).
    code: Mapped[str] = mapped_column(String(8), nullable=False)
    created_at: Mapped[datetime] = mapped_column(
        TIMESTAMP(timezone=True), nullable=False, server_default=func.now()
    )
    # Set when the referee finishes their first qualifying session.
    completed_at: Mapped[datetime | None] = mapped_column(TIMESTAMP(timezone=True), nullable=True)

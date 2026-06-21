"""SQLAlchemy ORM model for the share domain (M62).

``ShareCardEvent`` records one row each time a user shares an SNS certification
card. It backs the viral-loop analytics: which card templates drive shares and
on which platforms. ``referral_code`` is snapshotted so a share can be joined
to downstream sign-ups even if the user later regenerates their code.
"""

from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy import ForeignKey, Index, String, func
from sqlalchemy.dialects.postgresql import TIMESTAMP
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column

from app.core.db import Base


class ShareCardEvent(Base):
    """One row per SNS card share."""

    __tablename__ = "share_card_events"
    __table_args__ = (
        # Powers per-user share history and the admin share-stats aggregation.
        Index("idx_share_events_user", "user_id", "created_at"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    # One of the five card templates (book_completed | reading_streak |
    # challenge_badge | monthly_recap | progress_checkin).
    card_type: Mapped[str] = mapped_column(String(32), nullable=False)
    # instagram | twitter | kakaotalk | copy — NULL when the share sheet was
    # dismissed before a target was chosen but the client still logged intent.
    platform: Mapped[str | None] = mapped_column(String(32), nullable=True)
    # Snapshot of the inviter's referral code at share time.
    referral_code: Mapped[str | None] = mapped_column(String(16), nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        TIMESTAMP(timezone=True), nullable=False, server_default=func.now()
    )

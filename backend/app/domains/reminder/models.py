"""SQLAlchemy ORM model for the reminder domain.

``ReadingReminder`` stores the user's scheduled push reminder configuration.
One user can have up to 7 reminders (enforced in the service layer).
"""

from __future__ import annotations

import uuid
from datetime import datetime
from datetime import time as time_type

from sqlalchemy import Boolean, DateTime, ForeignKey, Integer, Time, func
from sqlalchemy.dialects.postgresql import ARRAY
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column

from app.core.db import Base


class ReadingReminder(Base):
    """User-configured recurring reading reminder."""

    __tablename__ = "reading_reminders"

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    # ISO weekday list: 0 = Monday … 6 = Sunday.
    days_of_week: Mapped[list[int]] = mapped_column(ARRAY(Integer()), nullable=False)
    remind_at: Mapped[time_type] = mapped_column(Time(), nullable=False)
    is_active: Mapped[bool] = mapped_column(Boolean(), nullable=False, server_default="true")
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )

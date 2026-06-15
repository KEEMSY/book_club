"""SQLAlchemy ORM models for the experiment domain.

``Experiment`` defines an A/B experiment with a key, description, and a JSONB
list of variant names.  ``UserExperiment`` records each user's deterministic
variant assignment and an optional ``converted_at`` timestamp written when the
user upgrades to Pro.
"""

from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy import Boolean, DateTime, ForeignKey, Index, String, Text, UniqueConstraint, func
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column

from app.core.db import Base


class Experiment(Base):
    """Defines a named A/B experiment and its possible variants."""

    __tablename__ = "experiments"

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    experiment_key: Mapped[str] = mapped_column(String(64), nullable=False, unique=True)
    description: Mapped[str | None] = mapped_column(Text, nullable=True)
    # e.g. ["stats_tab", "club_limit"] — stored as JSONB for flexibility
    variants: Mapped[list[str]] = mapped_column(JSONB, nullable=False)
    is_active: Mapped[bool] = mapped_column(Boolean, nullable=False, server_default="true")
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )


class UserExperiment(Base):
    """Records which variant a user has been deterministically assigned to."""

    __tablename__ = "user_experiments"
    __table_args__ = (
        UniqueConstraint("user_id", "experiment_key", name="uq_user_experiments_user_key"),
        Index("idx_user_experiments_user", "user_id"),
        Index("idx_user_experiments_key", "experiment_key"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    experiment_key: Mapped[str] = mapped_column(String(64), nullable=False)
    variant: Mapped[str] = mapped_column(String(64), nullable=False)
    assigned_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )
    # Populated when the user converts to Pro after being assigned to this experiment.
    converted_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True), nullable=True
    )

"""SQLAlchemy ORM models for the B2B team-plan domain (M70).

``TeamSubscription`` is one contracted team: the admin holds the contract,
``seat_count`` caps the roster (admin included), and the validity window mirrors
the Pro entitlement period granted to each member. ``TeamMember`` is the seat
roster; the unique ``(team_id, user_id)`` guard prevents double-seating.

Member Pro *state* still lives on the ``users`` table (granted/revoked through
the subscription domain via a port); these tables capture team structure only.
"""

from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy import ForeignKey, Index, Integer, String, UniqueConstraint, func
from sqlalchemy.dialects.postgresql import TIMESTAMP as PGTIMESTAMP
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column

from app.core.db import Base


class TeamSubscription(Base):
    """A contracted B2B team plan owned by an admin user."""

    __tablename__ = "team_subscriptions"
    __table_args__ = (Index("idx_team_subscriptions_admin", "admin_user_id"),)

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    team_name: Mapped[str] = mapped_column(String(128), nullable=False)
    admin_user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), ForeignKey("users.id"), nullable=False
    )
    seat_count: Mapped[int] = mapped_column(Integer, nullable=False, server_default="10")
    plan_type: Mapped[str] = mapped_column(String(32), nullable=False, server_default="annual_team")
    valid_from: Mapped[datetime] = mapped_column(PGTIMESTAMP(timezone=True), nullable=False)
    valid_until: Mapped[datetime] = mapped_column(PGTIMESTAMP(timezone=True), nullable=False)
    created_at: Mapped[datetime] = mapped_column(
        PGTIMESTAMP(timezone=True), nullable=False, server_default=func.now()
    )


class TeamMember(Base):
    """A single occupied seat on a team plan."""

    __tablename__ = "team_members"
    __table_args__ = (
        UniqueConstraint("team_id", "user_id", name="uq_team_members_team_user"),
        Index("idx_team_members_team", "team_id"),
    )

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    team_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("team_subscriptions.id", ondelete="CASCADE"),
        nullable=False,
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
    )
    joined_at: Mapped[datetime] = mapped_column(
        PGTIMESTAMP(timezone=True), nullable=False, server_default=func.now()
    )

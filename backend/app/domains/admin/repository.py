"""Database queries for the admin domain.

Stays within the repository contract: only reads/writes the local Postgres
database — no business logic, no external HTTP.
"""

from __future__ import annotations

from datetime import UTC, datetime, timedelta
from decimal import Decimal
from uuid import UUID

from sqlalchemy import func, or_, select, update
from sqlalchemy.ext.asyncio import AsyncSession

from app.domains.auth.models import User
from app.domains.reading.models import ReadingSession
from app.domains.subscription.models import SubscriptionEvent
from app.domains.team.models import TeamSubscription


class AdminRepository:
    """Persistence adapter for admin statistics and user management."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    # ------------------------------------------------------------------
    # Statistics
    # ------------------------------------------------------------------

    async def count_mau(self) -> int:
        """Distinct users with at least one reading session in the last 30 days."""
        cutoff = datetime.now(tz=UTC) - timedelta(days=30)
        stmt = select(func.count(func.distinct(ReadingSession.user_id))).where(
            ReadingSession.started_at >= cutoff
        )
        result = await self._session.execute(stmt)
        return result.scalar_one() or 0

    async def count_dau(self) -> int:
        """Distinct users with at least one reading session in the last 24 hours."""
        cutoff = datetime.now(tz=UTC) - timedelta(hours=24)
        stmt = select(func.count(func.distinct(ReadingSession.user_id))).where(
            ReadingSession.started_at >= cutoff
        )
        result = await self._session.execute(stmt)
        return result.scalar_one() or 0

    async def count_new_users(self, *, days: int = 7) -> int:
        """Non-deleted users registered within the last ``days`` days."""
        cutoff = datetime.now(tz=UTC) - timedelta(days=days)
        stmt = select(func.count(User.id)).where(
            User.created_at >= cutoff,
            User.deleted_at.is_(None),
        )
        result = await self._session.execute(stmt)
        return result.scalar_one() or 0

    async def count_pro_users(self) -> int:
        """Current count of users with ``is_pro=True`` (non-deleted)."""
        stmt = select(func.count(User.id)).where(
            User.is_pro.is_(True),
            User.deleted_at.is_(None),
        )
        result = await self._session.execute(stmt)
        return result.scalar_one() or 0

    # ------------------------------------------------------------------
    # Monetization metrics (M65)
    # ------------------------------------------------------------------

    async def count_subscription_events(self, *, event_type: str) -> int:
        """Count subscription funnel events of the given type."""
        stmt = select(func.count(SubscriptionEvent.id)).where(
            SubscriptionEvent.event_type == event_type
        )
        result = await self._session.execute(stmt)
        return result.scalar_one() or 0

    async def count_churned_since(self, since: datetime) -> int:
        """Count ``churn`` events recorded on/after ``since``."""
        stmt = select(func.count(SubscriptionEvent.id)).where(
            SubscriptionEvent.event_type == "churn",
            SubscriptionEvent.created_at >= since,
        )
        result = await self._session.execute(stmt)
        return result.scalar_one() or 0

    async def count_active_subscribers_by_product(self) -> dict[str | None, int]:
        """Active Pro subscriber counts grouped by ``pro_product_id``.

        Drives MRR: each product's monthly-equivalent price is applied in the
        service. NULL product ids (legacy/manual grants) are kept as a key so
        the active-subscriber total stays accurate.
        """
        stmt = (
            select(User.pro_product_id, func.count(User.id))
            .where(User.is_pro.is_(True), User.deleted_at.is_(None))
            .group_by(User.pro_product_id)
        )
        result = await self._session.execute(stmt)
        return {row[0]: row[1] for row in result.all()}

    async def sum_active_team_seats(self) -> int:
        """Total seats across team plans whose validity window covers now (M70)."""
        now = datetime.now(tz=UTC)
        stmt = select(func.coalesce(func.sum(TeamSubscription.seat_count), 0)).where(
            TeamSubscription.valid_from <= now,
            TeamSubscription.valid_until > now,
        )
        result = await self._session.execute(stmt)
        return result.scalar_one() or 0

    async def monthly_subscription_revenue(self, *, since: datetime) -> dict[str, Decimal]:
        """Sum ``subscription``-event revenue grouped by ``YYYY-MM`` since ``since`` (M70).

        The subscription-event log is the only historical revenue signal; months
        with no events are simply absent here and zero-filled by the service.
        """
        month = func.to_char(func.date_trunc("month", SubscriptionEvent.created_at), "YYYY-MM")
        stmt = (
            select(month, func.coalesce(func.sum(SubscriptionEvent.revenue_amount), 0))
            .where(
                SubscriptionEvent.event_type == "subscription",
                SubscriptionEvent.created_at >= since,
            )
            .group_by(month)
        )
        result = await self._session.execute(stmt)
        return {row[0]: Decimal(row[1]) for row in result.all()}

    # ------------------------------------------------------------------
    # User management
    # ------------------------------------------------------------------

    async def count_users(self, *, search: str | None = None) -> int:
        """Total non-deleted user count, optionally filtered by nickname/email prefix."""
        stmt = select(func.count(User.id)).where(User.deleted_at.is_(None))
        if search:
            pattern = f"%{search}%"
            stmt = stmt.where(or_(User.nickname.ilike(pattern), User.email.ilike(pattern)))
        result = await self._session.execute(stmt)
        return result.scalar_one() or 0

    async def list_users(
        self,
        *,
        page: int = 1,
        page_size: int = 20,
        search: str | None = None,
    ) -> list[User]:
        """Paginated, optionally filtered user list ordered by registration date desc."""
        offset = (page - 1) * page_size
        stmt = (
            select(User)
            .where(User.deleted_at.is_(None))
            .order_by(User.created_at.desc())
            .offset(offset)
            .limit(page_size)
        )
        if search:
            pattern = f"%{search}%"
            stmt = stmt.where(or_(User.nickname.ilike(pattern), User.email.ilike(pattern)))
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

    async def get_user_by_id(self, user_id: UUID) -> User | None:
        """Return a non-deleted user by primary key."""
        user = await self._session.get(User, user_id)
        if user is None or user.deleted_at is not None:
            return None
        return user

    async def get_user_by_email(self, email: str) -> User | None:
        """Return a non-deleted user by case-insensitive exact email match.

        Used by the admin-promotion CLI (``scripts/promote_admin.py``, BC-88) —
        promotion is looked up by email since that is the identifier an
        operator has on hand, not the internal UUID.
        """
        stmt = select(User).where(
            func.lower(User.email) == email.lower(),
            User.deleted_at.is_(None),
        )
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()

    async def count_admins(self) -> int:
        """Count of non-deleted users with ``is_admin=True``.

        Used to guard against revoking the last remaining admin (BC-88) —
        once that count hits zero, only direct DB access can recover.
        """
        stmt = select(func.count(User.id)).where(
            User.is_admin.is_(True),
            User.deleted_at.is_(None),
        )
        result = await self._session.execute(stmt)
        return result.scalar_one() or 0

    async def patch_user(
        self,
        user_id: UUID,
        *,
        is_active: bool | None,
        is_admin: bool | None,
    ) -> User | None:
        """Partially update ``is_active`` / ``is_admin`` for a user.

        Returns the refreshed ``User`` on success or ``None`` when the user
        does not exist (or is soft-deleted).
        """
        values: dict[str, bool] = {}
        if is_active is not None:
            values["is_active"] = is_active
        if is_admin is not None:
            values["is_admin"] = is_admin
        if not values:
            # Nothing to update — return the existing user unchanged.
            return await self.get_user_by_id(user_id)

        stmt = (
            update(User)
            .where(User.id == user_id, User.deleted_at.is_(None))
            .values(**values)
            .returning(User)
        )
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()

"""Database queries for the admin domain.

Stays within the repository contract: only reads/writes the local Postgres
database — no business logic, no external HTTP.
"""

from __future__ import annotations

from datetime import UTC, datetime, timedelta
from uuid import UUID

from sqlalchemy import func, or_, select, update
from sqlalchemy.ext.asyncio import AsyncSession

from app.domains.auth.models import User
from app.domains.reading.models import ReadingSession


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
    # User management
    # ------------------------------------------------------------------

    async def count_users(self, *, search: str | None = None) -> int:
        """Total non-deleted user count, optionally filtered by nickname/email prefix."""
        stmt = select(func.count(User.id)).where(User.deleted_at.is_(None))
        if search:
            pattern = f"%{search}%"
            stmt = stmt.where(
                or_(User.nickname.ilike(pattern), User.email.ilike(pattern))
            )
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
            stmt = stmt.where(
                or_(User.nickname.ilike(pattern), User.email.ilike(pattern))
            )
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

    async def get_user_by_id(self, user_id: UUID) -> User | None:
        """Return a non-deleted user by primary key."""
        user = await self._session.get(User, user_id)
        if user is None or user.deleted_at is not None:
            return None
        return user

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

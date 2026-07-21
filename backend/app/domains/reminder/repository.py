"""SQLAlchemy async repository for the reminder domain.

All queries run on the AsyncSession injected at request time so they share
the same transaction as the rest of the request.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import time as time_type
from uuid import UUID

from sqlalchemy import delete, select, update
from sqlalchemy.ext.asyncio import AsyncSession

from app.domains.reminder.models import ReadingReminder


@dataclass(slots=True)
class ReminderRepository:
    """Concrete repository — all DB I/O for the reminder domain."""

    session: AsyncSession

    async def list_by_user(self, user_id: UUID) -> list[ReadingReminder]:
        """Return all reminders for a user, ordered by creation time."""
        result = await self.session.execute(
            select(ReadingReminder)
            .where(ReadingReminder.user_id == user_id)
            .order_by(ReadingReminder.created_at.asc())
        )
        return list(result.scalars().all())

    async def get_by_id(self, reminder_id: UUID) -> ReadingReminder | None:
        """Return a single reminder by primary key, or None if absent."""
        result = await self.session.execute(
            select(ReadingReminder).where(ReadingReminder.id == reminder_id)
        )
        return result.scalar_one_or_none()

    async def create(
        self,
        *,
        user_id: UUID,
        days_of_week: list[int],
        remind_at: time_type,
        is_active: bool,
    ) -> ReadingReminder:
        """Insert a new reminder row and return the persisted object."""
        reminder = ReadingReminder(
            user_id=user_id,
            days_of_week=days_of_week,
            remind_at=remind_at,
            is_active=is_active,
        )
        self.session.add(reminder)
        await self.session.flush()
        await self.session.refresh(reminder)
        return reminder

    async def update(
        self,
        reminder_id: UUID,
        *,
        days_of_week: list[int],
        remind_at: time_type,
        is_active: bool,
    ) -> ReadingReminder | None:
        """Update mutable fields on a reminder; return the updated row or None."""
        await self.session.execute(
            update(ReadingReminder)
            .where(ReadingReminder.id == reminder_id)
            .values(
                days_of_week=days_of_week,
                remind_at=remind_at,
                is_active=is_active,
            )
        )
        await self.session.flush()
        return await self.get_by_id(reminder_id)

    async def delete(self, reminder_id: UUID) -> None:
        """Delete a reminder row by primary key."""
        await self.session.execute(delete(ReadingReminder).where(ReadingReminder.id == reminder_id))
        await self.session.flush()

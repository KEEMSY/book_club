"""Business logic for the reminder domain.

``ReminderService`` enforces the per-user 7-reminder cap and ownership checks
before delegating persistence to ``ReminderRepository``.
"""

from __future__ import annotations

from dataclasses import dataclass
from uuid import UUID

from app.core.exceptions import ConflictError, NotFoundError
from app.domains.reminder.models import ReadingReminder
from app.domains.reminder.repository import ReminderRepository
from app.domains.reminder.schemas import ReminderCreate

_MAX_REMINDERS_PER_USER = 7


@dataclass(slots=True)
class ReminderService:
    """Handles CRUD operations for user-configured reading reminders."""

    repo: ReminderRepository

    async def list_reminders(self, user_id: UUID) -> list[ReadingReminder]:
        """Return all reminders owned by the user."""
        return await self.repo.list_by_user(user_id)

    async def create_reminder(
        self, *, user_id: UUID, data: ReminderCreate
    ) -> ReadingReminder:
        """Create a new reminder, enforcing the 7-per-user cap."""
        existing = await self.repo.list_by_user(user_id)
        if len(existing) >= _MAX_REMINDERS_PER_USER:
            raise ConflictError(
                f"maximum {_MAX_REMINDERS_PER_USER} reminders per user reached",
                code="REMINDER_LIMIT_EXCEEDED",
            )
        return await self.repo.create(
            user_id=user_id,
            days_of_week=data.days_of_week,
            remind_at=data.remind_at,
            is_active=data.is_active,
        )

    async def update_reminder(
        self, *, user_id: UUID, reminder_id: UUID, data: ReminderCreate
    ) -> ReadingReminder:
        """Replace a reminder's fields after verifying ownership."""
        reminder = await self.repo.get_by_id(reminder_id)
        if reminder is None or reminder.user_id != user_id:
            raise NotFoundError("reminder not found", code="REMINDER_NOT_FOUND")
        updated = await self.repo.update(
            reminder_id,
            days_of_week=data.days_of_week,
            remind_at=data.remind_at,
            is_active=data.is_active,
        )
        # update() returns None only when the row disappeared between the
        # ownership check above and the UPDATE — treat as not found.
        if updated is None:
            raise NotFoundError("reminder not found", code="REMINDER_NOT_FOUND")
        return updated

    async def delete_reminder(self, *, user_id: UUID, reminder_id: UUID) -> None:
        """Delete a reminder after verifying ownership."""
        reminder = await self.repo.get_by_id(reminder_id)
        if reminder is None or reminder.user_id != user_id:
            raise NotFoundError("reminder not found", code="REMINDER_NOT_FOUND")
        await self.repo.delete(reminder_id)

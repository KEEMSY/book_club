"""HTTP surface for the reminder domain — /me/reminders.

Thin DTO ↔ service ↔ DTO layer per CLAUDE.md §3.1.
All endpoints require a valid access token.
"""

from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, Response, status

from app.core.deps import get_current_user_id
from app.domains.reminder.providers import get_reminder_service
from app.domains.reminder.schemas import ReminderCreate, ReminderListResponse, ReminderPublic
from app.domains.reminder.service import ReminderService

router = APIRouter(tags=["reminder"])


@router.get("/me/reminders", response_model=ReminderListResponse)
async def list_reminders(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReminderService, Depends(get_reminder_service)],
) -> ReminderListResponse:
    """Return all reading reminders for the authenticated user."""
    reminders = await service.list_reminders(UUID(user_id))
    return ReminderListResponse(items=[ReminderPublic.model_validate(r) for r in reminders])


@router.post("/me/reminders", response_model=ReminderPublic, status_code=status.HTTP_201_CREATED)
async def create_reminder(
    body: ReminderCreate,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReminderService, Depends(get_reminder_service)],
) -> ReminderPublic:
    """Create a new reading reminder.

    Returns 409 when the user already has 7 reminders.
    """
    reminder = await service.create_reminder(user_id=UUID(user_id), data=body)
    return ReminderPublic.model_validate(reminder)


@router.put("/me/reminders/{reminder_id}", response_model=ReminderPublic)
async def update_reminder(
    reminder_id: UUID,
    body: ReminderCreate,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReminderService, Depends(get_reminder_service)],
) -> ReminderPublic:
    """Replace all fields on an existing reminder.

    Returns 404 when the reminder does not exist or belongs to a different user.
    """
    reminder = await service.update_reminder(
        user_id=UUID(user_id), reminder_id=reminder_id, data=body
    )
    return ReminderPublic.model_validate(reminder)


@router.delete("/me/reminders/{reminder_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_reminder(
    reminder_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[ReminderService, Depends(get_reminder_service)],
) -> Response:
    """Delete a reading reminder.

    Returns 204 on success, 404 when the reminder is unknown or owned by another user.
    """
    await service.delete_reminder(user_id=UUID(user_id), reminder_id=reminder_id)
    return Response(status_code=status.HTTP_204_NO_CONTENT)

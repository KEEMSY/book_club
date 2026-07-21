"""Unit tests for ReminderService — in-memory fakes, no DB."""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import time
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError, NotFoundError
from app.domains.reminder.schemas import ReminderCreate
from app.domains.reminder.service import ReminderService

# ---------------------------------------------------------------------------
# Fake ORM-like object
# ---------------------------------------------------------------------------


@dataclass
class _FakeReminder:
    id: UUID = field(default_factory=uuid4)
    user_id: UUID = field(default_factory=uuid4)
    days_of_week: list[int] = field(default_factory=lambda: [0])
    remind_at: time = field(default_factory=lambda: time(21, 0))
    is_active: bool = True


# ---------------------------------------------------------------------------
# Fake repository
# ---------------------------------------------------------------------------


class FakeReminderRepository:
    def __init__(self) -> None:
        self._store: dict[UUID, _FakeReminder] = {}

    async def list_by_user(self, user_id: UUID) -> list[_FakeReminder]:
        return [r for r in self._store.values() if r.user_id == user_id]

    async def get_by_id(self, reminder_id: UUID) -> _FakeReminder | None:
        return self._store.get(reminder_id)

    async def create(
        self,
        *,
        user_id: UUID,
        days_of_week: list[int],
        remind_at: time,
        is_active: bool,
    ) -> _FakeReminder:
        r = _FakeReminder(
            user_id=user_id,
            days_of_week=days_of_week,
            remind_at=remind_at,
            is_active=is_active,
        )
        self._store[r.id] = r
        return r

    async def update(
        self,
        reminder_id: UUID,
        *,
        days_of_week: list[int],
        remind_at: time,
        is_active: bool,
    ) -> _FakeReminder | None:
        r = self._store.get(reminder_id)
        if r is None:
            return None
        r.days_of_week = days_of_week
        r.remind_at = remind_at
        r.is_active = is_active
        return r

    async def delete(self, reminder_id: UUID) -> None:
        self._store.pop(reminder_id, None)


def _svc() -> tuple[ReminderService, FakeReminderRepository]:
    repo = FakeReminderRepository()
    return ReminderService(repo=repo), repo  # type: ignore[arg-type]


def _data(days: list[int] | None = None) -> ReminderCreate:
    return ReminderCreate(
        days_of_week=days or [0, 1, 2],
        remind_at=time(21, 0),
        is_active=True,
    )


# ---------------------------------------------------------------------------
# create_reminder
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_create_reminder_happy_path() -> None:
    svc, _ = _svc()
    user = uuid4()
    reminder = await svc.create_reminder(user_id=user, data=_data())
    assert reminder.user_id == user
    assert reminder.days_of_week == [0, 1, 2]


@pytest.mark.asyncio
async def test_create_reminder_enforces_7_cap() -> None:
    svc, _ = _svc()
    user = uuid4()
    for i in range(7):
        await svc.create_reminder(user_id=user, data=_data([i]))

    with pytest.raises(ConflictError) as exc_info:
        await svc.create_reminder(user_id=user, data=_data([0]))
    assert exc_info.value.code == "REMINDER_LIMIT_EXCEEDED"


@pytest.mark.asyncio
async def test_create_reminder_cap_is_per_user() -> None:
    svc, _ = _svc()
    user_a = uuid4()
    user_b = uuid4()
    for i in range(7):
        await svc.create_reminder(user_id=user_a, data=_data([i]))

    # user_b is unaffected by user_a's cap
    reminder = await svc.create_reminder(user_id=user_b, data=_data([0]))
    assert reminder.user_id == user_b


# ---------------------------------------------------------------------------
# list_reminders
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_list_reminders_returns_only_own() -> None:
    svc, _ = _svc()
    user_a = uuid4()
    user_b = uuid4()
    await svc.create_reminder(user_id=user_a, data=_data())
    await svc.create_reminder(user_id=user_a, data=_data())
    await svc.create_reminder(user_id=user_b, data=_data())

    result = await svc.list_reminders(user_a)
    assert len(result) == 2
    assert all(r.user_id == user_a for r in result)


# ---------------------------------------------------------------------------
# update_reminder
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_update_reminder_happy_path() -> None:
    svc, _ = _svc()
    user = uuid4()
    created = await svc.create_reminder(user_id=user, data=_data([0]))

    updated = await svc.update_reminder(
        user_id=user,
        reminder_id=created.id,
        data=ReminderCreate(days_of_week=[5, 6], remind_at=time(8, 0), is_active=False),
    )
    assert updated.days_of_week == [5, 6]
    assert updated.remind_at == time(8, 0)
    assert updated.is_active is False


@pytest.mark.asyncio
async def test_update_reminder_non_owner_raises_not_found() -> None:
    svc, _ = _svc()
    owner = uuid4()
    attacker = uuid4()
    created = await svc.create_reminder(user_id=owner, data=_data())

    with pytest.raises(NotFoundError):
        await svc.update_reminder(user_id=attacker, reminder_id=created.id, data=_data())


# ---------------------------------------------------------------------------
# delete_reminder
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_delete_reminder_happy_path() -> None:
    svc, _ = _svc()
    user = uuid4()
    created = await svc.create_reminder(user_id=user, data=_data())

    await svc.delete_reminder(user_id=user, reminder_id=created.id)
    remaining = await svc.list_reminders(user)
    assert len(remaining) == 0


@pytest.mark.asyncio
async def test_delete_reminder_non_owner_raises_not_found() -> None:
    svc, _ = _svc()
    owner = uuid4()
    attacker = uuid4()
    created = await svc.create_reminder(user_id=owner, data=_data())

    with pytest.raises(NotFoundError):
        await svc.delete_reminder(user_id=attacker, reminder_id=created.id)

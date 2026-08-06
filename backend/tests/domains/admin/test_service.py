"""Unit tests for AdminService — in-memory fakes, no DB."""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import UTC, datetime
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError, NotFoundError
from app.domains.admin.service import AdminService

# ---------------------------------------------------------------------------
# Fake repository
# ---------------------------------------------------------------------------


@dataclass
class _FakeUser:
    id: UUID = field(default_factory=uuid4)
    nickname: str = "tester"
    email: str = "test@example.com"
    is_active: bool = True
    is_admin: bool = False
    is_pro: bool = False
    created_at: datetime = field(default_factory=lambda: datetime.now(tz=UTC))

    # Required for model_validate
    def __getattr__(self, name: str) -> object:
        raise AttributeError(name)


@dataclass
class FakeAdminRepository:
    _users: dict[UUID, _FakeUser] = field(default_factory=dict)
    _mau: int = 5
    _dau: int = 2
    _new_7d: int = 1
    _pro: int = 0

    async def count_mau(self) -> int:
        return self._mau

    async def count_dau(self) -> int:
        return self._dau

    async def count_new_users(self, *, days: int) -> int:
        return self._new_7d

    async def count_pro_users(self) -> int:
        return self._pro

    async def count_users(self, *, search: str | None = None) -> int:
        if search:
            return sum(1 for u in self._users.values() if search in u.nickname)
        return len(self._users)

    async def list_users(
        self, *, page: int, page_size: int, search: str | None = None
    ) -> list[_FakeUser]:
        users = list(self._users.values())
        if search:
            users = [u for u in users if search in u.nickname]
        start = (page - 1) * page_size
        return users[start : start + page_size]

    async def get_user_by_id(self, user_id: UUID) -> _FakeUser | None:
        return self._users.get(user_id)

    async def get_user_by_email(self, email: str) -> _FakeUser | None:
        return next(
            (u for u in self._users.values() if (u.email or "").lower() == email.lower()), None
        )

    async def count_admins(self) -> int:
        return sum(1 for u in self._users.values() if u.is_admin)

    async def patch_user(
        self,
        user_id: UUID,
        *,
        is_active: bool | None,
        is_admin: bool | None,
    ) -> _FakeUser | None:
        user = self._users.get(user_id)
        if user is None:
            return None
        if is_active is not None:
            user.is_active = is_active
        if is_admin is not None:
            user.is_admin = is_admin
        return user


def _svc() -> tuple[AdminService, FakeAdminRepository]:
    repo = FakeAdminRepository()
    return AdminService(repo=repo), repo  # type: ignore[arg-type]


# ---------------------------------------------------------------------------
# get_stats
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_get_stats_returns_aggregated_counts() -> None:
    repo = FakeAdminRepository(_mau=42, _dau=7, _new_7d=3, _pro=5)
    svc = AdminService(repo=repo)  # type: ignore[arg-type]
    stats = await svc.get_stats()
    assert stats.mau == 42
    assert stats.dau == 7
    assert stats.new_users_7d == 3
    assert stats.pro_users == 5


# ---------------------------------------------------------------------------
# list_users
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_list_users_returns_paginated_result() -> None:
    svc, repo = _svc()
    for i in range(5):
        u = _FakeUser(nickname=f"user{i}", email=f"u{i}@example.com")
        repo._users[u.id] = u

    page = await svc.list_users(page=1, page_size=3)
    assert page.total == 5
    assert len(page.items) == 3


@pytest.mark.asyncio
async def test_list_users_empty_repo() -> None:
    svc, _ = _svc()
    page = await svc.list_users()
    assert page.total == 0
    assert page.items == []


# ---------------------------------------------------------------------------
# get_user
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_get_user_returns_item() -> None:
    svc, repo = _svc()
    user = _FakeUser(nickname="alice")
    repo._users[user.id] = user

    item = await svc.get_user(user.id)
    assert item.nickname == "alice"


@pytest.mark.asyncio
async def test_get_user_missing_raises_not_found() -> None:
    svc, _ = _svc()
    with pytest.raises(NotFoundError) as exc_info:
        await svc.get_user(uuid4())
    assert exc_info.value.code == "USER_NOT_FOUND"


# ---------------------------------------------------------------------------
# patch_user
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_patch_user_deactivates_user() -> None:
    svc, repo = _svc()
    user = _FakeUser(is_active=True)
    repo._users[user.id] = user

    patched = await svc.patch_user(user.id, is_active=False, is_admin=None)
    assert patched.is_active is False


@pytest.mark.asyncio
async def test_patch_user_promotes_to_admin() -> None:
    svc, repo = _svc()
    user = _FakeUser(is_admin=False)
    repo._users[user.id] = user

    patched = await svc.patch_user(user.id, is_active=None, is_admin=True)
    assert patched.is_admin is True


@pytest.mark.asyncio
async def test_patch_user_missing_raises_not_found() -> None:
    svc, _ = _svc()
    with pytest.raises(NotFoundError):
        await svc.patch_user(uuid4(), is_active=False, is_admin=None)


@pytest.mark.asyncio
async def test_patch_user_exposes_is_pro() -> None:
    svc, repo = _svc()
    user = _FakeUser(is_pro=True)
    repo._users[user.id] = user

    item = await svc.get_user(user.id)
    assert item.is_pro is True


# ---------------------------------------------------------------------------
# patch_user — last-admin protection (BC-88)
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_patch_user_blocks_revoking_last_admin() -> None:
    svc, repo = _svc()
    only_admin = _FakeUser(is_admin=True)
    repo._users[only_admin.id] = only_admin

    with pytest.raises(ConflictError) as exc_info:
        await svc.patch_user(only_admin.id, is_active=None, is_admin=False)
    assert exc_info.value.code == "LAST_ADMIN_PROTECTED"
    # The guard must fire before any write — the user stays an admin.
    assert only_admin.is_admin is True


@pytest.mark.asyncio
async def test_patch_user_allows_revoking_admin_when_others_remain() -> None:
    svc, repo = _svc()
    admin_a = _FakeUser(is_admin=True)
    admin_b = _FakeUser(is_admin=True)
    repo._users[admin_a.id] = admin_a
    repo._users[admin_b.id] = admin_b

    patched = await svc.patch_user(admin_a.id, is_active=None, is_admin=False)
    assert patched.is_admin is False


@pytest.mark.asyncio
async def test_patch_user_allows_deactivating_the_last_admin() -> None:
    """is_active=False alone must not trip the is_admin guard."""
    svc, repo = _svc()
    only_admin = _FakeUser(is_admin=True)
    repo._users[only_admin.id] = only_admin

    patched = await svc.patch_user(only_admin.id, is_active=False, is_admin=None)
    assert patched.is_active is False
    assert patched.is_admin is True

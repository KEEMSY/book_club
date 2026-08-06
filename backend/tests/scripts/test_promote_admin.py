"""Unit tests for scripts/promote_admin.py (BC-88).

``scripts/`` is not a package (matches the existing seed_*.py scripts), so the
module is loaded by file path rather than a normal import. Exercises the pure
async helpers (``promote_user``, ``bootstrap_from_settings``) against an
in-memory fake repository — no DB, no subprocess.
"""

from __future__ import annotations

import importlib.util
import pathlib
import sys
from dataclasses import dataclass, field
from types import ModuleType
from uuid import UUID, uuid4

import pytest

_SCRIPT_PATH = pathlib.Path(__file__).resolve().parents[2] / "scripts" / "promote_admin.py"


def _load_script() -> ModuleType:
    spec = importlib.util.spec_from_file_location("promote_admin_script", _SCRIPT_PATH)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    # dataclass(slots=True) needs its module registered in sys.modules while
    # exec_module runs a plain module_from_spec() does not do that for us.
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


promote_admin = _load_script()


@dataclass
class _FakeUser:
    id: UUID = field(default_factory=uuid4)
    email: str = "owner@bookclub.kr"
    is_admin: bool = False


@dataclass
class FakeRepo:
    users: dict[UUID, _FakeUser] = field(default_factory=dict)

    async def get_user_by_email(self, email: str) -> _FakeUser | None:
        return next((u for u in self.users.values() if u.email.lower() == email.lower()), None)

    async def patch_user(
        self, user_id: UUID, *, is_active: bool | None, is_admin: bool | None
    ) -> _FakeUser | None:
        user = self.users.get(user_id)
        if user is None:
            return None
        if is_admin is not None:
            user.is_admin = is_admin
        return user


# ---------------------------------------------------------------------------
# promote_user
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_promote_user_promotes_existing_user() -> None:
    repo = FakeRepo()
    user = _FakeUser(email="owner@bookclub.kr", is_admin=False)
    repo.users[user.id] = user

    result = await promote_admin.promote_user(repo, "owner@bookclub.kr")  # type: ignore[arg-type]
    assert result is not None
    assert result.is_admin is True


@pytest.mark.asyncio
async def test_promote_user_is_case_insensitive() -> None:
    repo = FakeRepo()
    user = _FakeUser(email="Owner@BookClub.kr", is_admin=False)
    repo.users[user.id] = user

    result = await promote_admin.promote_user(repo, "owner@bookclub.kr")  # type: ignore[arg-type]
    assert result is not None
    assert result.is_admin is True


@pytest.mark.asyncio
async def test_promote_user_missing_returns_none() -> None:
    repo = FakeRepo()
    result = await promote_admin.promote_user(repo, "nobody@bookclub.kr")  # type: ignore[arg-type]
    assert result is None


@pytest.mark.asyncio
async def test_promote_user_already_admin_is_idempotent() -> None:
    repo = FakeRepo()
    user = _FakeUser(email="owner@bookclub.kr", is_admin=True)
    repo.users[user.id] = user

    result = await promote_admin.promote_user(repo, "owner@bookclub.kr")  # type: ignore[arg-type]
    assert result is not None
    assert result.is_admin is True


# ---------------------------------------------------------------------------
# bootstrap_from_settings
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_bootstrap_promotes_matching_not_yet_admin_users() -> None:
    repo = FakeRepo()
    a = _FakeUser(email="a@bookclub.kr", is_admin=False)
    b = _FakeUser(email="b@bookclub.kr", is_admin=True)
    repo.users[a.id] = a
    repo.users[b.id] = b

    report = await promote_admin.bootstrap_from_settings(  # type: ignore[arg-type]
        repo, ["a@bookclub.kr", "b@bookclub.kr", "missing@bookclub.kr"]
    )
    assert report.promoted == ["a@bookclub.kr"]
    assert report.already_admin == ["b@bookclub.kr"]
    assert report.not_found == ["missing@bookclub.kr"]
    assert a.is_admin is True


@pytest.mark.asyncio
async def test_bootstrap_deduplicates_emails() -> None:
    repo = FakeRepo()
    a = _FakeUser(email="a@bookclub.kr", is_admin=False)
    repo.users[a.id] = a

    report = await promote_admin.bootstrap_from_settings(  # type: ignore[arg-type]
        repo, ["a@bookclub.kr", "a@bookclub.kr", "  "]
    )
    assert report.promoted == ["a@bookclub.kr"]


@pytest.mark.asyncio
async def test_bootstrap_empty_list_is_a_noop() -> None:
    repo = FakeRepo()
    report = await promote_admin.bootstrap_from_settings(repo, [])  # type: ignore[arg-type]
    assert report.promoted == []
    assert report.already_admin == []
    assert report.not_found == []

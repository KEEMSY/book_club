"""Postgres-backed async session fixtures for auth repository tests.

Connection strategy:
1. ``DATABASE_URL_TEST`` env var (preferred when CI sets up a service).
2. ``DATABASE_URL`` env var (local dev if the dev already has a container up).
3. Default ``postgresql+asyncpg://postgres:postgres@localhost:5432/book_club_test``.

Tests are ``skip``ped (not xfailed) when the DB is unreachable so contributors
without a running Postgres can still run unit-only tests locally. CI runs a
Postgres service, so the skip never triggers there.

The fixture applies Alembic ``upgrade head`` once per test session (against
the resolved URL), then truncates the auth tables between tests so rows do
not leak across tests.
"""

from __future__ import annotations

import os
import subprocess
import sys
from collections.abc import AsyncIterator

import pytest
import pytest_asyncio
from sqlalchemy import text
from sqlalchemy.ext.asyncio import (
    AsyncSession,
    async_sessionmaker,
    create_async_engine,
)

PROJECT_ROOT = os.path.dirname(
    os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
)


def _resolve_database_url() -> str:
    return (
        os.environ.get("DATABASE_URL_TEST")
        or os.environ.get("DATABASE_URL")
        or "postgresql+asyncpg://postgres:postgres@localhost:5432/book_club_test"
    )


async def _ping(url: str) -> bool:
    engine = create_async_engine(url, pool_pre_ping=True)
    try:
        async with engine.connect() as conn:
            await conn.execute(text("SELECT 1"))
        return True
    except Exception:
        return False
    finally:
        await engine.dispose()


@pytest_asyncio.fixture(scope="session")
async def db_url() -> AsyncIterator[str]:
    url = _resolve_database_url()
    reachable = await _ping(url)
    if not reachable:
        pytest.skip(
            f"Postgres not reachable at {url}; set DATABASE_URL to run "
            "repository/router integration tests."
        )
    yield url


@pytest_asyncio.fixture(scope="session")
async def _migrated_db(db_url: str) -> AsyncIterator[str]:
    # Alembic's env.py spins up its own asyncio loop, so we must invoke it
    # out-of-process to avoid "asyncio.run() from a running event loop".
    env = {**os.environ, "DATABASE_URL": db_url}
    subprocess.run(
        [sys.executable, "-m", "alembic", "upgrade", "head"],
        cwd=PROJECT_ROOT,
        check=True,
        env=env,
    )
    yield db_url


@pytest_asyncio.fixture
async def session(_migrated_db: str) -> AsyncIterator[AsyncSession]:
    engine = create_async_engine(_migrated_db, pool_pre_ping=True)
    maker = async_sessionmaker(bind=engine, expire_on_commit=False, autoflush=False)
    async with engine.begin() as conn:
        await conn.execute(text("TRUNCATE TABLE device_tokens, users RESTART IDENTITY CASCADE"))
    async with maker() as s:
        yield s
    await engine.dispose()

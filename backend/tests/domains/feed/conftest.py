"""Postgres-backed async session fixtures for feed repository tests.

Mirrors ``tests/domains/book|reading/conftest.py`` so contributors without
a running Postgres still run the unit test subset. DB-integration tests
skip gracefully when the connection fails.
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
async def feed_db_url() -> AsyncIterator[str]:
    url = _resolve_database_url()
    reachable = await _ping(url)
    if not reachable:
        pytest.skip(
            f"Postgres not reachable at {url}; set DATABASE_URL to run "
            "repository/router integration tests."
        )
    yield url


@pytest_asyncio.fixture(scope="session")
async def _migrated_feed_db(feed_db_url: str) -> AsyncIterator[str]:
    env = {**os.environ, "DATABASE_URL": feed_db_url}
    subprocess.run(
        [sys.executable, "-m", "alembic", "upgrade", "head"],
        cwd=PROJECT_ROOT,
        check=True,
        env=env,
    )
    yield feed_db_url


@pytest_asyncio.fixture
async def session(_migrated_feed_db: str) -> AsyncIterator[AsyncSession]:
    engine = create_async_engine(_migrated_feed_db, pool_pre_ping=True)
    maker = async_sessionmaker(bind=engine, expire_on_commit=False, autoflush=False)
    async with engine.begin() as conn:
        # Order matters: feed rows FK into posts/comments/users/books; truncate
        # all relevant tables in dependency order so each test starts clean.
        await conn.execute(
            text(
                "TRUNCATE TABLE "
                "comments, reactions, posts, "
                "goals, user_grades, daily_reading_stats, reading_sessions, "
                "user_books, books, device_tokens, users "
                "RESTART IDENTITY CASCADE"
            )
        )
    async with maker() as s:
        yield s
    await engine.dispose()

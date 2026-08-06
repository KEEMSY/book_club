"""Postgres-backed async session fixtures for club repository tests (BC-44).

Mirrors ``tests/domains/reading/conftest.py`` so contributors without a
running Postgres still run the fake-repo unit test subset (test_service_*.py).
DB-integration tests skip gracefully when the connection fails.
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
async def club_db_url() -> AsyncIterator[str]:
    url = _resolve_database_url()
    reachable = await _ping(url)
    if not reachable:
        pytest.skip(
            f"Postgres not reachable at {url}; set DATABASE_URL to run "
            "repository/router integration tests."
        )
    yield url


@pytest_asyncio.fixture(scope="session")
async def _migrated_club_db(club_db_url: str) -> AsyncIterator[str]:
    env = {**os.environ, "DATABASE_URL": club_db_url}
    subprocess.run(
        [sys.executable, "-m", "alembic", "upgrade", "head"],
        cwd=PROJECT_ROOT,
        check=True,
        env=env,
    )
    yield club_db_url


@pytest_asyncio.fixture
async def session(_migrated_club_db: str) -> AsyncIterator[AsyncSession]:
    engine = create_async_engine(_migrated_club_db, pool_pre_ping=True)
    maker = async_sessionmaker(bind=engine, expire_on_commit=False, autoflush=False)
    async with engine.begin() as conn:
        # Order matters: session/agenda/topic/comment rows FK into
        # reading_clubs/books/users; truncate all in dependency order so
        # each test starts from a clean slate.
        await conn.execute(
            text(
                "TRUNCATE TABLE "
                "topic_comments, agenda_topics, session_agendas, club_sessions, "
                "club_tags, club_members, reading_clubs, books, device_tokens, users "
                "RESTART IDENTITY CASCADE"
            )
        )
    async with maker() as s:
        yield s
    await engine.dispose()

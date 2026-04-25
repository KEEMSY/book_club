"""Alembic environment — async-aware, driven by app.core.config.

Design notes:
- `target_metadata` is `None` during M0 because no domain has declared SQLAlchemy
  models yet. Starting with M1 (Task 1.1), this will be replaced with the
  combined `Base.metadata` from `app.core.db` so that `alembic revision
  --autogenerate` can detect schema drift. Keeping autogeneration disabled for
  now prevents accidental no-op diffs against an empty metadata registry.
- The URL is read from the application's Settings, so there is exactly one
  source of truth for `DATABASE_URL` (CLAUDE.md §9).
"""

from __future__ import annotations

import asyncio
from logging.config import fileConfig

from alembic import context
from app.core.config import get_settings
from sqlalchemy import pool
from sqlalchemy.engine import Connection
from sqlalchemy.ext.asyncio import async_engine_from_config

config = context.config

if config.config_file_name is not None:
    fileConfig(config.config_file_name)

settings = get_settings()
# Inject the real DATABASE_URL at runtime so alembic.ini never holds secrets.
config.set_main_option("sqlalchemy.url", settings.database_url)

# Import every domain's models module so their tables register against
# Base.metadata before autogenerate diff runs. Adding a new domain means
# adding its import here (and nothing else).
from app.core.db import Base  # noqa: E402
from app.domains.auth import models as _auth_models  # noqa: E402, F401
from app.domains.book import models as _book_models  # noqa: E402, F401
from app.domains.feed import models as _feed_models  # noqa: E402, F401
from app.domains.reading import models as _reading_models  # noqa: E402, F401

target_metadata = Base.metadata


def run_migrations_offline() -> None:
    """Run migrations without a live DB connection (emits SQL scripts)."""
    url = config.get_main_option("sqlalchemy.url")
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
        compare_type=True,
    )

    with context.begin_transaction():
        context.run_migrations()


def do_run_migrations(connection: Connection) -> None:
    context.configure(
        connection=connection,
        target_metadata=target_metadata,
        compare_type=True,
    )

    with context.begin_transaction():
        context.run_migrations()


async def run_async_migrations() -> None:
    """Run migrations against an async engine."""
    configuration = config.get_section(config.config_ini_section, {})
    connectable = async_engine_from_config(
        configuration,
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )

    async with connectable.connect() as connection:
        await connection.run_sync(do_run_migrations)

    await connectable.dispose()


def run_migrations_online() -> None:
    asyncio.run(run_async_migrations())


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()

"""Async Redis client factory.

A process-wide singleton client is built lazily on first access; the
pool is managed by the redis library.  Callers receive the raw client
so they retain full control over key naming, TTL, and serialisation —
this module is purely an infrastructure concern (CLAUDE.md §3.3).
"""

from __future__ import annotations

from functools import lru_cache

import redis.asyncio as aioredis

from app.core.config import get_settings


@lru_cache(maxsize=1)
def get_redis() -> aioredis.Redis:  # type: ignore[type-arg]
    """Return the process-wide Redis client.

    The client is connection-pool-backed; each coroutine borrows a
    connection for the duration of a command and releases it immediately.
    """
    settings = get_settings()
    return aioredis.from_url(
        settings.redis_url,
        encoding="utf-8",
        decode_responses=True,
    )

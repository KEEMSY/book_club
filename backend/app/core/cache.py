"""Async Redis client factory and response-caching utilities.

A process-wide singleton client is built lazily on first access; the
pool is managed by the redis library.  Callers receive the raw client
so they retain full control over key naming, TTL, and serialisation —
this module is purely an infrastructure concern (CLAUDE.md §3.3).

``cache_response`` decorates async service methods so their results are
transparently stored in Redis.  Redis failures are silently bypassed so
a cache outage never breaks application functionality.
"""

from __future__ import annotations

import functools
import inspect
import json
import logging
from collections.abc import Callable, Coroutine
from functools import lru_cache
from typing import Any, TypeVar

import redis.asyncio as aioredis

from app.core.config import get_settings

logger = logging.getLogger(__name__)

F = TypeVar("F", bound=Callable[..., Coroutine[Any, Any, Any]])


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


def cache_response(*, key_pattern: str, ttl: int) -> Callable[[F], F]:
    """Decorator that caches the JSON-serialised return value of an async method.

    ``key_pattern`` may reference function argument names with ``{arg_name}``
    placeholders, which are interpolated at call time.  Example::

        @cache_response(key_pattern="recommendations:{user_id}", ttl=3600)
        async def get_recommendations(self, user_id: UUID, ...) -> ...:
            ...

    On Redis failure the decorator falls through to the real function so a
    cache outage is invisible to callers.
    """

    def decorator(fn: F) -> F:
        sig = inspect.signature(fn)

        @functools.wraps(fn)
        async def wrapper(*args: Any, **kwargs: Any) -> Any:
            # Bind positional + keyword args to their parameter names so we can
            # interpolate {param_name} placeholders in key_pattern.
            bound = sig.bind(*args, **kwargs)
            bound.apply_defaults()
            resolved_key = key_pattern.format_map(
                {k: str(v) for k, v in bound.arguments.items()}
            )

            redis_client = get_redis()
            try:
                cached = await redis_client.get(resolved_key)
                if cached is not None:
                    return json.loads(cached)
            except Exception:
                # Cache miss due to Redis error — proceed to the real call.
                logger.warning("cache_read_error key=%s", resolved_key, exc_info=True)

            result = await fn(*args, **kwargs)

            try:
                await redis_client.set(resolved_key, json.dumps(result), ex=ttl)
            except Exception:
                # Write failure should not surface to the caller.
                logger.warning("cache_write_error key=%s", resolved_key, exc_info=True)

            return result

        return wrapper  # type: ignore[return-value]

    return decorator


async def invalidate_cache(key: str) -> None:
    """Delete a single cache key.

    Silently ignores Redis errors so cache invalidation never raises in
    a hot code path.
    """
    try:
        await get_redis().delete(key)
    except Exception:
        logger.warning("cache_invalidate_error key=%s", key, exc_info=True)

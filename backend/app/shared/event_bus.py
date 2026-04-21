"""In-process event bus — interface + local implementation.

M0 ships the Protocol and a simple in-memory bus. Milestone 3 wires real
producers (ReadingSessionCompleted, etc.) through this interface, and
Milestone 6 may swap in a Redis Pub/Sub backed implementation for
multi-instance deployments without touching domain code.

Domain services depend only on the EventBus Protocol (Port/Adapter
discipline — CLAUDE.md §3.2).
"""

from __future__ import annotations

import logging
from collections import defaultdict
from collections.abc import Awaitable, Callable
from typing import Protocol, TypeVar

logger = logging.getLogger(__name__)

E = TypeVar("E")
Handler = Callable[[E], Awaitable[None]]


class EventBus(Protocol):
    """Port: minimal async pub/sub surface."""

    def subscribe(self, event_type: type[E], handler: Handler[E]) -> None: ...

    async def publish(self, event: object) -> None: ...


class LocalEventBus:
    """In-memory EventBus for single-process deployments and tests.

    Dispatch is sequential per subscriber; a handler failure is logged and
    swallowed so one broken subscriber cannot take the whole publish down. If
    a caller needs guaranteed delivery across instances, swap in a Redis-
    backed implementation at bootstrap time.
    """

    def __init__(self) -> None:
        self._handlers: dict[type, list[Handler[object]]] = defaultdict(list)

    def subscribe(self, event_type: type[E], handler: Handler[E]) -> None:
        # Variance-safe insert: the list stores type-erased handlers, each
        # handler is invoked only with events of its registered type.
        self._handlers[event_type].append(handler)  # type: ignore[arg-type]

    async def publish(self, event: object) -> None:
        handlers = self._handlers.get(type(event), [])
        for handler in handlers:
            try:
                await handler(event)
            except Exception:
                logger.exception(
                    "event_handler_failed event_type=%s handler=%s",
                    type(event).__name__,
                    getattr(handler, "__qualname__", repr(handler)),
                )

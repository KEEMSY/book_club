"""In-process event bus — interface, in-memory implementation, and
session-commit helper.

Domain services depend only on the ``EventBus`` Protocol (Port/Adapter
discipline — CLAUDE.md §3.2). The concrete ``LocalEventBus`` is fine for
single-process deployments (dev, staging, first production) and can be
swapped for a Redis Pub/Sub implementation at startup without touching
domain code.

Commit-coupled delivery
-----------------------
Session-scoped events must not fire until the database transaction that
produced them is durable — otherwise a subscriber could run while the
producer is about to roll back, leaving the read model ahead of the
source of truth.

``EventQueue`` is a per-session list staged via SQLAlchemy info dict.
``commit_and_publish`` attaches a one-shot ``after_commit`` listener to
the session; on commit we drain the queue onto the bus, on rollback we
clear it. Subscribers run asynchronously via ``asyncio.create_task`` so
a slow handler does not block the response to the caller.
"""

from __future__ import annotations

import asyncio
import logging
from collections import defaultdict
from collections.abc import Awaitable, Callable
from typing import Any, Protocol, TypeVar, cast

from sqlalchemy import event as sa_event
from sqlalchemy.ext.asyncio import AsyncSession

logger = logging.getLogger(__name__)

E = TypeVar("E")
Handler = Callable[[E], Awaitable[None]]

_EVENT_QUEUE_KEY = "_reading_event_queue"
_DISPATCH_TASKS_KEY = "_reading_dispatch_tasks"


class EventBus(Protocol):
    """Port: minimal async pub/sub surface."""

    def subscribe(self, event_type: type[E], handler: Handler[E]) -> None: ...

    async def publish(self, event: object) -> None: ...


class LocalEventBus:
    """In-memory EventBus for single-process deployments and tests.

    Dispatch is sequential per subscriber; a handler failure is logged and
    swallowed so one broken subscriber cannot take the whole publish down.
    If a caller needs guaranteed delivery across instances, swap in a
    Redis-backed implementation at bootstrap time.
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


def stage_event(session: AsyncSession, event: object) -> None:
    """Attach an event to the current async session's deferred queue.

    The event is NOT delivered until ``commit_and_publish`` observes a
    successful commit on the underlying sync session. Callers should invoke
    this inside their service method and rely on the session lifecycle
    (managed by the FastAPI dependency) to flush at the end.
    """
    queue: list[object] = session.info.setdefault(_EVENT_QUEUE_KEY, [])
    queue.append(event)


def _drain_queue(session: AsyncSession) -> list[object]:
    queue = session.info.get(_EVENT_QUEUE_KEY, [])
    session.info[_EVENT_QUEUE_KEY] = []
    return list(queue)


def commit_and_publish(session: AsyncSession, bus: EventBus) -> None:
    """Register a one-shot commit / rollback listener on the given session.

    - On ``after_commit`` we drain the staged event queue onto ``bus``.
      Dispatch happens in a background task so a slow subscriber does not
      block the caller.
    - On ``after_rollback`` we clear the queue (events tied to a rolled-back
      transaction never reach the read model).

    Attaching listeners per call (``once=True``) keeps the hook scoped to
    one transaction — a subsequent request gets a fresh binding.
    """
    sync_session = session.sync_session

    # Keep a strong reference to the dispatch task on the session info dict
    # so the loop cannot garbage-collect it mid-flight. The ruff RUF006 rule
    # flags bare ``create_task`` for exactly this hazard.
    @sa_event.listens_for(sync_session, "after_commit", once=True)
    def _on_commit(_session: Any) -> None:
        events = _drain_queue(session)
        if not events:
            return
        task = asyncio.create_task(_dispatch(events, bus))
        tasks = cast(list[asyncio.Task[None]], session.info.setdefault(_DISPATCH_TASKS_KEY, []))
        tasks.append(task)
        task.add_done_callback(tasks.remove)

    @sa_event.listens_for(sync_session, "after_rollback", once=True)
    def _on_rollback(_session: Any) -> None:
        _drain_queue(session)


async def _dispatch(events: list[object], bus: EventBus) -> None:
    for event in events:
        try:
            await bus.publish(event)
        except Exception:
            logger.exception(
                "event_dispatch_failed event_type=%s",
                type(event).__name__,
            )

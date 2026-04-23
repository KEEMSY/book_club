"""Unit tests for the in-memory LocalEventBus + commit-and-publish helper."""

from __future__ import annotations

import asyncio
from dataclasses import dataclass
from typing import cast

import pytest_asyncio
from app.shared.event_bus import (
    LocalEventBus,
    commit_and_publish,
    stage_event,
)
from sqlalchemy import create_engine
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import Session


class _FakeAsyncSession:
    """Minimal stub that exposes the two attributes commit_and_publish uses:
    ``info`` (a dict for event staging) and ``sync_session`` (a real
    SQLAlchemy ``Session`` so ``after_commit``/``after_rollback`` listeners
    actually fire via ``session.dispatch``).
    """

    def __init__(self) -> None:
        self.info: dict[str, object] = {}
        # A real Session (no bind needed — we only fire dispatch events
        # manually via commit()/rollback() on this stub object).
        self._engine = create_engine("sqlite:///:memory:")
        self.sync_session: Session = Session(bind=self._engine)

    async def commit(self) -> None:
        self.sync_session.dispatch.after_commit(self.sync_session)

    async def rollback(self) -> None:
        self.sync_session.dispatch.after_rollback(self.sync_session)

    def close(self) -> None:
        self.sync_session.close()
        self._engine.dispose()


@dataclass(frozen=True)
class SampleEvent:
    user_id: str
    value: int


async def test_publish_delivers_to_subscribed_handlers() -> None:
    bus = LocalEventBus()
    received: list[SampleEvent] = []

    async def handler(event: SampleEvent) -> None:
        received.append(event)

    bus.subscribe(SampleEvent, handler)

    await bus.publish(SampleEvent(user_id="u1", value=7))

    assert received == [SampleEvent(user_id="u1", value=7)]


async def test_multiple_handlers_all_receive_event() -> None:
    bus = LocalEventBus()
    calls: list[str] = []

    async def h1(event: SampleEvent) -> None:
        calls.append(f"h1:{event.user_id}")

    async def h2(event: SampleEvent) -> None:
        calls.append(f"h2:{event.user_id}")

    bus.subscribe(SampleEvent, h1)
    bus.subscribe(SampleEvent, h2)

    await bus.publish(SampleEvent(user_id="u2", value=1))

    assert sorted(calls) == ["h1:u2", "h2:u2"]


async def test_handler_for_different_event_is_not_invoked() -> None:
    @dataclass(frozen=True)
    class OtherEvent:
        name: str

    bus = LocalEventBus()
    seen: list[object] = []

    async def handler(event: OtherEvent) -> None:
        seen.append(event)

    bus.subscribe(OtherEvent, handler)

    await bus.publish(SampleEvent(user_id="u", value=0))

    assert seen == []


async def test_handler_exception_does_not_block_other_handlers() -> None:
    bus = LocalEventBus()
    received: list[SampleEvent] = []

    async def bad_handler(event: SampleEvent) -> None:
        raise RuntimeError("boom")

    async def good_handler(event: SampleEvent) -> None:
        received.append(event)

    bus.subscribe(SampleEvent, bad_handler)
    bus.subscribe(SampleEvent, good_handler)

    await bus.publish(SampleEvent(user_id="u3", value=5))

    assert received == [SampleEvent(user_id="u3", value=5)]


# --- commit_and_publish tests use an in-memory SQLite session. -----------


@pytest_asyncio.fixture
async def fake_session() -> _FakeAsyncSession:
    s = _FakeAsyncSession()
    try:
        yield s
    finally:
        s.close()


async def test_commit_and_publish_delivers_after_commit(
    fake_session: _FakeAsyncSession,
) -> None:
    bus = LocalEventBus()
    delivered: list[SampleEvent] = []

    async def handler(event: SampleEvent) -> None:
        delivered.append(event)

    bus.subscribe(SampleEvent, handler)

    session = cast(AsyncSession, fake_session)
    stage_event(session, SampleEvent(user_id="u-c", value=1))
    commit_and_publish(session, bus)
    await fake_session.commit()

    # after_commit schedules an asyncio task — yield once so it runs.
    await asyncio.sleep(0)
    await asyncio.sleep(0)
    assert delivered == [SampleEvent(user_id="u-c", value=1)]


async def test_commit_and_publish_does_not_fire_on_rollback(
    fake_session: _FakeAsyncSession,
) -> None:
    bus = LocalEventBus()
    delivered: list[SampleEvent] = []

    async def handler(event: SampleEvent) -> None:
        delivered.append(event)

    bus.subscribe(SampleEvent, handler)

    session = cast(AsyncSession, fake_session)
    stage_event(session, SampleEvent(user_id="u-r", value=99))
    commit_and_publish(session, bus)
    await fake_session.rollback()

    await asyncio.sleep(0)
    assert delivered == []


async def test_commit_and_publish_dispatches_even_if_handler_raises(
    fake_session: _FakeAsyncSession,
) -> None:
    # Confirm the dispatch task absorbs handler exceptions (same contract as
    # LocalEventBus.publish). A broken subscriber must not escalate to the
    # FastAPI response pipeline — our session hook is fire-and-forget.
    bus = LocalEventBus()
    delivered: list[SampleEvent] = []

    async def bad(event: SampleEvent) -> None:
        raise RuntimeError("subscriber boom")

    async def good(event: SampleEvent) -> None:
        delivered.append(event)

    bus.subscribe(SampleEvent, bad)
    bus.subscribe(SampleEvent, good)

    session = cast(AsyncSession, fake_session)
    stage_event(session, SampleEvent(user_id="u-e", value=2))
    commit_and_publish(session, bus)
    await fake_session.commit()
    await asyncio.sleep(0)
    await asyncio.sleep(0)

    # Good subscriber still delivered despite sibling raising.
    assert delivered == [SampleEvent(user_id="u-e", value=2)]

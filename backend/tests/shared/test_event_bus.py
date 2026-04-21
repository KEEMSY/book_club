"""Unit tests for the in-memory LocalEventBus."""

from __future__ import annotations

from dataclasses import dataclass

from app.shared.event_bus import LocalEventBus


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

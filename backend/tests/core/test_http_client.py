"""Unit tests for the shared AsyncHttpClient (timeout + retry behavior)."""

from __future__ import annotations

import httpx
import pytest
from app.core.exceptions import ExternalServiceError
from app.core.http.base_client import AsyncHttpClient


async def test_retries_on_5xx_then_succeeds() -> None:
    call_count = {"n": 0}

    def handler(request: httpx.Request) -> httpx.Response:
        call_count["n"] += 1
        if call_count["n"] < 3:
            return httpx.Response(503, json={"error": "busy"})
        return httpx.Response(200, json={"ok": True})

    transport = httpx.MockTransport(handler)

    async with AsyncHttpClient(
        base_url="https://api.example.com",
        timeout=1.0,
        max_retries=3,
        transport=transport,
    ) as client:
        response = await client.get("/ping")

    assert response.status_code == 200
    assert response.json() == {"ok": True}
    assert call_count["n"] == 3


async def test_gives_up_after_max_retries() -> None:
    call_count = {"n": 0}

    def handler(request: httpx.Request) -> httpx.Response:
        call_count["n"] += 1
        return httpx.Response(500)

    transport = httpx.MockTransport(handler)

    async with AsyncHttpClient(
        base_url="https://api.example.com",
        timeout=1.0,
        max_retries=2,
        transport=transport,
    ) as client:
        with pytest.raises(ExternalServiceError):
            await client.get("/ping")

    # Initial attempt + 2 retries = 3 total calls.
    assert call_count["n"] == 3


async def test_does_not_retry_4xx() -> None:
    call_count = {"n": 0}

    def handler(request: httpx.Request) -> httpx.Response:
        call_count["n"] += 1
        return httpx.Response(404, json={"error": "not found"})

    transport = httpx.MockTransport(handler)

    async with AsyncHttpClient(
        base_url="https://api.example.com",
        timeout=1.0,
        max_retries=3,
        transport=transport,
    ) as client:
        response = await client.get("/missing")

    assert response.status_code == 404
    assert call_count["n"] == 1

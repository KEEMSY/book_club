"""Health endpoint smoke test — the first TDD check for M0."""

from __future__ import annotations

from app import __version__ as app_version
from httpx import AsyncClient


async def test_health_returns_ok_status(async_client: AsyncClient) -> None:
    response = await async_client.get("/health")

    assert response.status_code == 200
    body = response.json()
    assert body["status"] == "ok"
    assert body["version"] == app_version

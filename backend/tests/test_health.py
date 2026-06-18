"""Health endpoint smoke tests — liveness (M0) and readiness (M59)."""

from __future__ import annotations

from collections.abc import AsyncIterator

import pytest
from app import __version__ as app_version
from app.core.db import get_session
from app.main import create_app
from httpx import ASGITransport, AsyncClient


async def test_health_returns_ok_status(async_client: AsyncClient) -> None:
    response = await async_client.get("/health")

    assert response.status_code == 200
    body = response.json()
    assert body["status"] == "ok"
    assert body["version"] == app_version


class _FakeSession:
    """Stand-in AsyncSession whose execute() either succeeds or raises."""

    def __init__(self, *, fail: bool) -> None:
        self._fail = fail

    async def execute(self, _statement: object) -> None:
        if self._fail:
            raise RuntimeError("connection refused")


async def _client_with_session(fail: bool) -> AsyncIterator[AsyncClient]:
    app = create_app()

    async def _override() -> AsyncIterator[_FakeSession]:
        yield _FakeSession(fail=fail)

    app.dependency_overrides[get_session] = _override
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://testserver") as client:
        yield client


async def test_readiness_ok_when_db_reachable() -> None:
    async for client in _client_with_session(fail=False):
        response = await client.get("/health/ready")

        assert response.status_code == 200
        body = response.json()
        assert body == {"status": "ok", "db": "ok", "version": app_version}


async def test_readiness_503_when_db_unreachable() -> None:
    async for client in _client_with_session(fail=True):
        response = await client.get("/health/ready")

        assert response.status_code == 503
        body = response.json()
        assert body["status"] == "degraded"
        assert body["db"] == "error"


@pytest.fixture(autouse=True)
def _suppress_readiness_log(caplog: pytest.LogCaptureFixture) -> None:
    """Keep the intentional readiness-failure traceback out of test output."""
    caplog.set_level("CRITICAL", logger="app.api.health")

"""Shared pytest fixtures for the Book Club backend test suite."""

from __future__ import annotations

from collections.abc import AsyncIterator

import pytest
from app.main import create_app
from httpx import ASGITransport, AsyncClient


@pytest.fixture
async def async_client() -> AsyncIterator[AsyncClient]:
    """Provide an httpx AsyncClient bound to the FastAPI ASGI app."""
    app = create_app()
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://testserver") as client:
        yield client

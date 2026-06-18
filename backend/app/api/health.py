"""Health probes used by container orchestrators and smoke tests.

Two endpoints with distinct contracts:

* ``/health`` — **liveness**. Cheap, dependency-free; answers "is the process
  up?". Safe to point a restart-on-failure probe at without a transient DB blip
  cycling every machine.
* ``/health/ready`` — **readiness**. Runs ``SELECT 1`` so it answers "can this
  instance actually serve traffic?". Returns 503 when the DB is unreachable so
  Fly stops routing to a machine that would only return errors.
"""

from __future__ import annotations

import logging
from typing import Annotated

from fastapi import APIRouter, Depends, Response, status
from pydantic import BaseModel
from sqlalchemy import text
from sqlalchemy.ext.asyncio import AsyncSession

from app import __version__
from app.core.db import get_session

logger = logging.getLogger(__name__)

router = APIRouter(tags=["health"])


class HealthResponse(BaseModel):
    status: str
    version: str


class ReadinessResponse(BaseModel):
    status: str
    db: str
    version: str


@router.get("/health", response_model=HealthResponse)
async def health() -> HealthResponse:
    """Liveness probe — no external dependencies, always cheap."""
    return HealthResponse(status="ok", version=__version__)


@router.get("/health/ready", response_model=ReadinessResponse)
async def readiness(
    response: Response,
    session: Annotated[AsyncSession, Depends(get_session)],
) -> ReadinessResponse:
    """Readiness probe — verifies the DB is reachable via ``SELECT 1``."""
    try:
        await session.execute(text("SELECT 1"))
    except Exception:
        # Logged (not swallowed) so a failing readiness check is diagnosable in
        # Sentry / Fly logs rather than only visible as a 503 to the prober.
        logger.exception("Readiness DB check failed")
        response.status_code = status.HTTP_503_SERVICE_UNAVAILABLE
        return ReadinessResponse(status="degraded", db="error", version=__version__)
    return ReadinessResponse(status="ok", db="ok", version=__version__)

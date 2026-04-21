"""Domain-level exception hierarchy and FastAPI exception handlers.

Service-layer code raises these semantic exceptions; the router layer never
catches them — the registered handlers below translate each class to the
appropriate HTTP status code and response body. This keeps Service free of
HTTP concerns (CLAUDE.md §3.1).
"""

from __future__ import annotations

import logging

from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse

logger = logging.getLogger(__name__)


class DomainError(Exception):
    """Base class for all domain-level errors."""

    status_code: int = 500
    code: str = "DOMAIN_ERROR"

    def __init__(self, message: str, *, code: str | None = None) -> None:
        super().__init__(message)
        self.message = message
        if code is not None:
            self.code = code


class NotFoundError(DomainError):
    """Requested entity does not exist."""

    status_code = 404
    code = "NOT_FOUND"


class ConflictError(DomainError):
    """State conflict — e.g. duplicate, concurrent session, unique violation."""

    status_code = 409
    code = "CONFLICT"


class AuthError(DomainError):
    """Authentication or authorization failure."""

    status_code = 401
    code = "UNAUTHORIZED"


class ExternalServiceError(DomainError):
    """An external adapter call failed after retries (non-retryable or exhausted)."""

    status_code = 502
    code = "EXTERNAL_SERVICE_ERROR"


def _error_response(exc: DomainError) -> JSONResponse:
    return JSONResponse(
        status_code=exc.status_code,
        content={"error": {"code": exc.code, "message": exc.message}},
    )


def register_exception_handlers(app: FastAPI) -> None:
    """Register domain → HTTP exception handlers on the FastAPI app."""

    @app.exception_handler(DomainError)
    async def _handle_domain_error(request: Request, exc: DomainError) -> JSONResponse:
        # Log at warning for client-class (4xx), error for server-class (5xx).
        log = logger.warning if exc.status_code < 500 else logger.error
        log(
            "domain_error path=%s code=%s status=%s",
            request.url.path,
            exc.code,
            exc.status_code,
        )
        return _error_response(exc)

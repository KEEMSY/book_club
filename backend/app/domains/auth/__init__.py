"""Auth domain — social login (Kakao/Apple), JWT sessions, device tokens.

Public surface (stable across domain boundaries):
- ``router`` — FastAPI router mounted under ``/auth`` + ``/me``.
- ``schemas`` — Pydantic DTOs that the router accepts / returns.
- ``providers`` — FastAPI ``Depends`` factories for the service and
  repositories, so other modules can build test overrides cleanly.

Models, repository, adapters, and service live as internals and must not be
imported across domain boundaries (CLAUDE.md §3.3).
"""

from app.domains.auth.models import AuthProvider, DevicePlatform

__all__ = ["AuthProvider", "DevicePlatform"]

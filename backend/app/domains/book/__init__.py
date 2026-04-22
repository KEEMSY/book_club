"""Book domain — global catalog, user library (UserBook), external search.

Public surface (stable across domain boundaries):
- ``router`` — FastAPI router mounted under ``/books`` + ``/me/library``.
- ``schemas`` — Pydantic DTOs that the router accepts / returns.
- ``providers`` — FastAPI ``Depends`` factories for the service and
  repositories, so other modules can build test overrides cleanly.

Models, repository, adapters, and service live as internals and must not be
imported across domain boundaries (CLAUDE.md §3.3).
"""

from app.domains.book.models import BookSource, UserBookStatus

__all__ = ["BookSource", "UserBookStatus"]

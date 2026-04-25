"""Feed domain — per-book posts, reactions, comments + R2 image upload.

Public surface (stable across domain boundaries):
- ``router`` — FastAPI router mounted under ``/books/{id}/posts`` +
  ``/posts/{id}/...`` + ``/comments/{id}`` + ``/uploads/presign-image``.
- ``schemas`` — Pydantic DTOs that the router accepts / returns.
- ``providers`` — FastAPI ``Depends`` factories for the service so other
  modules can build test overrides cleanly.

Models, repository, adapters, and service live as internals and must not
be imported across domain boundaries (CLAUDE.md §3.3).
"""

from app.domains.feed.models import PostType, ReactionType

__all__ = ["PostType", "ReactionType"]

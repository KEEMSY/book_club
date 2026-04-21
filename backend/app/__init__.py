"""Book Club backend package."""

from __future__ import annotations

from importlib.metadata import PackageNotFoundError, version

try:
    __version__: str = version("book-club-backend")
except PackageNotFoundError:  # pragma: no cover - editable install fallback
    __version__ = "0.0.0"

__all__ = ["__version__"]

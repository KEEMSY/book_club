"""Domain events produced by the book domain."""

from __future__ import annotations

from dataclasses import dataclass
from uuid import UUID


@dataclass(frozen=True, slots=True)
class UserBookCompleted:
    """Fired when a UserBook transitions to COMPLETED status.

    Produced by ``update_status(COMPLETED)``. Challenge handlers subscribe to
    this event to update ``books_count``-type challenge progress.
    """

    user_id: UUID
    user_book_id: UUID
    book_id: UUID

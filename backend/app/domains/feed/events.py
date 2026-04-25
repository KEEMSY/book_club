"""Domain events emitted by the feed service.

Plain frozen dataclasses — no pydantic, no SQLAlchemy, no transport concerns.
Subscribers match on event *type*, keeping each event as its own class so
adding a new event type does not require subscriber rewrites.
"""

from __future__ import annotations

from dataclasses import dataclass
from uuid import UUID


@dataclass(frozen=True, slots=True)
class PostCreated:
    """A new post was published in a book group feed."""

    post_id: UUID
    book_id: UUID
    author_id: UUID


@dataclass(frozen=True, slots=True)
class ReactionAdded:
    """A reaction was added to a post.

    ``reactor_id`` is the user who reacted; ``post_author_id`` is the recipient
    of the notification. The service skips self-reactions before publishing.
    """

    post_id: UUID
    reactor_id: UUID
    post_author_id: UUID
    reaction_type: str


@dataclass(frozen=True, slots=True)
class CommentAdded:
    """A comment (or reply) was added to a post.

    ``parent_author_id`` is None for top-level comments; set for replies so
    the notification service can fan-out to both post author and parent commenter.
    """

    comment_id: UUID
    post_id: UUID
    commenter_id: UUID
    post_author_id: UUID
    parent_author_id: UUID | None

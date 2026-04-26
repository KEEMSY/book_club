"""Domain events emitted by the social service.

Plain frozen dataclasses — no pydantic, no SQLAlchemy, no transport concerns.
Subscribers match on event *type* so adding a new event type does not require
subscriber rewrites (same pattern as feed/events.py).
"""

from __future__ import annotations

from dataclasses import dataclass
from uuid import UUID


@dataclass(frozen=True, slots=True)
class FollowReceived:
    """A user was followed by another user.

    ``follower_id`` is the actor; ``followee_id`` is the recipient of the
    notification. The notification service subscribes to this event to
    create an in-app notification and optional push for the followee.
    """

    follower_id: UUID
    followee_id: UUID

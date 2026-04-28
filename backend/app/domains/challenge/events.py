"""Domain events produced by the challenge domain."""

from __future__ import annotations

from dataclasses import dataclass
from uuid import UUID


@dataclass(frozen=True, slots=True)
class BadgeEarned:
    """Fired after a UserBadge row is committed for the first time."""

    user_id: UUID
    badge_id: UUID
    badge_name: str

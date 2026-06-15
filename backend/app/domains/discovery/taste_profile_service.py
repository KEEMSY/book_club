"""TasteProfileService — recompute and cache user taste vectors.

Thin orchestration layer: delegates all DB work to the two repositories.
Called from the reading domain as a fire-and-forget after book completion.
"""

from __future__ import annotations

import logging
from dataclasses import dataclass
from uuid import UUID

from app.domains.book.models import UserTasteProfile
from app.domains.book.taste_profile_repository import TasteProfileRepository

logger = logging.getLogger(__name__)


@dataclass(slots=True)
class TasteProfileService:
    """Recomputes a user's genre/author taste vector on demand."""

    taste_profiles: TasteProfileRepository

    async def recompute(self, user_id: UUID) -> UserTasteProfile:
        """Rebuild the taste vector for *user_id* from their completed books.

        Delegates the DB aggregation to the repository so the service stays
        thin and testable.
        """
        profile = await self.taste_profiles.compute_and_upsert(user_id)
        logger.info("taste_profile_recomputed user_id=%s", user_id)
        return profile

    async def get_or_none(self, user_id: UUID) -> UserTasteProfile | None:
        return await self.taste_profiles.get(user_id)

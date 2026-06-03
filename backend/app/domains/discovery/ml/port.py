"""Port definition for ML-based book recommendations.

Domain services depend only on this Protocol — never on the concrete
CollaborativeFilteringRecommender (CLAUDE.md §3.2).
"""

from __future__ import annotations

from typing import TYPE_CHECKING, Protocol
from uuid import UUID

if TYPE_CHECKING:
    from sqlalchemy.ext.asyncio import AsyncSession

    from app.domains.discovery.service import RecommendedBookItem


class MLRecommendationPort(Protocol):
    """Abstraction over an ML recommendation engine.

    The ``retrain`` method is called by the scheduler; ``recommend`` is
    called per-request by DiscoveryService.
    """

    async def retrain(self, conn: AsyncSession) -> None:
        """Rebuild the CF model from the live database and push to cache.

        ``conn`` is an active :class:`~sqlalchemy.ext.asyncio.AsyncSession`.
        """
        ...

    async def recommend(
        self,
        user_id: UUID,
        limit: int = 10,
    ) -> list[RecommendedBookItem]:
        """Return up to *limit* personalised book recommendations.

        Returns an empty list when a cold-start is detected or the model
        cache has expired; the service layer handles the fallback.
        """
        ...

from __future__ import annotations

from dataclasses import dataclass
from typing import TYPE_CHECKING, TypedDict
from uuid import UUID

from app.domains.discovery.repository import DiscoveryRepository

if TYPE_CHECKING:
    from app.domains.discovery.ml.port import MLRecommendationPort


class RecommendedBookItem(TypedDict):
    id: str  # str UUID — Pydantic coerces to UUID in RecommendedBookPublic
    title: str
    author: str
    cover_url: str | None
    reason: str  # "community_popular" | "similar_readers" | "recently_added"


@dataclass(slots=True)
class DiscoveryService:
    repo: DiscoveryRepository
    ml: MLRecommendationPort | None = None

    async def get_ml_recommendations(self, user_id: UUID) -> list[RecommendedBookItem]:
        """Return ML-powered item-CF recommendations, falling back to rule-based.

        Falls back when:
        - No ML engine is wired (ml is None).
        - The engine signals a cold-start by returning an empty list.
        """
        if self.ml is not None:
            ml_results = await self.ml.recommend(user_id)
            if ml_results:
                return ml_results
        # Cold-start or unconfigured engine — delegate to rule-based path.
        return await self.get_recommendations(user_id)

    async def get_recommendations(self, user_id: UUID) -> list[RecommendedBookItem]:
        popular = await self.repo.community_popular(user_id=user_id)
        similar = await self.repo.similar_readers(user_id=user_id)
        recent = await self.repo.recently_added(user_id=user_id)
        seen: set[UUID] = set()
        result: list[RecommendedBookItem] = []
        for book_id, title, author, cover_url in popular:
            if book_id not in seen:
                seen.add(book_id)
                result.append(
                    RecommendedBookItem(
                        id=str(book_id),
                        title=title,
                        author=author,
                        cover_url=cover_url,
                        reason="community_popular",
                    )
                )
        for book_id, title, author, cover_url in similar:
            if book_id not in seen:
                seen.add(book_id)
                result.append(
                    RecommendedBookItem(
                        id=str(book_id),
                        title=title,
                        author=author,
                        cover_url=cover_url,
                        reason="similar_readers",
                    )
                )
        for book_id, title, author, cover_url in recent:
            if book_id not in seen:
                seen.add(book_id)
                result.append(
                    RecommendedBookItem(
                        id=str(book_id),
                        title=title,
                        author=author,
                        cover_url=cover_url,
                        reason="recently_added",
                    )
                )
        return result[:15]

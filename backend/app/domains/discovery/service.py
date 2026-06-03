from __future__ import annotations

from dataclasses import dataclass
from typing import TypedDict
from uuid import UUID

from app.domains.discovery.repository import DiscoveryRepository


class RecommendedBookItem(TypedDict):
    id: str  # str UUID — Pydantic coerces to UUID in RecommendedBookPublic
    title: str
    author: str
    cover_url: str | None
    reason: str  # "community_popular" | "similar_readers" | "recently_added"


@dataclass(slots=True)
class DiscoveryService:
    repo: DiscoveryRepository

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

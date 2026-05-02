from __future__ import annotations

import asyncio
from dataclasses import dataclass
from uuid import UUID

from app.domains.discovery.repository import DiscoveryRepository


@dataclass(slots=True)
class DiscoveryService:
    repo: DiscoveryRepository

    async def get_recommendations(self, user_id: UUID) -> list[dict]:  # type: ignore[type-arg]
        popular, similar, recent = await asyncio.gather(
            self.repo.community_popular(user_id=user_id),
            self.repo.similar_readers(user_id=user_id),
            self.repo.recently_added(user_id=user_id),
        )
        seen: set[UUID] = set()
        result: list[dict] = []  # type: ignore[type-arg]
        for book_id, title, author, cover_url in popular:
            if book_id not in seen:
                seen.add(book_id)
                result.append(
                    dict(
                        id=book_id,
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
                    dict(
                        id=book_id,
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
                    dict(
                        id=book_id,
                        title=title,
                        author=author,
                        cover_url=cover_url,
                        reason="recently_added",
                    )
                )
        return result[:15]

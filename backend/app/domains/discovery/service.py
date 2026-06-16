"""DiscoveryService — rule-based and ML-powered book recommendations.

Supports four strategies (M44):
- ``collaborative``   — existing item-CF engine (M21)
- ``similar_readers`` — cosine-similarity on taste vectors, then books read by
                        the top-5 nearest neighbours
- ``taste_match``     — direct genre-vector matching against the book catalog
- ``cold_start``      — onboarding-interest based (used automatically when the
                        user has fewer than _COLD_START_THRESHOLD completed books
                        or when the taste profile is absent)

Strategy selection is explicit (caller passes ?strategy=) but the service
auto-downgrades to cold_start when the preconditions for the requested
strategy are not met (no profile, insufficient history).
"""

from __future__ import annotations

import logging
from dataclasses import dataclass
from typing import TYPE_CHECKING, TypedDict
from uuid import UUID

from app.core.cache import cache_response
from app.domains.discovery.repository import DiscoveryRepository
from app.domains.discovery.strategies import RecommendationStrategy, cosine_similarity

if TYPE_CHECKING:
    from app.domains.discovery.ml.port import MLRecommendationPort

logger = logging.getLogger(__name__)

# Users with fewer completed books fall through to cold_start.
_COLD_START_THRESHOLD = 3
# Number of taste-similar neighbours used by similar_readers strategy.
_SIMILAR_READERS_TOP_N = 5


class RecommendedBookItem(TypedDict):
    id: str  # str UUID — Pydantic coerces to UUID in RecommendedBookPublic
    title: str
    author: str
    cover_url: str | None
    reason: str
    strategy: str


@dataclass(slots=True)
class DiscoveryService:
    repo: DiscoveryRepository
    ml: MLRecommendationPort | None = None

    # ------------------------------------------------------------------
    # Public interface
    # ------------------------------------------------------------------

    async def get_ml_recommendations(self, user_id: UUID) -> list[RecommendedBookItem]:
        """Return ML-powered item-CF recommendations, falling back to rule-based.

        Falls back when:
        - No ML engine is wired (ml is None).
        - The engine signals a cold-start by returning an empty list.
        """
        if self.ml is not None:
            ml_results = await self.ml.recommend(user_id)
            if ml_results:
                return [
                    RecommendedBookItem(
                        id=item["id"],
                        title=item["title"],
                        author=item["author"],
                        cover_url=item["cover_url"],
                        reason=item["reason"],
                        strategy=RecommendationStrategy.COLLABORATIVE,
                    )
                    for item in ml_results
                ]
        return await self.get_recommendations(user_id)

    @cache_response(key_pattern="recommendations:{user_id}", ttl=3600)
    async def get_recommendations(
        self,
        user_id: UUID,
        strategy: RecommendationStrategy = RecommendationStrategy.COLLABORATIVE,
        limit: int = 10,
    ) -> list[RecommendedBookItem]:
        """Dispatch to the requested strategy, auto-downgrading to cold_start
        when the user's reading history is insufficient.
        """
        completed = await self.repo.count_completed_books(user_id)
        if completed < _COLD_START_THRESHOLD and strategy not in (
            RecommendationStrategy.COLD_START,
            RecommendationStrategy.COLLABORATIVE,
        ):
            logger.debug(
                "recommendation_cold_start_downgrade user_id=%s completed=%d",
                user_id,
                completed,
            )
            strategy = RecommendationStrategy.COLD_START

        if strategy == RecommendationStrategy.SIMILAR_READERS:
            return await self._similar_readers(user_id, limit=limit)
        if strategy == RecommendationStrategy.TASTE_MATCH:
            return await self._taste_match(user_id, limit=limit)
        if strategy == RecommendationStrategy.COLD_START:
            return await self._cold_start(user_id, limit=limit)

        # Default: collaborative (rule-based mix, ML engine already tried
        # by the caller via get_ml_recommendations if desired)
        return await self._rule_based(user_id, limit=limit)

    # ------------------------------------------------------------------
    # Strategy implementations
    # ------------------------------------------------------------------

    async def _rule_based(self, user_id: UUID, *, limit: int) -> list[RecommendedBookItem]:
        """Original community_popular + similar_readers + recently_added mix."""
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
                        reason="커뮤니티에서 인기 있는 책",
                        strategy=RecommendationStrategy.COLLABORATIVE,
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
                        reason="비슷한 취향의 독자가 읽은 책",
                        strategy=RecommendationStrategy.COLLABORATIVE,
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
                        reason="최근 많이 추가된 책",
                        strategy=RecommendationStrategy.COLLABORATIVE,
                    )
                )
        return result[:limit]

    async def _similar_readers(
        self, user_id: UUID, *, limit: int
    ) -> list[RecommendedBookItem]:
        """Find the top-N taste-similar users and return books they completed.

        Similarity is computed in Python using cosine similarity on the
        genre_vector dicts — no vector DB needed at this scale.
        """
        my_profile = await self.repo.taste_profiles.get(user_id)
        if my_profile is None:
            # No profile → cold start
            return await self._cold_start(user_id, limit=limit)

        all_profiles = await self.repo.taste_profiles.list_all()
        scored: list[tuple[float, UUID]] = []
        for profile in all_profiles:
            if profile.user_id == user_id:
                continue
            sim = cosine_similarity(my_profile.genre_vector, profile.genre_vector)
            if sim > 0.0:
                scored.append((sim, profile.user_id))

        scored.sort(key=lambda x: x[0], reverse=True)
        top_users = [uid for _, uid in scored[:_SIMILAR_READERS_TOP_N]]

        books = await self.repo.books_read_by_users(
            top_users, exclude_user_id=user_id, limit=limit
        )
        return [
            RecommendedBookItem(
                id=str(book_id),
                title=title,
                author=author,
                cover_url=cover_url,
                reason="비슷한 독서 패턴의 사용자가 읽은 책",
                strategy=RecommendationStrategy.SIMILAR_READERS,
            )
            for book_id, title, author, cover_url, _cnt in books
        ]

    async def _taste_match(self, user_id: UUID, *, limit: int) -> list[RecommendedBookItem]:
        """Return books whose genre (publisher proxy) matches the user's top genres."""
        my_profile = await self.repo.taste_profiles.get(user_id)
        if my_profile is None:
            return await self._cold_start(user_id, limit=limit)

        # Sort genres by frequency descending; take top 3 as search keywords.
        top_genres = sorted(
            my_profile.genre_vector.items(), key=lambda kv: kv[1], reverse=True
        )[:3]
        genre_keywords = [g for g, _ in top_genres]

        books = await self.repo.books_by_genre_match(
            user_id=user_id, genre_keywords=genre_keywords, limit=limit
        )
        return [
            RecommendedBookItem(
                id=str(book_id),
                title=title,
                author=author,
                cover_url=cover_url,
                reason=f"당신의 취향 장르 '{matched_genre}' 기반 추천",
                strategy=RecommendationStrategy.TASTE_MATCH,
            )
            for book_id, title, author, cover_url, matched_genre in books
        ]

    async def _cold_start(self, user_id: UUID, *, limit: int) -> list[RecommendedBookItem]:
        """Recommend based on onboarding interests when no reading history exists."""
        interests = await self.repo.onboarding_interests.list_for_user(user_id)

        genre_interests = [i.value for i in interests if i.category == "genre"]
        if genre_interests:
            books = await self.repo.books_by_genre_match(
                user_id=user_id, genre_keywords=genre_interests, limit=limit
            )
            if books:
                return [
                    RecommendedBookItem(
                        id=str(book_id),
                        title=title,
                        author=author,
                        cover_url=cover_url,
                        reason=f"관심 장르 '{matched_genre}' 기반 추천",
                        strategy=RecommendationStrategy.COLD_START,
                    )
                    for book_id, title, author, cover_url, matched_genre in books
                ]

        # No onboarding interests set — fall back to globally popular books.
        popular = await self.repo.community_popular(user_id=user_id, limit=limit)
        return [
            RecommendedBookItem(
                id=str(book_id),
                title=title,
                author=author,
                cover_url=cover_url,
                reason="지금 가장 많이 읽히는 책",
                strategy=RecommendationStrategy.COLD_START,
            )
            for book_id, title, author, cover_url in popular
        ]

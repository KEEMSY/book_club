"""Deterministic stub :class:`AIBookRecommenderPort` for key-less envs.

Selected by ``providers.py`` whenever ``ANTHROPIC_API_KEY`` is unset, so local
development and the test suite run the ai_picks channel end-to-end without a real
Claude call. Suggestions reference the input history so output is obviously a
stub. The titles are generic on purpose — the repository will simply find no
catalog match for them in tests, which exercises the empty-match path too.
"""

from __future__ import annotations

from app.domains.discovery.ai_port import AIBookSuggestion, CompletedBook


class StubBookRecommenderAdapter:
    """Returns three canned suggestions derived from the reading history."""

    async def recommend_books(
        self, *, completed_books: list[CompletedBook]
    ) -> list[AIBookSuggestion]:
        seed = completed_books[0].author if completed_books else "여러 저자"
        return [
            AIBookSuggestion(
                title=f"추천 도서 {i}",
                author=seed,
                reason=f"최근 독서 이력과 결이 비슷한 책입니다 (샘플 {i}).",
            )
            for i in range(1, 4)
        ]

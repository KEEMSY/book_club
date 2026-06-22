"""Unit tests for SearchService.autocomplete (M69).

The trigram ranking itself is exercised by repository integration tests against
a real Postgres; here we verify the service contract: it forwards the query and
limit to the repository and wraps the suggestions in the response envelope.
"""

from __future__ import annotations

import pytest
from app.domains.search.service import SearchService


class FakeAutocompleteRepository:
    def __init__(self, suggestions: list[str]) -> None:
        self._suggestions = suggestions
        self.calls: list[tuple[str, int]] = []

    async def autocomplete(self, query: str, limit: int = 10) -> list[str]:
        self.calls.append((query, limit))
        return self._suggestions[:limit]


@pytest.mark.asyncio
async def test_autocomplete_wraps_suggestions() -> None:
    repo = FakeAutocompleteRepository(["미움받을 용기", "미드나잇 라이브러리"])
    svc = SearchService(repo=repo)  # type: ignore[arg-type]

    result = await svc.autocomplete("미", limit=5)

    assert result.suggestions == ["미움받을 용기", "미드나잇 라이브러리"]
    assert repo.calls == [("미", 5)]


@pytest.mark.asyncio
async def test_autocomplete_respects_limit() -> None:
    repo = FakeAutocompleteRepository(["a", "b", "c"])
    svc = SearchService(repo=repo)  # type: ignore[arg-type]

    result = await svc.autocomplete("x", limit=2)

    assert result.suggestions == ["a", "b"]
    assert repo.calls == [("x", 2)]

"""Search service — fans out to all three entity searches in parallel."""

from __future__ import annotations

import asyncio
from dataclasses import dataclass

from app.domains.search.repository import SearchRepository
from app.domains.search.schemas import AutocompleteResult, SearchResult


@dataclass(slots=True)
class SearchService:
    repo: SearchRepository

    async def search(
        self,
        query: str,
        *,
        include_books: bool = True,
        include_users: bool = True,
        include_clubs: bool = True,
        limit: int = 10,
    ) -> SearchResult:
        """Run enabled entity searches concurrently and aggregate results."""
        book_task = (
            asyncio.ensure_future(self.repo.search_books(query, limit=limit))
            if include_books
            else asyncio.ensure_future(_empty_list())
        )
        user_task = (
            asyncio.ensure_future(self.repo.search_users(query, limit=limit))
            if include_users
            else asyncio.ensure_future(_empty_list())
        )
        club_task = (
            asyncio.ensure_future(self.repo.search_clubs(query, limit=limit))
            if include_clubs
            else asyncio.ensure_future(_empty_list())
        )

        books, users, clubs = await asyncio.gather(book_task, user_task, club_task)
        return SearchResult(books=books, users=users, clubs=clubs)

    async def autocomplete(self, query: str, *, limit: int = 10) -> AutocompleteResult:
        """Return up to ``limit`` book title/author suggestions for the query."""
        suggestions = await self.repo.autocomplete(query, limit=limit)
        return AutocompleteResult(suggestions=suggestions)


async def _empty_list() -> list:  # type: ignore[type-arg]
    return []

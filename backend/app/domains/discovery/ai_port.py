"""Port for the AI-picks recommendation channel (M69).

``ai_picks`` is the one discovery channel backed by a real external collaborator
(the Claude API), so per CLAUDE.md §3.2 it sits behind a Port with two live
implementations: ``ClaudeBookRecommenderAdapter`` and a deterministic stub. The
service depends only on this Protocol, so it unit-tests against an in-memory fake
with no network.

The adapter is given the reader's recently completed books and returns free-text
title/author/reason suggestions. Matching those titles back to catalog rows is
the repository's job, not the adapter's — the adapter never touches the DB.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Protocol


@dataclass(frozen=True, slots=True)
class CompletedBook:
    """A book the reader finished — the only signal the prompt needs."""

    title: str
    author: str


@dataclass(frozen=True, slots=True)
class AIBookSuggestion:
    """One Claude-generated suggestion before catalog resolution."""

    title: str
    author: str
    reason: str


class AIBookRecommenderPort(Protocol):
    """The external generative boundary for ``ai_picks`` — Claude or a stub."""

    async def recommend_books(
        self, *, completed_books: list[CompletedBook]
    ) -> list[AIBookSuggestion]: ...

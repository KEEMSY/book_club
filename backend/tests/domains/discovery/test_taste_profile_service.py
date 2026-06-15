"""Unit tests for TasteProfileService.

All tests use a FakeTasteProfileRepository — no DB required (CLAUDE.md §5).
"""

from __future__ import annotations

from dataclasses import dataclass, field
from uuid import UUID, uuid4

import pytest

from app.domains.discovery.taste_profile_service import TasteProfileService


# ---------------------------------------------------------------------------
# Minimal stub mirroring UserTasteProfile model fields
# ---------------------------------------------------------------------------


@dataclass
class _FakeProfile:
    """Lightweight stand-in for app.domains.book.models.UserTasteProfile."""

    user_id: UUID
    genre_vector: dict[str, int]
    author_vector: dict[str, int]


# ---------------------------------------------------------------------------
# Fake repository
# ---------------------------------------------------------------------------


class FakeTasteProfileRepository:
    """In-memory TasteProfileRepository for unit tests.

    ``compute_and_upsert`` re-derives vectors from ``_completed_books``.
    Each entry in ``_completed_books`` is a (author, publisher) tuple that
    mirrors what the real query returns.
    """

    def __init__(
        self,
        completed_books: list[tuple[str | None, str | None]] | None = None,
        existing_profile: _FakeProfile | None = None,
    ) -> None:
        # (author, publisher) rows — simulates the JOIN result in compute_and_upsert
        self._completed_books: list[tuple[str | None, str | None]] = completed_books or []
        self._stored: _FakeProfile | None = existing_profile

    async def get(self, user_id: UUID) -> _FakeProfile | None:
        if self._stored and self._stored.user_id == user_id:
            return self._stored
        return None

    async def compute_and_upsert(self, user_id: UUID) -> _FakeProfile:
        """Re-implement the vector computation logic without hitting the DB."""
        import re

        genre_vector: dict[str, int] = {}
        author_vector: dict[str, int] = {}

        for author, publisher in self._completed_books:
            if author:
                for token in [t.strip() for t in re.split(r"[,|]", author) if t.strip()]:
                    author_vector[token] = author_vector.get(token, 0) + 1
            if publisher:
                pub = publisher.strip()
                if pub and len(pub) <= 12:
                    genre_vector[pub] = genre_vector.get(pub, 0) + 1

        profile = _FakeProfile(
            user_id=user_id,
            genre_vector=genre_vector,
            author_vector=author_vector,
        )
        self._stored = profile
        return profile

    async def list_all(self) -> list[_FakeProfile]:
        return [self._stored] if self._stored else []


# ---------------------------------------------------------------------------
# Helper
# ---------------------------------------------------------------------------


def _svc(
    completed_books: list[tuple[str | None, str | None]] | None = None,
    existing_profile: _FakeProfile | None = None,
) -> TasteProfileService:
    repo = FakeTasteProfileRepository(
        completed_books=completed_books,
        existing_profile=existing_profile,
    )
    return TasteProfileService(taste_profiles=repo)  # type: ignore[arg-type]


# ---------------------------------------------------------------------------
# Tests
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_recompute_no_completed_books() -> None:
    """User with no completed books gets an empty taste profile stored."""
    user_id = uuid4()
    svc = _svc(completed_books=[])

    profile = await svc.recompute(user_id)

    assert profile.user_id == user_id
    assert profile.genre_vector == {}
    assert profile.author_vector == {}


@pytest.mark.asyncio
async def test_recompute_counts_genres_and_authors() -> None:
    """Genre and author frequency vectors are built correctly from completed books.

    Three completed books:
    - (한강, 소설)  — genre "소설" ×1, author "한강" ×1
    - (한강, 소설)  — genre "소설" ×2, author "한강" ×2
    - (김영하, 에세이) — genre "에세이" ×1, author "김영하" ×1
    """
    user_id = uuid4()
    svc = _svc(
        completed_books=[
            ("한강", "소설"),
            ("한강", "소설"),
            ("김영하", "에세이"),
        ]
    )

    profile = await svc.recompute(user_id)

    assert profile.genre_vector == {"소설": 2, "에세이": 1}
    assert profile.author_vector == {"한강": 2, "김영하": 1}


@pytest.mark.asyncio
async def test_recompute_updates_existing_profile() -> None:
    """recompute() overwrites a previously stored profile with fresh vectors."""
    user_id = uuid4()
    old_profile = _FakeProfile(
        user_id=user_id,
        genre_vector={"구소설": 99},
        author_vector={"옛저자": 99},
    )
    svc = _svc(
        completed_books=[("신저자", "신장르")],
        existing_profile=old_profile,
    )

    profile = await svc.recompute(user_id)

    # The stored profile must reflect the freshly computed vectors, not the old ones.
    assert profile.genre_vector == {"신장르": 1}
    assert profile.author_vector == {"신저자": 1}

"""Community domain cross-domain read ports.

Three lightweight query ports used by CommunityService.get_user_profile to
pull grade stats, badges, and highlights from foreign domains without
importing their repositories directly (CLAUDE.md §3.3).
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
from typing import Protocol
from uuid import UUID


@dataclass(frozen=True, slots=True)
class GradeStats:
    grade: int
    tier: int
    total_books: int
    total_seconds: int
    streak_days: int


@dataclass(frozen=True, slots=True)
class BadgeSummary:
    id: UUID
    name: str
    icon_url: str
    category: str
    earned_at: datetime


@dataclass(frozen=True, slots=True)
class HighlightSummary:
    id: UUID
    quote_text: str
    book_title: str | None
    created_at: datetime


class ProfileReadingQueryPort(Protocol):
    async def get_grade_stats(self, user_id: UUID) -> GradeStats | None: ...


class ProfileChallengeQueryPort(Protocol):
    async def get_user_badges(self, user_id: UUID, limit: int) -> list[BadgeSummary]: ...


class ProfileHighlightQueryPort(Protocol):
    async def get_recent_highlights(self, user_id: UUID, limit: int) -> list[HighlightSummary]: ...

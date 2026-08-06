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


# ---------------------------------------------------------------------------
# BC-80 — "내 활동" (my activity) summary. Each port wraps the OWNING domain's
# real Service (not its repository) — the aggregation call is service-to-service
# per CLAUDE.md §3.3; concrete adapters are wired in providers.py.
# ---------------------------------------------------------------------------


@dataclass(frozen=True, slots=True)
class ActivityReviewItem:
    id: UUID
    book_id: UUID
    book_title: str | None
    book_cover_url: str | None
    rating: float
    body: str | None
    created_at: datetime


@dataclass(frozen=True, slots=True)
class ActivityHighlightItem:
    id: UUID
    book_id: UUID
    book_title: str | None
    book_cover_url: str | None
    quote_text: str
    created_at: datetime


@dataclass(frozen=True, slots=True)
class ActivityAgendaItem:
    id: UUID
    club_id: UUID
    club_name: str
    session_id: UUID
    session_title: str
    status: str
    published_at: datetime | None
    created_at: datetime


@dataclass(frozen=True, slots=True)
class ActivityClubItem:
    id: UUID
    name: str
    created_at: datetime


@dataclass(frozen=True, slots=True)
class ActivityBookItem:
    user_book_id: UUID
    book_id: UUID
    title: str
    cover_url: str | None
    current_chapter: int
    started_at: datetime | None


class ActivityReviewQueryPort(Protocol):
    """Preview = (total count, first ``limit`` items newest-first) in one call —
    matches ``ReviewService.list_my_reviews``'s combined return so the
    aggregator never issues two round-trips for one preview."""

    async def preview(self, user_id: UUID, limit: int) -> tuple[int, list[ActivityReviewItem]]: ...


class ActivityHighlightQueryPort(Protocol):
    async def preview(
        self, user_id: UUID, limit: int
    ) -> tuple[int, list[ActivityHighlightItem]]: ...


class ActivityAgendaQueryPort(Protocol):
    async def preview(self, user_id: UUID, limit: int) -> tuple[int, list[ActivityAgendaItem]]: ...


class ActivityClubQueryPort(Protocol):
    async def preview(self, user_id: UUID, limit: int) -> tuple[int, list[ActivityClubItem]]: ...


class ActivityLibraryQueryPort(Protocol):
    async def preview(self, user_id: UUID, limit: int) -> tuple[int, list[ActivityBookItem]]: ...

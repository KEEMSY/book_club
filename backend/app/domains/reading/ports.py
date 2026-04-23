"""Reading domain ports — the only contracts ``service.py`` is allowed to import.

Per CLAUDE.md §3.2 the service layer depends only on these Protocols; the
concrete SQLAlchemy repositories live in ``repository.py`` and are wired in
``providers.py`` for live HTTP traffic or via in-memory fakes for unit
tests.

We also declare two service-layer DTOs here that the router converts into
Pydantic public shapes:

- ``HeatmapDay`` — per-day aggregate for the jan-sheep grid.
- ``GradeSummary`` — UserGrade snapshot plus the next-level thresholds.
- ``GoalProgress`` — a goal + what the user has already achieved within
  its window.

Keeping them here rather than in ``schemas.py`` means the service stays
free of pydantic, FastAPI, or any transport imports.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import date, datetime
from typing import Protocol
from uuid import UUID

from app.domains.reading.models import (
    DailyReadingStat,
    Goal,
    GoalPeriod,
    ReadingSession,
    UserGrade,
)


@dataclass(frozen=True, slots=True)
class GradeThreshold:
    """Thresholds required to reach the *next* grade."""

    target_books: int
    target_seconds: int


@dataclass(frozen=True, slots=True)
class HeatmapDay:
    """Service-shape per-day aggregate for the heatmap."""

    date: date
    total_seconds: int
    session_count: int


@dataclass(frozen=True, slots=True)
class GradeSummary:
    """Service-shape grade snapshot returned by ``ReadingService.get_grade``."""

    grade: int
    total_books: int
    total_seconds: int
    streak_days: int
    longest_streak: int
    next_grade_thresholds: GradeThreshold | None


@dataclass(frozen=True, slots=True)
class GoalProgress:
    """Service-shape progress toward a single goal."""

    goal: Goal
    books_done: int
    seconds_done: int
    percent: float


@dataclass(frozen=True, slots=True)
class SessionCompletion:
    """Returned by ``end_session`` — the row plus derived grade snapshot.

    Carries a ``grade_up`` flag so the mobile UI can trigger the grade-up
    animation without another round-trip.
    """

    session: ReadingSession
    grade: GradeSummary
    grade_up: bool


class ReadingSessionRepositoryPort(Protocol):
    async def get_active_session(self, user_id: UUID) -> ReadingSession | None: ...

    async def create_started(
        self,
        *,
        user_id: UUID,
        user_book_id: UUID,
        started_at: datetime,
        device: str | None,
    ) -> ReadingSession: ...

    async def end_session(
        self,
        session_id: UUID,
        ended_at: datetime,
        duration_sec: int,
    ) -> ReadingSession: ...

    async def create_manual(
        self,
        *,
        user_id: UUID,
        user_book_id: UUID,
        started_at: datetime,
        ended_at: datetime,
        duration_sec: int,
        note: str | None,
    ) -> ReadingSession: ...

    async def get_by_id(self, session_id: UUID) -> ReadingSession | None: ...


class DailyStatRepositoryPort(Protocol):
    async def upsert(
        self,
        *,
        user_id: UUID,
        date: date,
        add_seconds: int,
        add_sessions: int,
    ) -> None: ...

    async def range(
        self,
        user_id: UUID,
        from_date: date,
        to_date: date,
    ) -> list[DailyReadingStat]: ...


class UserGradeRepositoryPort(Protocol):
    async def get_or_init(self, user_id: UUID) -> UserGrade: ...

    async def update_snapshot(
        self,
        user_id: UUID,
        *,
        total_books: int | None = None,
        total_seconds_delta: int | None = None,
        grade: int | None = None,
        streak_days: int | None = None,
        longest_streak: int | None = None,
        streak_last_date: date | None = None,
    ) -> UserGrade: ...


class GoalRepositoryPort(Protocol):
    async def create(
        self,
        *,
        user_id: UUID,
        period: GoalPeriod,
        target_books: int,
        target_seconds: int,
        start_date: date,
        end_date: date,
    ) -> Goal: ...

    async def active_for(
        self,
        user_id: UUID,
        period: GoalPeriod,
        on_date: date,
    ) -> Goal | None: ...

    async def list_active(self, user_id: UUID, on_date: date) -> list[Goal]: ...


class ReadingBookQueryPort(Protocol):
    """Cross-domain view into the Book domain's UserBook table.

    Declared here (not in ``book/ports.py``) because the reading domain is
    the *consumer* — it defines the shape it needs. The concrete adapter
    lives in ``providers.py`` and wraps a ``UserBookRepository``. This
    preserves the §3.3 boundary: the reading service never imports a book
    repository directly.
    """

    async def user_book_belongs_to_user(
        self,
        *,
        user_id: UUID,
        user_book_id: UUID,
    ) -> bool: ...

    async def count_completed_books(
        self,
        *,
        user_id: UUID,
        from_date: date | None = None,
        to_date: date | None = None,
    ) -> int: ...

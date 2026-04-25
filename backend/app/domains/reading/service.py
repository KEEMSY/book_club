"""Reading domain service — session timer, manual log, heatmap, grade, goal.

Depends only on the Protocols in ``ports.py`` (CLAUDE.md §3.2). Concrete
repositories, the cross-domain ``ReadingBookQueryPort`` adapter, and the
event bus are injected by ``providers.py`` for HTTP traffic or by test
fakes for unit tests.

Business rules captured here:

- ``start_session`` — verifies the user_book belongs to the caller (else
  404 ``USER_BOOK_NOT_FOUND``); an existing active session raises 409
  ``ACTIVE_SESSION_EXISTS``; otherwise creates a new row with
  ``started_at = now(UTC)``.
- ``end_session`` — session must belong to the user and still be active.
  Duration is reconciled at the server from ``paused_ms``:

      duration = max(0, min(elapsed, elapsed - paused_ms / 1000))

  Anything below 1 second raises 422 ``SESSION_TOO_SHORT`` (defends
  against a stuck timer flicker inflating stats). On success:
    * the session row is stamped,
    * a ``ReadingSessionCompleted`` event is staged on the session so it
      delivers ONLY after the transaction commits,
    * the derived grade snapshot is returned so the mobile UI can trigger
      a grade-up animation without a round-trip.

- ``log_manual_session`` — source='manual'. Duration is derived from
  (ended_at - started_at) and must be in [60, 14400] seconds (1 min to 4
  hours). Raises 422 ``MANUAL_SESSION_OUT_OF_RANGE`` otherwise. Manual
  sessions DO NOT publish ``ReadingSessionCompleted`` — they carry no
  grade/streak/heatmap weight by policy (design doc §5.1).

- ``get_heatmap`` — clamps the window to ≤ 366 days.

- ``get_grade`` — reads the snapshot and computes next-level thresholds
  via ``grade_policy``.

- ``create_goal`` — derives the window from ``period``:
    weekly  -> current ISO week, Mon..Sun
    monthly -> current calendar month
    yearly  -> current calendar year
  Replacing a goal for the same period is allowed — we just insert a new
  row; the repo's ``active_for`` returns the newest window-matching row.

- ``get_current_goals`` — per active goal, computes progress from
    books_done = count of UserBook rows completed within the window
                 (via ReadingBookQueryPort)
    seconds_done = sum of DailyReadingStat.total_seconds in the window

Event subscriber ``on_reading_session_completed`` (registered at app
startup) reads the event, upserts DailyReadingStat, pulls the updated
completed-book count, recomputes grade + streak, and emits a derived
``UserGradeRecomputed`` event for M5.
"""

from __future__ import annotations

from collections.abc import Callable
from dataclasses import dataclass
from datetime import UTC, date, datetime, timedelta
from uuid import UUID

from app.core.exceptions import ConflictError, NotFoundError
from app.domains.reading.events import (
    ReadingSessionCompleted,
    UserGradeRecomputed,
)
from app.domains.reading.grade_policy import calculate_grade_tier, next_threshold
from app.domains.reading.models import Goal, GoalPeriod, ReadingSession
from app.domains.reading.ports import (
    DailyStatRepositoryPort,
    GoalProgress,
    GoalRepositoryPort,
    GradeSummary,
    GradeThreshold,
    HeatmapDay,
    ReadingBookQueryPort,
    ReadingSessionRepositoryPort,
    SessionCompletion,
    UserGradeRepositoryPort,
)
from app.domains.reading.streak_policy import update_streak
from app.shared.event_bus import EventBus

StageEventFn = Callable[[object], None]

_MAX_HEATMAP_DAYS = 366
_MIN_TIMER_DURATION_SEC = 1
_MANUAL_MIN_SEC = 60
_MANUAL_MAX_SEC = 4 * 60 * 60


@dataclass(slots=True)
class ReadingService:
    """Orchestrates the reading domain use cases."""

    sessions: ReadingSessionRepositoryPort
    daily_stats: DailyStatRepositoryPort
    user_grades: UserGradeRepositoryPort
    goals: GoalRepositoryPort
    book_query: ReadingBookQueryPort
    bus: EventBus
    stage_event: StageEventFn

    async def start_session(
        self,
        *,
        user_id: UUID,
        user_book_id: UUID,
        device: str | None,
    ) -> ReadingSession:
        owned = await self.book_query.user_book_belongs_to_user(
            user_id=user_id, user_book_id=user_book_id
        )
        if not owned:
            raise NotFoundError("user_book not found", code="USER_BOOK_NOT_FOUND")

        existing = await self.sessions.get_active_session(user_id)
        if existing is not None:
            raise ConflictError(
                "user already has an active session",
                code="ACTIVE_SESSION_EXISTS",
            )

        started_at = datetime.now(tz=UTC)
        return await self.sessions.create_started(
            user_id=user_id,
            user_book_id=user_book_id,
            started_at=started_at,
            device=device,
        )

    async def end_session(
        self,
        *,
        user_id: UUID,
        session_id: UUID,
        ended_at: datetime,
        paused_ms: int,
    ) -> SessionCompletion:
        session = await self.sessions.get_by_id(session_id)
        if session is None or session.user_id != user_id:
            # Don't leak the existence of another user's session.
            raise NotFoundError("session not found", code="SESSION_NOT_FOUND")
        if session.ended_at is not None:
            raise ConflictError("session already ended", code="SESSION_ALREADY_ENDED")

        duration_sec = _reconcile_duration(
            started_at=session.started_at,
            ended_at=ended_at,
            paused_ms=paused_ms,
        )
        if duration_sec < _MIN_TIMER_DURATION_SEC:
            raise ConflictError(
                "session shorter than 1s",
                code="SESSION_TOO_SHORT",
            )

        updated = await self.sessions.end_session(session_id, ended_at, duration_sec)

        # Compute and persist the updated snapshot inline so the HTTP
        # response reflects the post-completion grade. This is the
        # canonical write path; the event below is for cross-domain
        # consumers (M5 push notifier, etc.), not a second writer.
        snapshot_before = await self.user_grades.get_or_init(user_id)
        grade_before = snapshot_before.grade
        tier_before = snapshot_before.tier
        grade_after = await self._apply_session_completion(
            user_id=user_id,
            duration_sec=duration_sec,
            session_date=ended_at.date(),
        )

        # Stage both events — delivered only after the enclosing
        # transaction commits. On rollback the staged list is cleared by
        # the session hook so consumers never see a phantom completion.
        self.stage_event(
            ReadingSessionCompleted(
                user_id=user_id,
                user_book_id=updated.user_book_id,
                session_id=updated.id,
                date=ended_at.date(),
                duration_sec=duration_sec,
                source="timer",
            )
        )
        if (grade_after.grade, grade_after.tier) != (grade_before, tier_before):
            self.stage_event(
                UserGradeRecomputed(
                    user_id=user_id,
                    old_grade=grade_before,
                    old_tier=tier_before,
                    new_grade=grade_after.grade,
                    new_tier=grade_after.tier,
                    streak_days=grade_after.streak_days,
                )
            )

        return SessionCompletion(
            session=updated,
            grade=grade_after,
            grade_up=grade_after.grade > grade_before,
        )

    async def log_manual_session(
        self,
        *,
        user_id: UUID,
        user_book_id: UUID,
        started_at: datetime,
        ended_at: datetime,
        note: str | None,
    ) -> ReadingSession:
        owned = await self.book_query.user_book_belongs_to_user(
            user_id=user_id, user_book_id=user_book_id
        )
        if not owned:
            raise NotFoundError("user_book not found", code="USER_BOOK_NOT_FOUND")

        if ended_at <= started_at:
            raise ConflictError(
                "manual session window invalid",
                code="MANUAL_SESSION_OUT_OF_RANGE",
            )
        duration_sec = int((ended_at - started_at).total_seconds())
        if not _MANUAL_MIN_SEC <= duration_sec <= _MANUAL_MAX_SEC:
            raise ConflictError(
                "manual session duration out of range",
                code="MANUAL_SESSION_OUT_OF_RANGE",
            )

        return await self.sessions.create_manual(
            user_id=user_id,
            user_book_id=user_book_id,
            started_at=started_at,
            ended_at=ended_at,
            duration_sec=duration_sec,
            note=note,
        )

    async def get_heatmap(
        self,
        *,
        user_id: UUID,
        from_date: date,
        to_date: date,
    ) -> list[HeatmapDay]:
        if from_date > to_date:
            raise ConflictError("from_date after to_date", code="HEATMAP_RANGE_INVALID")
        # Clamp to at most 366 days so a pathological client cannot request
        # a multi-year sweep in one go.
        if (to_date - from_date).days > _MAX_HEATMAP_DAYS:
            from_date = to_date - timedelta(days=_MAX_HEATMAP_DAYS)
        rows = await self.daily_stats.range(user_id, from_date, to_date)
        return [
            HeatmapDay(
                date=row.date,
                total_seconds=row.total_seconds,
                session_count=row.session_count,
            )
            for row in rows
        ]

    async def get_grade(self, *, user_id: UUID) -> GradeSummary:
        return await self._grade_summary(user_id)

    async def create_goal(
        self,
        *,
        user_id: UUID,
        period: GoalPeriod,
        target_books: int,
        target_seconds: int,
        on_date: date | None = None,
    ) -> Goal:
        anchor = on_date or datetime.now(tz=UTC).date()
        start_date, end_date = _compute_window(period, anchor)
        return await self.goals.create(
            user_id=user_id,
            period=period,
            target_books=target_books,
            target_seconds=target_seconds,
            start_date=start_date,
            end_date=end_date,
        )

    async def get_current_goals(
        self,
        *,
        user_id: UUID,
        on_date: date,
    ) -> list[GoalProgress]:
        active = await self.goals.list_active(user_id, on_date)
        out: list[GoalProgress] = []
        for goal in active:
            books_done = await self.book_query.count_completed_books(
                user_id=user_id,
                from_date=goal.start_date,
                to_date=goal.end_date,
            )
            # Only count days up to ``on_date`` so a goal in its first week
            # doesn't pretend to have zero-progress based on data that
            # hasn't been recorded yet.
            stats = await self.daily_stats.range(
                user_id,
                goal.start_date,
                min(goal.end_date, on_date),
            )
            seconds_done = sum(s.total_seconds for s in stats)
            percent = _progress_percent(
                books_done=books_done,
                seconds_done=seconds_done,
                target_books=goal.target_books,
                target_seconds=goal.target_seconds,
            )
            out.append(
                GoalProgress(
                    goal=goal,
                    books_done=books_done,
                    seconds_done=seconds_done,
                    percent=percent,
                )
            )
        return out

    # ------------------------------------------------------------------
    # Internal helpers
    # ------------------------------------------------------------------

    async def _apply_session_completion(
        self,
        *,
        user_id: UUID,
        duration_sec: int,
        session_date: date,
    ) -> GradeSummary:
        # 1) aggregate heatmap bucket
        await self.daily_stats.upsert(
            user_id=user_id,
            date=session_date,
            add_seconds=duration_sec,
            add_sessions=1,
        )
        # 2) recompute totals
        current = await self.user_grades.get_or_init(user_id)
        total_seconds = current.total_seconds + duration_sec
        total_books = await self.book_query.count_completed_books(user_id=user_id)
        # 3) grade + tier under AND semantics
        grade, tier = calculate_grade_tier(total_books=total_books, total_seconds=total_seconds)
        # 4) streak
        streak_days, longest_streak, last_date = update_streak(
            previous_last_date=current.streak_last_date,
            previous_streak_days=current.streak_days,
            longest_streak=current.longest_streak,
            session_date=session_date,
        )
        # 5) persist
        await self.user_grades.update_snapshot(
            user_id,
            total_books=total_books,
            total_seconds_delta=duration_sec,
            grade=grade,
            tier=tier,
            streak_days=streak_days,
            longest_streak=longest_streak,
            streak_last_date=last_date,
        )
        return GradeSummary(
            grade=grade,
            tier=tier,
            total_books=total_books,
            total_seconds=total_seconds,
            streak_days=streak_days,
            longest_streak=longest_streak,
            next_grade_thresholds=_next_threshold(grade),
        )

    async def _grade_summary(self, user_id: UUID) -> GradeSummary:
        row = await self.user_grades.get_or_init(user_id)
        return GradeSummary(
            grade=row.grade,
            tier=row.tier,
            total_books=row.total_books,
            total_seconds=row.total_seconds,
            streak_days=row.streak_days,
            longest_streak=row.longest_streak,
            next_grade_thresholds=_next_threshold(row.grade),
        )


# -------------------------------------------------------------------------
# Pure helpers
# -------------------------------------------------------------------------


def _reconcile_duration(
    *,
    started_at: datetime,
    ended_at: datetime,
    paused_ms: int,
) -> int:
    """Server-side reconciliation of the client-reported pause time.

    ``duration_sec = min(elapsed, elapsed - paused_ms/1000)`` clamped at 0.
    Any ``paused_ms`` > elapsed collapses to 0 so a malicious client can
    never inflate stats by sending a negative-pause delta.
    """
    elapsed = (ended_at - started_at).total_seconds()
    adjusted = elapsed - (paused_ms / 1000.0)
    return max(0, int(min(elapsed, adjusted)))


def _next_threshold(current_grade: int) -> GradeThreshold | None:
    t = next_threshold(current_grade)
    if t is None:
        return None
    books, seconds = t
    return GradeThreshold(target_books=books, target_seconds=seconds)


def _progress_percent(
    *,
    books_done: int,
    seconds_done: int,
    target_books: int,
    target_seconds: int,
) -> float:
    # Average of the two axis ratios, each capped at 1.0 so the overall
    # progress never exceeds 100% even when one axis over-achieves. The
    # return value stays 0.0..1.0 — the router multiplies by 100 for the
    # wire contract.
    def _ratio(done: int, target: int) -> float:
        if target <= 0:
            return 1.0
        return min(1.0, done / target)

    return round((_ratio(books_done, target_books) + _ratio(seconds_done, target_seconds)) / 2, 4)


def _compute_window(period: GoalPeriod, anchor: date) -> tuple[date, date]:
    """Return [start_date, end_date] inclusive for a goal window.

    - weekly  -> ISO week Mon..Sun containing ``anchor``
    - monthly -> first..last day of ``anchor``'s month
    - yearly  -> Jan 1..Dec 31 of ``anchor``'s year
    """
    if period is GoalPeriod.WEEKLY:
        # Monday == weekday() 0. iso_weekday 1..7 with Monday=1.
        monday = anchor - timedelta(days=anchor.weekday())
        sunday = monday + timedelta(days=6)
        return (monday, sunday)
    if period is GoalPeriod.MONTHLY:
        first = anchor.replace(day=1)
        # Last day: jump to next month, back up one.
        if anchor.month == 12:
            next_first = date(anchor.year + 1, 1, 1)
        else:
            next_first = date(anchor.year, anchor.month + 1, 1)
        last = next_first - timedelta(days=1)
        return (first, last)
    # yearly
    first = date(anchor.year, 1, 1)
    last = date(anchor.year, 12, 31)
    return (first, last)


__all__ = [
    "ReadingService",
    "SessionCompletion",
    "StageEventFn",
    "_compute_window",
    "_reconcile_duration",
]

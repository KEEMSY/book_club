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

import asyncio
import logging
from collections.abc import Callable, Coroutine
from dataclasses import dataclass, field
from datetime import UTC, date, datetime, timedelta
from typing import Any, Protocol
from uuid import UUID

from app.core.exceptions import ConflictError, NotFoundError, PermissionDeniedError
from app.domains.reading.events import (
    ReadingSessionCompleted,
    UserGradeRecomputed,
)
from app.domains.reading.grade_policy import calculate_grade_tier, next_threshold
from app.domains.reading.models import Bookmark, Goal, GoalPeriod, ReadingSession
from app.domains.reading.ports import (
    AdvancedStats,
    DailySessionInfo,
    DailyStatRepositoryPort,
    FormatBreakdown,
    GenreBreakdown,
    GenreSlice,
    GoalProgress,
    GoalRepositoryPort,
    GradeSummary,
    GradeThreshold,
    HeatmapDay,
    MilestoneData,
    MonthlyHours,
    MonthlyRecap,
    ReadingBookQueryPort,
    ReadingRecap,
    ReadingSessionRepositoryPort,
    ReadingSpeedStats,
    ReadingStats,
    RecapCardData,
    RecapTopBook,
    SessionCompletion,
    SpeedTrendPoint,
    UserGradeRepositoryPort,
)
from app.domains.reading.repository import BookmarkRepository, ReadingStatsRepository, RecapBookRow
from app.domains.reading.streak_policy import update_streak
from app.shared.event_bus import EventBus

logger = logging.getLogger(__name__)

StageEventFn = Callable[[object], None]

# Module-level set keeps a strong reference to fire-and-forget tasks so the
# event loop does not garbage-collect them before they complete (RUF006).
_background_tasks: set[asyncio.Task[None]] = set()


def _schedule_background_task(coro: Coroutine[Any, Any, None]) -> None:
    """Schedule *coro* as a fire-and-forget asyncio Task.

    The strong reference is stored in ``_background_tasks`` and removed when
    the task finishes, preventing premature GC while honouring RUF006.
    """
    task: asyncio.Task[None] = asyncio.create_task(coro)
    _background_tasks.add(task)
    task.add_done_callback(_background_tasks.discard)


class FeedStreakPort(Protocol):
    """Minimal cross-domain interface consumed by ReadingService.

    Defined here (rather than importing FeedService) so the reading service
    depends only on this narrow contract per CLAUDE.md §3.2.
    """

    async def record_streak_milestone(self, *, user_id: UUID, streak_days: int) -> None: ...


class SubscriptionQueryPort(Protocol):
    """Minimal cross-domain port for reading the caller's Pro status.

    Defined here (rather than importing the subscription service) so the
    reading service depends only on this narrow contract per CLAUDE.md §3.2.
    The concrete implementation lives in ``providers.py``; tests inject a
    fake that returns a fixed boolean.
    """

    async def is_pro(self, user_id: UUID) -> bool: ...


class TasteProfileRecomputePort(Protocol):
    """Minimal port for triggering taste-profile recomputation on book completion.

    Defined here (rather than importing TasteProfileService) so the reading
    service depends only on this narrow contract per CLAUDE.md §3.2.
    The concrete implementation is ``TasteProfileService``; tests can inject
    a no-op fake.
    """

    async def recompute(self, user_id: UUID) -> object: ...


_MAX_HEATMAP_DAYS = 366


@dataclass(frozen=True, slots=True)
class YearStats:
    year: int
    year_books: int
    year_seconds: int
    year_best_day_date: date | None
    year_best_day_seconds: int | None
    total_books: int
    total_seconds: int
    streak_days: int
    longest_streak: int


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
    bookmark_repo: BookmarkRepository
    stats_repo: ReadingStatsRepository
    # Optional — existing callers that do not wire the feed service continue to
    # work; streak milestone events are silently skipped when absent.
    feed_service: FeedStreakPort | None = field(default=None)
    # Optional — existing callers that do not wire the taste profile service
    # continue to work; recompute is fire-and-forget, errors are swallowed.
    taste_profile_service: TasteProfileRecomputePort | None = field(default=None)
    # Optional — gates Pro-only endpoints. When absent the caller is treated
    # as non-Pro so the gate fails closed rather than leaking the feature.
    subscription_query: SubscriptionQueryPort | None = field(default=None)

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

    async def get_active_session(self, user_id: UUID) -> ReadingSession | None:
        return await self.sessions.get_active_session(user_id)

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

        if self.feed_service is not None:
            await self.feed_service.record_streak_milestone(
                user_id=user_id, streak_days=grade_after.streak_days
            )

        # Fire-and-forget: update the taste profile so ML recommendations
        # reflect the latest reading session. Errors are intentionally swallowed
        # — a failed recompute must never roll back the reading session itself.
        if self.taste_profile_service is not None:
            _schedule_background_task(self._fire_taste_recompute(user_id))

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

    async def get_year_stats(self, *, user_id: UUID, year: int) -> YearStats:
        year_start = date(year, 1, 1)
        year_end = date(year, 12, 31)

        # Sequential — all three share the same SQLAlchemy async session;
        # concurrent gather on a single session causes connection drops.
        year_books = await self.book_query.count_completed_books(
            user_id=user_id, from_date=year_start, to_date=year_end
        )
        daily_rows = await self.daily_stats.range(user_id, year_start, year_end)
        grade = await self._grade_summary(user_id)

        year_seconds = sum(r.total_seconds for r in daily_rows)
        best = max(daily_rows, key=lambda r: r.total_seconds, default=None)
        return YearStats(
            year=year,
            year_books=year_books,
            year_seconds=year_seconds,
            year_best_day_date=best.date if best else None,
            year_best_day_seconds=best.total_seconds if best else None,
            total_books=grade.total_books,
            total_seconds=grade.total_seconds,
            streak_days=grade.streak_days,
            longest_streak=grade.longest_streak,
        )

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

    async def get_daily_sessions(
        self,
        *,
        user_id: UUID,
        target_date: date,
    ) -> list[DailySessionInfo]:
        return await self.book_query.get_daily_sessions_with_book_info(
            user_id=user_id,
            target_date=target_date,
        )

    async def add_bookmark(
        self,
        *,
        user_id: UUID,
        user_book_id: UUID,
        page: int,
        note: str | None,
    ) -> Bookmark:
        owned = await self.book_query.user_book_belongs_to_user(
            user_book_id=user_book_id, user_id=user_id
        )
        if not owned:
            raise NotFoundError("user_book not found", code="USER_BOOK_NOT_FOUND")
        return await self.bookmark_repo.create(
            user_id=user_id,
            user_book_id=user_book_id,
            page=page,
            note=note,
        )

    async def get_latest_bookmark(
        self,
        *,
        user_id: UUID,
        user_book_id: UUID,
    ) -> Bookmark | None:
        owned = await self.book_query.user_book_belongs_to_user(
            user_book_id=user_book_id, user_id=user_id
        )
        if not owned:
            raise NotFoundError("user_book not found", code="USER_BOOK_NOT_FOUND")
        return await self.bookmark_repo.get_latest(user_book_id=user_book_id)

    async def get_reading_stats(self, *, user_id: UUID) -> ReadingStats:
        """Aggregate reading statistics for the /me/reading-stats endpoint.

        All queries are sequential on the shared AsyncSession — parallel
        gather on a single SQLAlchemy async session causes connection drops
        (same constraint as ``get_year_stats``).
        """
        avg_min, avg_pph = await self.stats_repo.avg_speed(user_id)
        fmt = await self.stats_repo.format_breakdown(user_id)
        monthly = await self.stats_repo.monthly_hours(user_id)
        genres = await self.stats_repo.genre_breakdown(user_id)
        avg_days = await self.stats_repo.avg_completion_days(user_id)

        return ReadingStats(
            speed=ReadingSpeedStats(
                avg_minutes_per_page=avg_min,
                avg_pages_per_hour=avg_pph,
            ),
            format_breakdown=FormatBreakdown(
                paper=fmt.get("paper", 0),
                ebook=fmt.get("ebook", 0),
                audio=fmt.get("audio", 0),
            ),
            monthly_hours=[
                MonthlyHours(month=str(m["month"]), hours=float(str(m["hours"]))) for m in monthly
            ],
            genre_breakdown=[
                GenreBreakdown(genre=str(g["genre"]), count=int(str(g["count"]))) for g in genres
            ],
            avg_completion_days=avg_days,
        )

    async def get_reading_recap(
        self,
        *,
        user_id: UUID,
        period: str,
    ) -> ReadingRecap:
        """Return recap cards and aggregate stats for the given half-year/year period.

        ``period`` format: ``YYYY-H1`` (Jan-Jun), ``YYYY-H2`` (Jul-Dec),
        or ``YYYY`` (full year).  Each card is only included when data
        exists — so the list may have 0 to 4 items.

        Queries are run sequentially on the shared AsyncSession (same
        constraint as ``get_year_stats``).
        """
        from_date, to_date = _parse_recap_period(period)

        rows = [
            (
                "most_time",
                await self.stats_repo.recap_most_time(user_id, from_date, to_date),
            ),
            (
                "first_completed",
                await self.stats_repo.recap_first_completed(user_id, from_date, to_date),
            ),
            (
                "thickest",
                await self.stats_repo.recap_thickest(user_id, from_date, to_date),
            ),
            (
                "most_highlighted",
                await self.stats_repo.recap_most_highlighted(user_id, from_date, to_date),
            ),
        ]

        cards: list[RecapCardData] = []
        for card_type, row in rows:
            if row is None:
                continue
            stat_value = _format_recap_stat(card_type, row)
            cards.append(
                RecapCardData(
                    card_type=card_type,
                    title=row.title,
                    cover_url=row.cover_url,
                    author=row.author,
                    stat_value=stat_value,
                )
            )

        # Aggregate stats for the mobile summary view.
        agg = await self.stats_repo.recap_aggregate_stats(user_id, from_date, to_date)
        top_book_rows = await self.stats_repo.recap_top_books(user_id, from_date, to_date)
        top_books = [
            RecapTopBook(
                title=r.title,
                cover_url=r.cover_url,
                author=r.author,
                read_seconds=r.stat_int or 0,
            )
            for r in top_book_rows
        ]

        # Longest streak from the grade snapshot (all-time best; period-scoped
        # streak reconstruction is a future backlog item).
        grade = await self.user_grades.get_or_init(user_id)
        longest_streak_days = grade.longest_streak

        return ReadingRecap(
            period=period,
            cards=cards,
            total_books=agg["total_books"],
            total_seconds=agg["total_seconds"],
            longest_streak_days=longest_streak_days,
            top_books=top_books,
        )

    async def get_monthly_recap(
        self,
        *,
        user_id: UUID,
        year: int,
        month: int,
    ) -> MonthlyRecap:
        """Return aggregated stats for a single calendar month.

        Queries are run sequentially on the shared AsyncSession (same
        constraint as ``get_year_stats``).
        """
        stats = await self.stats_repo.get_monthly_stats(user_id, year, month)
        total_seconds = int(str(stats["total_seconds"]))
        days_read = int(str(stats["days_read"]))
        # avg_daily_minutes counts only days with actual reading data
        # to avoid a near-zero value for users who read every few days.
        avg_daily_minutes = (total_seconds / 60.0 / days_read) if days_read > 0 else 0.0
        prev_seconds = int(str(stats["prev_month_seconds"]))
        return MonthlyRecap(
            year=year,
            month=month,
            books_completed=int(str(stats["books_completed"])),
            total_hours=round(total_seconds / 3600.0, 2),
            avg_daily_minutes=round(avg_daily_minutes, 1),
            longest_streak=int(str(stats["longest_streak"])),
            top_genre=stats["top_genre"] if stats["top_genre"] else None,  # type: ignore[arg-type]
            prev_month_hours=round(prev_seconds / 3600.0, 2) if prev_seconds > 0 else None,
        )

    async def get_milestones(self, *, user_id: UUID) -> list[MilestoneData]:
        """Return all achieved milestones derived from existing reading data."""
        return await self.stats_repo.get_achieved_milestones(user_id)

    async def get_advanced_stats(self, *, user_id: UUID) -> AdvancedStats:
        """Pro-only advanced statistics: speed trend, genre mix, year-over-year.

        Raises ``PermissionDeniedError`` (``PRO_REQUIRED``) when the caller is
        not a Pro subscriber.  Queries run sequentially on the shared
        AsyncSession — concurrent gather on a single SQLAlchemy async session
        drops the connection (same constraint as ``get_year_stats`` /
        ``get_reading_stats``).
        """
        is_pro = (
            await self.subscription_query.is_pro(user_id)
            if self.subscription_query is not None
            else False
        )
        if not is_pro:
            raise PermissionDeniedError(
                "Pro 구독이 필요한 기능이에요.",
                code="PRO_REQUIRED",
            )

        current_year = datetime.now(tz=UTC).year
        prev_year = current_year - 1

        speed_rows = await self.stats_repo.get_speed_trend(user_id)
        genre_rows = await self.stats_repo.get_genre_distribution(user_id)
        current_count = await self.stats_repo.get_yearly_reading_count(user_id, current_year)
        prev_count = await self.stats_repo.get_yearly_reading_count(user_id, prev_year)
        longest_streak = await self.stats_repo.get_longest_streak(user_id)

        return AdvancedStats(
            speed_trend=[
                SpeedTrendPoint(
                    week_start=row["week_start"],  # type: ignore[arg-type]
                    minutes_per_page=round(float(str(row["minutes_per_page"])), 2),
                )
                for row in speed_rows
            ],
            genre_distribution=[
                GenreSlice(
                    genre=str(row["genre"]),
                    count=int(str(row["count"])),
                    pct=round(float(str(row["pct"])), 2),
                )
                for row in genre_rows
            ],
            yearly_comparison={str(current_year): current_count, str(prev_year): prev_count},
            longest_streak_days=longest_streak,
        )

    # ------------------------------------------------------------------
    # Internal helpers
    # ------------------------------------------------------------------

    async def _fire_taste_recompute(self, user_id: UUID) -> None:
        """Best-effort taste profile recompute. Exceptions are swallowed."""
        try:
            if self.taste_profile_service is not None:
                await self.taste_profile_service.recompute(user_id)
        except Exception:
            # A failed recompute is non-critical — log and continue.
            logger.warning("taste_profile_recompute_failed user_id=%s", user_id, exc_info=True)

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
        # 4) streak — apply shield protection before committing a reset
        streak_days, longest_streak, last_date, new_shields = _apply_streak_with_shield(
            previous_last_date=current.streak_last_date,
            previous_streak_days=current.streak_days,
            longest_streak=current.longest_streak,
            streak_shields=current.streak_shields,
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
            streak_shields=new_shields,
        )
        return GradeSummary(
            grade=grade,
            tier=tier,
            total_books=total_books,
            total_seconds=total_seconds,
            streak_days=streak_days,
            longest_streak=longest_streak,
            streak_shields=new_shields,
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
            streak_shields=row.streak_shields,
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


_MAX_STREAK_SHIELDS = 3
_SHIELD_AWARD_INTERVAL = 7  # award one shield every N consecutive days


def _apply_streak_with_shield(
    *,
    previous_last_date: date | None,
    previous_streak_days: int,
    longest_streak: int,
    streak_shields: int,
    session_date: date,
) -> tuple[int, int, date, int]:
    """Compute the new streak state, consuming a shield when a gap would reset.

    Returns ``(new_streak_days, new_longest_streak, new_last_date, new_shields)``.

    Shield rules:
    - When a session would cause a streak reset (gap > 1 day) AND the user
      holds at least one shield: decrement shields by 1 and keep the existing
      streak counter + last_date rather than resetting.
    - After each successful streak update, if the new streak_days is a
      nonzero multiple of ``_SHIELD_AWARD_INTERVAL``, award one shield up
      to ``_MAX_STREAK_SHIELDS``.
    """
    new_shields = streak_shields

    # Detect a gap that would normally reset the streak.
    gap_reset = previous_last_date is not None and session_date > previous_last_date + timedelta(
        days=1
    )

    shield_consumed = False
    if gap_reset and new_shields > 0:
        # Absorb the gap with a shield: keep the existing streak counter and
        # advance last_date to today.  The streak is not incremented because
        # the user did not actually read on the intervening day(s); we only
        # prevent the reset.
        new_shields -= 1
        shield_consumed = True
        streak_days = previous_streak_days
        new_longest = longest_streak
        last_date = session_date
    else:
        streak_days, new_longest, last_date = update_streak(
            previous_last_date=previous_last_date,
            previous_streak_days=previous_streak_days,
            longest_streak=longest_streak,
            session_date=session_date,
        )

    # Award a shield when the streak genuinely reaches a multiple of the award
    # interval.  Suppress when a shield was just consumed to prevent immediate
    # shield recovery by sitting at an existing award threshold.
    if not shield_consumed and streak_days > 0 and streak_days % _SHIELD_AWARD_INTERVAL == 0:
        new_shields = min(_MAX_STREAK_SHIELDS, new_shields + 1)

    return streak_days, new_longest, last_date, new_shields


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


def _parse_recap_period(period: str) -> tuple[date, date]:
    """Parse ``period`` into an inclusive [from_date, to_date] pair.

    Accepted formats:
    - ``YYYY``    — full calendar year
    - ``YYYY-H1`` — first half (January-June)
    - ``YYYY-H2`` — second half (July-December)

    Raises ``ValueError`` for malformed input so the router can return 422.
    """
    period = period.strip()
    if "-H" in period:
        parts = period.split("-H")
        if len(parts) != 2:
            raise ValueError(f"invalid recap period: {period!r}")
        year_str, half_str = parts
        year = int(year_str)
        half = int(half_str)
        if half == 1:
            return date(year, 1, 1), date(year, 6, 30)
        if half == 2:
            return date(year, 7, 1), date(year, 12, 31)
        raise ValueError(f"invalid half in recap period: {period!r}")
    year = int(period)
    return date(year, 1, 1), date(year, 12, 31)


def _format_recap_stat(card_type: str, row: RecapBookRow) -> str:
    """Return the human-readable ``stat_value`` string for a card."""
    if card_type == "most_time":
        hours = (row.stat_int or 0) // 3600
        return f"총 {hours}시간"
    if card_type == "first_completed":
        if row.stat_date is not None:
            return f"{row.stat_date.month}월 {row.stat_date.day}일"
        return "—"
    if card_type == "thickest":
        return f"{row.stat_int or 0}페이지"
    if card_type == "most_highlighted":
        return f"하이라이트 {row.stat_int or 0}개"
    return "—"


__all__ = [
    "ReadingService",
    "SessionCompletion",
    "StageEventFn",
    "_compute_window",
    "_parse_recap_period",
    "_reconcile_duration",
]

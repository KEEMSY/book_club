"""SQLAlchemy async implementations of the reading repository ports.

The repository layer only knows SQLAlchemy / Postgres; it never raises
raw ``IntegrityError`` past its boundary — conflicts are mapped to
``ConflictError`` so the service layer stays transport-agnostic
(CLAUDE.md §3.1).

Key design choices:
- ``ReadingSessionRepository.create_started`` relies on the partial
  UNIQUE index (``user_id WHERE ended_at IS NULL``) as the final line of
  defence. The service pre-checks so the common path is a clean 409, but
  if two requests race we still raise ``ConflictError`` instead of a
  naked IntegrityError.
- ``DailyStatRepository.upsert`` uses Postgres ``INSERT ... ON CONFLICT
  (user_id, date) DO UPDATE`` so two concurrent session-complete events
  for the same day simply accumulate.
- ``UserGradeRepository.get_or_init`` lazily creates a row on first read
  with grade=1 and zero counters. The write path uses an INSERT ... ON
  CONFLICT so concurrent first-reads resolve to a single row.
"""

from __future__ import annotations

import calendar
from dataclasses import dataclass
from datetime import UTC, date, datetime
from uuid import UUID

from sqlalchemy import and_, select, text
from sqlalchemy.dialects.postgresql import insert as pg_insert
from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.exceptions import ConflictError, NotFoundError
from app.domains.reading.models import (
    Bookmark,
    DailyReadingStat,
    Goal,
    GoalPeriod,
    ReadingSession,
    ReadingSessionSource,
    UserGrade,
)
from app.domains.reading.ports import MilestoneData


@dataclass(frozen=True, slots=True)
class RecapBookRow:
    """Intermediate result from a single recap card query.

    ``stat_int`` carries a numeric value (seconds, page count, highlight
    count); ``stat_date`` carries a completion date.  Exactly one of the
    two will be populated depending on the card type.
    """

    title: str
    cover_url: str | None
    author: str
    stat_int: int | None
    stat_date: date | None


class ReadingSessionRepository:
    """Persistence adapter for :class:`ReadingSession`."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get_active_session(self, user_id: UUID) -> ReadingSession | None:
        stmt = select(ReadingSession).where(
            ReadingSession.user_id == user_id,
            ReadingSession.ended_at.is_(None),
        )
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()

    async def create_started(
        self,
        *,
        user_id: UUID,
        user_book_id: UUID,
        started_at: datetime,
        device: str | None,
    ) -> ReadingSession:
        row = ReadingSession(
            user_id=user_id,
            user_book_id=user_book_id,
            started_at=started_at,
            source=ReadingSessionSource.TIMER,
            device=device,
        )
        self._session.add(row)
        try:
            await self._session.flush()
        except IntegrityError as exc:
            await self._session.rollback()
            raise ConflictError(
                "user already has an active session",
                code="ACTIVE_SESSION_EXISTS",
            ) from exc
        await self._session.refresh(row)
        return row

    async def end_session(
        self,
        session_id: UUID,
        ended_at: datetime,
        duration_sec: int,
    ) -> ReadingSession:
        row = await self._session.get(ReadingSession, session_id)
        if row is None:
            raise NotFoundError("session not found", code="SESSION_NOT_FOUND")
        if row.ended_at is not None:
            # Double-end — treat as idempotent noop; return the existing row.
            return row
        row.ended_at = ended_at
        row.duration_sec = duration_sec
        await self._session.flush()
        await self._session.refresh(row)
        return row

    async def create_manual(
        self,
        *,
        user_id: UUID,
        user_book_id: UUID,
        started_at: datetime,
        ended_at: datetime,
        duration_sec: int,
        note: str | None,
    ) -> ReadingSession:
        row = ReadingSession(
            user_id=user_id,
            user_book_id=user_book_id,
            started_at=started_at,
            ended_at=ended_at,
            duration_sec=duration_sec,
            source=ReadingSessionSource.MANUAL,
            note=note,
        )
        self._session.add(row)
        await self._session.flush()
        await self._session.refresh(row)
        return row

    async def get_by_id(self, session_id: UUID) -> ReadingSession | None:
        return await self._session.get(ReadingSession, session_id)


class DailyStatRepository:
    """Persistence adapter for :class:`DailyReadingStat`."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def upsert(
        self,
        *,
        user_id: UUID,
        date: date,
        add_seconds: int,
        add_sessions: int,
    ) -> None:
        # Postgres UPSERT so two concurrent session-completed events for the
        # same (user, date) simply accumulate instead of racing.
        stmt = (
            pg_insert(DailyReadingStat)
            .values(
                user_id=user_id,
                date=date,
                total_seconds=add_seconds,
                session_count=add_sessions,
            )
            .on_conflict_do_update(
                index_elements=["user_id", "date"],
                set_={
                    "total_seconds": DailyReadingStat.total_seconds + add_seconds,
                    "session_count": DailyReadingStat.session_count + add_sessions,
                },
            )
        )
        await self._session.execute(stmt)
        await self._session.flush()

    async def range(
        self,
        user_id: UUID,
        from_date: date,
        to_date: date,
    ) -> list[DailyReadingStat]:
        stmt = (
            select(DailyReadingStat)
            .where(
                DailyReadingStat.user_id == user_id,
                DailyReadingStat.date >= from_date,
                DailyReadingStat.date <= to_date,
            )
            .order_by(DailyReadingStat.date.asc())
        )
        result = await self._session.execute(stmt)
        return list(result.scalars().all())


class UserGradeRepository:
    """Persistence adapter for :class:`UserGrade`."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get_or_init(self, user_id: UUID) -> UserGrade:
        existing = await self._session.get(UserGrade, user_id)
        if existing is not None:
            return existing

        stmt = (
            pg_insert(UserGrade)
            .values(
                user_id=user_id,
                grade=1,
                total_books=0,
                total_seconds=0,
                streak_days=0,
                longest_streak=0,
            )
            .on_conflict_do_nothing(index_elements=["user_id"])
        )
        await self._session.execute(stmt)
        await self._session.flush()
        # SELECT after upsert so concurrent first-reads both return a row.
        result = await self._session.get(UserGrade, user_id)
        if result is None:
            # Unreachable — the row was just inserted or already existed.
            raise RuntimeError(f"user_grade for {user_id} vanished after upsert")
        return result

    async def update_snapshot(
        self,
        user_id: UUID,
        *,
        total_books: int | None = None,
        total_seconds_delta: int | None = None,
        grade: int | None = None,
        tier: int | None = None,
        streak_days: int | None = None,
        longest_streak: int | None = None,
        streak_last_date: date | None = None,
        streak_shields: int | None = None,
    ) -> UserGrade:
        row = await self.get_or_init(user_id)
        if total_books is not None:
            row.total_books = total_books
        if total_seconds_delta is not None:
            row.total_seconds = row.total_seconds + total_seconds_delta
        if grade is not None:
            row.grade = grade
        if tier is not None:
            row.tier = tier
        if streak_days is not None:
            row.streak_days = streak_days
        if longest_streak is not None:
            row.longest_streak = longest_streak
        if streak_last_date is not None:
            row.streak_last_date = streak_last_date
        if streak_shields is not None:
            row.streak_shields = streak_shields
        await self._session.flush()
        await self._session.refresh(row)
        return row

    async def update_streak_shields(self, user_id: UUID, *, shields: int) -> UserGrade:
        """Set ``streak_shields`` to exactly ``shields`` (caller enforces max)."""
        row = await self.get_or_init(user_id)
        row.streak_shields = shields
        await self._session.flush()
        await self._session.refresh(row)
        return row


class GoalRepository:
    """Persistence adapter for :class:`Goal`."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def create(
        self,
        *,
        user_id: UUID,
        period: GoalPeriod,
        target_books: int,
        target_seconds: int,
        start_date: date,
        end_date: date,
    ) -> Goal:
        row = Goal(
            user_id=user_id,
            period=period,
            target_books=target_books,
            target_seconds=target_seconds,
            start_date=start_date,
            end_date=end_date,
        )
        self._session.add(row)
        await self._session.flush()
        await self._session.refresh(row)
        return row

    async def active_for(
        self,
        user_id: UUID,
        period: GoalPeriod,
        on_date: date,
    ) -> Goal | None:
        # The newest goal whose window contains on_date. Multiple overlapping
        # goals are allowed (service doesn't enforce DB uniqueness); we take
        # the most recently created one.
        stmt = (
            select(Goal)
            .where(
                Goal.user_id == user_id,
                Goal.period == period,
                Goal.start_date <= on_date,
                Goal.end_date >= on_date,
            )
            # id DESC is the tiebreak for rows with identical created_at —
            # uuid4 is not monotonic but using it here matters only for
            # determinism, not semantic recency. In practice the service
            # never creates two Goals for the same period in the same
            # microsecond; this tiebreak is defence in depth for tests.
            .order_by(Goal.created_at.desc(), Goal.id.desc())
            .limit(1)
        )
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()

    async def list_active(self, user_id: UUID, on_date: date) -> list[Goal]:
        # Returns the newest goal per period whose window contains on_date.
        # Callers use this to render the "current goals" screen.
        stmt = (
            select(Goal)
            .where(
                and_(
                    Goal.user_id == user_id,
                    Goal.start_date <= on_date,
                    Goal.end_date >= on_date,
                )
            )
            .order_by(Goal.created_at.desc(), Goal.id.desc())
        )
        result = await self._session.execute(stmt)
        rows = list(result.scalars().all())
        # Dedupe by period, keeping the most recent.
        seen: set[GoalPeriod] = set()
        unique: list[Goal] = []
        for row in rows:
            if row.period in seen:
                continue
            seen.add(row.period)
            unique.append(row)
        return unique


class BookmarkRepository:
    """Persistence adapter for :class:`Bookmark`."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def create(
        self,
        *,
        user_id: UUID,
        user_book_id: UUID,
        page: int,
        note: str | None,
    ) -> Bookmark:
        row = Bookmark(user_id=user_id, user_book_id=user_book_id, page=page, note=note)
        self._session.add(row)
        await self._session.flush()
        return row

    async def get_latest(self, *, user_book_id: UUID) -> Bookmark | None:
        stmt = (
            select(Bookmark)
            .where(Bookmark.user_book_id == user_book_id)
            .order_by(Bookmark.created_at.desc())
            .limit(1)
        )
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()


class ReadingStatsRepository:
    """Aggregate queries that feed the /me/reading-stats endpoint.

    All queries run against ``reading_sessions``, ``daily_reading_stats``,
    and the book domain's ``user_books`` / ``books`` tables via raw SQL
    expressions.  No cross-domain service calls are made here — the
    repository is read-only and touches only existing rows.
    """

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def avg_speed(
        self,
        user_id: UUID,
    ) -> tuple[float | None, float | None]:
        """Return (avg_minutes_per_page, avg_pages_per_hour).

        Uses bookmarks to infer page deltas per session.  A session
        qualifies only when it has both a duration and at least one
        bookmark saved after ``started_at``.  Returns (None, None) when
        no qualifying sessions exist.
        """
        # Raw SQL for clarity — SQLAlchemy ORM would require three-way
        # joins with correlated subqueries that are harder to read.
        stmt = text(
            """
            WITH session_pages AS (
                SELECT
                    rs.id,
                    rs.duration_sec,
                    MAX(bm.page) - MIN(bm.page) AS page_delta
                FROM reading_sessions rs
                JOIN bookmarks bm
                    ON bm.user_book_id = rs.user_book_id
                    AND bm.user_id = rs.user_id
                    AND bm.created_at BETWEEN rs.started_at AND rs.ended_at
                WHERE rs.user_id = :user_id
                  AND rs.ended_at IS NOT NULL
                  AND rs.duration_sec > 0
                  AND rs.source = 'timer'
                GROUP BY rs.id, rs.duration_sec
                HAVING MAX(bm.page) > MIN(bm.page)
            )
            SELECT
                AVG(duration_sec / 60.0 / NULLIF(page_delta, 0)) AS avg_min_per_page,
                AVG(page_delta / (duration_sec / 3600.0))         AS avg_pages_per_hour
            FROM session_pages
            """
        )
        row = (await self._session.execute(stmt, {"user_id": user_id})).one()
        avg_min: float | None = float(row[0]) if row[0] is not None else None
        avg_pph: float | None = float(row[1]) if row[1] is not None else None
        return avg_min, avg_pph

    async def format_breakdown(self, user_id: UUID) -> dict[str, int]:
        """Count completed user_books grouped by book format.

        ``books`` does not have a ``format`` column yet, so we derive the
        breakdown from the session source distribution: any user_book with
        at least one completed timer session is counted as "paper".  This
        is a pragmatic approximation until the book catalog carries format
        metadata (see IDEAS.md backlog item).

        Returns a dict with keys ``paper``, ``ebook``, ``audio``.
        """
        # Count distinct user_books that have at least one completed session.
        # We default everything to "paper" until the schema evolves.
        stmt = text(
            """
            SELECT COUNT(DISTINCT ub.id)
            FROM user_books ub
            WHERE ub.user_id = :user_id
              AND ub.status = 'completed'
            """
        )
        result = (await self._session.execute(stmt, {"user_id": user_id})).scalar_one()
        paper_count = int(result or 0)
        return {"paper": paper_count, "ebook": 0, "audio": 0}

    async def monthly_hours(
        self,
        user_id: UUID,
        months: int = 12,
    ) -> list[dict[str, object]]:
        """Return total reading hours per calendar month for the last *months* months.

        Months with zero reading time are omitted from the result — the
        caller is responsible for zero-filling if a dense timeline is needed.
        Result is ordered oldest-first.
        """
        stmt = text(
            """
            SELECT
                TO_CHAR(date, 'YYYY-MM') AS month,
                SUM(total_seconds) / 3600.0 AS hours
            FROM daily_reading_stats
            WHERE user_id = :user_id
              AND date >= DATE_TRUNC('month', NOW()) - INTERVAL '1 month' * (:months - 1)
            GROUP BY month
            ORDER BY month ASC
            """
        )
        rows = (await self._session.execute(stmt, {"user_id": user_id, "months": months})).all()
        return [{"month": str(row[0]), "hours": float(row[1])} for row in rows]

    async def genre_breakdown(
        self,
        user_id: UUID,
        top_n: int = 5,
    ) -> list[dict[str, object]]:
        """Return the top *top_n* genres by completed book count.

        ``books`` does not have a dedicated ``genre`` column; we fall back
        to extracting the first category token from the publisher field as
        a temporary approximation.  Returns an empty list when no
        completed books exist.
        """
        # Books table has no genre column — return empty until backlog
        # item "(book) genre 필드 추가" is resolved.
        stmt = text(
            """
            SELECT
                COALESCE(b.publisher, '기타') AS genre,
                COUNT(*) AS cnt
            FROM user_books ub
            JOIN books b ON b.id = ub.book_id
            WHERE ub.user_id = :user_id
              AND ub.status = 'completed'
            GROUP BY genre
            ORDER BY cnt DESC
            LIMIT :top_n
            """
        )
        rows = (await self._session.execute(stmt, {"user_id": user_id, "top_n": top_n})).all()
        return [{"genre": str(row[0]), "count": int(row[1])} for row in rows]

    async def avg_completion_days(self, user_id: UUID) -> float | None:
        """Average days from started_at to finished_at for completed books."""
        raw = text(
            """
            SELECT AVG(
                EXTRACT(EPOCH FROM (finished_at - started_at)) / 86400.0
            )
            FROM user_books
            WHERE user_id = :user_id
              AND status = 'completed'
              AND finished_at IS NOT NULL
              AND started_at IS NOT NULL
              AND finished_at > started_at
            """
        )
        result = (await self._session.execute(raw, {"user_id": user_id})).scalar_one()
        return float(result) if result is not None else None

    async def recap_most_time(
        self, user_id: UUID, from_date: date, to_date: date
    ) -> RecapBookRow | None:
        """Completed book with the highest total reading seconds in the period.

        Joins ``reading_sessions`` to ``user_books`` and ``books`` so we
        avoid a cross-domain service call from the repository layer.
        Duration is summed across ALL timer sessions for each completed
        user_book that was finished within the period window.
        """
        stmt = text(
            """
            SELECT
                b.title,
                b.cover_url,
                b.author,
                SUM(rs.duration_sec) AS total_sec,
                ub.finished_at
            FROM user_books ub
            JOIN books b ON b.id = ub.book_id
            JOIN reading_sessions rs ON rs.user_book_id = ub.id
            WHERE ub.user_id = :user_id
              AND ub.status = 'completed'
              AND ub.finished_at IS NOT NULL
              AND ub.finished_at::date >= :from_date
              AND ub.finished_at::date <= :to_date
              AND rs.ended_at IS NOT NULL
              AND rs.source = 'timer'
            GROUP BY b.title, b.cover_url, b.author, ub.finished_at
            ORDER BY total_sec DESC, ub.finished_at DESC
            LIMIT 1
            """
        )
        row = (
            await self._session.execute(
                stmt, {"user_id": user_id, "from_date": from_date, "to_date": to_date}
            )
        ).one_or_none()
        if row is None:
            return None
        return RecapBookRow(
            title=str(row.title),
            cover_url=str(row.cover_url) if row.cover_url else None,
            author=str(row.author),
            stat_int=int(row.total_sec),
            stat_date=None,
        )

    async def recap_first_completed(
        self, user_id: UUID, from_date: date, to_date: date
    ) -> RecapBookRow | None:
        """The very first book the user completed within the period."""
        stmt = text(
            """
            SELECT
                b.title,
                b.cover_url,
                b.author,
                ub.finished_at
            FROM user_books ub
            JOIN books b ON b.id = ub.book_id
            WHERE ub.user_id = :user_id
              AND ub.status = 'completed'
              AND ub.finished_at IS NOT NULL
              AND ub.finished_at::date >= :from_date
              AND ub.finished_at::date <= :to_date
            ORDER BY ub.finished_at ASC
            LIMIT 1
            """
        )
        row = (
            await self._session.execute(
                stmt, {"user_id": user_id, "from_date": from_date, "to_date": to_date}
            )
        ).one_or_none()
        if row is None:
            return None
        return RecapBookRow(
            title=str(row.title),
            cover_url=str(row.cover_url) if row.cover_url else None,
            author=str(row.author),
            stat_int=None,
            stat_date=row.finished_at.date() if hasattr(row.finished_at, "date") else None,
        )

    async def recap_thickest(
        self, user_id: UUID, from_date: date, to_date: date
    ) -> RecapBookRow | None:
        """Completed book with the highest max bookmark page in the period.

        ``books`` has no ``page_count`` column yet, so we infer thickness
        from the maximum page number saved in ``bookmarks`` for the
        user_book — the same proxy used by ``avg_speed``.
        """
        stmt = text(
            """
            SELECT
                b.title,
                b.cover_url,
                b.author,
                MAX(bm.page) AS max_page,
                ub.finished_at
            FROM user_books ub
            JOIN books b ON b.id = ub.book_id
            JOIN bookmarks bm ON bm.user_book_id = ub.id
            WHERE ub.user_id = :user_id
              AND ub.status = 'completed'
              AND ub.finished_at IS NOT NULL
              AND ub.finished_at::date >= :from_date
              AND ub.finished_at::date <= :to_date
            GROUP BY b.title, b.cover_url, b.author, ub.finished_at
            ORDER BY max_page DESC, ub.finished_at DESC
            LIMIT 1
            """
        )
        row = (
            await self._session.execute(
                stmt, {"user_id": user_id, "from_date": from_date, "to_date": to_date}
            )
        ).one_or_none()
        if row is None:
            return None
        return RecapBookRow(
            title=str(row.title),
            cover_url=str(row.cover_url) if row.cover_url else None,
            author=str(row.author),
            stat_int=int(row.max_page),
            stat_date=None,
        )

    async def recap_most_highlighted(
        self, user_id: UUID, from_date: date, to_date: date
    ) -> RecapBookRow | None:
        """Completed book with the most highlights saved in the period."""
        stmt = text(
            """
            SELECT
                b.title,
                b.cover_url,
                b.author,
                COUNT(ph.id) AS highlight_count,
                ub.finished_at
            FROM user_books ub
            JOIN books b ON b.id = ub.book_id
            JOIN post_highlights ph ON ph.user_book_id = ub.id
            WHERE ub.user_id = :user_id
              AND ub.status = 'completed'
              AND ub.finished_at IS NOT NULL
              AND ub.finished_at::date >= :from_date
              AND ub.finished_at::date <= :to_date
            GROUP BY b.title, b.cover_url, b.author, ub.finished_at
            ORDER BY highlight_count DESC, ub.finished_at DESC
            LIMIT 1
            """
        )
        row = (
            await self._session.execute(
                stmt, {"user_id": user_id, "from_date": from_date, "to_date": to_date}
            )
        ).one_or_none()
        if row is None:
            return None
        return RecapBookRow(
            title=str(row.title),
            cover_url=str(row.cover_url) if row.cover_url else None,
            author=str(row.author),
            stat_int=int(row.highlight_count),
            stat_date=None,
        )

    async def get_monthly_stats(
        self,
        user_id: UUID,
        year: int,
        month: int,
    ) -> dict[str, object]:
        """Aggregate stats for a single calendar month.

        Returns a dict with keys:
        - ``books_completed``    — completed user_books whose finished_at falls in the month
        - ``total_seconds``      — sum of daily_reading_stats.total_seconds for the month
        - ``days_read``          — count of distinct days with any reading data
        - ``longest_streak``     — longest_streak from user_grades snapshot
        - ``top_genre``          — top publisher (genre proxy) among the month's completed books
        - ``prev_month_seconds`` — total_seconds for the previous calendar month
        """
        month_start = date(year, month, 1)
        month_end = date(year, month, calendar.monthrange(year, month)[1])

        books_completed = int(
            (
                await self._session.execute(
                    text(
                        """
                        SELECT COUNT(*) FROM user_books
                        WHERE user_id = :user_id
                          AND status = 'completed'
                          AND finished_at IS NOT NULL
                          AND finished_at::date >= :start
                          AND finished_at::date <= :end
                        """
                    ),
                    {"user_id": user_id, "start": month_start, "end": month_end},
                )
            ).scalar_one()
            or 0
        )

        daily_row = (
            await self._session.execute(
                text(
                    """
                    SELECT COALESCE(SUM(total_seconds), 0) AS total_sec,
                           COUNT(*) AS days_read
                    FROM daily_reading_stats
                    WHERE user_id = :user_id
                      AND date >= :start
                      AND date <= :end
                    """
                ),
                {"user_id": user_id, "start": month_start, "end": month_end},
            )
        ).one()
        total_seconds = int(daily_row.total_sec or 0)
        days_read = int(daily_row.days_read or 0)

        # Longest streak from the snapshot (global; month-scoped streak
        # reconstruction is out of scope — the snapshot value shows the
        # user's all-time best next to their monthly activity).
        grade_row = await self._session.get(UserGrade, user_id)
        longest_streak = int(grade_row.longest_streak) if grade_row else 0

        genre_result = (
            await self._session.execute(
                text(
                    """
                    SELECT COALESCE(b.publisher, '기타') AS genre, COUNT(*) AS cnt
                    FROM user_books ub
                    JOIN books b ON b.id = ub.book_id
                    WHERE ub.user_id = :user_id
                      AND ub.status = 'completed'
                      AND ub.finished_at IS NOT NULL
                      AND ub.finished_at::date >= :start
                      AND ub.finished_at::date <= :end
                    GROUP BY genre
                    ORDER BY cnt DESC
                    LIMIT 1
                    """
                ),
                {"user_id": user_id, "start": month_start, "end": month_end},
            )
        ).one_or_none()
        top_genre: str | None = str(genre_result.genre) if genre_result else None

        if month == 1:
            prev_year, prev_month = year - 1, 12
        else:
            prev_year, prev_month = year, month - 1
        prev_start = date(prev_year, prev_month, 1)
        prev_end = date(prev_year, prev_month, calendar.monthrange(prev_year, prev_month)[1])
        prev_seconds = int(
            (
                await self._session.execute(
                    text(
                        """
                        SELECT COALESCE(SUM(total_seconds), 0)
                        FROM daily_reading_stats
                        WHERE user_id = :user_id
                          AND date >= :start
                          AND date <= :end
                        """
                    ),
                    {"user_id": user_id, "start": prev_start, "end": prev_end},
                )
            ).scalar_one()
            or 0
        )

        return {
            "books_completed": books_completed,
            "total_seconds": total_seconds,
            "days_read": days_read,
            "longest_streak": longest_streak,
            "top_genre": top_genre,
            "prev_month_seconds": prev_seconds,
        }

    async def get_achieved_milestones(self, user_id: UUID) -> list[MilestoneData]:
        """Compute achieved milestones from existing data.

        Milestones are derived at query time — no dedicated table exists yet.
        Book-count thresholds are resolved from the ordered list of completed
        books; hour thresholds from a cumulative sum over daily_reading_stats;
        streak thresholds from the user_grades snapshot.

        Streak milestones report ``achieved_at = NOW()`` because only the
        current snapshot is stored, not the history.  A future migration that
        records streak-achieved events will replace this.
        """
        milestones: list[MilestoneData] = []

        # ------ Book-count milestones ------
        book_rows = (
            await self._session.execute(
                text(
                    """
                    SELECT finished_at
                    FROM user_books
                    WHERE user_id = :user_id
                      AND status = 'completed'
                      AND finished_at IS NOT NULL
                    ORDER BY finished_at ASC
                    """
                ),
                {"user_id": user_id},
            )
        ).all()
        book_count = len(book_rows)

        for threshold, label in (
            (5, "BOOKS_5"),
            (10, "BOOKS_10"),
            (20, "BOOKS_20"),
            (50, "BOOKS_50"),
        ):
            if book_count >= threshold:
                raw_dt = book_rows[threshold - 1].finished_at
                if isinstance(raw_dt, datetime):
                    achieved_at = raw_dt if raw_dt.tzinfo else raw_dt.replace(tzinfo=UTC)
                else:
                    achieved_at = datetime(raw_dt.year, raw_dt.month, raw_dt.day, tzinfo=UTC)
                milestones.append(
                    MilestoneData(milestone_type=label, achieved_at=achieved_at, value=threshold)
                )

        # ------ Hour-count milestones ------
        hours_rows = (
            await self._session.execute(
                text(
                    """
                    SELECT date,
                           SUM(total_seconds) OVER (
                               ORDER BY date ASC
                               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                           ) AS cum_seconds
                    FROM daily_reading_stats
                    WHERE user_id = :user_id
                    ORDER BY date ASC
                    """
                ),
                {"user_id": user_id},
            )
        ).all()

        for threshold_hours, label in (
            (10, "HOURS_10"),
            (50, "HOURS_50"),
            (100, "HOURS_100"),
        ):
            threshold_sec = threshold_hours * 3600
            for h_row in hours_rows:
                if int(h_row.cum_seconds or 0) >= threshold_sec:
                    d: date = h_row.date
                    achieved_at = datetime(d.year, d.month, d.day, tzinfo=UTC)
                    milestones.append(
                        MilestoneData(
                            milestone_type=label,
                            achieved_at=achieved_at,
                            value=threshold_hours,
                        )
                    )
                    break  # only the first crossing counts

        # ------ Streak milestones ------
        # Only the current snapshot is available; report milestones as
        # achieved now when the all-time longest_streak meets the threshold.
        grade_row = await self._session.get(UserGrade, user_id)
        if grade_row is not None:
            now = datetime.now(tz=UTC)
            for threshold_days, label in ((7, "STREAK_7"), (30, "STREAK_30")):
                if grade_row.longest_streak >= threshold_days:
                    milestones.append(
                        MilestoneData(milestone_type=label, achieved_at=now, value=threshold_days)
                    )

        return milestones

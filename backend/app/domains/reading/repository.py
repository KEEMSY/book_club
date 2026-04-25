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

from datetime import date, datetime
from uuid import UUID

from sqlalchemy import and_, select
from sqlalchemy.dialects.postgresql import insert as pg_insert
from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.exceptions import ConflictError, NotFoundError
from app.domains.reading.models import (
    DailyReadingStat,
    Goal,
    GoalPeriod,
    ReadingSession,
    ReadingSessionSource,
    UserGrade,
)


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

"""SQLAlchemy async repository for the challenge domain.

All queries use the session injected at construction time; callers (providers)
are responsible for committing or rolling back the surrounding transaction.

Design choices:
- ``list_challenges`` filters by status using server-side ``func.now()`` so
  the DB time zone is authoritative, not the application host.
- ``leaderboard`` JOINs to the users table and returns (participant, user)
  tuples so the service layer can build ranked entries in a single round-trip.
- ``batch_get_participants`` / ``batch_participant_counts`` enable the service
  layer to load viewer participation data for a whole page of challenges in 2
  queries instead of 2N (avoids N+1 in list_challenges).
- ``update_progress`` uses a plain UPDATE; the caller decides the new value
  so the method stays generic (usable by both manual admin edits and event
  handlers).
- ``award_badge`` lets ``IntegrityError`` propagate — callers should guard
  with ``has_badge`` first; double-award should never be attempted silently.
"""

from __future__ import annotations

from datetime import datetime
from uuid import UUID

from sqlalchemy import ColumnElement, delete, func, select, update
from sqlalchemy.ext.asyncio import AsyncSession

from app.domains.auth.models import User
from app.domains.challenge.models import (
    Badge,
    BadgeCategory,
    Challenge,
    ChallengeParticipant,
    UserBadge,
)


class ChallengeRepository:
    """Concrete SQLAlchemy async repository for challenges and badges."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    # ------------------------------------------------------------------
    # Challenges
    # ------------------------------------------------------------------

    async def list_challenges(
        self,
        status: str | None,
        limit: int,
        cursor_at: datetime | None,
    ) -> list[Challenge]:
        """Return challenges filtered by status with cursor pagination.

        status values: "active" | "upcoming" | "ended" | None (all).
        Cursor is the ends_at of the last item in the previous page.
        """
        now = func.now()
        conditions: list[ColumnElement[bool]] = []

        if status == "active":
            conditions.append(Challenge.starts_at <= now)
            conditions.append(Challenge.ends_at >= now)
        elif status == "upcoming":
            conditions.append(Challenge.starts_at > now)
        elif status == "ended":
            conditions.append(Challenge.ends_at < now)

        if cursor_at is not None:
            conditions.append(Challenge.ends_at > cursor_at)

        stmt = select(Challenge)
        if conditions:
            from sqlalchemy import and_

            stmt = stmt.where(and_(*conditions))

        stmt = stmt.order_by(Challenge.ends_at.asc()).limit(limit)
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

    async def get_challenge(self, challenge_id: UUID) -> Challenge | None:
        """Return the challenge with the given id, or None."""
        stmt = select(Challenge).where(Challenge.id == challenge_id)
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()

    # ------------------------------------------------------------------
    # Participation
    # ------------------------------------------------------------------

    async def get_participant(
        self, challenge_id: UUID, user_id: UUID
    ) -> ChallengeParticipant | None:
        """Return the participation record, or None when the user has not joined."""
        stmt = select(ChallengeParticipant).where(
            ChallengeParticipant.challenge_id == challenge_id,
            ChallengeParticipant.user_id == user_id,
        )
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()

    async def join(self, challenge_id: UUID, user_id: UUID) -> ChallengeParticipant:
        """Insert a participation record and return it."""
        row = ChallengeParticipant(challenge_id=challenge_id, user_id=user_id)
        self._session.add(row)
        await self._session.flush()
        await self._session.refresh(row)
        return row

    async def leave(self, challenge_id: UUID, user_id: UUID) -> None:
        """Delete the participation record (no-op when not present)."""
        stmt = delete(ChallengeParticipant).where(
            ChallengeParticipant.challenge_id == challenge_id,
            ChallengeParticipant.user_id == user_id,
        )
        await self._session.execute(stmt)
        await self._session.flush()

    async def leaderboard(
        self, challenge_id: UUID, limit: int = 50
    ) -> list[tuple[ChallengeParticipant, User]]:
        """Return top-N participants with their user rows, ordered by progress DESC."""
        stmt = (
            select(ChallengeParticipant, User)
            .join(User, User.id == ChallengeParticipant.user_id)
            .where(
                ChallengeParticipant.challenge_id == challenge_id,
                User.deleted_at.is_(None),
            )
            .order_by(ChallengeParticipant.current_value.desc())
            .limit(limit)
        )
        result = await self._session.execute(stmt)
        return [(row.ChallengeParticipant, row.User) for row in result]

    async def my_challenges(
        self, user_id: UUID, limit: int = 20
    ) -> list[tuple[Challenge, ChallengeParticipant]]:
        """Return challenges the user has joined, most recently joined first."""
        stmt = (
            select(Challenge, ChallengeParticipant)
            .join(
                ChallengeParticipant,
                ChallengeParticipant.challenge_id == Challenge.id,
            )
            .where(ChallengeParticipant.user_id == user_id)
            .order_by(ChallengeParticipant.joined_at.desc())
            .limit(limit)
        )
        result = await self._session.execute(stmt)
        return [(row.Challenge, row.ChallengeParticipant) for row in result]

    async def participant_count(self, challenge_id: UUID) -> int:
        """Return the number of participants in a challenge."""
        from sqlalchemy import func as sqlfunc

        stmt = (
            select(sqlfunc.count())
            .select_from(ChallengeParticipant)
            .where(ChallengeParticipant.challenge_id == challenge_id)
        )
        result = await self._session.execute(stmt)
        return result.scalar_one()

    async def batch_get_participants(
        self,
        challenge_ids: list[UUID],
        user_id: UUID,
    ) -> dict[UUID, ChallengeParticipant | None]:
        """Fetch viewer's participant rows for multiple challenges in one query."""
        if not challenge_ids:
            return {}
        stmt = select(ChallengeParticipant).where(
            ChallengeParticipant.challenge_id.in_(challenge_ids),
            ChallengeParticipant.user_id == user_id,
        )
        result = await self._session.execute(stmt)
        by_challenge = {row.challenge_id: row for row in result.scalars().all()}
        return {cid: by_challenge.get(cid) for cid in challenge_ids}

    async def batch_participant_counts(
        self,
        challenge_ids: list[UUID],
    ) -> dict[UUID, int]:
        """Count participants for multiple challenges in one query."""
        if not challenge_ids:
            return {}
        stmt = (
            select(
                ChallengeParticipant.challenge_id,
                func.count().label("cnt"),
            )
            .where(ChallengeParticipant.challenge_id.in_(challenge_ids))
            .group_by(ChallengeParticipant.challenge_id)
        )
        result = await self._session.execute(stmt)
        counts = {row.challenge_id: row.cnt for row in result}
        return {cid: counts.get(cid, 0) for cid in challenge_ids}

    async def update_progress(
        self,
        challenge_id: UUID,
        user_id: UUID,
        value: int,
        achieved_at: datetime | None,
    ) -> None:
        """Overwrite the participant's current_value and achieved_at."""
        stmt = (
            update(ChallengeParticipant)
            .where(
                ChallengeParticipant.challenge_id == challenge_id,
                ChallengeParticipant.user_id == user_id,
            )
            .values(current_value=value, achieved_at=achieved_at)
        )
        await self._session.execute(stmt)
        await self._session.flush()

    # ------------------------------------------------------------------
    # Badges
    # ------------------------------------------------------------------

    async def has_badge(self, user_id: UUID, badge_id: UUID) -> bool:
        """Return True when the user already owns this badge."""
        stmt = select(UserBadge.user_id).where(
            UserBadge.user_id == user_id,
            UserBadge.badge_id == badge_id,
        )
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none() is not None

    async def award_badge(self, user_id: UUID, badge_id: UUID) -> UserBadge:
        """Insert a UserBadge row and return it."""
        row = UserBadge(user_id=user_id, badge_id=badge_id)
        self._session.add(row)
        await self._session.flush()
        await self._session.refresh(row)
        return row

    async def list_badges(self, category: str | None) -> list[Badge]:
        """Return all badges, optionally filtered by category."""
        stmt = select(Badge)
        if category is not None:
            stmt = stmt.where(Badge.category == BadgeCategory(category))
        stmt = stmt.order_by(Badge.created_at.asc())
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

    async def my_badges(self, user_id: UUID) -> list[tuple[Badge, UserBadge]]:
        """Return badges earned by the user, most recently earned first."""
        stmt = (
            select(Badge, UserBadge)
            .join(UserBadge, UserBadge.badge_id == Badge.id)
            .where(UserBadge.user_id == user_id)
            .order_by(UserBadge.earned_at.desc())
        )
        result = await self._session.execute(stmt)
        return [(row.Badge, row.UserBadge) for row in result]

    async def badge_earner_count(self, badge_id: UUID) -> int:
        """Return the number of users who have earned a badge."""
        from sqlalchemy import func as sqlfunc

        stmt = select(sqlfunc.count()).select_from(UserBadge).where(UserBadge.badge_id == badge_id)
        result = await self._session.execute(stmt)
        return result.scalar_one()

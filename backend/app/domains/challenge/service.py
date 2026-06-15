"""Challenge domain service — challenges, leaderboards, and badges.

Depends only on the concrete ``ChallengeRepository`` (no external HTTP
boundaries, so no Port abstraction layer is needed; CLAUDE.md §3.2 allows
1:1 repo/impl when there is no multi-implementation boundary).

Business rules enforced here:
- ``join``: raises ``AlreadyJoinedError`` (409) when the user is already a
  participant; raises ``ChallengeEndedError`` (409) when ends_at < now.
- ``leave``: raises ``NotFoundError`` when the user is not a participant.
- ``evaluate_progress``: placeholder — will be wired to reading events in a
  future milestone.

All view-model dataclasses are imported from ``schemas.py`` so the router can
depend solely on the service and schema modules without importing ORM types.
"""

from __future__ import annotations

import contextlib
import os
from collections.abc import Callable
from dataclasses import dataclass, field
from datetime import UTC, datetime
from uuid import UUID

from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker

from app.core.exceptions import ConflictError, NotFoundError
from app.domains.challenge.events import BadgeEarned
from app.domains.challenge.models import ChallengeParticipant
from app.domains.challenge.repository import ChallengeRepository
from app.domains.challenge.schemas import (
    BadgeView,
    BadgeWithEarnedAt,
    ChallengeDetailView,
    ChallengePage,
    ChallengePublic,
    LeaderboardEntry,
    MyBadgeItem,
    MyChallengeItem,
)
from app.shared.event_bus import EventBus, commit_and_publish
from app.shared.event_bus import stage_event as _stage_to_session


class AlreadyJoinedError(Exception):
    """The user is already participating in this challenge."""

    status_code: int = 409
    code: str = "ALREADY_JOINED"


class ChallengeEndedError(Exception):
    """The challenge has already ended — new joins are not allowed."""

    status_code: int = 409
    code: str = "CHALLENGE_ENDED"


def _icon_url(icon_key: str) -> str:
    """Compose a full URL from an R2 object key using R2_BASE_URL env var."""
    base = os.environ.get("R2_BASE_URL", "").rstrip("/")
    if not base:
        return icon_key
    return f"{base}/{icon_key}"


@dataclass(slots=True)
class ChallengeService:
    """Orchestrates challenge lifecycle, progress tracking, and badge awards.

    Two operating modes:
    - **Request-scoped** (router path): ``repo`` holds the request session;
      ``stage_event`` is a closure over that session. ``sessionmaker`` / ``bus``
      are None.
    - **Event-handler** (bus subscriber): ``sessionmaker`` and ``bus`` are set;
      each handler opens a fresh session, wires ``commit_and_publish``, and
      commits independently. ``repo`` and ``stage_event`` may be placeholders.
    """

    repo: ChallengeRepository | None
    stage_event: Callable[[object], None] | None = field(default=None)
    sessionmaker: async_sessionmaker[AsyncSession] | None = field(default=None)
    bus: EventBus | None = field(default=None)

    def _get_repo(self) -> ChallengeRepository:
        """Return the request-scoped repo, asserting it is set."""
        assert self.repo is not None, "repo required in request-scoped mode"
        return self.repo

    async def list_challenges(
        self,
        viewer_id: UUID,
        status: str | None,
        limit: int,
        cursor: str | None,
    ) -> ChallengePage:
        """Return a page of challenges with viewer-specific participation flags."""
        cursor_dt: datetime | None = None
        if cursor is not None:
            with contextlib.suppress(ValueError):
                cursor_dt = datetime.fromisoformat(cursor)

        clamped = max(1, min(limit, 50))
        challenges = await self._get_repo().list_challenges(status, clamped, cursor_dt)

        # Batch-fetch participant rows and counts — 2 queries for any page size.
        challenge_ids = [ch.id for ch in challenges]
        participants = await self._get_repo().batch_get_participants(challenge_ids, viewer_id)
        counts = await self._get_repo().batch_participant_counts(challenge_ids)

        items: list[ChallengePublic] = []
        for ch in challenges:
            p = participants.get(ch.id)
            items.append(
                ChallengePublic(
                    id=ch.id,
                    title=ch.title,
                    description=ch.description,
                    challenge_type=ch.challenge_type,
                    target_value=ch.target_value,
                    genre_filter=ch.genre_filter,
                    starts_at=ch.starts_at,
                    ends_at=ch.ends_at,
                    participant_count=counts.get(ch.id, 0),
                    is_joined=p is not None,
                    my_progress=p.current_value if p else None,
                    achieved_at=p.achieved_at if p else None,
                    badge=None,  # badge detail omitted in list view for performance
                    is_limited=ch.is_limited,
                    ends_at_exclusive=ch.ends_at_exclusive,
                )
            )

        next_cursor: str | None = None
        if len(challenges) == clamped:
            next_cursor = challenges[-1].ends_at.isoformat()

        return ChallengePage(items=items, next_cursor=next_cursor)

    async def get_challenge_detail(
        self, challenge_id: UUID, viewer_id: UUID
    ) -> ChallengeDetailView:
        """Return full challenge detail including viewer participation info."""
        ch = await self._get_repo().get_challenge(challenge_id)
        if ch is None:
            raise NotFoundError("challenge not found", code="CHALLENGE_NOT_FOUND")

        participant = await self._get_repo().get_participant(challenge_id, viewer_id)
        count = await self._get_repo().participant_count(challenge_id)

        badge_view: BadgeView | None = None
        if ch.badge_id is not None:
            badges = await self._get_repo().list_badges(None)
            badge_orm = next((b for b in badges if b.id == ch.badge_id), None)
            if badge_orm is not None:
                badge_view = BadgeView(
                    id=badge_orm.id,
                    name=badge_orm.name,
                    description=badge_orm.description,
                    category=badge_orm.category,
                    icon_url=_icon_url(badge_orm.icon_key),
                )

        return ChallengeDetailView(
            id=ch.id,
            title=ch.title,
            description=ch.description,
            challenge_type=ch.challenge_type,
            target_value=ch.target_value,
            genre_filter=ch.genre_filter,
            starts_at=ch.starts_at,
            ends_at=ch.ends_at,
            participant_count=count,
            is_joined=participant is not None,
            my_progress=participant.current_value if participant else None,
            achieved_at=participant.achieved_at if participant else None,
            badge=badge_view,
            is_limited=ch.is_limited,
            ends_at_exclusive=ch.ends_at_exclusive,
        )

    async def join(self, challenge_id: UUID, user_id: UUID) -> ChallengeParticipant:
        """Join the user to the challenge.

        Raises:
            NotFoundError: challenge does not exist.
            ChallengeEndedError: ends_at is in the past.
            AlreadyJoinedError: user is already a participant.
        """
        ch = await self._get_repo().get_challenge(challenge_id)
        if ch is None:
            raise NotFoundError("challenge not found", code="CHALLENGE_NOT_FOUND")

        now = datetime.now(tz=UTC)
        if ch.ends_at.replace(tzinfo=UTC) < now:
            raise ChallengeEndedError("challenge has already ended")

        existing = await self._get_repo().get_participant(challenge_id, user_id)
        if existing is not None:
            raise AlreadyJoinedError("already participating in this challenge")

        return await self._get_repo().join(challenge_id, user_id)

    async def leave(self, challenge_id: UUID, user_id: UUID) -> None:
        """Remove the user from the challenge.

        Raises:
            NotFoundError: user is not a participant.
        """
        existing = await self._get_repo().get_participant(challenge_id, user_id)
        if existing is None:
            raise NotFoundError("not participating in this challenge", code="NOT_PARTICIPANT")
        await self._get_repo().leave(challenge_id, user_id)

    async def leaderboard(self, challenge_id: UUID, limit: int) -> list[LeaderboardEntry]:
        """Return ranked participant list for a challenge."""
        ch = await self._get_repo().get_challenge(challenge_id)
        if ch is None:
            raise NotFoundError("challenge not found", code="CHALLENGE_NOT_FOUND")

        clamped = max(1, min(limit, 100))
        rows = await self._get_repo().leaderboard(challenge_id, clamped)

        entries: list[LeaderboardEntry] = []
        for rank, (participant, user) in enumerate(rows, start=1):
            entries.append(
                LeaderboardEntry(
                    rank=rank,
                    user_id=participant.user_id,
                    nickname=user.nickname,
                    profile_image_url=user.profile_image_url,
                    current_value=participant.current_value,
                    achieved_at=participant.achieved_at,
                )
            )
        return entries

    async def my_challenges(self, user_id: UUID) -> list[MyChallengeItem]:
        """Return challenges the user has joined."""
        rows = await self._get_repo().my_challenges(user_id)
        return [
            MyChallengeItem(
                id=ch.id,
                title=ch.title,
                challenge_type=ch.challenge_type,
                target_value=ch.target_value,
                starts_at=ch.starts_at,
                ends_at=ch.ends_at,
                current_value=p.current_value,
                achieved_at=p.achieved_at,
                joined_at=p.joined_at,
            )
            for ch, p in rows
        ]

    async def list_badges(self, category: str | None) -> list[BadgeView]:
        """Return all badges, optionally filtered by category."""
        badges = await self._get_repo().list_badges(category)
        return [
            BadgeView(
                id=b.id,
                name=b.name,
                description=b.description,
                category=b.category,
                icon_url=_icon_url(b.icon_key),
            )
            for b in badges
        ]

    async def my_badges(self, user_id: UUID) -> list[MyBadgeItem]:
        """Return badges earned by the user."""
        rows = await self._get_repo().my_badges(user_id)
        return [
            MyBadgeItem(
                badge=BadgeWithEarnedAt(
                    id=b.id,
                    name=b.name,
                    description=b.description,
                    category=b.category,
                    icon_url=_icon_url(b.icon_key),
                    earned_at=ub.earned_at,
                )
            )
            for b, ub in rows
        ]

    async def reorder_pinned_badges(
        self,
        user_id: UUID,
        badge_ids: list[UUID],
    ) -> None:
        """Set pin_order for the given badges in the supplied order.

        Raises:
            NotFoundError: one or more badge_ids are not owned by the user.
        """
        if badge_ids:
            owned = await self._get_repo().my_badges(user_id)
            owned_ids = {ub.badge_id for _, ub in owned}
            unknown = [str(bid) for bid in badge_ids if bid not in owned_ids]
            if unknown:
                raise NotFoundError(
                    f"badges not owned by user: {', '.join(unknown)}",
                    code="BADGE_NOT_OWNED",
                )

        await self._get_repo().reorder_pinned_badges(user_id, badge_ids)

    async def award_badge(self, user_id: UUID, badge_id: UUID) -> None:
        """Award a badge to the user if they do not already own it.

        Stages a BadgeEarned event so the notification service can push a
        congratulatory message after the transaction commits.
        Raises:
            NotFoundError: badge does not exist.
            ConflictError: badge_id is the exclusive badge of a limited-edition
                challenge whose deadline has passed.
        """
        badges = await self._get_repo().list_badges(None)
        badge = next((b for b in badges if b.id == badge_id), None)
        if badge is None:
            raise NotFoundError("badge not found", code="BADGE_NOT_FOUND")

        # Prevent manual award of an exclusive badge after its deadline.
        await self._guard_exclusive_badge_deadline(badge_id)

        if await self._get_repo().has_badge(user_id, badge_id):
            return

        await self._get_repo().award_badge(user_id, badge_id)

        if self.stage_event is not None:
            self.stage_event(BadgeEarned(user_id=user_id, badge_id=badge_id, badge_name=badge.name))

    async def _guard_exclusive_badge_deadline(self, badge_id: UUID) -> None:
        """Raise ConflictError if badge_id is an expired limited-edition exclusive badge.

        A badge is "locked" when it is referenced as badge_id_exclusive by a
        limited-edition challenge whose ends_at_exclusive has already passed.
        This prevents even admin manual awards once the deadline has closed.
        """
        challenge = await self._get_repo().get_limited_challenge_by_exclusive_badge(badge_id)
        if challenge is None:
            return
        deadline = challenge.ends_at_exclusive
        if deadline is None:
            return
        if deadline.tzinfo is None:
            deadline = deadline.replace(tzinfo=UTC)
        if datetime.now(tz=UTC) > deadline:
            raise ConflictError(
                "기간이 종료된 챌린지예요.",
                code="CHALLENGE_EXPIRED",
            )

    async def on_reading_session_completed(self, event: object) -> None:
        """Accumulate reading_time challenge progress when a timer session ends."""
        from app.domains.reading.events import ReadingSessionCompleted

        if not isinstance(event, ReadingSessionCompleted):
            return
        await self._handle_progress_event(
            user_id=event.user_id,
            challenge_type="reading_time",
            delta=event.duration_sec,
            mode="add",
        )

    async def on_user_book_completed(self, event: object) -> None:
        """Increment books_count challenge progress when a book is completed."""
        from app.domains.book.events import UserBookCompleted

        if not isinstance(event, UserBookCompleted):
            return
        await self._handle_progress_event(
            user_id=event.user_id,
            challenge_type="books_count",
            delta=1,
            mode="add",
        )

    async def on_grade_recomputed(self, event: object) -> None:
        """Update streak challenge progress to the max of current and new streak_days."""
        from app.domains.reading.events import UserGradeRecomputed

        if not isinstance(event, UserGradeRecomputed):
            return
        await self._handle_progress_event(
            user_id=event.user_id,
            challenge_type="streak",
            delta=event.streak_days,
            mode="max",
        )

    async def _handle_progress_event(
        self,
        *,
        user_id: UUID,
        challenge_type: str,
        delta: int,
        mode: str,
    ) -> None:
        """Open a fresh session and advance challenges for this event.

        Each event gets its own transaction so a failure in one user's
        challenge update doesn't roll back unrelated work. BadgeEarned events
        are staged on the fresh session so they publish only if this commit
        succeeds.
        """
        if self.sessionmaker is None or self.bus is None:
            return

        async with self.sessionmaker() as session:
            repo = ChallengeRepository(session)

            def _stage(ev: object) -> None:
                _stage_to_session(session, ev)

            commit_and_publish(session, self.bus)
            await self._advance_challenges(
                repo=repo,
                stage=_stage,
                user_id=user_id,
                challenge_type=challenge_type,
                delta=delta,
                mode=mode,
            )
            await session.commit()

    @staticmethod
    async def _advance_challenges(
        *,
        repo: ChallengeRepository,
        stage: Callable[[object], None],
        user_id: UUID,
        challenge_type: str,
        delta: int,
        mode: str,
    ) -> None:
        """Advance all active, unachieved challenges of a given type for a user.

        mode="add": new_value = current + delta
        mode="max": new_value = max(current, delta)
        Award badge + stage BadgeEarned when the target is first crossed.
        """
        rows = await repo.list_user_active_challenges(user_id, challenge_type)
        now = datetime.now(tz=UTC)
        for ch, p in rows:
            new_value = p.current_value + delta if mode == "add" else max(p.current_value, delta)

            achieved_at: datetime | None = None
            if new_value >= ch.target_value:
                achieved_at = now
            await repo.update_progress(ch.id, user_id, new_value, achieved_at)

            if achieved_at is None:
                continue

            # Standard badge award.
            if ch.badge_id is not None:
                badge = await repo.get_badge(ch.badge_id)
                if badge is not None and not await repo.has_badge(user_id, ch.badge_id):
                    await repo.award_badge(user_id, ch.badge_id)
                    stage(BadgeEarned(user_id=user_id, badge_id=ch.badge_id, badge_name=badge.name))

            # Exclusive badge award: only within the limited-edition deadline.
            if ch.is_limited and ch.badge_id_exclusive is not None:
                deadline = ch.ends_at_exclusive
                if deadline is not None:
                    if deadline.tzinfo is None:
                        deadline = deadline.replace(tzinfo=UTC)
                    if now <= deadline:
                        excl_badge = await repo.get_badge(ch.badge_id_exclusive)
                        if excl_badge is not None and not await repo.has_badge(
                            user_id, ch.badge_id_exclusive
                        ):
                            await repo.award_badge(user_id, ch.badge_id_exclusive)
                            stage(
                                BadgeEarned(
                                    user_id=user_id,
                                    badge_id=ch.badge_id_exclusive,
                                    badge_name=excl_badge.name,
                                )
                            )

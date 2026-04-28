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

from app.core.exceptions import NotFoundError
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
    """Orchestrates challenge lifecycle, progress tracking, and badge awards."""

    repo: ChallengeRepository
    stage_event: Callable[[object], None] | None = field(default=None)

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
        challenges = await self.repo.list_challenges(status, clamped, cursor_dt)

        items: list[ChallengePublic] = []
        for ch in challenges:
            participant = await self.repo.get_participant(ch.id, viewer_id)
            count = await self.repo.participant_count(ch.id)
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
                    participant_count=count,
                    is_joined=participant is not None,
                    my_progress=participant.current_value if participant else None,
                    achieved_at=participant.achieved_at if participant else None,
                    badge=None,  # badge detail omitted in list view for performance
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
        ch = await self.repo.get_challenge(challenge_id)
        if ch is None:
            raise NotFoundError("challenge not found", code="CHALLENGE_NOT_FOUND")

        participant = await self.repo.get_participant(challenge_id, viewer_id)
        count = await self.repo.participant_count(challenge_id)

        badge_view: BadgeView | None = None
        if ch.badge_id is not None:
            badges = await self.repo.list_badges(None)
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
        )

    async def join(self, challenge_id: UUID, user_id: UUID) -> ChallengeParticipant:
        """Join the user to the challenge.

        Raises:
            NotFoundError: challenge does not exist.
            ChallengeEndedError: ends_at is in the past.
            AlreadyJoinedError: user is already a participant.
        """
        ch = await self.repo.get_challenge(challenge_id)
        if ch is None:
            raise NotFoundError("challenge not found", code="CHALLENGE_NOT_FOUND")

        now = datetime.now(tz=UTC)
        if ch.ends_at.replace(tzinfo=UTC) < now:
            raise ChallengeEndedError("challenge has already ended")

        existing = await self.repo.get_participant(challenge_id, user_id)
        if existing is not None:
            raise AlreadyJoinedError("already participating in this challenge")

        return await self.repo.join(challenge_id, user_id)

    async def leave(self, challenge_id: UUID, user_id: UUID) -> None:
        """Remove the user from the challenge.

        Raises:
            NotFoundError: user is not a participant.
        """
        existing = await self.repo.get_participant(challenge_id, user_id)
        if existing is None:
            raise NotFoundError("not participating in this challenge", code="NOT_PARTICIPANT")
        await self.repo.leave(challenge_id, user_id)

    async def leaderboard(self, challenge_id: UUID, limit: int) -> list[LeaderboardEntry]:
        """Return ranked participant list for a challenge."""
        ch = await self.repo.get_challenge(challenge_id)
        if ch is None:
            raise NotFoundError("challenge not found", code="CHALLENGE_NOT_FOUND")

        clamped = max(1, min(limit, 100))
        rows = await self.repo.leaderboard(challenge_id, clamped)

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
        rows = await self.repo.my_challenges(user_id)
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
        badges = await self.repo.list_badges(category)
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
        rows = await self.repo.my_badges(user_id)
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

    async def award_badge(self, user_id: UUID, badge_id: UUID) -> None:
        """Award a badge to the user if they do not already own it.

        Stages a BadgeEarned event so the notification service can push a
        congratulatory message after the transaction commits.
        Raises:
            NotFoundError: badge does not exist.
        """
        badges = await self.repo.list_badges(None)
        badge = next((b for b in badges if b.id == badge_id), None)
        if badge is None:
            raise NotFoundError("badge not found", code="BADGE_NOT_FOUND")

        if await self.repo.has_badge(user_id, badge_id):
            return

        await self.repo.award_badge(user_id, badge_id)

        if self.stage_event is not None:
            self.stage_event(BadgeEarned(user_id=user_id, badge_id=badge_id, badge_name=badge.name))

    async def evaluate_progress(self, user_id: UUID, event_type: str) -> None:
        """Placeholder — will be connected to reading events in a future milestone."""
        # TODO(sy, M10): wire to ReadingSessionCompleted events and
        # update challenge progress automatically.
        pass

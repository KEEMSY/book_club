"""Referral domain service — invite-link lifecycle.

Business rules:
- ``get_my_referral``: lazily generates a code on first call.  The code is a
  6-character uppercase alphanumeric string stored on the ``users`` row.
- ``apply_referral``: a user may apply at most one referral code (idempotent).
  Applying your own code is rejected (ConflictError).  An unknown code raises
  NotFoundError (propagated from the repository).
- ``complete_referral_if_eligible``: called by the reading router after a
  timer session ends.  Only the *first* qualifying session (duration ≥ 60 s)
  triggers the completion.  The repository method is a no-op when no open
  referral row exists, so the reading flow is always safe to call this.
"""

from __future__ import annotations

from dataclasses import dataclass
from uuid import UUID

from app.core.exceptions import ConflictError
from app.domains.referral.repository import ReferralRepository
from app.domains.referral.schemas import ReferralStatsResponse

_MIN_ELIGIBLE_DURATION_SEC = 60


@dataclass(slots=True)
class ReferralService:
    """Orchestrates referral use cases."""

    repo: ReferralRepository

    async def get_my_referral(self, user_id: UUID) -> ReferralStatsResponse:
        """Return (or generate) the caller's invite code with conversion stats."""
        code = await self.repo.get_or_create_code(user_id)
        invited, completed = await self.repo.get_stats(user_id)
        return ReferralStatsResponse(
            code=code,
            invited_count=invited,
            completed_count=completed,
        )

    async def apply_referral(self, *, referee_id: UUID, code: str) -> None:
        """Apply a referral code for ``referee_id``.

        Normalises the code to uppercase before lookup so mobile clients can
        send either case without errors.
        """
        normalised = code.upper()

        # Prevent self-referral by checking whether the code belongs to the
        # referee themselves before hitting the DB lookup in the repository.
        own_code = await self.repo.get_or_create_code(referee_id)
        if own_code == normalised:
            raise ConflictError("cannot apply your own referral code", code="SELF_REFERRAL")

        await self.repo.apply_referral(referee_id=referee_id, code=normalised)

    async def complete_referral_if_eligible(
        self, *, user_id: UUID, duration_sec: int
    ) -> None:
        """Complete a pending referral when the session meets the duration gate.

        Designed to be called unconditionally from the reading router after
        every timer session — it is always a no-op when there is no open
        referral row or the session is too short.
        """
        if duration_sec < _MIN_ELIGIBLE_DURATION_SEC:
            return
        await self.repo.complete_referral(user_id)

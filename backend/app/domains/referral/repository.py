"""SQLAlchemy async repository for the referral domain.

All queries run on the AsyncSession injected at request time so they share
the same transaction as the rest of the request.

Public surface:
- ``get_or_create_code`` — return (and lazily generate) the user's invite code.
- ``get_stats``         — invited / completed counts for a referrer.
- ``apply_referral``    — record a new referee using a code (idempotent).
- ``complete_referral`` — stamp completed_at on the open referral row.
- ``has_any_completed_session`` — guard used before completing a referral.
"""

from __future__ import annotations

import random
import string
from dataclasses import dataclass
from datetime import UTC, datetime
from uuid import UUID

from sqlalchemy import func, select, update
from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.exceptions import NotFoundError
from app.domains.auth.models import User
from app.domains.referral.models import Referral

_CODE_CHARS = string.ascii_uppercase + string.digits
_CODE_LENGTH = 6
_MAX_COLLISION_RETRIES = 5


def _random_code() -> str:
    """Generate a random 6-character alphanumeric code (uppercase)."""
    return "".join(random.choices(_CODE_CHARS, k=_CODE_LENGTH))


@dataclass(slots=True)
class ReferralRepository:
    """Concrete repository — all DB I/O for the referral domain."""

    session: AsyncSession

    async def get_or_create_code(self, user_id: UUID) -> str:
        """Return the user's referral code, generating one if absent.

        Retries on unique-constraint collisions (extremely unlikely for a
        6-char alphanumeric space of 2.18 billion combinations).
        """
        result = await self.session.execute(
            select(User.referral_code).where(User.id == user_id)
        )
        existing = result.scalar_one_or_none()
        if existing is not None:
            return existing

        for _ in range(_MAX_COLLISION_RETRIES):
            code = _random_code()
            try:
                await self.session.execute(
                    update(User).where(User.id == user_id).values(referral_code=code)
                )
                # Flush to trigger the unique constraint check before we return.
                await self.session.flush()
                return code
            except IntegrityError:
                # Another concurrent request picked the same code — try again.
                await self.session.rollback()

        # Astronomically unlikely; surface as a server error rather than
        # silently failing.
        raise RuntimeError("referral code generation failed after max retries")

    async def get_stats(self, user_id: UUID) -> tuple[int, int]:
        """Return (invited_count, completed_count) for the given referrer."""
        invited_result = await self.session.execute(
            select(func.count()).where(Referral.referrer_id == user_id)
        )
        invited_count: int = invited_result.scalar_one()

        completed_result = await self.session.execute(
            select(func.count()).where(
                Referral.referrer_id == user_id,
                Referral.completed_at.is_not(None),
            )
        )
        completed_count: int = completed_result.scalar_one()

        return invited_count, completed_count

    async def apply_referral(self, *, referee_id: UUID, code: str) -> None:
        """Record that ``referee_id`` signed up using ``code``.

        Raises ``NotFoundError`` when the code does not match any user.
        Silently ignores duplicates (idempotent — only one row per referee).
        """
        # Resolve the referrer by their code.
        referrer_result = await self.session.execute(
            select(User.id).where(User.referral_code == code)
        )
        referrer_id: UUID | None = referrer_result.scalar_one_or_none()
        if referrer_id is None:
            raise NotFoundError(
                f"referral code '{code}' not found", code="REFERRAL_CODE_NOT_FOUND"
            )

        # Idempotency: do nothing if this referee already has a referral row.
        existing_result = await self.session.execute(
            select(Referral.id).where(Referral.referee_id == referee_id)
        )
        if existing_result.scalar_one_or_none() is not None:
            return

        self.session.add(
            Referral(
                referrer_id=referrer_id,
                referee_id=referee_id,
                code=code,
            )
        )
        await self.session.flush()

    async def complete_referral(self, referee_id: UUID) -> None:
        """Stamp ``completed_at`` on the open referral row for ``referee_id``.

        No-op when there is no matching open row (e.g. user joined without a
        referral code, or the referral was already completed).
        """
        await self.session.execute(
            update(Referral)
            .where(
                Referral.referee_id == referee_id,
                Referral.completed_at.is_(None),
            )
            .values(completed_at=datetime.now(tz=UTC))
        )
        await self.session.flush()

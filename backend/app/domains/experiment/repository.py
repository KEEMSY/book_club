"""SQLAlchemy async repository for the experiment domain.

Variant assignment uses a deterministic SHA-256 hash of ``user_id +
experiment_key`` modulo the number of variants, so a given user always lands
in the same bucket without needing a random draw stored upfront.  The INSERT
is attempted only when no row exists; if another request races us we fall back
to the existing row via the UNIQUE constraint.
"""

from __future__ import annotations

import hashlib
from dataclasses import dataclass
from datetime import UTC, datetime
from uuid import UUID

from sqlalchemy import func, select, update
from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.asyncio import AsyncSession

from app.domains.experiment.models import Experiment, UserExperiment


@dataclass(slots=True)
class ExperimentRepository:
    """Persistence adapter for :class:`Experiment` and :class:`UserExperiment`."""

    session: AsyncSession

    async def get_active_experiments(self) -> list[Experiment]:
        """Return all experiments where ``is_active`` is true."""
        result = await self.session.execute(
            select(Experiment).where(Experiment.is_active.is_(True))
        )
        return list(result.scalars().all())

    async def get_or_assign_variant(
        self,
        *,
        user_id: UUID,
        experiment_key: str,
        variants: list[str],
    ) -> UserExperiment:
        """Return the existing assignment or create a new deterministic one.

        The variant index is derived from SHA-256(user_id_hex + experiment_key)
        modulo the number of variants, guaranteeing the same bucket every time
        without storing a random seed.
        """
        # Fast path: row already exists.
        existing = await self.session.scalar(
            select(UserExperiment).where(
                UserExperiment.user_id == user_id,
                UserExperiment.experiment_key == experiment_key,
            )
        )
        if existing is not None:
            return existing

        # Deterministic variant selection.
        digest = hashlib.sha256(f"{user_id.hex}{experiment_key}".encode()).hexdigest()
        variant = variants[int(digest, 16) % len(variants)]

        row = UserExperiment(
            user_id=user_id,
            experiment_key=experiment_key,
            variant=variant,
        )
        self.session.add(row)
        try:
            await self.session.flush()
            await self.session.refresh(row)
            return row
        except IntegrityError:
            # Concurrent insert won the race; roll back and return what is there.
            await self.session.rollback()
            result = await self.session.scalar(
                select(UserExperiment).where(
                    UserExperiment.user_id == user_id,
                    UserExperiment.experiment_key == experiment_key,
                )
            )
            # result cannot be None here: the UNIQUE constraint guarantees a row exists.
            assert result is not None
            return result

    async def get_assignments(self, user_id: UUID) -> list[UserExperiment]:
        """Return all variant assignments for the given user."""
        result = await self.session.execute(
            select(UserExperiment).where(UserExperiment.user_id == user_id)
        )
        return list(result.scalars().all())

    async def record_conversion(self, *, user_id: UUID, experiment_key: str) -> None:
        """Set ``converted_at = now()`` for the matching assignment row.

        A missing row is silently ignored — the client may have been assigned
        the experiment but the row hasn't been written yet (race) or the
        experiment key is stale.
        """
        await self.session.execute(
            update(UserExperiment)
            .where(
                UserExperiment.user_id == user_id,
                UserExperiment.experiment_key == experiment_key,
                UserExperiment.converted_at.is_(None),
            )
            .values(converted_at=datetime.now(tz=UTC))
        )
        await self.session.flush()

    async def get_experiment_stats(self, experiment_key: str) -> dict[str, dict[str, int | float]]:
        """Return per-variant conversion counts for the given experiment.

        Result shape: {variant: {total: int, converted: int, conversion_rate: float}}
        """
        result = await self.session.execute(
            select(
                UserExperiment.variant,
                func.count(UserExperiment.id).label("total"),
                func.count(UserExperiment.converted_at).label("converted"),
            )
            .where(UserExperiment.experiment_key == experiment_key)
            .group_by(UserExperiment.variant)
        )
        rows = result.all()
        stats: dict[str, dict[str, int | float]] = {}
        for row in rows:
            total: int = row.total
            converted: int = row.converted
            rate = converted / total if total > 0 else 0.0
            stats[row.variant] = {
                "total": total,
                "converted": converted,
                "conversion_rate": round(rate, 4),
            }
        return stats

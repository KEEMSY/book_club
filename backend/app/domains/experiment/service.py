"""Domain service for A/B experiment management.

Keeps all orchestration logic out of the router layer (CLAUDE.md §3.1).
The service drives variant assignment lazily: active experiments are fetched,
and each one that lacks a row for the current user gets a deterministic row
written on the spot.
"""

from __future__ import annotations

from dataclasses import dataclass
from uuid import UUID

from app.domains.experiment.repository import ExperimentRepository
from app.domains.experiment.schemas import (
    ExperimentAssignment,
    ExperimentStatsResponse,
    UserExperimentsResponse,
    VariantStats,
)


@dataclass(slots=True)
class ExperimentService:
    """Orchestrates experiment assignment and conversion tracking."""

    repo: ExperimentRepository

    async def get_user_assignments(self, user_id: UUID) -> UserExperimentsResponse:
        """Return the authenticated user's assignment for every active experiment.

        Assignments are created deterministically on first access so the client
        always receives a variant without a separate enrolment call.
        """
        experiments = await self.repo.get_active_experiments()
        assignments: list[ExperimentAssignment] = []
        for experiment in experiments:
            row = await self.repo.get_or_assign_variant(
                user_id=user_id,
                experiment_key=experiment.experiment_key,
                variants=experiment.variants,
            )
            assignments.append(
                ExperimentAssignment(
                    experiment_key=row.experiment_key,
                    variant=row.variant,
                    assigned_at=row.assigned_at,
                )
            )
        return UserExperimentsResponse(assignments=assignments)

    async def record_conversion(self, *, user_id: UUID, experiment_key: str) -> None:
        """Mark the user as converted for the given experiment.

        Conversion means the user completed a Pro subscription purchase.
        Missing assignments are silently skipped.
        """
        await self.repo.record_conversion(user_id=user_id, experiment_key=experiment_key)

    async def get_experiment_stats(self, experiment_key: str) -> ExperimentStatsResponse:
        """Return per-variant conversion statistics for the given experiment key."""
        raw = await self.repo.get_experiment_stats(experiment_key)
        stats = {
            variant: VariantStats(
                total=int(data["total"]),
                converted=int(data["converted"]),
                conversion_rate=float(data["conversion_rate"]),
            )
            for variant, data in raw.items()
        }
        return ExperimentStatsResponse(experiment_key=experiment_key, stats=stats)

"""Pydantic v2 request / response schemas for the experiment domain."""

from __future__ import annotations

from datetime import datetime

from pydantic import BaseModel


class ExperimentAssignment(BaseModel):
    """Single experiment assignment for the authenticated user."""

    experiment_key: str
    variant: str
    assigned_at: datetime


class UserExperimentsResponse(BaseModel):
    """All active experiment assignments for the authenticated user."""

    assignments: list[ExperimentAssignment]


class RecordConversionRequest(BaseModel):
    """Body for POST /me/experiments/conversion."""

    experiment_key: str


class VariantStats(BaseModel):
    """Per-variant conversion statistics for an experiment."""

    total: int
    converted: int
    conversion_rate: float


class ExperimentStatsResponse(BaseModel):
    """Conversion statistics keyed by variant name."""

    experiment_key: str
    stats: dict[str, VariantStats]

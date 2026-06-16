"""Pydantic schemas for the retention domain API surface."""

from __future__ import annotations

from pydantic import BaseModel, Field


class StreakRecoverResponse(BaseModel):
    """Response for POST /me/streak/recover."""

    recovered_days: int = Field(..., description="Number of streak days recovered (always 1).")
    recoveries_remaining: int = Field(
        ..., description="Recovery slots remaining in the current 30-day window."
    )


class StreakRecoveryStatusResponse(BaseModel):
    """Response for GET /me/streak/recovery-status."""

    recoveries_used: int = Field(..., description="Recoveries used in the last 30 days.")
    recoveries_remaining: int = Field(..., description="Recovery slots still available.")


class CampaignRunResponse(BaseModel):
    """Response for POST /admin/retention/run-campaign."""

    pushes_sent: int = Field(..., description="Number of re-engagement pushes dispatched.")


class RetentionStatsResponse(BaseModel):
    """Response for GET /admin/retention/stats."""

    pushes_sent_last_7d: int = Field(
        ..., description="Re-engagement pushes dispatched in the last 7 days."
    )
    streak_recoveries_last_30d: int = Field(
        ..., description="Streak recoveries performed in the last 30 days."
    )
    inactive_users_7d: int = Field(
        ..., description="Users with no activity in the last 7 days."
    )

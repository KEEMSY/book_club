"""Pydantic v2 request / response schemas for the referral domain."""

from __future__ import annotations

from pydantic import BaseModel, Field


class ReferralStatsResponse(BaseModel):
    """Referral code plus conversion counts for the authenticated user."""

    code: str
    # Number of users who signed up using this code.
    invited_count: int
    # Number of those who completed their first qualifying reading session.
    completed_count: int


class ApplyReferralRequest(BaseModel):
    """Body for POST /me/referral/apply."""

    code: str = Field(min_length=6, max_length=8)

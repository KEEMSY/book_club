from __future__ import annotations

from uuid import UUID

from pydantic import BaseModel, Field

from app.domains.discovery.strategies import RecommendationStrategy


class RecommendedBookPublic(BaseModel):
    id: UUID
    title: str
    author: str
    cover_url: str | None = None
    reason: str
    strategy: RecommendationStrategy = RecommendationStrategy.COLLABORATIVE


class RecommendationResponse(BaseModel):
    items: list[RecommendedBookPublic]


# ------------------------------------------------------------------
# Onboarding interest schemas
# ------------------------------------------------------------------


class OnboardingInterestItem(BaseModel):
    category: str = Field(
        description="Interest category: 'genre', 'author', or 'keyword'"
    )
    value: str = Field(max_length=64)


class SaveOnboardingInterestsRequest(BaseModel):
    interests: list[OnboardingInterestItem] = Field(max_length=50)


class OnboardingInterestPublic(BaseModel):
    category: str
    value: str


class OnboardingInterestsResponse(BaseModel):
    items: list[OnboardingInterestPublic]

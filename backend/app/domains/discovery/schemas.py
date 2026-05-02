from __future__ import annotations

from uuid import UUID

from pydantic import BaseModel


class RecommendedBookPublic(BaseModel):
    id: UUID
    title: str
    author: str
    cover_url: str | None = None
    reason: str  # "community_popular" | "similar_readers" | "recently_added"


class RecommendationResponse(BaseModel):
    items: list[RecommendedBookPublic]

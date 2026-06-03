"""Item-based collaborative filtering for book recommendations."""

from __future__ import annotations

from app.domains.discovery.ml.port import MLRecommendationPort
from app.domains.discovery.ml.recommender import CollaborativeFilteringRecommender

__all__ = ["CollaborativeFilteringRecommender", "MLRecommendationPort"]

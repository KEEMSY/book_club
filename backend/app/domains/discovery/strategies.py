"""Recommendation strategy enum and cosine-similarity helper.

``RecommendationStrategy`` is the wire-level discriminator accepted by the
``GET /me/recommendations?strategy=`` query parameter.
"""

from __future__ import annotations

import enum
import math


class RecommendationStrategy(enum.StrEnum):
    """Supported recommendation strategies."""

    COLLABORATIVE = "collaborative"  # item-based CF (existing M21 engine)
    SIMILAR_READERS = "similar_readers"  # taste-vector cosine similarity
    TASTE_MATCH = "taste_match"  # direct genre-vector matching
    COLD_START = "cold_start"  # onboarding-interest based


class RecommendationChannel(enum.StrEnum):
    """Curation channels surfaced on the discovery screen (M69).

    Each channel is a distinct angle on "books for you": the reader's taste
    profile, what the community is reading right now, what their clubs are
    reading, and an AI pick derived from their completed-book history.
    """

    TASTE_MATCH = "taste_match"  # genre-vector match against the catalog
    TRENDING = "trending"  # most reading sessions started in last 7 days
    CLUB_PICKS = "club_picks"  # books read by the user's clubs
    AI_PICKS = "ai_picks"  # Claude-generated picks from reading history


def cosine_similarity(a: dict[str, int], b: dict[str, int]) -> float:
    """Compute cosine similarity between two sparse frequency dicts.

    Returns 0.0 when either vector is empty, so callers do not need to guard
    against the zero-vector case.
    """
    if not a or not b:
        return 0.0

    dot = sum(a.get(key, 0) * b[key] for key in b)
    mag_a = math.sqrt(sum(v * v for v in a.values()))
    mag_b = math.sqrt(sum(v * v for v in b.values()))
    if mag_a == 0.0 or mag_b == 0.0:
        return 0.0
    return dot / (mag_a * mag_b)

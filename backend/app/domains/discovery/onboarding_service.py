"""OnboardingService — manage user onboarding interest selections.

Thin service that validates category values and delegates persistence to
``OnboardingInterestRepository``.
"""

from __future__ import annotations

from dataclasses import dataclass
from uuid import UUID

from app.core.exceptions import ConflictError
from app.domains.book.models import UserOnboardingInterest
from app.domains.book.taste_profile_repository import OnboardingInterestRepository

_VALID_CATEGORIES = frozenset({"genre", "author", "keyword"})


@dataclass(slots=True)
class OnboardingService:
    interests_repo: OnboardingInterestRepository

    async def replace_interests(
        self,
        user_id: UUID,
        interests: list[tuple[str, str]],
    ) -> list[UserOnboardingInterest]:
        """Validate and replace the user's onboarding interest set.

        ``interests`` is a list of (category, value) tuples. Raises
        ``ConflictError`` when an unrecognised category is supplied so the
        router can surface HTTP 422 without leaking DB errors.
        """
        for category, _ in interests:
            if category not in _VALID_CATEGORIES:
                raise ConflictError(
                    f"invalid category '{category}'; must be one of {sorted(_VALID_CATEGORIES)}",
                    code="INVALID_INTEREST_CATEGORY",
                )
        return await self.interests_repo.replace_all(user_id, interests)

    async def list_interests(self, user_id: UUID) -> list[UserOnboardingInterest]:
        return await self.interests_repo.list_for_user(user_id)

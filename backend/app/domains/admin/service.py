"""Domain logic for the admin dashboard.

Thin orchestration: the only business rule here is "raise NotFoundError when a
user does not exist".  All SQL lives in ``AdminRepository``.
"""

from __future__ import annotations

from dataclasses import dataclass
from uuid import UUID

from app.core.exceptions import NotFoundError
from app.domains.admin.repository import AdminRepository
from app.domains.admin.schemas import StatsResponse, UserAdminItem, UserAdminPage
from app.domains.auth.models import User


@dataclass(slots=True)
class AdminService:
    """Provides statistics and user-management operations for the admin dashboard."""

    repo: AdminRepository

    async def get_stats(self) -> StatsResponse:
        """Aggregate usage statistics for the dashboard overview."""
        mau, dau, new_users_7d, pro_users = (
            await self.repo.count_mau(),
            await self.repo.count_dau(),
            await self.repo.count_new_users(days=7),
            await self.repo.count_pro_users(),
        )
        return StatsResponse(mau=mau, dau=dau, new_users_7d=new_users_7d, pro_users=pro_users)

    async def list_users(
        self,
        *,
        page: int = 1,
        page_size: int = 20,
        search: str | None = None,
    ) -> UserAdminPage:
        """Paginated user list with an optional nickname/email search filter."""
        total, users = (
            await self.repo.count_users(search=search),
            await self.repo.list_users(page=page, page_size=page_size, search=search),
        )
        return UserAdminPage(
            items=[UserAdminItem.model_validate(u) for u in users],
            total=total,
            page=page,
            page_size=page_size,
        )

    async def get_user(self, user_id: UUID) -> UserAdminItem:
        """Return a single user by ID or raise ``NotFoundError``."""
        user = await self.repo.get_user_by_id(user_id)
        if user is None:
            raise NotFoundError("user not found", code="USER_NOT_FOUND")
        return UserAdminItem.model_validate(user)

    async def patch_user(
        self,
        user_id: UUID,
        *,
        is_active: bool | None,
        is_admin: bool | None,
    ) -> UserAdminItem:
        """Partially update a user's admin flags.

        Raises ``NotFoundError`` when the user does not exist.
        """
        user: User | None = await self.repo.patch_user(
            user_id, is_active=is_active, is_admin=is_admin
        )
        if user is None:
            raise NotFoundError("user not found", code="USER_NOT_FOUND")
        return UserAdminItem.model_validate(user)

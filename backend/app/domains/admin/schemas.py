"""Pydantic schemas for the admin domain.

All response models use ``from_attributes=True`` so they can be built
directly from ORM objects returned by the repository layer.
"""

from __future__ import annotations

from datetime import datetime
from uuid import UUID

from pydantic import BaseModel, ConfigDict


class StatsResponse(BaseModel):
    """Aggregate app-usage statistics for the admin dashboard."""

    mau: int
    """Monthly active users — distinct users with a reading session in the last 30 days."""

    dau: int
    """Daily active users — distinct users with a reading session in the last 24 hours."""

    new_users_7d: int
    """New registrations in the last 7 days."""

    pro_users: int
    """Current count of users with ``is_pro=True``."""


class UserAdminItem(BaseModel):
    """Flattened user record returned by admin user-management endpoints."""

    model_config = ConfigDict(from_attributes=True)

    id: UUID
    nickname: str
    email: str | None
    is_active: bool
    is_admin: bool
    created_at: datetime


class UserAdminPage(BaseModel):
    """Paginated list of users for the admin users endpoint."""

    items: list[UserAdminItem]
    total: int
    page: int
    page_size: int


class PatchUserRequest(BaseModel):
    """Partial update payload for admin user management."""

    is_active: bool | None = None
    is_admin: bool | None = None

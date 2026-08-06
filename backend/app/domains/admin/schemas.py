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


class ConversionFunnelResponse(BaseModel):
    """Paywall conversion funnel: views → clicks → subscriptions (M65)."""

    paywall_views: int
    paywall_clicks: int
    subscriptions: int
    conversion_rate: float
    """subscriptions / paywall_views, in [0, 1]; 0.0 when there are no views."""


class MonthlyMrrPoint(BaseModel):
    """One month of the MRR trend series (M70)."""

    month: str
    """Calendar month as ``YYYY-MM``."""

    mrr: float


class RevenueMetricsResponse(BaseModel):
    """Recurring-revenue snapshot derived from active subscribers (M65, M70)."""

    mrr: float
    """Monthly recurring revenue (KRW), summed from active subscribers' plans."""

    arr: float
    """Annual recurring revenue — ``mrr * 12``."""

    active_subscribers: int
    churned_30d: int
    """Churn events recorded in the last 30 days."""

    team_mrr: float
    """MRR (KRW) from active B2B team plans (M70)."""

    monthly_trend: list[MonthlyMrrPoint]
    """Last 6 months of MRR, oldest first (M70)."""


class UserAdminItem(BaseModel):
    """Flattened user record returned by admin user-management endpoints."""

    model_config = ConfigDict(from_attributes=True)

    id: UUID
    nickname: str
    email: str | None
    is_active: bool
    is_admin: bool
    is_pro: bool
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

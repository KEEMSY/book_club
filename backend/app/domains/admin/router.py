"""HTTP surface for the admin domain — /admin/stats and /admin/users.

All endpoints require a valid access token **and** ``is_admin=True`` on the
requesting user (enforced by ``get_current_admin_id``).
"""

from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, Query

from app.core.deps import get_current_admin_id
from app.domains.admin.providers import get_admin_service
from app.domains.admin.schemas import (
    ConversionFunnelResponse,
    PatchUserRequest,
    RevenueMetricsResponse,
    StatsResponse,
    UserAdminItem,
    UserAdminPage,
)
from app.domains.admin.service import AdminService

router = APIRouter(prefix="/admin", tags=["admin-dashboard"])


@router.get("/stats", response_model=StatsResponse)
async def get_stats(
    _: Annotated[str, Depends(get_current_admin_id)],
    service: Annotated[AdminService, Depends(get_admin_service)],
) -> StatsResponse:
    """Return aggregate usage statistics (MAU, DAU, new users, Pro count)."""
    return await service.get_stats()


@router.get("/conversion-funnel", response_model=ConversionFunnelResponse)
async def get_conversion_funnel(
    _: Annotated[str, Depends(get_current_admin_id)],
    service: Annotated[AdminService, Depends(get_admin_service)],
) -> ConversionFunnelResponse:
    """Paywall conversion funnel: views → clicks → subscriptions."""
    return await service.get_conversion_funnel()


@router.get("/revenue-metrics", response_model=RevenueMetricsResponse)
async def get_revenue_metrics(
    _: Annotated[str, Depends(get_current_admin_id)],
    service: Annotated[AdminService, Depends(get_admin_service)],
) -> RevenueMetricsResponse:
    """Recurring-revenue snapshot — MRR, ARR, active subscribers, 30-day churn."""
    return await service.get_revenue_metrics()


@router.get("/users", response_model=UserAdminPage)
async def list_users(
    _: Annotated[str, Depends(get_current_admin_id)],
    service: Annotated[AdminService, Depends(get_admin_service)],
    page: Annotated[int, Query(ge=1)] = 1,
    page_size: Annotated[int, Query(ge=1, le=100)] = 20,
    search: Annotated[str | None, Query(max_length=200)] = None,
) -> UserAdminPage:
    """Paginated user list.  ``search`` filters by nickname or email (case-insensitive)."""
    return await service.list_users(page=page, page_size=page_size, search=search)


@router.get("/users/{user_id}", response_model=UserAdminItem)
async def get_user(
    user_id: UUID,
    _: Annotated[str, Depends(get_current_admin_id)],
    service: Annotated[AdminService, Depends(get_admin_service)],
) -> UserAdminItem:
    """Return a single user record by ID.  404 when not found or soft-deleted."""
    return await service.get_user(user_id)


@router.patch("/users/{user_id}", response_model=UserAdminItem)
async def patch_user(
    user_id: UUID,
    body: PatchUserRequest,
    _: Annotated[str, Depends(get_current_admin_id)],
    service: Annotated[AdminService, Depends(get_admin_service)],
) -> UserAdminItem:
    """Partially update ``is_active`` or ``is_admin`` for a user.

    Omit a field to leave it unchanged.  404 when user not found.
    """
    return await service.patch_user(
        user_id,
        is_active=body.is_active,
        is_admin=body.is_admin,
    )

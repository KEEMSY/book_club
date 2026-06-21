"""Domain logic for the admin dashboard.

Thin orchestration: the only business rule here is "raise NotFoundError when a
user does not exist".  All SQL lives in ``AdminRepository``.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import UTC, datetime, timedelta
from decimal import Decimal
from uuid import UUID

from app.core.exceptions import NotFoundError
from app.domains.admin.repository import AdminRepository
from app.domains.admin.schemas import (
    ConversionFunnelResponse,
    RevenueMetricsResponse,
    StatsResponse,
    UserAdminItem,
    UserAdminPage,
)
from app.domains.auth.models import User

# Monthly-equivalent KRW price per Pro plan, used to compute MRR from the
# active-subscriber mix. Annual plans are divided across 12 months.
_PRODUCT_MONTHLY_PRICE: dict[str, Decimal] = {
    "monthly_pro_6900": Decimal("6900"),
    "annual_pro_59000": Decimal("59000") / 12,
    "annual_pro_53100": Decimal("53100") / 12,  # early-bird annual
}


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

    async def get_conversion_funnel(self) -> ConversionFunnelResponse:
        """Paywall funnel counts and the view→subscription conversion rate."""
        views = await self.repo.count_subscription_events(event_type="paywall_view")
        clicks = await self.repo.count_subscription_events(event_type="paywall_click")
        subscriptions = await self.repo.count_subscription_events(event_type="subscription")
        conversion_rate = subscriptions / views if views else 0.0
        return ConversionFunnelResponse(
            paywall_views=views,
            paywall_clicks=clicks,
            subscriptions=subscriptions,
            conversion_rate=conversion_rate,
        )

    async def get_revenue_metrics(self) -> RevenueMetricsResponse:
        """MRR/ARR from the active-subscriber plan mix plus 30-day churn."""
        by_product = await self.repo.count_active_subscribers_by_product()
        active_subscribers = sum(by_product.values())
        mrr = sum(
            (
                _PRODUCT_MONTHLY_PRICE.get(product or "", Decimal(0)) * count
                for product, count in by_product.items()
            ),
            Decimal(0),
        )
        churned_30d = await self.repo.count_churned_since(datetime.now(tz=UTC) - timedelta(days=30))
        return RevenueMetricsResponse(
            mrr=float(round(mrr, 2)),
            arr=float(round(mrr * 12, 2)),
            active_subscribers=active_subscribers,
            churned_30d=churned_30d,
        )

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

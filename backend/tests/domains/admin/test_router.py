"""HTTP contract tests for the admin dashboard router.

Uses ``app.dependency_overrides`` for both ``get_admin_service`` (swap in a
fake) and ``get_current_admin_id`` (control whether the caller passes the
is_admin gate) — mirrors the pattern in tests/domains/auth/test_router.py.
No Postgres, no real JWT.
"""

from __future__ import annotations

from collections.abc import AsyncIterator
from datetime import UTC, datetime
from uuid import UUID, uuid4

import pytest
import pytest_asyncio
from app.core.deps import get_current_admin_id
from app.core.exceptions import ConflictError, NotFoundError
from app.domains.admin.providers import get_admin_service
from app.domains.admin.schemas import (
    ConversionFunnelResponse,
    RevenueMetricsResponse,
    StatsResponse,
    UserAdminItem,
    UserAdminPage,
)
from app.main import create_app
from fastapi import HTTPException
from httpx import ASGITransport, AsyncClient


class FakeAdminService:
    """Drop-in replacement for AdminService. Records calls for assertions."""

    def __init__(self) -> None:
        self.patch_calls: list[tuple[UUID, bool | None, bool | None]] = []
        self.fail_patch_with: Exception | None = None
        self.user = UserAdminItem(
            id=uuid4(),
            nickname="책벌레",
            email="reader@example.com",
            is_active=True,
            is_admin=False,
            is_pro=False,
            created_at=datetime.now(tz=UTC),
        )

    async def get_stats(self) -> StatsResponse:
        return StatsResponse(mau=10, dau=3, new_users_7d=2, pro_users=1)

    async def get_conversion_funnel(self) -> ConversionFunnelResponse:
        return ConversionFunnelResponse(
            paywall_views=100, paywall_clicks=20, subscriptions=5, conversion_rate=0.05
        )

    async def get_revenue_metrics(self) -> RevenueMetricsResponse:
        return RevenueMetricsResponse(
            mrr=6900.0,
            arr=82800.0,
            active_subscribers=1,
            churned_30d=0,
            team_mrr=0.0,
            monthly_trend=[],
        )

    async def list_users(
        self, *, page: int = 1, page_size: int = 20, search: str | None = None
    ) -> UserAdminPage:
        return UserAdminPage(items=[self.user], total=1, page=page, page_size=page_size)

    async def get_user(self, user_id: UUID) -> UserAdminItem:
        if user_id != self.user.id:
            raise NotFoundError("user not found", code="USER_NOT_FOUND")
        return self.user

    async def patch_user(
        self, user_id: UUID, *, is_active: bool | None, is_admin: bool | None
    ) -> UserAdminItem:
        self.patch_calls.append((user_id, is_active, is_admin))
        if self.fail_patch_with is not None:
            raise self.fail_patch_with
        updated = self.user.model_copy(
            update={
                "is_active": is_active if is_active is not None else self.user.is_active,
                "is_admin": is_admin if is_admin is not None else self.user.is_admin,
            }
        )
        self.user = updated
        return updated


@pytest_asyncio.fixture
async def admin_client() -> AsyncIterator[tuple[AsyncClient, FakeAdminService]]:
    """Authenticated-as-admin client — ``get_current_admin_id`` passes."""
    app = create_app()
    fake = FakeAdminService()
    app.dependency_overrides[get_admin_service] = lambda: fake
    app.dependency_overrides[get_current_admin_id] = lambda: str(uuid4())
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://testserver") as client:
        yield client, fake


@pytest_asyncio.fixture
async def non_admin_client() -> AsyncIterator[AsyncClient]:
    """Client whose ``get_current_admin_id`` dependency raises 403 — a
    logged-in, non-admin user hitting an admin route."""
    app = create_app()

    def _raise_forbidden() -> str:
        raise HTTPException(status_code=403, detail="admin access required")

    app.dependency_overrides[get_current_admin_id] = _raise_forbidden
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://testserver") as client:
        yield client


# ---------------------------------------------------------------------------
# Gating — every admin endpoint must 403 a non-admin caller
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "method,path",
    [
        ("GET", "/admin/stats"),
        ("GET", "/admin/conversion-funnel"),
        ("GET", "/admin/revenue-metrics"),
        ("GET", "/admin/users"),
        ("GET", f"/admin/users/{uuid4()}"),
        ("PATCH", f"/admin/users/{uuid4()}"),
    ],
)
async def test_admin_endpoints_reject_non_admin(
    non_admin_client: AsyncClient, method: str, path: str
) -> None:
    resp = await non_admin_client.request(method, path, json={} if method == "PATCH" else None)
    assert resp.status_code == 403


# ---------------------------------------------------------------------------
# Happy paths — the surface B2 (mobile admin console) renders
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_get_stats(admin_client: tuple[AsyncClient, FakeAdminService]) -> None:
    client, _ = admin_client
    resp = await client.get("/admin/stats")
    assert resp.status_code == 200
    assert resp.json() == {"mau": 10, "dau": 3, "new_users_7d": 2, "pro_users": 1}


@pytest.mark.asyncio
async def test_get_conversion_funnel(admin_client: tuple[AsyncClient, FakeAdminService]) -> None:
    client, _ = admin_client
    resp = await client.get("/admin/conversion-funnel")
    assert resp.status_code == 200
    assert resp.json()["conversion_rate"] == 0.05


@pytest.mark.asyncio
async def test_get_revenue_metrics(admin_client: tuple[AsyncClient, FakeAdminService]) -> None:
    client, _ = admin_client
    resp = await client.get("/admin/revenue-metrics")
    assert resp.status_code == 200
    assert resp.json()["mrr"] == 6900.0


@pytest.mark.asyncio
async def test_list_users(admin_client: tuple[AsyncClient, FakeAdminService]) -> None:
    client, fake = admin_client
    resp = await client.get("/admin/users", params={"page": 1, "page_size": 20})
    assert resp.status_code == 200
    body = resp.json()
    assert body["total"] == 1
    assert body["items"][0]["id"] == str(fake.user.id)
    assert "is_pro" in body["items"][0]


@pytest.mark.asyncio
async def test_get_user(admin_client: tuple[AsyncClient, FakeAdminService]) -> None:
    client, fake = admin_client
    resp = await client.get(f"/admin/users/{fake.user.id}")
    assert resp.status_code == 200
    assert resp.json()["nickname"] == "책벌레"


@pytest.mark.asyncio
async def test_get_user_missing_returns_404(
    admin_client: tuple[AsyncClient, FakeAdminService],
) -> None:
    client, _ = admin_client
    resp = await client.get(f"/admin/users/{uuid4()}")
    assert resp.status_code == 404


@pytest.mark.asyncio
async def test_patch_user_promotes_to_admin(
    admin_client: tuple[AsyncClient, FakeAdminService],
) -> None:
    client, fake = admin_client
    resp = await client.patch(f"/admin/users/{fake.user.id}", json={"is_admin": True})
    assert resp.status_code == 200
    assert resp.json()["is_admin"] is True
    assert fake.patch_calls == [(fake.user.id, None, True)]


@pytest.mark.asyncio
async def test_patch_user_last_admin_guard_surfaces_as_409(
    admin_client: tuple[AsyncClient, FakeAdminService],
) -> None:
    client, fake = admin_client
    fake.fail_patch_with = ConflictError(
        "마지막 관리자 권한은 해제할 수 없습니다.", code="LAST_ADMIN_PROTECTED"
    )
    resp = await client.patch(f"/admin/users/{fake.user.id}", json={"is_admin": False})
    assert resp.status_code == 409
    assert resp.json()["error"]["code"] == "LAST_ADMIN_PROTECTED"

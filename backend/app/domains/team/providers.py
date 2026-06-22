"""FastAPI dependency factories for the team domain (CLAUDE.md §3.1).

The ``MemberProGrantPort`` adapter delegates the Pro write to the subscription
domain's ``SubscriptionRepository`` so the ``users`` Pro columns stay owned by a
single domain (mirrors the ``ShieldGrantPort`` adapter in subscription).
"""

from __future__ import annotations

from datetime import datetime
from typing import Annotated
from uuid import UUID

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.subscription.repository import SubscriptionRepository
from app.domains.team.repository import TeamRepository
from app.domains.team.service import TeamService


class _SubscriptionProGrantAdapter:
    """Implements ``MemberProGrantPort`` over the subscription repository."""

    def __init__(self, session: AsyncSession) -> None:
        self._repo = SubscriptionRepository(session)

    async def grant_pro(self, *, user_id: UUID, expires_at: datetime, product_id: str) -> None:
        await self._repo.update_subscription(
            user_id, is_pro=True, expires_at=expires_at, product_id=product_id
        )

    async def revoke_pro(self, *, user_id: UUID) -> None:
        await self._repo.update_subscription(
            user_id, is_pro=False, expires_at=None, product_id=None
        )


def get_team_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> TeamService:
    """Construct a ``TeamService`` wired with a live repository and Pro-grant adapter."""
    return TeamService(
        repo=TeamRepository(session),
        pro_grant=_SubscriptionProGrantAdapter(session),
    )

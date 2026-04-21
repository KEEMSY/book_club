"""SQLAlchemy async implementation of the auth repository ports.

The repository layer only knows SQLAlchemy / Postgres; it never raises raw
``IntegrityError`` past its boundary — conflicts are mapped to ``ConflictError``
so the service layer stays transport-agnostic (CLAUDE.md §3.1).
"""

from __future__ import annotations

from datetime import UTC, datetime
from uuid import UUID

from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.exceptions import ConflictError
from app.domains.auth.models import AuthProvider, DevicePlatform, DeviceToken, User


class UserRepository:
    """Persistence adapter for :class:`User`. Implements ``UserRepositoryPort``."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get_by_provider_sub(self, provider: AuthProvider, sub: str) -> User | None:
        stmt = select(User).where(
            User.provider == provider,
            User.provider_sub == sub,
            User.deleted_at.is_(None),
        )
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()

    async def create(
        self,
        *,
        provider: AuthProvider,
        sub: str,
        email: str | None,
        nickname: str,
        profile_image_url: str | None,
    ) -> User:
        user = User(
            provider=provider,
            provider_sub=sub,
            email=email,
            nickname=nickname,
            profile_image_url=profile_image_url,
        )
        self._session.add(user)
        try:
            await self._session.flush()
        except IntegrityError as exc:
            await self._session.rollback()
            raise ConflictError(
                f"user already exists for {provider.value}:{sub}",
                code="USER_ALREADY_EXISTS",
            ) from exc
        await self._session.refresh(user)
        return user

    async def update_last_login(self, user_id: UUID, at: datetime) -> None:
        user = await self._session.get(User, user_id)
        if user is None:
            return
        user.last_login_at = at
        await self._session.flush()

    async def get_by_id(self, user_id: UUID) -> User | None:
        user = await self._session.get(User, user_id)
        if user is None or user.deleted_at is not None:
            return None
        return user

    async def soft_delete(self, user_id: UUID, at: datetime) -> None:
        user = await self._session.get(User, user_id)
        if user is None:
            return
        user.deleted_at = at
        await self._session.flush()


class DeviceTokenRepository:
    """Persistence adapter for :class:`DeviceToken`."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def upsert(self, user_id: UUID, token: str, platform: DevicePlatform) -> DeviceToken:
        existing = await self._get_by_token(token)
        now = datetime.now(tz=UTC)
        if existing is not None:
            existing.user_id = user_id
            existing.platform = platform
            existing.last_seen_at = now
            await self._session.flush()
            return existing

        device = DeviceToken(user_id=user_id, token=token, platform=platform)
        self._session.add(device)
        try:
            await self._session.flush()
        except IntegrityError as exc:
            await self._session.rollback()
            raise ConflictError(
                "device token already exists",
                code="DEVICE_TOKEN_CONFLICT",
            ) from exc
        await self._session.refresh(device)
        return device

    async def get_active_tokens_for_user(self, user_id: UUID) -> list[DeviceToken]:
        stmt = (
            select(DeviceToken)
            .where(DeviceToken.user_id == user_id)
            .order_by(DeviceToken.last_seen_at.desc())
        )
        result = await self._session.execute(stmt)
        return list(result.scalars().all())

    async def touch(self, token: str) -> None:
        existing = await self._get_by_token(token)
        if existing is None:
            return
        existing.last_seen_at = datetime.now(tz=UTC)
        await self._session.flush()

    async def _get_by_token(self, token: str) -> DeviceToken | None:
        stmt = select(DeviceToken).where(DeviceToken.token == token)
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()

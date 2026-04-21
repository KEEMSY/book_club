"""FastAPI dependency factories for the auth domain.

Keeps the router file free of wiring code (CLAUDE.md §3.1) and gives tests a
stable seam: override ``get_auth_service`` with ``app.dependency_overrides``
to inject a FakeAuthService in router tests.
"""

from __future__ import annotations

from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.db import get_session
from app.domains.auth.adapters.apple_oauth_adapter import AppleOAuthAdapter
from app.domains.auth.adapters.kakao_oauth_adapter import KakaoOAuthAdapter
from app.domains.auth.repository import DeviceTokenRepository, UserRepository
from app.domains.auth.service import AuthService


def get_auth_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> AuthService:
    """Construct an AuthService wired with live repositories + adapters."""
    return AuthService(
        users=UserRepository(session),
        device_tokens=DeviceTokenRepository(session),
        kakao=KakaoOAuthAdapter(),
        apple=AppleOAuthAdapter(),
    )

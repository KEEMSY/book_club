"""HTTP surface for the auth domain — /auth/* and /me.

Keep this file thin: every handler is at most a DTO -> service -> DTO
adapter. Business decisions live in ``service.py``. The router never
catches domain exceptions; the global handler translates them.
"""

from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, Response, status

from app.core.config import get_settings
from app.core.deps import get_current_user_id
from app.domains.auth.models import DevicePlatform
from app.domains.auth.providers import get_auth_service
from app.domains.auth.schemas import (
    AppleLoginRequest,
    DeviceTokenRegisterRequest,
    KakaoLoginRequest,
    LoginResponse,
    RefreshRequest,
    RefreshResponse,
    UserPublic,
)
from app.domains.auth.service import AuthService

router = APIRouter(tags=["auth"])


def _login_response(access: str, refresh: str, user: object, is_new_user: bool) -> LoginResponse:
    settings = get_settings()
    return LoginResponse(
        access_token=access,
        refresh_token=refresh,
        expires_in=settings.jwt_access_ttl_seconds,
        user=UserPublic.model_validate(user),
        is_new_user=is_new_user,
    )


@router.post("/auth/kakao", response_model=LoginResponse)
async def login_with_kakao(
    body: KakaoLoginRequest,
    service: Annotated[AuthService, Depends(get_auth_service)],
) -> LoginResponse:
    result = await service.login_with_kakao(access_token=body.access_token)
    return _login_response(
        result.access_token, result.refresh_token, result.user, result.is_new_user
    )


@router.post("/auth/apple", response_model=LoginResponse)
async def login_with_apple(
    body: AppleLoginRequest,
    service: Annotated[AuthService, Depends(get_auth_service)],
) -> LoginResponse:
    result = await service.login_with_apple(identity_token=body.identity_token)
    return _login_response(
        result.access_token, result.refresh_token, result.user, result.is_new_user
    )


@router.post("/auth/refresh", response_model=RefreshResponse)
async def refresh(
    body: RefreshRequest,
    service: Annotated[AuthService, Depends(get_auth_service)],
) -> RefreshResponse:
    settings = get_settings()
    result = await service.refresh(refresh_token=body.refresh_token)
    return RefreshResponse(
        access_token=result.access_token,
        refresh_token=result.refresh_token,
        expires_in=settings.jwt_access_ttl_seconds,
    )


@router.post("/auth/device-tokens", status_code=status.HTTP_204_NO_CONTENT)
async def register_device_token(
    body: DeviceTokenRegisterRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[AuthService, Depends(get_auth_service)],
) -> Response:
    await service.register_device_token(
        user_id=UUID(user_id),
        token=body.token,
        platform=DevicePlatform(body.platform),
    )
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@router.get("/me", response_model=UserPublic)
async def get_me(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[AuthService, Depends(get_auth_service)],
) -> UserPublic:
    user = await service.get_me(user_id=UUID(user_id))
    return UserPublic.model_validate(user)


@router.delete("/me", status_code=status.HTTP_204_NO_CONTENT)
async def delete_me(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[AuthService, Depends(get_auth_service)],
) -> Response:
    await service.delete_account(user_id=UUID(user_id))
    return Response(status_code=status.HTTP_204_NO_CONTENT)

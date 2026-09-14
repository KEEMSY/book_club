"""HTTP surface for the auth domain — /auth/* and /me.

Keep this file thin: every handler is at most a DTO -> service -> DTO
adapter. Business decisions live in ``service.py``. The router never
catches domain exceptions; the global handler translates them.
"""

from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, Response, status

from app.core.config import Settings, get_settings
from app.core.deps import get_current_user_id
from app.domains.auth.models import DevicePlatform, ProfileTheme
from app.domains.auth.providers import get_auth_service
from app.domains.auth.schemas import (
    AppleLoginRequest,
    DeviceTokenRegisterRequest,
    DevLoginRequest,
    KakaoLoginRequest,
    LoginResponse,
    RefreshRequest,
    RefreshResponse,
    TrialStatusResponse,
    UpdateProfileRequest,
    UserPublic,
)
from app.domains.auth.service import AuthService
from app.shared.sentinel import UNSET, UnsetType

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
    result = await service.login_with_apple(identity_token=body.identity_token, nonce=body.nonce)
    return _login_response(
        result.access_token, result.refresh_token, result.user, result.is_new_user
    )


@router.post("/auth/dev-login", response_model=LoginResponse)
async def login_dev(
    body: DevLoginRequest,
    service: Annotated[AuthService, Depends(get_auth_service)],
    settings: Annotated[Settings, Depends(get_settings)],
) -> LoginResponse:
    # Dev-only surface. Any non-dev environment gets a flat 404 so the
    # endpoint is indistinguishable from a missing route to an attacker
    # probing the production deploy.
    if settings.env != "dev":
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="not found")
    result = await service.login_dev(nickname=body.nickname, email=body.email)
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


@router.get("/me/trial-status", response_model=TrialStatusResponse)
async def get_my_trial_status(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[AuthService, Depends(get_auth_service)],
) -> TrialStatusResponse:
    """Return the authenticated user's Pro trial window state."""
    status = await service.get_trial_status(user_id=UUID(user_id))
    return TrialStatusResponse(
        is_in_trial=status.is_in_trial,
        trial_ends_at=status.trial_ends_at,
        days_remaining=status.days_remaining,
    )


@router.patch("/me", response_model=UserPublic)
async def update_me(
    body: UpdateProfileRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[AuthService, Depends(get_auth_service)],
) -> UserPublic:
    # A field the client omitted must stay unchanged; a field sent as an
    # explicit ``null`` clears the column (BC-100). ``model_fields_set`` is the
    # only way to tell the two apart, so unsent fields are forwarded as UNSET.
    fields = body.model_fields_set
    theme: ProfileTheme | None | UnsetType = UNSET
    if "theme" in fields:
        theme = ProfileTheme(body.theme) if body.theme is not None else None
    user = await service.update_profile(
        user_id=UUID(user_id),
        nickname=body.nickname,
        bio=body.bio if "bio" in fields else UNSET,
        cover_image_url=body.cover_image_url if "cover_image_url" in fields else UNSET,
        theme=theme,
        featured_book_id=body.featured_book_id if "featured_book_id" in fields else UNSET,
        featured_quote=body.featured_quote if "featured_quote" in fields else UNSET,
    )
    return UserPublic.model_validate(user)


@router.delete("/me", status_code=status.HTTP_204_NO_CONTENT)
async def delete_me(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[AuthService, Depends(get_auth_service)],
) -> Response:
    await service.delete_account(user_id=UUID(user_id))
    return Response(status_code=status.HTTP_204_NO_CONTENT)

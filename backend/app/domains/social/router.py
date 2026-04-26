"""HTTP surface for the social domain.

Prefix: /social. All endpoints require a valid access token (get_current_user_id).

Keep this file thin: every handler is at most a DTO -> service -> DTO adapter.
Business decisions live in ``service.py``. The router never catches domain
exceptions; the global handler translates them (CLAUDE.md §3.1).
"""

from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, Query, Response, status

from app.core.deps import get_current_user_id
from app.domains.social.providers import get_social_service
from app.domains.social.schemas import ReportCreate, UserSummaryPage
from app.domains.social.service import SocialService

router = APIRouter(prefix="/social", tags=["social"])


# ---------------------------------------------------------------------------
# Follow
# ---------------------------------------------------------------------------


@router.post(
    "/follow/{target_user_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def follow_user(
    target_user_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[SocialService, Depends(get_social_service)],
) -> Response:
    await service.follow(UUID(user_id), target_user_id)
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@router.delete(
    "/follow/{target_user_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def unfollow_user(
    target_user_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[SocialService, Depends(get_social_service)],
) -> Response:
    await service.unfollow(UUID(user_id), target_user_id)
    return Response(status_code=status.HTTP_204_NO_CONTENT)


# ---------------------------------------------------------------------------
# My followers / following
# ---------------------------------------------------------------------------


@router.get("/followers", response_model=UserSummaryPage)
async def my_followers(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[SocialService, Depends(get_social_service)],
    cursor: Annotated[str | None, Query()] = None,
    limit: Annotated[int, Query(ge=1, le=50)] = 20,
) -> UserSummaryPage:
    return await service.get_followers(UUID(user_id), UUID(user_id), cursor, limit)


@router.get("/following", response_model=UserSummaryPage)
async def my_following(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[SocialService, Depends(get_social_service)],
    cursor: Annotated[str | None, Query()] = None,
    limit: Annotated[int, Query(ge=1, le=50)] = 20,
) -> UserSummaryPage:
    return await service.get_following(UUID(user_id), UUID(user_id), cursor, limit)


# ---------------------------------------------------------------------------
# Another user's followers / following
# ---------------------------------------------------------------------------


@router.get("/users/{user_id}/followers", response_model=UserSummaryPage)
async def user_followers(
    user_id: UUID,
    actor_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[SocialService, Depends(get_social_service)],
    cursor: Annotated[str | None, Query()] = None,
    limit: Annotated[int, Query(ge=1, le=50)] = 20,
) -> UserSummaryPage:
    return await service.get_followers(UUID(actor_id), user_id, cursor, limit)


@router.get("/users/{user_id}/following", response_model=UserSummaryPage)
async def user_following(
    user_id: UUID,
    actor_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[SocialService, Depends(get_social_service)],
    cursor: Annotated[str | None, Query()] = None,
    limit: Annotated[int, Query(ge=1, le=50)] = 20,
) -> UserSummaryPage:
    return await service.get_following(UUID(actor_id), user_id, cursor, limit)


# ---------------------------------------------------------------------------
# Block
# ---------------------------------------------------------------------------


@router.post(
    "/block/{target_user_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def block_user(
    target_user_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[SocialService, Depends(get_social_service)],
) -> Response:
    await service.block(UUID(user_id), target_user_id)
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@router.delete(
    "/block/{target_user_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def unblock_user(
    target_user_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[SocialService, Depends(get_social_service)],
) -> Response:
    await service.unblock(UUID(user_id), target_user_id)
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@router.get("/blocks", response_model=UserSummaryPage)
async def my_blocks(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[SocialService, Depends(get_social_service)],
    cursor: Annotated[str | None, Query()] = None,
    limit: Annotated[int, Query(ge=1, le=50)] = 20,
) -> UserSummaryPage:
    return await service.get_blocks(UUID(user_id), cursor, limit)


# ---------------------------------------------------------------------------
# Report
# ---------------------------------------------------------------------------


@router.get("/users/explore", response_model=UserSummaryPage)
async def explore_users(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[SocialService, Depends(get_social_service)],
    q: Annotated[str, Query(max_length=64)] = "",
    cursor: Annotated[str | None, Query()] = None,
    limit: Annotated[int, Query(ge=1, le=50)] = 20,
) -> UserSummaryPage:
    return await service.search_users(UUID(user_id), q, cursor, limit)


@router.post(
    "/reports/posts/{post_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def report_post(
    post_id: UUID,
    body: ReportCreate,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[SocialService, Depends(get_social_service)],
) -> Response:
    await service.report(UUID(user_id), "post", post_id, body.reason)
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@router.post(
    "/reports/comments/{comment_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def report_comment(
    comment_id: UUID,
    body: ReportCreate,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[SocialService, Depends(get_social_service)],
) -> Response:
    await service.report(UUID(user_id), "comment", comment_id, body.reason)
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@router.post(
    "/reports/users/{reported_user_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def report_user(
    reported_user_id: UUID,
    body: ReportCreate,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[SocialService, Depends(get_social_service)],
) -> Response:
    await service.report(UUID(user_id), "user", reported_user_id, body.reason)
    return Response(status_code=status.HTTP_204_NO_CONTENT)

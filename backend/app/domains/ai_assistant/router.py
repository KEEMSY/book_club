"""HTTP surface for the ai_assistant domain.

Thin handlers only — DTO ↔ service ↔ DTO. Business rules (caching, rate limits,
Pro gating) live in ``service.py``; domain exceptions propagate to the global
handler (CLAUDE.md §3.1).
"""

from __future__ import annotations

from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends

from app.core.deps import get_current_user_id
from app.domains.ai_assistant.providers import get_ai_assistant_service
from app.domains.ai_assistant.schemas import (
    AiPreferencesResponse,
    AIUsageResponse,
    AudioIntroResponse,
    ClubTopicsRequest,
    ClubTopicsResponse,
    PrepCardResponse,
    ReflectionResponse,
    UpdateAiPreferencesRequest,
)
from app.domains.ai_assistant.service import AIAssistantService

router = APIRouter(tags=["ai_assistant"])


@router.post("/books/{book_id}/ai-prep-card", response_model=PrepCardResponse)
async def create_prep_card(
    book_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[AIAssistantService, Depends(get_ai_assistant_service)],
) -> PrepCardResponse:
    content = await service.get_prep_card(user_id=UUID(user_id), book_id=book_id)
    return PrepCardResponse.from_content(content)


@router.post("/me/library/{user_book_id}/ai-reflection", response_model=ReflectionResponse)
async def create_reflection(
    user_book_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[AIAssistantService, Depends(get_ai_assistant_service)],
) -> ReflectionResponse:
    content = await service.create_reflection(user_id=UUID(user_id), user_book_id=user_book_id)
    return ReflectionResponse.from_content(content)


@router.post("/clubs/{club_id}/ai-discussion-topics", response_model=ClubTopicsResponse)
async def create_discussion_topics(
    club_id: UUID,
    body: ClubTopicsRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[AIAssistantService, Depends(get_ai_assistant_service)],
) -> ClubTopicsResponse:
    content = await service.get_club_topics(
        user_id=UUID(user_id),
        club_id=club_id,
        page_start=body.page_start,
        page_end=body.page_end,
    )
    return ClubTopicsResponse.from_content(content)


@router.post("/books/{book_id}/ai-audio-intro", response_model=AudioIntroResponse)
async def create_audio_intro(
    book_id: UUID,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[AIAssistantService, Depends(get_ai_assistant_service)],
) -> AudioIntroResponse:
    content = await service.get_audio_intro(user_id=UUID(user_id), book_id=book_id)
    return AudioIntroResponse.from_content(content, book_id=str(book_id))


@router.get("/me/ai-preferences", response_model=AiPreferencesResponse)
async def get_ai_preferences(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[AIAssistantService, Depends(get_ai_assistant_service)],
) -> AiPreferencesResponse:
    style = await service.get_card_style(user_id=UUID(user_id))
    return AiPreferencesResponse.from_style(style)


@router.patch("/me/ai-preferences", response_model=AiPreferencesResponse)
async def update_ai_preferences(
    body: UpdateAiPreferencesRequest,
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[AIAssistantService, Depends(get_ai_assistant_service)],
) -> AiPreferencesResponse:
    style = await service.set_card_style(user_id=UUID(user_id), style=body.card_style)
    return AiPreferencesResponse.from_style(style)


@router.get("/me/ai-usage", response_model=AIUsageResponse)
async def get_ai_usage(
    user_id: Annotated[str, Depends(get_current_user_id)],
    service: Annotated[AIAssistantService, Depends(get_ai_assistant_service)],
) -> AIUsageResponse:
    summary = await service.get_usage(user_id=UUID(user_id))
    return AIUsageResponse.from_summary(summary)

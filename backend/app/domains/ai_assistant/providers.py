"""FastAPI dependency wiring for the ai_assistant domain.

Keeps the router free of construction code (CLAUDE.md §3.1) and gives tests a
stable seam (override ``get_ai_assistant_service``). Adapter selection lives
here: when ``ANTHROPIC_API_KEY`` is set we wire the live ``ClaudeAdapter``,
otherwise the ``StubClaudeAdapter`` so dev/test work without a key.
"""

from __future__ import annotations

from functools import lru_cache
from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import get_settings
from app.core.db import get_session
from app.domains.ai_assistant.adapters.claude_adapter import ClaudeAdapter
from app.domains.ai_assistant.adapters.stub_claude_adapter import StubClaudeAdapter
from app.domains.ai_assistant.ports import AIAssistantPort
from app.domains.ai_assistant.repository import (
    AIReflectionRepository,
    AIUsageLogRepository,
    BookInfoAdapter,
    ClubCoachAdapter,
    LibraryQueryAdapter,
    RedisPrepCache,
    UserAiPreferencesRepository,
    UserQueryAdapter,
)
from app.domains.ai_assistant.service import AIAssistantService
from app.domains.club.providers import get_club_service
from app.domains.club.repository import ClubRepository


@lru_cache(maxsize=1)
def _get_ai_adapter() -> AIAssistantPort:
    """Process-wide AI adapter — the live SDK client is reused across requests."""
    settings = get_settings()
    if settings.anthropic_api_key:
        return ClaudeAdapter(api_key=settings.anthropic_api_key, model=settings.anthropic_model)
    return StubClaudeAdapter()


def get_ai_assistant_service(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> AIAssistantService:
    book_info = BookInfoAdapter(session)
    return AIAssistantService(
        ai=_get_ai_adapter(),
        prep_cache=RedisPrepCache(),
        reflections=AIReflectionRepository(session),
        usage=AIUsageLogRepository(session),
        books=book_info,
        users=UserQueryAdapter(session),
        library=LibraryQueryAdapter(session),
        clubs=ClubCoachAdapter(
            club_repo=ClubRepository(session),
            book_info=book_info,
            club_service=get_club_service(session),
        ),
        preferences=UserAiPreferencesRepository(session),
    )

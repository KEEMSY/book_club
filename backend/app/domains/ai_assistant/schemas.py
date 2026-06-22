"""Pydantic request/response DTOs for the ai_assistant HTTP surface.

These are the only place pydantic appears in the domain; the router converts
between them and the domain dataclasses from ``ports.py`` / ``service.py``.
``tokens_used`` is intentionally not exposed to clients — it is an internal
billing/limit signal, not user-facing content.
"""

from __future__ import annotations

from typing import Literal

from pydantic import BaseModel, Field

from app.domains.ai_assistant.ports import (
    AudioIntroContent,
    ClubTopicsContent,
    PrepCardContent,
    ReflectionContent,
)
from app.domains.ai_assistant.service import UsageSummary

CardStyle = Literal["motivational", "analytical", "reflective"]


class PrepCardResponse(BaseModel):
    author_intro: str
    theme_keywords: list[str]
    prereading_questions: list[str]

    @classmethod
    def from_content(cls, content: PrepCardContent) -> PrepCardResponse:
        return cls(
            author_intro=content.author_intro,
            theme_keywords=content.theme_keywords,
            prereading_questions=content.prereading_questions,
        )


class NextBookPublic(BaseModel):
    title: str
    reason: str


class ReflectionResponse(BaseModel):
    insights: list[str]
    action_point: str
    next_books: list[NextBookPublic]

    @classmethod
    def from_content(cls, content: ReflectionContent) -> ReflectionResponse:
        return cls(
            insights=content.insights,
            action_point=content.action_point,
            next_books=[NextBookPublic(title=b.title, reason=b.reason) for b in content.next_books],
        )


class ClubTopicsRequest(BaseModel):
    page_start: int = Field(ge=0)
    page_end: int = Field(ge=0)


class ClubTopicsResponse(BaseModel):
    topics: list[str]

    @classmethod
    def from_content(cls, content: ClubTopicsContent) -> ClubTopicsResponse:
        return cls(topics=content.topics)


class AiPreferencesResponse(BaseModel):
    card_style: CardStyle

    @classmethod
    def from_style(cls, style: str) -> AiPreferencesResponse:
        return cls(card_style=style)  # type: ignore[arg-type]


class UpdateAiPreferencesRequest(BaseModel):
    card_style: CardStyle


class AudioIntroResponse(BaseModel):
    script: str
    book_id: str
    tokens_used: int

    @classmethod
    def from_content(cls, content: AudioIntroContent, *, book_id: str) -> AudioIntroResponse:
        return cls(script=content.script, book_id=book_id, tokens_used=content.tokens_used)


class AIUsageResponse(BaseModel):
    prep_card: int
    reflection: int
    club_topics: int

    @classmethod
    def from_summary(cls, summary: UsageSummary) -> AIUsageResponse:
        return cls(
            prep_card=summary.prep_card,
            reflection=summary.reflection,
            club_topics=summary.club_topics,
        )

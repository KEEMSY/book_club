"""Claude API adapter — the live :class:`AIAssistantPort` implementation.

Wraps the async ``anthropic`` SDK. Generation uses structured outputs
(``output_config.format`` with a JSON schema) so the model returns parseable
JSON in one shot — Haiku 4.5 supports this. The SDK's own retry is disabled and
retries are driven by ``tenacity`` (3 attempts, exponential backoff) so we retry
only the transient classes (timeout / connection / 429 / 5xx) and map everything
else to a domain ``ExternalServiceError``.

Prompts and the persona are Korean: Book Club positions its AI as a reading
*coach* (pre-reading prep + post-completion reflection), not a summarizer
(Phase 14 §5.1). ``ANTHROPIC_API_KEY`` is required to construct this adapter;
``providers.py`` selects the stub when the key is unset.
"""

from __future__ import annotations

import json
import logging
from typing import Any

import anthropic
from tenacity import (
    retry,
    retry_if_exception_type,
    stop_after_attempt,
    wait_exponential,
)

from app.core.exceptions import ExternalServiceError
from app.domains.ai_assistant.ports import (
    AgendaTopicDraftsContent,
    AudioIntroContent,
    ClubTopicsContent,
    NextBookRecommendation,
    PrepCardContent,
    ReflectionContent,
)

logger = logging.getLogger(__name__)

_TIMEOUT_SECONDS = 30.0
_MAX_TOKENS = 1024
_MAX_HIGHLIGHTS = 10

_RETRYABLE = (
    anthropic.APITimeoutError,
    anthropic.APIConnectionError,
    anthropic.RateLimitError,
    anthropic.InternalServerError,
)

_PREP_SYSTEM = (
    "당신은 따뜻하고 통찰력 있는 독서 코치입니다. 독자가 책을 펼치기 전에 "
    "기대감을 갖고 능동적으로 읽도록 돕습니다. 요약이 아니라 '준비'에 집중하세요. "
    "모든 답변은 한국어로 작성합니다."
)

# Per-style persona prepended to the prep-card system prompt (M67). The reader
# picks one of these once; an unknown style falls back to the motivational tone.
_PREP_PERSONAS: dict[str, str] = {
    "motivational": (
        "독자가 책을 펼치고 싶어지도록 동기를 부여하는 힘 있고 따뜻한 어조로 말하세요. "
    ),
    "analytical": (
        "책의 구조와 핵심 논점을 또렷하게 짚어 주는 분석적이고 차분한 어조로 말하세요. "
    ),
    "reflective": (
        "독자가 자신의 삶과 연결해 깊이 사색하도록 이끄는 잔잔하고 성찰적인 어조로 말하세요. "
    ),
}
_REFLECTION_SYSTEM = (
    "당신은 따뜻하고 통찰력 있는 독서 코치입니다. 독자가 방금 완독한 책을 자신의 "
    "삶과 연결해 성찰하도록 돕습니다. 독자가 직접 밑줄 그은 문장에서 출발해 깊이 있는 "
    "통찰을 끌어내세요. 모든 답변은 한국어로 작성합니다."
)
_TOPICS_SYSTEM = (
    "당신은 독서 모임을 이끄는 진행자입니다. 이번 주 읽기 범위를 바탕으로 모임 구성원이 "
    "활발히 대화할 수 있는 토론 주제를 제안합니다. 모든 답변은 한국어로 작성합니다."
)
_AGENDA_TOPICS_SYSTEM = (
    "당신은 독서 모임 발제자를 돕는 진행자입니다. 발제자가 정한 이번 회차의 범위를 "
    "바탕으로, 모임 구성원이 활발히 토론할 수 있는 논제 초안을 제안합니다. 각 논제는 "
    "찬반이 갈리거나 해석의 여지가 있는 개방형 질문으로 작성하세요. 모든 답변은 "
    "한국어로 작성합니다."
)
_AUDIO_INTRO_SYSTEM = (
    "당신은 오디오 독서 코치입니다. 독자가 이어폰으로 들으며 책에 몰입할 수 있도록, "
    "귀로 듣기 좋은 자연스러운 구어체로 책 소개를 들려줍니다. 모든 답변은 한국어로 작성합니다."
)

_PREP_SCHEMA: dict[str, Any] = {
    "type": "object",
    "properties": {
        "author_intro": {
            "type": "string",
            "description": "저자 한 줄 소개와 이 책이 탄생한 배경 (2~3문장)",
        },
        "theme_keywords": {
            "type": "array",
            "items": {"type": "string"},
            "description": "이 책의 핵심 테마 키워드 정확히 3개",
        },
        "prereading_questions": {
            "type": "array",
            "items": {"type": "string"},
            "description": "읽기 전 생각해볼 질문 정확히 2개",
        },
    },
    "required": ["author_intro", "theme_keywords", "prereading_questions"],
    "additionalProperties": False,
}

_REFLECTION_SCHEMA: dict[str, Any] = {
    "type": "object",
    "properties": {
        "insights": {
            "type": "array",
            "items": {"type": "string"},
            "description": "밑줄 문장들을 관통하는 핵심 인사이트 정확히 2개",
        },
        "action_point": {
            "type": "string",
            "description": "일상에 적용 가능한 실천 포인트 1가지",
        },
        "next_books": {
            "type": "array",
            "items": {
                "type": "object",
                "properties": {
                    "title": {"type": "string"},
                    "reason": {"type": "string", "description": "추천 이유 한 문장"},
                },
                "required": ["title", "reason"],
                "additionalProperties": False,
            },
            "description": "이 책과 연결된 다음 읽을 책 추천 정확히 2권",
        },
    },
    "required": ["insights", "action_point", "next_books"],
    "additionalProperties": False,
}

_TOPICS_SCHEMA: dict[str, Any] = {
    "type": "object",
    "properties": {
        "topics": {
            "type": "array",
            "items": {"type": "string"},
            "description": "이번 주 읽기 범위 토론 주제 정확히 3개",
        },
    },
    "required": ["topics"],
    "additionalProperties": False,
}

_AGENDA_TOPICS_SCHEMA: dict[str, Any] = {
    "type": "object",
    "properties": {
        "topics": {
            "type": "array",
            "items": {"type": "string"},
            "minItems": 3,
            "maxItems": 5,
            "description": "발제 범위를 바탕으로 한 논제 초안, 3~5개",
        },
    },
    "required": ["topics"],
    "additionalProperties": False,
}

_AUDIO_INTRO_SCHEMA: dict[str, Any] = {
    "type": "object",
    "properties": {
        "script": {
            "type": "string",
            "description": "귀로 듣기 좋은 구어체 책 소개 스크립트, 한국어로 약 200자",
        },
    },
    "required": ["script"],
    "additionalProperties": False,
}


class ClaudeAdapter:
    """Implements :class:`app.domains.ai_assistant.ports.AIAssistantPort`."""

    def __init__(self, api_key: str, model: str) -> None:
        # SDK retries off — tenacity owns the retry policy below.
        self._client = anthropic.AsyncAnthropic(
            api_key=api_key, timeout=_TIMEOUT_SECONDS, max_retries=0
        )
        self._model = model

    @retry(
        retry=retry_if_exception_type(_RETRYABLE),
        stop=stop_after_attempt(3),
        wait=wait_exponential(multiplier=1, min=1, max=8),
        reraise=True,
    )
    async def _generate(
        self, *, system: str, prompt: str, schema: dict[str, Any]
    ) -> tuple[dict[str, Any], int]:
        try:
            response = await self._client.messages.create(
                model=self._model,
                max_tokens=_MAX_TOKENS,
                system=system,
                messages=[{"role": "user", "content": prompt}],
                output_config={"format": {"type": "json_schema", "schema": schema}},
            )
        except _RETRYABLE:
            raise  # handled by tenacity
        except anthropic.APIError as exc:
            logger.warning("claude_generate failed: %s", exc)
            raise ExternalServiceError(
                "AI 생성에 실패했어요.", code="CLAUDE_REQUEST_FAILED"
            ) from exc

        text = next((b.text for b in response.content if b.type == "text"), "")
        try:
            data: dict[str, Any] = json.loads(text)
        except json.JSONDecodeError as exc:
            logger.warning("claude_generate returned non-JSON body")
            raise ExternalServiceError(
                "AI 응답을 해석하지 못했어요.", code="CLAUDE_BAD_RESPONSE"
            ) from exc

        tokens = response.usage.input_tokens + response.usage.output_tokens
        return data, tokens

    async def generate_prep_card(
        self, *, book_title: str, author: str, description: str | None, style: str
    ) -> PrepCardContent:
        desc = description or "(설명 없음)"
        persona = _PREP_PERSONAS.get(style, _PREP_PERSONAS["motivational"])
        system = persona + _PREP_SYSTEM
        prompt = (
            f"책 제목: {book_title}\n저자: {author}\n책 소개: {desc}\n\n"
            "이 책을 읽기 전에 도움이 될 준비 카드를 만들어 주세요."
        )
        data, tokens = await self._generate(system=system, prompt=prompt, schema=_PREP_SCHEMA)
        return PrepCardContent(
            author_intro=str(data["author_intro"]),
            theme_keywords=[str(k) for k in data["theme_keywords"]],
            prereading_questions=[str(q) for q in data["prereading_questions"]],
            tokens_used=tokens,
        )

    async def generate_reflection(
        self,
        *,
        book_title: str,
        author: str,
        highlights: list[str],
        reading_days: int,
    ) -> ReflectionContent:
        capped = highlights[:_MAX_HIGHLIGHTS]
        highlight_block = (
            "\n".join(f"- {h}" for h in capped) if capped else "(저장된 하이라이트 없음)"
        )
        prompt = (
            f"책 제목: {book_title}\n저자: {author}\n독서 기간: {reading_days}일\n"
            f"독자가 밑줄 그은 문장들:\n{highlight_block}\n\n"
            "이 독자를 위한 완독 성찰 가이드를 만들어 주세요."
        )
        data, tokens = await self._generate(
            system=_REFLECTION_SYSTEM, prompt=prompt, schema=_REFLECTION_SCHEMA
        )
        return ReflectionContent(
            insights=[str(i) for i in data["insights"]],
            action_point=str(data["action_point"]),
            next_books=[
                NextBookRecommendation(title=str(b["title"]), reason=str(b["reason"]))
                for b in data["next_books"]
            ],
            tokens_used=tokens,
        )

    async def generate_club_topics(
        self, *, book_title: str, page_start: int, page_end: int
    ) -> ClubTopicsContent:
        prompt = (
            f"책 제목: {book_title}\n이번 주 읽기 범위: {page_start}~{page_end}쪽\n\n"
            "이 범위를 바탕으로 독서 모임 토론 주제를 만들어 주세요."
        )
        data, tokens = await self._generate(
            system=_TOPICS_SYSTEM, prompt=prompt, schema=_TOPICS_SCHEMA
        )
        return ClubTopicsContent(
            topics=[str(t) for t in data["topics"]],
            tokens_used=tokens,
        )

    async def generate_agenda_topics(
        self, *, book_title: str, author: str, scope: str
    ) -> AgendaTopicDraftsContent:
        prompt = (
            f"책 제목: {book_title}\n저자: {author}\n이번 회차 발제 범위: {scope}\n\n"
            "이 범위를 바탕으로 독서 모임 논제 초안 3~5개를 만들어 주세요."
        )
        data, tokens = await self._generate(
            system=_AGENDA_TOPICS_SYSTEM, prompt=prompt, schema=_AGENDA_TOPICS_SCHEMA
        )
        return AgendaTopicDraftsContent(
            topics=[str(t) for t in data["topics"]],
            tokens_used=tokens,
        )

    async def generate_audio_intro(
        self, *, book_title: str, author: str, description: str | None
    ) -> AudioIntroContent:
        desc = description or "(설명 없음)"
        prompt = (
            f"책 제목: {book_title}\n저자: {author}\n책 소개: {desc}\n\n"
            "이 책을 읽기 전에 들려줄 약 200자 분량의 오디오 소개 스크립트를 만들어 주세요. "
            "이어폰으로 듣기 좋은 자연스러운 구어체로 작성하세요."
        )
        data, tokens = await self._generate(
            system=_AUDIO_INTRO_SYSTEM, prompt=prompt, schema=_AUDIO_INTRO_SCHEMA
        )
        return AudioIntroContent(script=str(data["script"]), tokens_used=tokens)

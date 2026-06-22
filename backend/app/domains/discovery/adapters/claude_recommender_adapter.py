"""Claude-backed :class:`AIBookRecommenderPort` for the ai_picks channel (M69).

Mirrors the structured-output + tenacity pattern of the ai_assistant
``ClaudeAdapter``: the SDK's own retry is off and ``tenacity`` retries only the
transient error classes (timeout / connection / 429 / 5xx), mapping everything
else to a domain ``ExternalServiceError``. The model is asked for exactly three
book picks with a one-line Korean reason each; the discovery repository then
resolves those titles to catalog rows.
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
from app.domains.discovery.ai_port import AIBookSuggestion, CompletedBook

logger = logging.getLogger(__name__)

_TIMEOUT_SECONDS = 30.0
_MAX_TOKENS = 1024

_RETRYABLE = (
    anthropic.APITimeoutError,
    anthropic.APIConnectionError,
    anthropic.RateLimitError,
    anthropic.InternalServerError,
)

_SYSTEM = (
    "당신은 독자의 독서 이력을 분석해 다음에 읽으면 좋을 책을 골라 주는 책 큐레이터입니다. "
    "독자가 최근 완독한 책들의 주제·분위기·저자를 고려해, 새롭지만 취향에 맞는 책을 "
    "추천하세요. 이미 읽은 책은 추천하지 마세요. 모든 답변은 한국어로 작성합니다."
)

_SCHEMA: dict[str, Any] = {
    "type": "object",
    "properties": {
        "recommendations": {
            "type": "array",
            "description": "추천 도서 정확히 3권",
            "items": {
                "type": "object",
                "properties": {
                    "title": {"type": "string", "description": "추천 도서 제목"},
                    "author": {"type": "string", "description": "추천 도서 저자"},
                    "reason": {
                        "type": "string",
                        "description": "이 독자에게 추천하는 이유 한 문장",
                    },
                },
                "required": ["title", "author", "reason"],
                "additionalProperties": False,
            },
        },
    },
    "required": ["recommendations"],
    "additionalProperties": False,
}


class ClaudeBookRecommenderAdapter:
    """Implements :class:`app.domains.discovery.ai_port.AIBookRecommenderPort`."""

    def __init__(self, api_key: str, model: str) -> None:
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
    async def recommend_books(
        self, *, completed_books: list[CompletedBook]
    ) -> list[AIBookSuggestion]:
        history = "\n".join(f"- {b.title} ({b.author})" for b in completed_books)
        prompt = (
            f"독자가 최근 완독한 책 목록:\n{history}\n\n"
            "이 독자가 다음에 읽으면 좋을 책 3권을 추천해 주세요."
        )
        try:
            response = await self._client.messages.create(
                model=self._model,
                max_tokens=_MAX_TOKENS,
                system=_SYSTEM,
                messages=[{"role": "user", "content": prompt}],
                output_config={"format": {"type": "json_schema", "schema": _SCHEMA}},
            )
        except _RETRYABLE:
            raise  # handled by tenacity
        except anthropic.APIError as exc:
            logger.warning("claude_recommend_books failed: %s", exc)
            raise ExternalServiceError(
                "AI 추천 생성에 실패했어요.", code="CLAUDE_REQUEST_FAILED"
            ) from exc

        text = next((b.text for b in response.content if b.type == "text"), "")
        try:
            data: dict[str, Any] = json.loads(text)
        except json.JSONDecodeError as exc:
            logger.warning("claude_recommend_books returned non-JSON body")
            raise ExternalServiceError(
                "AI 응답을 해석하지 못했어요.", code="CLAUDE_BAD_RESPONSE"
            ) from exc

        return [
            AIBookSuggestion(
                title=str(item["title"]),
                author=str(item["author"]),
                reason=str(item["reason"]),
            )
            for item in data["recommendations"]
        ]

"""Deterministic stub :class:`AIAssistantPort` for dev/test and key-less envs.

Selected by ``providers.py`` whenever ``ANTHROPIC_API_KEY`` is unset, so local
development and the test suite run the full AI flow — caching, rate limits, Pro
gating — without a real Claude call or network access. Output is fixed text that
references the inputs so it is obviously a stub, never mistaken for real content.
"""

from __future__ import annotations

from app.domains.ai_assistant.ports import (
    AgendaTopicDraftsContent,
    AudioIntroContent,
    ClubTopicsContent,
    NextBookRecommendation,
    PrepCardContent,
    ReflectionContent,
)


class StubClaudeAdapter:
    """Returns canned content; reports ``tokens_used=0`` so usage logs stay honest."""

    async def generate_prep_card(
        self, *, book_title: str, author: str, description: str | None, style: str
    ) -> PrepCardContent:
        return PrepCardContent(
            author_intro=f"《{book_title}》의 저자 {author} 소개 ({style} 샘플).",
            theme_keywords=["성장", "관계", "선택"],
            prereading_questions=[
                "이 책에서 가장 기대되는 부분은 무엇인가요?",
                "지금 나의 어떤 고민과 연결될 수 있을까요?",
            ],
            tokens_used=0,
        )

    async def generate_reflection(
        self,
        *,
        book_title: str,
        author: str,
        highlights: list[str],
        reading_days: int,
    ) -> ReflectionContent:
        return ReflectionContent(
            insights=[
                f"《{book_title}》을(를) {reading_days}일간 읽으며 얻은 핵심 통찰 1 (샘플).",
                "핵심 통찰 2 (샘플).",
            ],
            action_point="오늘 하나의 작은 실천을 시작해 보세요 (샘플).",
            next_books=[
                NextBookRecommendation(title="추천 도서 1", reason="비슷한 주제 (샘플)."),
                NextBookRecommendation(title="추천 도서 2", reason="한 걸음 더 (샘플)."),
            ],
            tokens_used=0,
        )

    async def generate_club_topics(
        self, *, book_title: str, page_start: int, page_end: int
    ) -> ClubTopicsContent:
        return ClubTopicsContent(
            topics=[
                f"{page_start}~{page_end}쪽에서 가장 인상 깊었던 장면은? (샘플)",
                "등장인물의 선택에 동의하나요? (샘플)",
                "이번 주 범위의 핵심 메시지는? (샘플)",
            ],
            tokens_used=0,
        )

    async def generate_agenda_topics(
        self, *, book_title: str, author: str, scope: str
    ) -> AgendaTopicDraftsContent:
        return AgendaTopicDraftsContent(
            topics=[
                f"《{book_title}》의 '{scope}' 범위에서 가장 논쟁적인 지점은? (샘플)",
                "이 범위에서 등장인물의 선택에 동의하나요, 반대하나요? (샘플)",
                f"{author}의 관점에서 이 범위가 전하는 메시지는 무엇일까요? (샘플)",
                "우리 모임과 비슷한 경험이 있다면 무엇인가요? (샘플)",
            ],
            tokens_used=0,
        )

    async def generate_audio_intro(
        self, *, book_title: str, author: str, description: str | None
    ) -> AudioIntroContent:
        return AudioIntroContent(
            script=(
                f"안녕하세요. 오늘 함께 읽을 책은 {author}의 《{book_title}》입니다. "
                "잠시 호흡을 가다듬고, 책장을 넘기며 떠오르는 생각에 귀 기울여 보세요. (샘플)"
            ),
            tokens_used=0,
        )

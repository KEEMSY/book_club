"""ai_assistant domain ports — the only contracts ``service.py`` imports.

Per CLAUDE.md §3.2 the Port/Adapter boundary is enforced strictly for the one
real external collaborator here, the Claude API (``AIAssistantPort``, two live
implementations: ``ClaudeAdapter`` and ``StubClaudeAdapter``). The remaining
ports wrap our own DB / Redis / cross-domain reads; they stay Port-shaped so the
service can be unit-tested against in-memory fakes with no DB.

DTOs live here rather than in ``schemas.py`` so the domain never sees pydantic
or HTTP types. ``tokens_used`` rides on each generation DTO because the service
must log it to ``ai_usage_logs`` — keeping it on the result avoids a second,
race-prone "how many tokens did the last call use" lookup on the adapter.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
from typing import Protocol
from uuid import UUID


@dataclass(frozen=True, slots=True)
class PrepCardContent:
    """Pre-reading prep card: author intro, three themes, two warm-up questions."""

    author_intro: str
    theme_keywords: list[str]
    prereading_questions: list[str]
    tokens_used: int = 0


@dataclass(frozen=True, slots=True)
class NextBookRecommendation:
    title: str
    reason: str


@dataclass(frozen=True, slots=True)
class ReflectionContent:
    """Post-completion reflection guide tied to the reader's highlights."""

    insights: list[str]
    action_point: str
    next_books: list[NextBookRecommendation]
    tokens_used: int = 0


@dataclass(frozen=True, slots=True)
class ClubTopicsContent:
    """Three discussion topics for a club's current weekly reading range."""

    topics: list[str]
    tokens_used: int = 0


@dataclass(frozen=True, slots=True)
class AudioIntroContent:
    """A ~200-character spoken reading intro script, played in-app via TTS."""

    script: str
    tokens_used: int = 0


@dataclass(frozen=True, slots=True)
class BookInfo:
    """Minimal book facts the adapter needs to prompt Claude."""

    title: str
    author: str
    description: str | None


@dataclass(frozen=True, slots=True)
class ReflectionInput:
    """Everything the reflection prompt needs, resolved in one library query."""

    book_id: UUID
    title: str
    author: str
    highlights: list[str]
    reading_days: int


class AIAssistantPort(Protocol):
    """The external generative boundary — Claude, or a deterministic stub."""

    async def generate_prep_card(
        self, *, book_title: str, author: str, description: str | None, style: str
    ) -> PrepCardContent: ...

    async def generate_reflection(
        self,
        *,
        book_title: str,
        author: str,
        highlights: list[str],
        reading_days: int,
    ) -> ReflectionContent: ...

    async def generate_club_topics(
        self, *, book_title: str, page_start: int, page_end: int
    ) -> ClubTopicsContent: ...

    async def generate_audio_intro(
        self, *, book_title: str, author: str, description: str | None
    ) -> AudioIntroContent: ...


class PrepCachePort(Protocol):
    """Redis-backed 72h cache for prep cards, keyed by ``(book_id, style)``.

    Keying on style as well as book keeps the per-user persona personalization
    correct — two readers with different styles never share a cached card.
    """

    async def get_prep(self, book_id: UUID, style: str) -> PrepCardContent | None: ...

    async def set_prep(self, book_id: UUID, style: str, content: PrepCardContent) -> None: ...


class UserPreferencesPort(Protocol):
    """Reader's chosen prep-card persona style, persisted in Postgres."""

    async def get_prefs(self, user_id: UUID) -> str | None: ...

    async def upsert_prefs(self, *, user_id: UUID, style: str) -> None: ...


class ReflectionRepositoryPort(Protocol):
    async def get(self, *, user_id: UUID, book_id: UUID) -> ReflectionContent | None: ...

    async def create(
        self, *, user_id: UUID, book_id: UUID, content: ReflectionContent
    ) -> ReflectionContent: ...


class UsageLogRepositoryPort(Protocol):
    async def count_since(self, *, user_id: UUID, feature: str, since: datetime) -> int: ...

    async def record(
        self, *, user_id: UUID, feature: str, book_id: UUID | None, tokens_used: int
    ) -> None: ...


class BookInfoPort(Protocol):
    async def get_book_info(self, book_id: UUID) -> BookInfo | None: ...


class UserQueryPort(Protocol):
    async def is_pro(self, user_id: UUID) -> bool: ...


class LibraryQueryPort(Protocol):
    """Resolves a library item to its reflection inputs, gating on ownership.

    Returns ``None`` when the ``user_book_id`` is unknown or not owned by the
    caller — the service maps that to 404 without leaking the row's existence.
    """

    async def get_reflection_input(
        self, *, user_id: UUID, user_book_id: UUID
    ) -> ReflectionInput | None: ...


class ClubCoachPort(Protocol):
    """Cross-domain club operations the topic generator needs."""

    async def get_club_book(self, club_id: UUID) -> BookInfo | None: ...

    async def is_owner(self, *, club_id: UUID, user_id: UUID) -> bool: ...

    async def post_topics_message(
        self, *, club_id: UUID, user_id: UUID, topics: list[str]
    ) -> None: ...

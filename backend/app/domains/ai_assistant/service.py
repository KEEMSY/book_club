"""ai_assistant domain service — the AI reading coach (Phase 14 §5).

Depends only on the Protocols in ``ports.py`` (CLAUDE.md §3.2); concrete
adapters (Claude / Redis / repositories / cross-domain readers) are injected by
``providers.py`` for HTTP traffic and by fakes in unit tests.

Business rules owned here:
- ``get_prep_card``: serve from the 72h Redis cache first; on a miss, enforce the
  daily free cap (5/user) *before* spending a Claude call, then generate, cache,
  and log usage. A cache hit costs nothing and is never rate-limited.
- ``create_reflection``: idempotent per (user, book) via the stored guide — a
  second request returns the existing one without a new call or quota hit. New
  guides are Pro-gated: free users get one trial per calendar month (monthly
  cap = 1); Pro is unlimited.
- ``get_club_topics``: Pro club-owner only; generates topics and posts them to
  the club chat as a pinned-style message.
- ``get_prep_card`` is personalized (M67): the reader's stored persona style
  feeds both the Claude prompt and the cache key, so two readers with different
  styles never share a cached card.
- ``get_audio_intro`` (M67): generates a short spoken reading intro. Free users
  get one per day (logged under ``audio_intro``); Pro is unmetered.
- ``generate_agenda_topic_drafts`` (BC-53): module-level, not a method — the
  club domain's session-agenda 논제 추천 reuses this exact book-lookup +
  Claude-call + usage-log business logic through a narrow adapter that wires
  only the three ports it needs (``AIAssistantPort``/``BookInfoPort``/
  ``UsageLogRepositoryPort``), instead of constructing a full
  ``AIAssistantService`` — that would recurse into ``get_club_service`` via
  ``ClubCoachPort`` (see ``providers.py``). No Pro gate, no DB write; the
  presenter only gets a recommendation and still adds picked topics via the
  existing club ``add_topic`` flow (design §6.3, BC-45).
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import UTC, datetime
from uuid import UUID

from app.core.exceptions import (
    NotFoundError,
    PermissionDeniedError,
    RateLimitedError,
)
from app.domains.ai_assistant.ports import (
    AgendaTopicDraftsContent,
    AIAssistantPort,
    AudioIntroContent,
    BookInfoPort,
    ClubCoachPort,
    ClubTopicsContent,
    LibraryQueryPort,
    PrepCachePort,
    PrepCardContent,
    ReflectionContent,
    ReflectionRepositoryPort,
    UsageLogRepositoryPort,
    UserPreferencesPort,
    UserQueryPort,
)

FEATURE_PREP = "prep_card"
FEATURE_REFLECTION = "reflection"
FEATURE_TOPICS = "club_topics"
FEATURE_AGENDA_TOPICS = "agenda_topics"
FEATURE_AUDIO_INTRO = "audio_intro"

PREP_DAILY_LIMIT = 5
FREE_REFLECTION_MONTHLY_LIMIT = 1
AUDIO_INTRO_FREE_DAILY_LIMIT = 1

VALID_CARD_STYLES = ("motivational", "analytical", "reflective")
DEFAULT_CARD_STYLE = "motivational"


@dataclass(frozen=True, slots=True)
class UsageSummary:
    """This-month generation counts per feature."""

    prep_card: int
    reflection: int
    club_topics: int


def _today_start() -> datetime:
    now = datetime.now(tz=UTC)
    return now.replace(hour=0, minute=0, second=0, microsecond=0)


def _month_start() -> datetime:
    now = datetime.now(tz=UTC)
    return now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)


async def generate_agenda_topic_drafts(
    *,
    ai: AIAssistantPort,
    books: BookInfoPort,
    usage: UsageLogRepositoryPort,
    user_id: UUID,
    book_id: UUID,
    scope: str,
) -> AgendaTopicDraftsContent:
    """발제자용 논제 초안 3~5개 추천 (BC-53) — 추천만 반환하며 DB에 저장하지 않는다.

    무료 MVP 범위로 Pro 게이팅을 두지 않는다(design §6.3, 명시적 결정). club
    도메인의 ``ClubService.recommend_topics``가 발제문 author 권한을 확인한
    뒤 이 함수를 호출한다 — 실제 논제 추가는 기존 ``add_topic``을 그대로 쓴다.
    """
    info = await books.get_book_info(book_id)
    if info is None:
        raise NotFoundError("book not found", code="BOOK_NOT_FOUND")

    content = await ai.generate_agenda_topics(
        book_title=info.title, author=info.author, scope=scope
    )
    await usage.record(
        user_id=user_id,
        feature=FEATURE_AGENDA_TOPICS,
        book_id=book_id,
        tokens_used=content.tokens_used,
    )
    return content


@dataclass(slots=True)
class AIAssistantService:
    """Orchestrates prep cards, reflection guides, and club topics."""

    ai: AIAssistantPort
    prep_cache: PrepCachePort
    reflections: ReflectionRepositoryPort
    usage: UsageLogRepositoryPort
    books: BookInfoPort
    users: UserQueryPort
    library: LibraryQueryPort
    clubs: ClubCoachPort
    preferences: UserPreferencesPort

    async def get_prep_card(self, *, user_id: UUID, book_id: UUID) -> PrepCardContent:
        style = await self._resolve_style(user_id)
        cached = await self.prep_cache.get_prep(book_id, style)
        if cached is not None:
            return cached

        used_today = await self.usage.count_since(
            user_id=user_id, feature=FEATURE_PREP, since=_today_start()
        )
        if used_today >= PREP_DAILY_LIMIT:
            raise RateLimitedError(
                "오늘 사용할 수 있는 AI 준비카드를 모두 사용했어요. 내일 다시 시도해 주세요.",
                code="PREP_DAILY_LIMIT",
            )

        info = await self.books.get_book_info(book_id)
        if info is None:
            raise NotFoundError("book not found", code="BOOK_NOT_FOUND")

        content = await self.ai.generate_prep_card(
            book_title=info.title,
            author=info.author,
            description=info.description,
            style=style,
        )
        await self.prep_cache.set_prep(book_id, style, content)
        await self.usage.record(
            user_id=user_id,
            feature=FEATURE_PREP,
            book_id=book_id,
            tokens_used=content.tokens_used,
        )
        return content

    async def get_card_style(self, *, user_id: UUID) -> str:
        """Return the reader's prep-card style, defaulting when unset."""
        return await self._resolve_style(user_id)

    async def set_card_style(self, *, user_id: UUID, style: str) -> str:
        """Persist the reader's prep-card style and echo it back."""
        if style not in VALID_CARD_STYLES:
            raise NotFoundError("unknown card style", code="INVALID_CARD_STYLE")
        await self.preferences.upsert_prefs(user_id=user_id, style=style)
        return style

    async def get_audio_intro(self, *, user_id: UUID, book_id: UUID) -> AudioIntroContent:
        """Generate a short spoken reading intro for *book_id*.

        Free users get one generation per day (logged under
        ``audio_intro`` in ``ai_usage_logs``); Pro users are unmetered. The
        daily cap is checked before the Claude call so a rate-limited request
        spends nothing.
        """
        if not await self.users.is_pro(user_id):
            used_today = await self.usage.count_since(
                user_id=user_id, feature=FEATURE_AUDIO_INTRO, since=_today_start()
            )
            if used_today >= AUDIO_INTRO_FREE_DAILY_LIMIT:
                raise RateLimitedError(
                    "오늘의 오디오 인트로를 모두 사용했어요. 내일 다시 시도해 주세요.",
                    code="AUDIO_INTRO_DAILY_LIMIT",
                )

        info = await self.books.get_book_info(book_id)
        if info is None:
            raise NotFoundError("book not found", code="BOOK_NOT_FOUND")

        content = await self.ai.generate_audio_intro(
            book_title=info.title, author=info.author, description=info.description
        )
        await self.usage.record(
            user_id=user_id,
            feature=FEATURE_AUDIO_INTRO,
            book_id=book_id,
            tokens_used=content.tokens_used,
        )
        return content

    async def _resolve_style(self, user_id: UUID) -> str:
        stored = await self.preferences.get_prefs(user_id)
        if stored in VALID_CARD_STYLES:
            return stored
        return DEFAULT_CARD_STYLE

    async def create_reflection(self, *, user_id: UUID, user_book_id: UUID) -> ReflectionContent:
        info = await self.library.get_reflection_input(user_id=user_id, user_book_id=user_book_id)
        if info is None:
            raise NotFoundError("user_book not found", code="USER_BOOK_NOT_FOUND")

        existing = await self.reflections.get(user_id=user_id, book_id=info.book_id)
        if existing is not None:
            return existing

        if not await self.users.is_pro(user_id):
            used = await self.usage.count_since(
                user_id=user_id, feature=FEATURE_REFLECTION, since=_month_start()
            )
            if used >= FREE_REFLECTION_MONTHLY_LIMIT:
                raise PermissionDeniedError(
                    "AI 성찰 가이드는 Pro 전용이에요. 무료 체험을 모두 사용했어요.",
                    code="PRO_REQUIRED",
                )

        content = await self.ai.generate_reflection(
            book_title=info.title,
            author=info.author,
            highlights=info.highlights,
            reading_days=info.reading_days,
        )
        stored = await self.reflections.create(
            user_id=user_id, book_id=info.book_id, content=content
        )
        await self.usage.record(
            user_id=user_id,
            feature=FEATURE_REFLECTION,
            book_id=info.book_id,
            tokens_used=content.tokens_used,
        )
        return stored

    async def get_club_topics(
        self, *, user_id: UUID, club_id: UUID, page_start: int, page_end: int
    ) -> ClubTopicsContent:
        if not await self.users.is_pro(user_id):
            raise PermissionDeniedError(
                "AI 토론 주제는 Pro 클럽장 전용이에요.", code="PRO_REQUIRED"
            )
        if not await self.clubs.is_owner(club_id=club_id, user_id=user_id):
            raise PermissionDeniedError(
                "클럽장만 토론 주제를 생성할 수 있어요.", code="NOT_CLUB_OWNER"
            )

        info = await self.clubs.get_club_book(club_id)
        if info is None:
            raise NotFoundError("club has no current book", code="CLUB_BOOK_NOT_SET")

        content = await self.ai.generate_club_topics(
            book_title=info.title, page_start=page_start, page_end=page_end
        )
        await self.clubs.post_topics_message(
            club_id=club_id, user_id=user_id, topics=content.topics
        )
        await self.usage.record(
            user_id=user_id,
            feature=FEATURE_TOPICS,
            book_id=None,
            tokens_used=content.tokens_used,
        )
        return content

    async def get_usage(self, *, user_id: UUID) -> UsageSummary:
        since = _month_start()
        return UsageSummary(
            prep_card=await self.usage.count_since(
                user_id=user_id, feature=FEATURE_PREP, since=since
            ),
            reflection=await self.usage.count_since(
                user_id=user_id, feature=FEATURE_REFLECTION, since=since
            ),
            club_topics=await self.usage.count_since(
                user_id=user_id, feature=FEATURE_TOPICS, since=since
            ),
        )

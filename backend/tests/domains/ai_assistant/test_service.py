"""Unit tests for AIAssistantService with the real StubClaudeAdapter + fakes.

No DB, no Redis, no network — every Port is an in-memory fake and the AI port is
the production ``StubClaudeAdapter`` (per the M63 brief). Covers the business
rules the service owns: prep-card cache hit/miss, the daily prep cap, and the Pro
gate / idempotency on reflections.
"""

from __future__ import annotations

from datetime import UTC, datetime
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import NotFoundError, PermissionDeniedError, RateLimitedError
from app.domains.ai_assistant.adapters.stub_claude_adapter import StubClaudeAdapter
from app.domains.ai_assistant.ports import (
    BookInfo,
    PrepCardContent,
    ReflectionContent,
    ReflectionInput,
)
from app.domains.ai_assistant.service import (
    AUDIO_INTRO_FREE_DAILY_LIMIT,
    DEFAULT_CARD_STYLE,
    FEATURE_AUDIO_INTRO,
    FEATURE_PREP,
    FEATURE_REFLECTION,
    PREP_DAILY_LIMIT,
    AIAssistantService,
)


class CountingStub(StubClaudeAdapter):
    """StubClaudeAdapter that counts generations, to assert cache behaviour."""

    def __init__(self) -> None:
        self.prep_calls = 0
        self.reflection_calls = 0

    async def generate_prep_card(self, **kwargs: object) -> PrepCardContent:  # type: ignore[override]
        self.prep_calls += 1
        return await super().generate_prep_card(**kwargs)  # type: ignore[arg-type]

    async def generate_reflection(self, **kwargs: object) -> ReflectionContent:  # type: ignore[override]
        self.reflection_calls += 1
        return await super().generate_reflection(**kwargs)  # type: ignore[arg-type]


class FakePrepCache:
    def __init__(self) -> None:
        # Keyed by book_id only; the style param is accepted but the test fakes
        # never exercise two styles for one book, so collapsing the key is safe.
        self.store: dict[UUID, PrepCardContent] = {}

    async def get_prep(self, book_id: UUID, style: str) -> PrepCardContent | None:
        return self.store.get(book_id)

    async def set_prep(self, book_id: UUID, style: str, content: PrepCardContent) -> None:
        self.store[book_id] = content


class FakePreferences:
    def __init__(self, styles: dict[UUID, str] | None = None) -> None:
        self.styles: dict[UUID, str] = styles or {}

    async def get_prefs(self, user_id: UUID) -> str | None:
        return self.styles.get(user_id)

    async def upsert_prefs(self, *, user_id: UUID, style: str) -> None:
        self.styles[user_id] = style


class FakeUsageLog:
    def __init__(self) -> None:
        self.records: list[tuple[UUID, str, datetime]] = []

    async def count_since(self, *, user_id: UUID, feature: str, since: datetime) -> int:
        return sum(
            1
            for uid, feat, ts in self.records
            if uid == user_id and feat == feature and ts >= since
        )

    async def record(
        self, *, user_id: UUID, feature: str, book_id: UUID | None, tokens_used: int
    ) -> None:
        self.records.append((user_id, feature, datetime.now(tz=UTC)))


class FakeReflectionRepo:
    def __init__(self) -> None:
        self.store: dict[tuple[UUID, UUID], ReflectionContent] = {}

    async def get(self, *, user_id: UUID, book_id: UUID) -> ReflectionContent | None:
        return self.store.get((user_id, book_id))

    async def create(
        self, *, user_id: UUID, book_id: UUID, content: ReflectionContent
    ) -> ReflectionContent:
        self.store[(user_id, book_id)] = content
        return content


class FakeBookInfo:
    def __init__(self, books: dict[UUID, BookInfo]) -> None:
        self.books = books

    async def get_book_info(self, book_id: UUID) -> BookInfo | None:
        return self.books.get(book_id)


class FakeUsers:
    def __init__(self, pro: set[UUID]) -> None:
        self.pro = pro

    async def is_pro(self, user_id: UUID) -> bool:
        return user_id in self.pro


class FakeLibrary:
    def __init__(self) -> None:
        self.store: dict[tuple[UUID, UUID], ReflectionInput] = {}

    async def get_reflection_input(
        self, *, user_id: UUID, user_book_id: UUID
    ) -> ReflectionInput | None:
        return self.store.get((user_id, user_book_id))


class FakeClubCoach:
    def __init__(self) -> None:
        self.posted: list[list[str]] = []
        self.book: BookInfo | None = None
        self.owner: UUID | None = None

    async def get_club_book(self, club_id: UUID) -> BookInfo | None:
        return self.book

    async def is_owner(self, *, club_id: UUID, user_id: UUID) -> bool:
        return self.owner == user_id

    async def post_topics_message(self, *, club_id: UUID, user_id: UUID, topics: list[str]) -> None:
        self.posted.append(topics)


def _make_service(
    *,
    ai: object | None = None,
    books: dict[UUID, BookInfo] | None = None,
    pro: set[UUID] | None = None,
) -> tuple[AIAssistantService, dict[str, object]]:
    deps: dict[str, object] = {
        "ai": ai or CountingStub(),
        "prep_cache": FakePrepCache(),
        "usage": FakeUsageLog(),
        "reflections": FakeReflectionRepo(),
        "books": FakeBookInfo(books or {}),
        "users": FakeUsers(pro or set()),
        "library": FakeLibrary(),
        "clubs": FakeClubCoach(),
        "preferences": FakePreferences(),
    }
    service = AIAssistantService(**deps)  # type: ignore[arg-type]
    return service, deps


async def test_prep_card_cache_miss_generates_and_caches() -> None:
    book_id = uuid4()
    user_id = uuid4()
    ai = CountingStub()
    service, deps = _make_service(
        ai=ai, books={book_id: BookInfo(title="데미안", author="헤세", description=None)}
    )

    result = await service.get_prep_card(user_id=user_id, book_id=book_id)

    assert ai.prep_calls == 1
    assert len(result.theme_keywords) == 3
    # cached for next time, and usage logged once
    assert book_id in deps["prep_cache"].store  # type: ignore[attr-defined]
    assert len(deps["usage"].records) == 1  # type: ignore[attr-defined]


async def test_prep_card_cache_hit_skips_generation() -> None:
    book_id = uuid4()
    user_id = uuid4()
    ai = CountingStub()
    service, deps = _make_service(
        ai=ai, books={book_id: BookInfo(title="데미안", author="헤세", description=None)}
    )
    deps["prep_cache"].store[book_id] = PrepCardContent(  # type: ignore[attr-defined]
        author_intro="x", theme_keywords=["a", "b", "c"], prereading_questions=["q1", "q2"]
    )

    result = await service.get_prep_card(user_id=user_id, book_id=book_id)

    assert ai.prep_calls == 0
    assert result.author_intro == "x"
    assert len(deps["usage"].records) == 0  # type: ignore[attr-defined]  # cache hit isn't metered


async def test_prep_card_daily_limit_enforced() -> None:
    book_id = uuid4()
    user_id = uuid4()
    service, deps = _make_service(
        books={book_id: BookInfo(title="데미안", author="헤세", description=None)}
    )
    usage = deps["usage"]
    for _ in range(PREP_DAILY_LIMIT):
        await usage.record(  # type: ignore[attr-defined]
            user_id=user_id, feature=FEATURE_PREP, book_id=book_id, tokens_used=0
        )

    with pytest.raises(RateLimitedError) as exc:
        await service.get_prep_card(user_id=user_id, book_id=book_id)
    assert exc.value.code == "PREP_DAILY_LIMIT"


async def test_prep_card_missing_book_raises_not_found() -> None:
    service, _ = _make_service(books={})
    with pytest.raises(NotFoundError):
        await service.get_prep_card(user_id=uuid4(), book_id=uuid4())


async def test_reflection_free_user_blocked_after_monthly_trial() -> None:
    user_id = uuid4()
    user_book_id = uuid4()
    book_id = uuid4()
    service, deps = _make_service(pro=set())  # free user
    deps["library"].store[(user_id, user_book_id)] = ReflectionInput(  # type: ignore[attr-defined]
        book_id=book_id, title="데미안", author="헤세", highlights=["문장"], reading_days=7
    )
    # already used the one free reflection this month
    await deps["usage"].record(  # type: ignore[attr-defined]
        user_id=user_id, feature=FEATURE_REFLECTION, book_id=book_id, tokens_used=0
    )

    with pytest.raises(PermissionDeniedError) as exc:
        await service.create_reflection(user_id=user_id, user_book_id=user_book_id)
    assert exc.value.code == "PRO_REQUIRED"


async def test_reflection_pro_user_unlimited() -> None:
    user_id = uuid4()
    user_book_id = uuid4()
    book_id = uuid4()
    service, deps = _make_service(pro={user_id})
    deps["library"].store[(user_id, user_book_id)] = ReflectionInput(  # type: ignore[attr-defined]
        book_id=book_id, title="데미안", author="헤세", highlights=["문장"], reading_days=7
    )
    # even with prior usage, Pro is not gated
    await deps["usage"].record(  # type: ignore[attr-defined]
        user_id=user_id, feature=FEATURE_REFLECTION, book_id=book_id, tokens_used=0
    )

    result = await service.create_reflection(user_id=user_id, user_book_id=user_book_id)

    assert len(result.insights) == 2
    assert len(result.next_books) == 2


async def test_reflection_is_idempotent_per_book() -> None:
    user_id = uuid4()
    user_book_id = uuid4()
    book_id = uuid4()
    ai = CountingStub()
    service, deps = _make_service(ai=ai, pro={user_id})
    deps["library"].store[(user_id, user_book_id)] = ReflectionInput(  # type: ignore[attr-defined]
        book_id=book_id, title="데미안", author="헤세", highlights=[], reading_days=3
    )

    first = await service.create_reflection(user_id=user_id, user_book_id=user_book_id)
    second = await service.create_reflection(user_id=user_id, user_book_id=user_book_id)

    assert ai.reflection_calls == 1  # second call returned the stored guide
    assert first.action_point == second.action_point


async def test_reflection_unknown_library_item_raises_not_found() -> None:
    service, _ = _make_service(pro=set())
    with pytest.raises(NotFoundError):
        await service.create_reflection(user_id=uuid4(), user_book_id=uuid4())


async def test_club_topics_non_pro_blocked() -> None:
    service, _ = _make_service(pro=set())
    with pytest.raises(PermissionDeniedError) as exc:
        await service.get_club_topics(user_id=uuid4(), club_id=uuid4(), page_start=1, page_end=50)
    assert exc.value.code == "PRO_REQUIRED"


async def test_club_topics_pro_owner_generates_and_posts() -> None:
    user_id = uuid4()
    club_id = uuid4()
    service, deps = _make_service(pro={user_id})
    coach = deps["clubs"]
    coach.owner = user_id  # type: ignore[attr-defined]
    coach.book = BookInfo(title="데미안", author="헤세", description=None)  # type: ignore[attr-defined]

    result = await service.get_club_topics(
        user_id=user_id, club_id=club_id, page_start=1, page_end=50
    )

    assert len(result.topics) == 3
    assert coach.posted == [result.topics]  # type: ignore[attr-defined]


async def test_club_topics_pro_non_owner_blocked() -> None:
    user_id = uuid4()
    service, deps = _make_service(pro={user_id})
    deps["clubs"].owner = uuid4()  # type: ignore[attr-defined]  # someone else owns it

    with pytest.raises(PermissionDeniedError) as exc:
        await service.get_club_topics(user_id=user_id, club_id=uuid4(), page_start=1, page_end=50)
    assert exc.value.code == "NOT_CLUB_OWNER"


# ---------------------------------------------------------------------------
# M67 — prep card style personalization
# ---------------------------------------------------------------------------


async def test_card_style_defaults_when_unset() -> None:
    service, _ = _make_service()
    assert await service.get_card_style(user_id=uuid4()) == DEFAULT_CARD_STYLE


async def test_set_and_get_card_style_round_trips() -> None:
    user_id = uuid4()
    service, _ = _make_service()

    returned = await service.set_card_style(user_id=user_id, style="analytical")

    assert returned == "analytical"
    assert await service.get_card_style(user_id=user_id) == "analytical"


async def test_set_invalid_card_style_raises() -> None:
    service, _ = _make_service()
    with pytest.raises(NotFoundError) as exc:
        await service.set_card_style(user_id=uuid4(), style="snarky")
    assert exc.value.code == "INVALID_CARD_STYLE"


async def test_prep_card_passes_stored_style_to_adapter() -> None:
    book_id = uuid4()
    user_id = uuid4()

    captured: dict[str, object] = {}

    class StyleCapturingStub(StubClaudeAdapter):
        async def generate_prep_card(self, **kwargs: object) -> PrepCardContent:  # type: ignore[override]
            captured.update(kwargs)
            return await super().generate_prep_card(**kwargs)  # type: ignore[arg-type]

    service, deps = _make_service(
        ai=StyleCapturingStub(),
        books={book_id: BookInfo(title="데미안", author="헤세", description=None)},
    )
    await deps["preferences"].upsert_prefs(user_id=user_id, style="reflective")  # type: ignore[attr-defined]

    await service.get_prep_card(user_id=user_id, book_id=book_id)

    assert captured["style"] == "reflective"


# ---------------------------------------------------------------------------
# M67 — audio intro
# ---------------------------------------------------------------------------


async def test_audio_intro_free_user_first_call_succeeds() -> None:
    book_id = uuid4()
    user_id = uuid4()
    service, deps = _make_service(
        books={book_id: BookInfo(title="데미안", author="헤세", description=None)}
    )

    result = await service.get_audio_intro(user_id=user_id, book_id=book_id)

    assert result.script
    # one usage row logged under the audio_intro feature
    assert len(deps["usage"].records) == 1  # type: ignore[attr-defined]


async def test_audio_intro_free_user_blocked_after_daily_limit() -> None:
    book_id = uuid4()
    user_id = uuid4()
    service, deps = _make_service(
        books={book_id: BookInfo(title="데미안", author="헤세", description=None)}
    )
    for _ in range(AUDIO_INTRO_FREE_DAILY_LIMIT):
        await deps["usage"].record(  # type: ignore[attr-defined]
            user_id=user_id, feature=FEATURE_AUDIO_INTRO, book_id=book_id, tokens_used=0
        )

    with pytest.raises(RateLimitedError) as exc:
        await service.get_audio_intro(user_id=user_id, book_id=book_id)
    assert exc.value.code == "AUDIO_INTRO_DAILY_LIMIT"


async def test_audio_intro_pro_user_unmetered() -> None:
    book_id = uuid4()
    user_id = uuid4()
    service, deps = _make_service(
        books={book_id: BookInfo(title="데미안", author="헤세", description=None)},
        pro={user_id},
    )
    # prior usage that would block a free user
    await deps["usage"].record(  # type: ignore[attr-defined]
        user_id=user_id, feature=FEATURE_AUDIO_INTRO, book_id=book_id, tokens_used=0
    )

    result = await service.get_audio_intro(user_id=user_id, book_id=book_id)

    assert result.script


async def test_audio_intro_missing_book_raises_not_found() -> None:
    service, _ = _make_service(books={})
    with pytest.raises(NotFoundError):
        await service.get_audio_intro(user_id=uuid4(), book_id=uuid4())

"""Unit tests for CurationService (M42 — curation card domain).

Covers:
1. Adding a card to a book with fewer than 5 cards succeeds.
2. Adding a 6th card raises ConflictError(code=CURATION_CARD_LIMIT).
3. Deleting an existing card succeeds.
4. Deleting a non-existent card raises NotFoundError(code=CURATION_CARD_NOT_FOUND).
5. Listing a book's cards returns them in order_index order.
6. Getting the first card returns the lowest-order_index card; returns None when empty.

All tests use FakeCurationRepository — no real DB required
(CLAUDE.md §5: service unit tests inject Fake repos).
"""

from __future__ import annotations

from dataclasses import dataclass, field
from datetime import UTC, datetime
from typing import Any
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError, NotFoundError
from app.domains.curation.schemas import CreateCurationCardRequest
from app.domains.curation.service import CurationService

# ---------------------------------------------------------------------------
# Lightweight stand-in for CurationCard ORM model
# ---------------------------------------------------------------------------


@dataclass
class _FakeCard:
    id: UUID = field(default_factory=uuid4)
    book_id: UUID = field(default_factory=uuid4)
    card_type: str = "intro"
    title: str = "제목"
    body: str = "본문 내용"
    order_index: int = 0
    created_at: datetime = field(default_factory=lambda: datetime.now(tz=UTC))


# ---------------------------------------------------------------------------
# Fake repository
# ---------------------------------------------------------------------------


class FakeCurationRepository:
    """In-memory CurationRepository for unit tests."""

    def __init__(self) -> None:
        self._cards: list[_FakeCard] = []

    # Test setup helpers

    def seed_card(self, card: _FakeCard) -> None:
        """Directly insert a card — bypasses service-layer limit checks."""
        self._cards.append(card)

    # Repository interface

    async def list_by_book(self, book_id: UUID) -> list[Any]:
        """Return cards for book_id sorted by order_index asc, created_at asc."""
        result = [c for c in self._cards if c.book_id == book_id]
        result.sort(key=lambda c: (c.order_index, c.created_at))
        return result

    async def create(
        self,
        *,
        book_id: UUID,
        card_type: str,
        title: str,
        body: str,
        order_index: int,
    ) -> _FakeCard:
        card = _FakeCard(
            book_id=book_id,
            card_type=card_type,
            title=title,
            body=body,
            order_index=order_index,
        )
        self._cards.append(card)
        return card

    async def get_by_id(self, card_id: UUID) -> _FakeCard | None:
        return next((c for c in self._cards if c.id == card_id), None)

    async def delete(self, card_id: UUID) -> bool:
        for i, c in enumerate(self._cards):
            if c.id == card_id:
                self._cards.pop(i)
                return True
        return False

    async def get_first_for_book(self, book_id: UUID) -> _FakeCard | None:
        candidates = [c for c in self._cards if c.book_id == book_id]
        if not candidates:
            return None
        candidates.sort(key=lambda c: (c.order_index, c.created_at))
        return candidates[0]


# ---------------------------------------------------------------------------
# Helper
# ---------------------------------------------------------------------------


class FakeFeedbackRepository:
    """In-memory CurationFeedbackRepository for unit tests.

    Mirrors the production semantics: ``upsert_feedback`` is one-vote-per-card,
    and ``deprioritized_card_types`` counts skip/dismiss grouped by the card's
    type (resolved against a shared card index seeded by the test).
    """

    def __init__(self, cards: dict[UUID, _FakeCard]) -> None:
        self._cards = cards
        self._feedback: dict[tuple[UUID, UUID], str] = {}

    async def upsert_feedback(self, *, user_id: UUID, card_id: UUID, action: str) -> None:
        self._feedback[(user_id, card_id)] = action

    async def deprioritized_card_types(self, *, user_id: UUID, threshold: int) -> set[str]:
        counts: dict[str, int] = {}
        for (uid, card_id), action in self._feedback.items():
            if uid != user_id or action not in ("skip", "dismiss"):
                continue
            card = self._cards.get(card_id)
            if card is None:
                continue
            counts[card.card_type] = counts.get(card.card_type, 0) + 1
        return {ctype for ctype, n in counts.items() if n >= threshold}


def _svc(repo: FakeCurationRepository) -> CurationService:
    return CurationService(repo=repo)  # type: ignore[arg-type]


def _svc_with_feedback(
    repo: FakeCurationRepository, feedback: FakeFeedbackRepository
) -> CurationService:
    return CurationService(repo=repo, feedback_repo=feedback)  # type: ignore[arg-type]


def _req(
    card_type: str = "intro",
    title: str = "제목",
    body: str = "본문 내용",
    order_index: int = 0,
) -> CreateCurationCardRequest:
    return CreateCurationCardRequest(
        card_type=card_type,  # type: ignore[arg-type]
        title=title,
        body=body,
        order_index=order_index,
    )


# ---------------------------------------------------------------------------
# Tests
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_create_card_success_under_limit() -> None:
    """A card can be added when the book has fewer than 5 existing cards."""
    repo = FakeCurationRepository()
    book_id = uuid4()
    svc = _svc(repo)

    result = await svc.create_card(book_id=book_id, req=_req(title="첫 번째 카드"))

    assert result.book_id == book_id
    assert result.title == "첫 번째 카드"
    assert result.card_type == "intro"
    assert result.order_index == 0

    # Card is persisted in the repo.
    stored = await repo.list_by_book(book_id)
    assert len(stored) == 1


@pytest.mark.asyncio
async def test_create_card_at_limit_raises() -> None:
    """Adding a 6th card raises ConflictError with code CURATION_CARD_LIMIT."""
    repo = FakeCurationRepository()
    book_id = uuid4()
    svc = _svc(repo)

    # Seed 5 cards directly to reach the limit.
    for i in range(5):
        repo.seed_card(_FakeCard(book_id=book_id, order_index=i))

    with pytest.raises(ConflictError) as exc_info:
        await svc.create_card(book_id=book_id, req=_req())

    assert exc_info.value.code == "CURATION_CARD_LIMIT"
    # Confirm no 6th card was written.
    assert len(await repo.list_by_book(book_id)) == 5


@pytest.mark.asyncio
async def test_create_exactly_fifth_card_succeeds() -> None:
    """The 5th card (index 4 after 4 existing) must be accepted, not rejected."""
    repo = FakeCurationRepository()
    book_id = uuid4()
    svc = _svc(repo)

    for i in range(4):
        repo.seed_card(_FakeCard(book_id=book_id, order_index=i))

    result = await svc.create_card(book_id=book_id, req=_req(title="다섯 번째 카드"))

    assert result.title == "다섯 번째 카드"
    assert len(await repo.list_by_book(book_id)) == 5


@pytest.mark.asyncio
async def test_delete_card_success() -> None:
    """Deleting an existing card removes it from the repository."""
    repo = FakeCurationRepository()
    book_id = uuid4()
    card = _FakeCard(book_id=book_id)
    repo.seed_card(card)
    svc = _svc(repo)

    await svc.delete_card(card.id)

    assert len(await repo.list_by_book(book_id)) == 0


@pytest.mark.asyncio
async def test_delete_nonexistent_card_raises() -> None:
    """Deleting a card that does not exist raises NotFoundError with code CURATION_CARD_NOT_FOUND."""
    repo = FakeCurationRepository()
    svc = _svc(repo)

    with pytest.raises(NotFoundError) as exc_info:
        await svc.delete_card(uuid4())

    assert exc_info.value.code == "CURATION_CARD_NOT_FOUND"


@pytest.mark.asyncio
async def test_list_cards_returns_in_order_index_order() -> None:
    """list_cards returns cards sorted by order_index ascending."""
    repo = FakeCurationRepository()
    book_id = uuid4()
    svc = _svc(repo)

    # Insert out of order to verify sorting is enforced.
    repo.seed_card(_FakeCard(book_id=book_id, title="세 번째", order_index=2))
    repo.seed_card(_FakeCard(book_id=book_id, title="첫 번째", order_index=0))
    repo.seed_card(_FakeCard(book_id=book_id, title="두 번째", order_index=1))

    cards = await svc.list_cards(book_id)

    assert len(cards) == 3
    assert cards[0].title == "첫 번째"
    assert cards[1].title == "두 번째"
    assert cards[2].title == "세 번째"


@pytest.mark.asyncio
async def test_list_cards_empty_book_returns_empty() -> None:
    """list_cards returns an empty list when no cards exist for the book."""
    repo = FakeCurationRepository()
    svc = _svc(repo)

    cards = await svc.list_cards(uuid4())

    assert cards == []


@pytest.mark.asyncio
async def test_get_first_card_returns_lowest_order() -> None:
    """get_first_card returns the card with the smallest order_index."""
    repo = FakeCurationRepository()
    book_id = uuid4()
    svc = _svc(repo)

    first_card = _FakeCard(book_id=book_id, title="먼저", order_index=0)
    second_card = _FakeCard(book_id=book_id, title="나중", order_index=5)
    repo.seed_card(second_card)
    repo.seed_card(first_card)

    result = await svc.get_first_card(book_id)

    assert result is not None
    assert result.title == "먼저"
    assert result.order_index == 0


@pytest.mark.asyncio
async def test_get_first_card_returns_none_when_empty() -> None:
    """get_first_card returns None when the book has no curation cards."""
    repo = FakeCurationRepository()
    svc = _svc(repo)

    result = await svc.get_first_card(uuid4())

    assert result is None


@pytest.mark.asyncio
async def test_list_cards_isolated_per_book() -> None:
    """Cards are scoped per book — listing one book's cards does not include another's."""
    repo = FakeCurationRepository()
    svc = _svc(repo)

    book_a = uuid4()
    book_b = uuid4()

    repo.seed_card(_FakeCard(book_id=book_a, title="A 카드"))
    repo.seed_card(_FakeCard(book_id=book_b, title="B 카드"))

    cards_a = await svc.list_cards(book_a)
    cards_b = await svc.list_cards(book_b)

    assert len(cards_a) == 1
    assert cards_a[0].title == "A 카드"
    assert len(cards_b) == 1
    assert cards_b[0].title == "B 카드"


# ---------------------------------------------------------------------------
# M67 — feedback loop & deprioritization
# ---------------------------------------------------------------------------


def _feedback_setup(
    cards: list[_FakeCard],
) -> tuple[FakeCurationRepository, FakeFeedbackRepository, CurationService]:
    repo = FakeCurationRepository()
    for c in cards:
        repo.seed_card(c)
    feedback = FakeFeedbackRepository({c.id: c for c in cards})
    return repo, feedback, _svc_with_feedback(repo, feedback)


@pytest.mark.asyncio
async def test_record_feedback_persists_action() -> None:
    """record_feedback upserts the reader's reaction for an existing card."""
    book_id = uuid4()
    card = _FakeCard(book_id=book_id, card_type="quote")
    _, feedback, svc = _feedback_setup([card])
    user_id = uuid4()

    await svc.record_feedback(user_id=user_id, card_id=card.id, action="skip")

    deprioritized = await feedback.deprioritized_card_types(user_id=user_id, threshold=1)
    assert "quote" in deprioritized


@pytest.mark.asyncio
async def test_record_feedback_unknown_card_raises() -> None:
    """Feedback on a non-existent card raises NotFoundError."""
    _, _, svc = _feedback_setup([])
    with pytest.raises(NotFoundError) as exc_info:
        await svc.record_feedback(user_id=uuid4(), card_id=uuid4(), action="helpful")
    assert exc_info.value.code == "CURATION_CARD_NOT_FOUND"


@pytest.mark.asyncio
async def test_get_first_card_deprioritizes_disliked_type() -> None:
    """A type skipped >= threshold times sorts last, even with a lower order_index."""
    book_id = uuid4()
    # The quote card has the lowest order_index, so it wins by default order.
    quote_card = _FakeCard(book_id=book_id, card_type="quote", order_index=0, title="인용")
    intro_card = _FakeCard(book_id=book_id, card_type="intro", order_index=1, title="소개")
    repo, feedback, svc = _feedback_setup([quote_card, intro_card])
    user_id = uuid4()

    # Skip three different quote cards to deprioritize the whole 'quote' type.
    for _ in range(3):
        other_quote = _FakeCard(book_id=book_id, card_type="quote")
        repo.seed_card(other_quote)
        feedback._cards[other_quote.id] = other_quote
        await svc.record_feedback(user_id=user_id, card_id=other_quote.id, action="skip")

    result = await svc.get_first_card(book_id, user_id=user_id)

    assert result is not None
    assert result.card_type == "intro"  # quote deprioritized despite lower order


@pytest.mark.asyncio
async def test_get_first_card_below_threshold_keeps_default_order() -> None:
    """Fewer than threshold skips leave the default order_index ranking intact."""
    book_id = uuid4()
    quote_card = _FakeCard(book_id=book_id, card_type="quote", order_index=0, title="인용")
    intro_card = _FakeCard(book_id=book_id, card_type="intro", order_index=1, title="소개")
    repo, feedback, svc = _feedback_setup([quote_card, intro_card])
    user_id = uuid4()

    # Only two skips — under the threshold of 3.
    for _ in range(2):
        other_quote = _FakeCard(book_id=book_id, card_type="quote")
        repo.seed_card(other_quote)
        feedback._cards[other_quote.id] = other_quote
        await svc.record_feedback(user_id=user_id, card_id=other_quote.id, action="skip")

    result = await svc.get_first_card(book_id, user_id=user_id)

    assert result is not None
    assert result.card_type == "quote"  # default order preserved


@pytest.mark.asyncio
async def test_get_first_card_anonymous_uses_default_order() -> None:
    """Without a user_id the service falls back to the single-query default."""
    book_id = uuid4()
    repo = FakeCurationRepository()
    repo.seed_card(_FakeCard(book_id=book_id, card_type="quote", order_index=0, title="인용"))
    svc = _svc(repo)

    result = await svc.get_first_card(book_id)

    assert result is not None
    assert result.card_type == "quote"

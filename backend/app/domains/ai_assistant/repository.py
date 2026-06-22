"""ai_assistant repositories and cross-domain query adapters.

Everything that touches our own infrastructure (Postgres rows, the Redis prep
cache) or reads another domain's data lives here, behind the ports in
``ports.py``. The service stays DB-free and unit-testable; ``providers.py`` wires
these concrete implementations for HTTP traffic.

The cross-domain reads (book info, ``is_pro``, library/highlights, club) are kept
as thin query adapters rather than importing other domains' services, per
CLAUDE.md §3.3 — a domain may read another's data through a narrow contract but
not reach into its repositories.
"""

from __future__ import annotations

import json
import logging
from datetime import UTC, datetime
from typing import TYPE_CHECKING, Any
from uuid import UUID

from sqlalchemy import func, select, text
from sqlalchemy.ext.asyncio import AsyncSession

if TYPE_CHECKING:
    from app.domains.club.repository import ClubRepository
    from app.domains.club.service import ClubService

from sqlalchemy.dialects.postgresql import insert as pg_insert

from app.core.cache import get_redis
from app.domains.ai_assistant.models import AIReflectionGuide, AIUsageLog, UserAiPreference
from app.domains.ai_assistant.ports import (
    BookInfo,
    NextBookRecommendation,
    PrepCardContent,
    ReflectionContent,
    ReflectionInput,
)
from app.domains.auth.models import User
from app.domains.book.models import Book, UserBook

logger = logging.getLogger(__name__)

_PREP_CACHE_TTL_SECONDS = 72 * 60 * 60
_MAX_HIGHLIGHTS = 10


def _prep_cache_key(book_id: UUID, style: str) -> str:
    return f"ai_prep:{book_id}:{style}"


class RedisPrepCache:
    """:class:`PrepCachePort` backed by the shared async Redis client (72h TTL).

    Keyed by ``(book_id, style)`` so per-user persona personalization stays
    correct (M67). Redis failures degrade to a cache miss / silent skip so an
    outage never blocks generation (matching ``core.cache`` semantics).
    """

    async def get_prep(self, book_id: UUID, style: str) -> PrepCardContent | None:
        try:
            raw = await get_redis().get(_prep_cache_key(book_id, style))
        except Exception:
            logger.warning("ai_prep cache_read_error book=%s", book_id, exc_info=True)
            return None
        if raw is None:
            return None
        data = json.loads(raw)
        return PrepCardContent(
            author_intro=data["author_intro"],
            theme_keywords=data["theme_keywords"],
            prereading_questions=data["prereading_questions"],
            tokens_used=data.get("tokens_used", 0),
        )

    async def set_prep(self, book_id: UUID, style: str, content: PrepCardContent) -> None:
        payload = json.dumps(
            {
                "author_intro": content.author_intro,
                "theme_keywords": content.theme_keywords,
                "prereading_questions": content.prereading_questions,
                "tokens_used": content.tokens_used,
            }
        )
        try:
            await get_redis().set(
                _prep_cache_key(book_id, style), payload, ex=_PREP_CACHE_TTL_SECONDS
            )
        except Exception:
            logger.warning("ai_prep cache_write_error book=%s", book_id, exc_info=True)


class UserAiPreferencesRepository:
    """:class:`UserPreferencesPort` over ``user_ai_preferences``."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get_prefs(self, user_id: UUID) -> str | None:
        style: str | None = await self._session.scalar(
            select(UserAiPreference.card_style).where(UserAiPreference.user_id == user_id)
        )
        return style

    async def upsert_prefs(self, *, user_id: UUID, style: str) -> None:
        stmt = (
            pg_insert(UserAiPreference)
            .values(user_id=user_id, card_style=style, updated_at=func.now())
            .on_conflict_do_update(
                index_elements=[UserAiPreference.user_id],
                set_={"card_style": style, "updated_at": func.now()},
            )
        )
        await self._session.execute(stmt)
        await self._session.flush()


class AIReflectionRepository:
    """:class:`ReflectionRepositoryPort` over ``ai_reflection_guides``."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get(self, *, user_id: UUID, book_id: UUID) -> ReflectionContent | None:
        row = await self._session.scalar(
            select(AIReflectionGuide).where(
                AIReflectionGuide.user_id == user_id,
                AIReflectionGuide.book_id == book_id,
            )
        )
        return _content_from_row(row.content) if row is not None else None

    async def create(
        self, *, user_id: UUID, book_id: UUID, content: ReflectionContent
    ) -> ReflectionContent:
        guide = AIReflectionGuide(
            user_id=user_id,
            book_id=book_id,
            content=_content_to_json(content),
            tokens_used=content.tokens_used,
        )
        self._session.add(guide)
        await self._session.flush()
        return content


class AIUsageLogRepository:
    """:class:`UsageLogRepositoryPort` over ``ai_usage_logs``."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def count_since(self, *, user_id: UUID, feature: str, since: datetime) -> int:
        count = await self._session.scalar(
            select(func.count())
            .select_from(AIUsageLog)
            .where(
                AIUsageLog.user_id == user_id,
                AIUsageLog.feature == feature,
                AIUsageLog.created_at >= since,
            )
        )
        return int(count or 0)

    async def record(
        self, *, user_id: UUID, feature: str, book_id: UUID | None, tokens_used: int
    ) -> None:
        self._session.add(
            AIUsageLog(
                user_id=user_id,
                feature=feature,
                book_id=book_id,
                tokens_used=tokens_used,
            )
        )
        await self._session.flush()


class BookInfoAdapter:
    """:class:`BookInfoPort` — reads the catalog ``books`` row."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get_book_info(self, book_id: UUID) -> BookInfo | None:
        row = await self._session.execute(
            select(Book.title, Book.author, Book.description).where(Book.id == book_id)
        )
        result = row.first()
        if result is None:
            return None
        return BookInfo(title=result.title, author=result.author, description=result.description)


class UserQueryAdapter:
    """:class:`UserQueryPort` — reads the auth ``users.is_pro`` flag."""

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def is_pro(self, user_id: UUID) -> bool:
        is_pro = await self._session.scalar(select(User.is_pro).where(User.id == user_id))
        return bool(is_pro)


class LibraryQueryAdapter:
    """:class:`LibraryQueryPort` — resolves a library item to reflection inputs.

    Joins ``user_books`` → ``books`` and pulls the reader's bookmark notes as the
    highlight list. Ownership is enforced in the WHERE clause: a row owned by
    another user resolves to ``None`` (→ 404), not a leaked record.
    """

    def __init__(self, session: AsyncSession) -> None:
        self._session = session

    async def get_reflection_input(
        self, *, user_id: UUID, user_book_id: UUID
    ) -> ReflectionInput | None:
        row = (
            await self._session.execute(
                select(
                    UserBook.book_id,
                    UserBook.started_at,
                    UserBook.finished_at,
                    Book.title,
                    Book.author,
                )
                .join(Book, Book.id == UserBook.book_id)
                .where(UserBook.id == user_book_id, UserBook.user_id == user_id)
            )
        ).first()
        if row is None:
            return None

        highlight_rows = await self._session.execute(
            text(
                "SELECT note FROM bookmarks "
                "WHERE user_book_id = :ub AND note IS NOT NULL "
                "ORDER BY created_at ASC LIMIT :lim"
            ),
            {"ub": str(user_book_id), "lim": _MAX_HIGHLIGHTS},
        )
        highlights = [r[0] for r in highlight_rows.fetchall()]

        return ReflectionInput(
            book_id=row.book_id,
            title=row.title,
            author=row.author,
            highlights=highlights,
            reading_days=_reading_days(row.started_at, row.finished_at),
        )


class ClubCoachAdapter:
    """:class:`ClubCoachPort` — bridges club ownership, the club's book, and chat.

    Composes the club repository (ownership + current book), a ``BookInfoPort``
    (book facts), and the club service (posting the generated topics as a chat
    message). Posting goes through ``ClubService.send_message`` rather than the
    club repo directly, so the existing membership check and WebSocket broadcast
    are reused (CLAUDE.md §3.3).
    """

    def __init__(
        self,
        *,
        club_repo: ClubRepository,
        book_info: BookInfoAdapter,
        club_service: ClubService,
    ) -> None:
        self._club_repo = club_repo
        self._book_info = book_info
        self._club_service = club_service

    async def get_club_book(self, club_id: UUID) -> BookInfo | None:
        club = await self._club_repo.get_by_id(club_id)
        if club is None or club.book_id is None:
            return None
        return await self._book_info.get_book_info(club.book_id)

    async def is_owner(self, *, club_id: UUID, user_id: UUID) -> bool:
        club = await self._club_repo.get_by_id(club_id)
        return club is not None and club.owner_id == user_id

    async def post_topics_message(self, *, club_id: UUID, user_id: UUID, topics: list[str]) -> None:
        numbered = "\n".join(f"{i}. {t}" for i, t in enumerate(topics, start=1))
        content = f"📌 이번 주 토론 주제\n{numbered}"
        await self._club_service.send_message(
            club_id=club_id, user_id=user_id, content=content, media_url=None
        )


def _reading_days(started_at: datetime | None, finished_at: datetime | None) -> int:
    if started_at is None:
        return 0
    end = finished_at or datetime.now(tz=UTC)
    return max(0, (end - started_at).days)


def _content_to_json(content: ReflectionContent) -> dict[str, object]:
    return {
        "insights": content.insights,
        "action_point": content.action_point,
        "next_books": [{"title": b.title, "reason": b.reason} for b in content.next_books],
        "tokens_used": content.tokens_used,
    }


def _content_from_row(data: dict[str, Any]) -> ReflectionContent:
    return ReflectionContent(
        insights=[str(i) for i in data["insights"]],
        action_point=str(data["action_point"]),
        next_books=[
            NextBookRecommendation(title=str(b["title"]), reason=str(b["reason"]))
            for b in data.get("next_books", [])
        ],
        tokens_used=int(data.get("tokens_used", 0)),
    )

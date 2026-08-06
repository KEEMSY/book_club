from __future__ import annotations

from dataclasses import dataclass
from typing import TYPE_CHECKING, Annotated
from uuid import UUID

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.cache import get_redis
from app.core.db import get_session
from app.domains.club.repository import ClubRepository
from app.domains.club.service import ClubService

if TYPE_CHECKING:
    from app.domains.ai_assistant.ports import AIAssistantPort, BookInfoPort, UsageLogRepositoryPort


@dataclass(slots=True)
class _AgendaTopicAiAdapter:
    """Adapts ai_assistant's reusable generation logic to ``AgendaTopicAiPort`` (BC-53).

    Deliberately does *not* go through ``ai_assistant.providers.get_ai_assistant_service``
    — that constructs a ``ClubCoachPort`` which itself calls ``get_club_service``
    (M63, for posting AI club-topics to chat), so routing through it here would
    recurse: get_club_service -> get_ai_assistant_service -> get_club_service -> ...
    Instead this wires only the three narrow ports the BC-53 flow actually needs
    (AI port, book lookup, usage log) directly from ai_assistant's own adapters,
    and calls the shared ``generate_agenda_topic_drafts`` business-logic function
    — the same reuse of the M63 asset without the construction cycle.
    """

    ai: AIAssistantPort
    books: BookInfoPort
    usage: UsageLogRepositoryPort

    async def generate_topic_drafts(self, *, user_id: UUID, book_id: UUID, scope: str) -> list[str]:
        from app.domains.ai_assistant.service import generate_agenda_topic_drafts

        content = await generate_agenda_topic_drafts(
            ai=self.ai,
            books=self.books,
            usage=self.usage,
            user_id=user_id,
            book_id=book_id,
            scope=scope,
        )
        return content.topics


def get_club_service(session: Annotated[AsyncSession, Depends(get_session)]) -> ClubService:
    from app.domains.ai_assistant.providers import get_ai_adapter
    from app.domains.ai_assistant.repository import AIUsageLogRepository, BookInfoAdapter
    from app.domains.feed.providers import get_feed_service
    from app.domains.notification.providers import get_notification_service

    return ClubService(
        repo=ClubRepository(session),
        feed_service=get_feed_service(session),
        # Process-wide — notification pushes use their own sessions, independent
        # of the request-scoped `session` above (BC-48, mirrors feed_service).
        notification_service=get_notification_service(),
        redis=get_redis(),
        agenda_ai=_AgendaTopicAiAdapter(
            ai=get_ai_adapter(),
            books=BookInfoAdapter(session),
            usage=AIUsageLogRepository(session),
        ),
    )

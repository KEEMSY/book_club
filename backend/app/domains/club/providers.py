from __future__ import annotations

from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.cache import get_redis
from app.core.db import get_session
from app.domains.club.repository import ClubRepository
from app.domains.club.service import ClubService


def get_club_service(session: Annotated[AsyncSession, Depends(get_session)]) -> ClubService:
    from app.domains.feed.providers import get_feed_service
    from app.domains.notification.providers import get_notification_service

    return ClubService(
        repo=ClubRepository(session),
        feed_service=get_feed_service(session),
        # Process-wide — notification pushes use their own sessions, independent
        # of the request-scoped `session` above (BC-48, mirrors feed_service).
        notification_service=get_notification_service(),
        redis=get_redis(),
    )

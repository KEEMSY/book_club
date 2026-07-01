"""Development-only data seeding endpoint.

Exposes ``POST /dev/seed`` which populates realistic test data for the
currently authenticated user.  Returns 404 in any non-dev environment.

Safety guard: the ``dev:개발자`` account is explicitly excluded so the
developer's own data is never touched by this endpoint.
"""

from __future__ import annotations

import calendar
from datetime import UTC, date, datetime, timedelta
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import delete, select
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import get_settings
from app.core.db import get_session
from app.core.deps import get_current_user
from app.domains.auth.models import User
from app.domains.book.models import Book, BookSource, UserBook, UserBookStatus
from app.domains.feed.models import FeedEvent, FeedEventType
from app.domains.notification.models import Notification, NotificationType
from app.domains.reading.models import (
    Goal,
    GoalPeriod,
    ReadingSession,
    ReadingSessionSource,
)

router = APIRouter(prefix="/dev", tags=["dev"])

_SEED_BOOKS = [
    {
        "isbn13": "TSTSEED000001",
        "title": "파친코",
        "author": "이민진",
        "publisher": "인플루엔셜",
        "source": BookSource.MANUAL,
    },
    {
        "isbn13": "TSTSEED000002",
        "title": "채식주의자",
        "author": "한강",
        "publisher": "창비",
        "source": BookSource.MANUAL,
    },
    {
        "isbn13": "TSTSEED000003",
        "title": "82년생 김지영",
        "author": "조남주",
        "publisher": "민음사",
        "source": BookSource.MANUAL,
    },
    {
        "isbn13": "TSTSEED000004",
        "title": "아몬드",
        "author": "손원평",
        "publisher": "창비",
        "source": BookSource.MANUAL,
    },
]


async def _clear_tester_data(user_id: object, session: AsyncSession) -> None:
    """Remove all seeded data for *user_id* so the endpoint is idempotent."""
    seed_isbns = [b["isbn13"] for b in _SEED_BOOKS]
    seed_book_ids_result = await session.execute(
        select(Book.id).where(Book.isbn13.in_(seed_isbns))
    )
    seed_book_ids = [row[0] for row in seed_book_ids_result.fetchall()]

    if seed_book_ids:
        ub_ids_result = await session.execute(
            select(UserBook.id).where(
                UserBook.user_id == user_id,
                UserBook.book_id.in_(seed_book_ids),
            )
        )
        ub_ids = [row[0] for row in ub_ids_result.fetchall()]
        if ub_ids:
            await session.execute(
                delete(ReadingSession).where(
                    ReadingSession.user_book_id.in_(ub_ids),
                )
            )
        await session.execute(
            delete(UserBook).where(
                UserBook.user_id == user_id,
                UserBook.book_id.in_(seed_book_ids),
            )
        )

    await session.execute(delete(Goal).where(Goal.user_id == user_id))
    await session.execute(delete(FeedEvent).where(FeedEvent.user_id == user_id))
    await session.execute(delete(Notification).where(Notification.user_id == user_id))


@router.post("/seed", status_code=status.HTTP_204_NO_CONTENT)
async def seed_tester_data(
    current_user: Annotated[User, Depends(get_current_user)],
    session: Annotated[AsyncSession, Depends(get_session)],
) -> None:
    """Seed realistic test data for the current dev-login user.

    Idempotent — re-running clears the previous seed and re-creates it.
    Always returns 404 outside the ``dev`` environment.
    """
    if get_settings().env != "dev":
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND)

    if current_user.provider_sub == "dev:개발자":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="개발자 계정은 시드 대상이 아닙니다.",
        )

    user_id = current_user.id
    today = date.today()
    now = datetime.now(tz=UTC)

    await _clear_tester_data(user_id, session)

    # ── Books (global catalog; shared across testers) ─────────────────────────
    books: list[Book] = []
    for spec in _SEED_BOOKS:
        existing = await session.scalar(select(Book).where(Book.isbn13 == spec["isbn13"]))
        if existing is None:
            book = Book(**spec)
            session.add(book)
            await session.flush()
            books.append(book)
        else:
            books.append(existing)

    # ── UserBook entries ───────────────────────────────────────────────────────
    ub_completed1 = UserBook(
        user_id=user_id,
        book_id=books[0].id,
        status=UserBookStatus.COMPLETED,
        started_at=now - timedelta(days=30),
        finished_at=now - timedelta(days=5),
        rating=5,
        one_line_review="읽는 내내 가슴이 먹먹했던 작품",
    )
    ub_completed2 = UserBook(
        user_id=user_id,
        book_id=books[1].id,
        status=UserBookStatus.COMPLETED,
        started_at=now - timedelta(days=60),
        finished_at=now - timedelta(days=40),
        rating=4,
    )
    ub_reading = UserBook(
        user_id=user_id,
        book_id=books[2].id,
        status=UserBookStatus.READING,
        started_at=now - timedelta(days=10),
    )
    ub_wishlist = UserBook(
        user_id=user_id,
        book_id=books[3].id,
        status=UserBookStatus.WISHLIST,
    )
    session.add_all([ub_completed1, ub_completed2, ub_reading, ub_wishlist])
    await session.flush()

    # ── Reading sessions (builds a streak + heatmap for the last 2 weeks) ─────
    _session_specs: list[tuple[object, date, int]] = [
        (ub_completed1.id, today - timedelta(days=30), 3600),
        (ub_completed1.id, today - timedelta(days=28), 2700),
        (ub_completed1.id, today - timedelta(days=25), 4500),
        (ub_completed2.id, today - timedelta(days=60), 1800),
        (ub_completed2.id, today - timedelta(days=55), 2400),
        (ub_reading.id, today - timedelta(days=7), 3000),
        (ub_reading.id, today - timedelta(days=6), 1800),
        (ub_reading.id, today - timedelta(days=5), 2700),
        (ub_reading.id, today - timedelta(days=4), 3600),
        (ub_reading.id, today - timedelta(days=3), 1200),
        (ub_reading.id, today - timedelta(days=2), 2400),
        (ub_reading.id, today - timedelta(days=1), 3000),
    ]
    for ub_id, day, dur in _session_specs:
        started = datetime(day.year, day.month, day.day, 20, 0, 0, tzinfo=UTC)
        session.add(
            ReadingSession(
                user_id=user_id,
                user_book_id=ub_id,
                started_at=started,
                ended_at=started + timedelta(seconds=dur),
                duration_sec=dur,
                source=ReadingSessionSource.MANUAL,
            )
        )

    # ── Goals ─────────────────────────────────────────────────────────────────
    weekday = today.weekday()
    week_start = today - timedelta(days=weekday)
    week_end = week_start + timedelta(days=6)

    month_start = today.replace(day=1)
    month_end = today.replace(day=calendar.monthrange(today.year, today.month)[1])

    session.add_all([
        Goal(
            user_id=user_id,
            period=GoalPeriod.WEEKLY,
            target_seconds=3 * 3600,
            target_books=0,
            start_date=week_start,
            end_date=week_end,
        ),
        Goal(
            user_id=user_id,
            period=GoalPeriod.MONTHLY,
            target_seconds=15 * 3600,
            target_books=2,
            start_date=month_start,
            end_date=month_end,
        ),
        Goal(
            user_id=user_id,
            period=GoalPeriod.YEARLY,
            target_seconds=100 * 3600,
            target_books=12,
            start_date=date(today.year, 1, 1),
            end_date=date(today.year, 12, 31),
        ),
    ])

    # ── Feed events ────────────────────────────────────────────────────────────
    session.add_all([
        FeedEvent(
            user_id=user_id,
            event_type=FeedEventType.BOOK_COMPLETED,
            event_metadata={"book_title": "파친코", "book_author": "이민진"},
        ),
        FeedEvent(
            user_id=user_id,
            event_type=FeedEventType.BOOK_COMPLETED,
            event_metadata={"book_title": "채식주의자", "book_author": "한강"},
        ),
        FeedEvent(
            user_id=user_id,
            event_type=FeedEventType.STREAK_MILESTONE,
            event_metadata={"streak_days": 7},
        ),
    ])

    # ── Notifications (mix of unread and already-read) ─────────────────────────
    session.add_all([
        Notification(
            user_id=user_id,
            ntype=NotificationType.GRADE_UP,
            title="등급 상승!",
            body="독서량이 늘어 등급이 올랐습니다. 계속 읽어보세요!",
            data={},
        ),
        Notification(
            user_id=user_id,
            ntype=NotificationType.STREAK_WARNING,
            title="스트릭 위기!",
            body="오늘 독서를 기록하지 않으면 스트릭이 끊깁니다.",
            data={},
        ),
        Notification(
            user_id=user_id,
            ntype=NotificationType.WEEKLY_REPORT,
            title="이번 주 독서 리포트",
            body="이번 주 총 3시간 30분을 읽었습니다. 훌륭해요!",
            data={},
            read_at=now - timedelta(hours=2),
        ),
    ])

    await session.commit()

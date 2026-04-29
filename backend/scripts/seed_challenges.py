"""챌린지 및 배지 시드 스크립트 (멱등).

Usage:
    cd backend
    .venv/bin/python scripts/seed_challenges.py

- 동일 title 의 챌린지가 이미 있으면 건너뜁니다 (upsert 방식).
- 동일 name 의 배지가 이미 있으면 건너뜁니다.
"""

from __future__ import annotations

import asyncio
import os
import sys
from datetime import datetime, timezone

sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker

from app.core.config import get_settings
from app.domains.challenge.models import Badge, BadgeCategory, Challenge, ChallengeType


_BADGES = [
    {
        "name": "독서 마라토너",
        "description": "한 달간 총 30시간 이상 독서한 독서 마라토너",
        "category": BadgeCategory.CHALLENGE,
        "icon_key": "badges/reading_marathon.png",
    },
    {
        "name": "다독가",
        "description": "5권의 책을 완독한 열정적인 독서인",
        "category": BadgeCategory.CHALLENGE,
        "icon_key": "badges/five_books.png",
    },
    {
        "name": "독서 스트리커",
        "description": "30일 연속 독서 스트릭 달성",
        "category": BadgeCategory.CHALLENGE,
        "icon_key": "badges/streak_30.png",
    },
]

# Challenges are defined relative to the script run date; adjust dates as needed.
_NOW = datetime.now(tz=timezone.utc)
_YEAR = _NOW.year


def _dt(month: int, day: int) -> datetime:
    return datetime(_YEAR, month, day, 0, 0, 0, tzinfo=timezone.utc)


_CHALLENGES = [
    {
        "title": f"{_YEAR}년 상반기 30시간 읽기",
        "description": "상반기 6개월 동안 총 108,000초(30시간) 이상 독서하세요.",
        "challenge_type": ChallengeType.READING_TIME,
        "target_value": 108_000,  # seconds
        "genre_filter": None,
        "starts_at": _dt(1, 1),
        "ends_at": _dt(6, 30),
        "badge_name": "독서 마라토너",
    },
    {
        "title": f"{_YEAR}년 책 5권 완독",
        "description": "올해 안에 책 5권을 완독해 보세요.",
        "challenge_type": ChallengeType.BOOKS_COUNT,
        "target_value": 5,
        "genre_filter": None,
        "starts_at": _dt(1, 1),
        "ends_at": _dt(12, 31),
        "badge_name": "다독가",
    },
    {
        "title": "30일 독서 스트릭",
        "description": "30일 연속 독서 기록을 쌓아보세요.",
        "challenge_type": ChallengeType.STREAK,
        "target_value": 30,
        "genre_filter": None,
        "starts_at": _dt(1, 1),
        "ends_at": _dt(12, 31),
        "badge_name": "독서 스트리커",
    },
]


async def seed(session: AsyncSession) -> None:
    # --- badges ---
    badge_by_name: dict[str, Badge] = {}
    for b_data in _BADGES:
        existing = await session.scalar(select(Badge).where(Badge.name == b_data["name"]))
        if existing is not None:
            print(f"  배지 이미 존재: {b_data['name']}")
            badge_by_name[b_data["name"]] = existing
            continue
        badge = Badge(
            name=b_data["name"],
            description=b_data["description"],
            category=b_data["category"],
            icon_key=b_data["icon_key"],
        )
        session.add(badge)
        await session.flush()
        await session.refresh(badge)
        badge_by_name[badge.name] = badge
        print(f"  배지 생성: {badge.name} ({badge.id})")

    # --- challenges ---
    for c_data in _CHALLENGES:
        existing = await session.scalar(select(Challenge).where(Challenge.title == c_data["title"]))
        if existing is not None:
            print(f"  챌린지 이미 존재: {c_data['title']}")
            continue
        badge = badge_by_name.get(c_data["badge_name"])
        ch = Challenge(
            title=c_data["title"],
            description=c_data["description"],
            challenge_type=c_data["challenge_type"],
            target_value=c_data["target_value"],
            genre_filter=c_data["genre_filter"],
            starts_at=c_data["starts_at"],
            ends_at=c_data["ends_at"],
            badge_id=badge.id if badge else None,
        )
        session.add(ch)
        await session.flush()
        await session.refresh(ch)
        print(f"  챌린지 생성: {ch.title} ({ch.id})")

    await session.commit()


async def main() -> None:
    settings = get_settings()
    engine = create_async_engine(settings.database_url, echo=False)
    factory = async_sessionmaker(engine, expire_on_commit=False)
    async with factory() as session:
        print("챌린지/배지 시드 시작...")
        await seed(session)
        print("완료.")
    await engine.dispose()


if __name__ == "__main__":
    asyncio.run(main())

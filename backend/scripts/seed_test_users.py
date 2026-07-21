"""개발용 테스트 유저 시드 스크립트.

Usage:
    cd backend
    .venv/bin/python scripts/seed_test_users.py

- 환경변수 DATABASE_URL 이 없으면 기본 로컬 URL을 사용합니다.
- 이미 존재하는 닉네임은 건너뜁니다 (idempotent).
- 생성된 각 유저의 dev-login JWT를 출력합니다.
"""

from __future__ import annotations

import asyncio
import os
import sys

# Ensure the project root (backend/) is on sys.path
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))

from app.core.config import get_settings
from app.domains.auth.models import AuthProvider, User
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker

_TEST_USERS = [
    {
        "nickname": "책벌레_지수",
        "email": "jisu@test.bookclub.kr",
        "bio": "하루 한 권이 목표예요 📚 SF랑 추리소설을 즐겨 읽어요.",
        "profile_image_url": None,
    },
    {
        "nickname": "독서중독_민준",
        "email": "minjun@test.bookclub.kr",
        "bio": "올해 목표는 100권 완독 🎯 철학·역사 주로 읽습니다.",
        "profile_image_url": None,
    },
    {
        "nickname": "새벽독서_유진",
        "email": "yujin@test.bookclub.kr",
        "bio": "새벽 5시 독서 클럽 운영 중 ☕ 에세이·시집 애독자.",
        "profile_image_url": None,
    },
    {
        "nickname": "책추천_서아",
        "email": "seoa@test.bookclub.kr",
        "bio": "매달 독서 챌린지 참여해요 🌿 문학·소설 전공.",
        "profile_image_url": None,
    },
    {
        "nickname": "느린독서_현우",
        "email": "hyunwoo@test.bookclub.kr",
        "bio": "빠르게보다 깊게. 한 달에 두세 권 천천히 읽어요.",
        "profile_image_url": None,
    },
    {
        "nickname": "북큐레이터_나연",
        "email": "nayeon@test.bookclub.kr",
        "bio": "좋은 책을 좋은 사람과 나누고 싶어요 💌",
        "profile_image_url": None,
    },
    {
        "nickname": "다독왕_태양",
        "email": "taeyang@test.bookclub.kr",
        "bio": "장르 불문 닥치는대로 읽는 중. 최근엔 경제경영에 빠짐.",
        "profile_image_url": None,
    },
    {
        "nickname": "글쓰는독자_하은",
        "email": "haeun@test.bookclub.kr",
        "bio": "읽고 쓰고 나누고. 독서 에세이 블로그 운영 중 ✍️",
        "profile_image_url": None,
    },
]


async def seed() -> None:
    settings = get_settings()
    db_url = settings.database_url

    engine = create_async_engine(db_url, echo=False)
    async_session: sessionmaker[AsyncSession] = sessionmaker(  # type: ignore[type-arg]
        engine, class_=AsyncSession, expire_on_commit=False
    )

    print(f"Connecting to: {db_url.split('@')[-1]}")  # hide credentials
    print("-" * 60)

    created = 0
    skipped = 0

    async with async_session() as session, session.begin():
        for data in _TEST_USERS:
            stmt = select(User).where(
                User.nickname == data["nickname"],
                User.deleted_at.is_(None),
            )
            result = await session.execute(stmt)
            existing = result.scalar_one_or_none()

            if existing is not None:
                print(f"SKIP  {data['nickname']:30s}  id={existing.id}")
                skipped += 1
                continue

            user = User(
                provider=AuthProvider.KAKAO,
                provider_sub=f"test_{data['nickname']}",
                email=data["email"],
                nickname=data["nickname"],
                bio=data["bio"],
                profile_image_url=data["profile_image_url"],
            )
            session.add(user)
            await session.flush()
            await session.refresh(user)

            print(f"  OK  {data['nickname']:30s}  id={user.id}")
            created += 1

    print("-" * 60)
    print(f"Created: {created}  Skipped (already exists): {skipped}")
    await engine.dispose()


if __name__ == "__main__":
    asyncio.run(seed())

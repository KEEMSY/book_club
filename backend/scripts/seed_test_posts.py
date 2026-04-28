"""개발용 테스트 게시물 시드 스크립트.

Usage:
    cd backend
    .venv/bin/python scripts/seed_test_posts.py

- 테스트 유저(seed_test_users.py 로 생성)를 조회하여 각 유저당 2~3 개 게시물을 생성합니다.
- 게시물에 리액션도 함께 추가하여 인기 피드 테스트가 가능합니다.
- 이미 게시물이 존재하는 유저는 건너뜁니다 (idempotent).
"""

from __future__ import annotations

import asyncio
import os
import random
import sys
from datetime import UTC, datetime, timedelta

sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))

from app.core.config import get_settings
from app.domains.auth.models import User
from app.domains.book.models import Book
from app.domains.feed.models import Post, PostType, Reaction, ReactionType
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker

_TEST_USER_EMAILS = [
    "jisu@test.bookclub.kr",
    "minjun@test.bookclub.kr",
    "yujin@test.bookclub.kr",
    "seoa@test.bookclub.kr",
    "hyunwoo@test.bookclub.kr",
    "nayeon@test.bookclub.kr",
    "taeyang@test.bookclub.kr",
    "haeun@test.bookclub.kr",
]

_POSTS_BY_USER: dict[str, list[dict]] = {
    "jisu@test.bookclub.kr": [
        {
            "post_type": PostType.HIGHLIGHT,
            "content": '"역사는 반복되지 않지만 운율을 맞춘다." 이 문장 하나가 파친코 전체를 관통하는 것 같아요. 이민진 작가가 왜 이 소설을 쓰는 데 30년이 걸렸는지 조금은 알 것 같습니다.',
        },
        {
            "post_type": PostType.THOUGHT,
            "content": "선자의 선택을 읽으면서 계속 나라면 어떻게 했을까 생각했어요. 사랑과 생존 중 하나를 골라야 하는 상황에서 그녀가 내린 결정은 어쩌면 가장 용감한 것이었을지도 모르겠습니다.",
        },
        {
            "post_type": PostType.QUESTION,
            "content": "파친코를 읽고 나서 재일교포에 대해 더 알고 싶어졌어요. 혹시 관련해서 같이 읽어볼 만한 책 추천해 주실 분 있나요?",
        },
    ],
    "minjun@test.bookclub.kr": [
        {
            "post_type": PostType.DISCUSSION,
            "content": "한국 근현대사를 배경으로 한 소설 중 파친코만큼 구체적이고 인간적인 작품이 또 있을까요? 역사를 개인의 이야기로 풀어낸 방식이 정말 탁월합니다. 독서 모임에서 토론해보고 싶은 주제가 한가득이에요.",
        },
        {
            "post_type": PostType.THOUGHT,
            "content": "노아의 이야기가 가장 마음 아팠어요. 자신의 정체성을 부정해야만 살아갈 수 있다는 것이 얼마나 고통스러운 일인지. 2세대의 갈등은 지금도 어딘가에서 계속되고 있겠죠.",
        },
    ],
    "yujin@test.bookclub.kr": [
        {
            "post_type": PostType.HIGHLIGHT,
            "content": '"파친코는 항상 집이 아닌 곳에 있는 사람들의 이야기다." 서문 한 줄에 이미 눈물이 날 뻔했어요. 새벽에 혼자 읽다가 한참 멍하니 있었습니다.',
        },
        {
            "post_type": PostType.THOUGHT,
            "content": "소설 속 각 세대가 선택할 수 있는 선택지가 얼마나 달랐는지 생각해보면, 우리가 지금 당연하게 여기는 것들이 얼마나 소중한지 다시 깨닫게 돼요.",
        },
        {
            "post_type": PostType.QUESTION,
            "content": "파친코 1권을 거의 다 읽었는데 2권도 바로 이어서 읽는 게 좋을까요, 아니면 좀 쉬었다 읽는 게 좋을까요? 감정이 너무 무거워서 쉬고 싶기도 하고 그냥 달리고 싶기도 하고 😅",
        },
    ],
    "seoa@test.bookclub.kr": [
        {
            "post_type": PostType.THOUGHT,
            "content": "이 소설에서 음식 묘사가 정말 인상적이에요. 선자 어머니가 만들어주는 음식들, 그 냄새와 맛이 느껴지는 것 같아서 읽다가 자꾸 배가 고파졌어요. 음식이 기억과 정체성의 매개체로 작용하는 방식이 아름답습니다.",
        },
        {
            "post_type": PostType.DISCUSSION,
            "content": "파친코를 통해 일제강점기 역사를 다시 공부하게 되었어요. 소설이 이렇게 역사 공부를 자연스럽게 유도할 수 있다는 게 놀랍습니다. 여러분은 이 책을 읽으면서 어떤 역사적 사건에 대해 더 알고 싶어지셨나요?",
        },
    ],
    "hyunwoo@test.bookclub.kr": [
        {
            "post_type": PostType.HIGHLIGHT,
            "content": "천천히 읽어야 제대로 음미할 수 있는 책이에요. 문장 하나하나를 그냥 지나치면 놓치는 것들이 너무 많아서. 3주에 걸쳐 읽고 있는데 그 시간이 전혀 아깝지 않습니다.",
        },
        {
            "post_type": PostType.THOUGHT,
            "content": "세대를 넘어 반복되는 차별과 억압의 구조를 보여주면서도 그 안에서 끝까지 인간적 존엄을 지켜나가는 이야기. 묵직하지만 포기하고 싶지 않은 이유가 있는 책입니다.",
        },
    ],
    "nayeon@test.bookclub.kr": [
        {
            "post_type": PostType.DISCUSSION,
            "content": "파친코를 읽고 주변 사람들에게 적극 추천했어요. 혼자 읽기엔 너무 아까운 이야기거든요. 이 책 읽으신 분들, 가장 기억에 남는 장면이 어디인지 궁금해요!",
        },
        {
            "post_type": PostType.HIGHLIGHT,
            "content": "모자수(Mozasu)가 파친코 업계에서 자신만의 길을 찾아가는 과정이 굉장히 인상적이었어요. 사회가 정한 '좋은 직업'의 범주를 벗어나서도 자부심을 가질 수 있다는 것, 지금 시대에도 여전히 의미 있는 메시지예요.",
        },
        {
            "post_type": PostType.THOUGHT,
            "content": "여러 시대에 걸친 이야기인데도 각 인물의 목소리가 선명하게 구분돼요. 이민진 작가가 얼마나 많은 인터뷰와 조사를 했을지 그 노력이 페이지마다 느껴집니다.",
        },
    ],
    "taeyang@test.bookclub.kr": [
        {
            "post_type": PostType.THOUGHT,
            "content": "장르 불문 읽는 편인데 파친코는 정말 오랜만에 밤새 읽은 책이에요. 경제적 생존의 문제가 정체성 문제와 얼마나 깊게 얽혀있는지, 비즈니스 관점에서도 생각해볼 거리가 많았습니다.",
        },
        {
            "post_type": PostType.DISCUSSION,
            "content": "솔직히 처음엔 두꺼운 책이라 부담스러웠는데 시작하고 나니 멈출 수가 없었어요. 다들 몇 페이지에서 완전히 빠져드셨나요? 저는 3장쯤에서 이미 포기 못 하겠다 싶었어요.",
        },
    ],
    "haeun@test.bookclub.kr": [
        {
            "post_type": PostType.HIGHLIGHT,
            "content": "이 소설 읽고 블로그에 긴 에세이를 쓸 것 같아요. 쓸 이야기가 너무 많아서 어디서부터 시작해야 할지 모르겠습니다. 읽으면서 계속 메모를 했는데 이미 A4 두 페이지가 됐어요.",
        },
        {
            "post_type": PostType.THOUGHT,
            "content": "소설에서 글쓰기가 언급되는 장면들이 유독 마음에 와닿았어요. 말하지 못한 것을 글로 남기는 행위, 기억을 붙잡으려는 시도로서의 글쓰기. 저도 왜 쓰는지 다시 생각해보게 됐습니다.",
        },
        {
            "post_type": PostType.DISCUSSION,
            "content": "파친코를 읽고 한국 문학에 관심이 더 생겼어요. 이민진 작가가 한국계 미국인 작가이긴 하지만, 이렇게 한국 역사를 서양 독자들에게 전달할 수 있다는 게 놀랍고 자랑스럽습니다.",
        },
    ],
}


async def seed() -> None:
    settings = get_settings()
    db_url = settings.database_url

    engine = create_async_engine(db_url, echo=False)
    async_session: sessionmaker[AsyncSession] = sessionmaker(  # type: ignore[type-arg]
        engine, class_=AsyncSession, expire_on_commit=False
    )

    print(f"Connecting to: {db_url.split('@')[-1]}")
    print("-" * 60)

    total_created = 0
    total_skipped = 0

    async with async_session() as session, session.begin():
        # Load books
        books_result = await session.execute(select(Book))
        books = books_result.scalars().all()
        if not books:
            print("ERROR: No books found in DB. Run book seeding first.")
            await engine.dispose()
            return
        print(f"Found {len(books)} book(s) (using first 5): {[b.title for b in books[:5]]}")
        books = list(books[:5])  # cap at 5 to keep posts relevant
        for email in _TEST_USER_EMAILS:
            # Load user
            user_result = await session.execute(
                select(User).where(User.email == email, User.deleted_at.is_(None))
            )
            user = user_result.scalar_one_or_none()
            if user is None:
                print(f"SKIP  {email:40s}  (user not found — run seed_test_users.py first)")
                total_skipped += 1
                continue

            # Check if user already has posts
            existing_result = await session.execute(
                select(Post).where(Post.user_id == user.id, Post.deleted_at.is_(None)).limit(1)
            )
            if existing_result.scalar_one_or_none() is not None:
                print(f"SKIP  {user.nickname:30s}  (already has posts)")
                total_skipped += 1
                continue

            post_specs = _POSTS_BY_USER.get(email, [])
            book_cycle = books * (len(post_specs) // len(books) + 1)
            created_posts: list[Post] = []

            for i, spec in enumerate(post_specs):
                book = book_cycle[i]
                # Stagger created_at so timeline ordering is realistic
                age = timedelta(hours=random.randint(1, 72))
                post = Post(
                    book_id=book.id,
                    user_id=user.id,
                    post_type=spec["post_type"],
                    content=spec["content"],
                    image_keys=[],
                    created_at=datetime.now(tz=UTC) - age,
                )
                session.add(post)
                await session.flush()
                await session.refresh(post)
                created_posts.append(post)

            print(f"  OK  {user.nickname:30s}  {len(created_posts)} posts")
            total_created += len(created_posts)

        # Add reactions from test users to each other's posts so popular feed
        # has meaningful data. Use all users that exist.
        all_users_result = await session.execute(
            select(User).where(User.email.in_(_TEST_USER_EMAILS), User.deleted_at.is_(None))
        )
        all_users = all_users_result.scalars().all()

        all_posts_result = await session.execute(
            select(Post).where(
                Post.user_id.in_([u.id for u in all_users]),
                Post.deleted_at.is_(None),
            )
        )
        all_posts = all_posts_result.scalars().all()

        reaction_types = list(ReactionType)
        reaction_count = 0
        for post in all_posts:
            # Each post gets reactions from a random subset of other users
            reactors = [u for u in all_users if u.id != post.user_id]
            num_reactors = random.randint(1, min(4, len(reactors)))
            chosen_reactors = random.sample(reactors, num_reactors)
            for reactor in chosen_reactors:
                rtype = random.choice(reaction_types)
                existing_r = await session.execute(
                    select(Reaction).where(
                        Reaction.post_id == post.id,
                        Reaction.user_id == reactor.id,
                        Reaction.reaction_type == rtype,
                    )
                )
                if existing_r.scalar_one_or_none() is None:
                    session.add(
                        Reaction(
                            post_id=post.id,
                            user_id=reactor.id,
                            reaction_type=rtype,
                        )
                    )
                    reaction_count += 1

        print(f"\nAdded {reaction_count} reactions across {len(all_posts)} posts")

    print("-" * 60)
    print(f"Posts created: {total_created}  Skipped: {total_skipped}")
    await engine.dispose()


if __name__ == "__main__":
    asyncio.run(seed())

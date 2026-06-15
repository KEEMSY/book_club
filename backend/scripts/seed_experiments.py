"""A/B 실험 시드 스크립트 (멱등).

Usage:
    cd backend
    .venv/bin/python scripts/seed_experiments.py

- 동일 experiment_key 가 이미 있으면 건너뜁니다 (upsert 방식).
"""

from __future__ import annotations

import asyncio
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine

from app.core.config import get_settings
from app.domains.experiment.models import Experiment

# 실험 1: 페이월 진입 시점 A/B
# stats_tab  — 독서 통계 탭에서 Pro 잠금 유도
# club_limit — 클럽 생성 한도 초과 시 Pro 잠금 유도
_EXPERIMENT_1 = {
    "experiment_key": "paywall_entry_v1",
    "description": "페이월 진입 시점 A/B — Pro 업그레이드를 유도하는 진입 지점 테스트",
    "variants": ["stats_tab", "club_limit"],
    "is_active": True,
}

# 실험 2: 가격 표시
# monthly_6900  — 월 6,900원 강조
# yearly_69000  — 연 69,000원 강조 (할인율 부각)
_EXPERIMENT_2 = {
    "experiment_key": "pricing_display_v1",
    "description": "가격 표시 A/B — 월간 vs 연간 플랜 강조 방식 테스트",
    "variants": ["monthly_6900", "yearly_69000"],
    "is_active": True,
}

_EXPERIMENTS = [_EXPERIMENT_1, _EXPERIMENT_2]


async def seed(session: AsyncSession) -> None:
    for data in _EXPERIMENTS:
        existing = await session.scalar(
            select(Experiment).where(
                Experiment.experiment_key == data["experiment_key"]
            )
        )
        if existing is not None:
            print(f"  실험 이미 존재: {data['experiment_key']}")
            continue
        experiment = Experiment(
            experiment_key=data["experiment_key"],
            description=data["description"],
            variants=data["variants"],
            is_active=data["is_active"],
        )
        session.add(experiment)
        await session.flush()
        await session.refresh(experiment)
        print(f"  실험 생성: {experiment.experiment_key} ({experiment.id})")

    await session.commit()


async def main() -> None:
    settings = get_settings()
    engine = create_async_engine(settings.database_url, echo=False)
    factory = async_sessionmaker(engine, expire_on_commit=False)
    async with factory() as session:
        print("A/B 실험 시드 시작...")
        await seed(session)
        print("완료.")
    await engine.dispose()


if __name__ == "__main__":
    asyncio.run(main())

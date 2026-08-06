"""관리자(is_admin) 승격 CLI — BC-88.

운영에서 `is_admin` 을 임의로 승격할 수 있는 HTTP 엔드포인트는 존재하지 않는다
(공격 표면을 만들지 않기 위한 의도적 설계). 최초 관리자는 반드시 DB 접근 권한을
가진 운영자가 이 스크립트를 직접 실행해서 지정한다. 이후 관리자는 기존
``PATCH /admin/users/{id}`` (is_admin=true, is_admin 세션 필요) 로 다른 유저를
관리자로 승격할 수 있다 — 이 스크립트는 그 "0 -> 1" 단계만 담당한다.

Usage:
    cd backend
    .venv/bin/python scripts/promote_admin.py owner@bookclub.kr
    .venv/bin/python scripts/promote_admin.py --bootstrap   # INITIAL_ADMIN_EMAILS 일괄 적용

- 이메일로 조회하며, 대소문자를 구분하지 않는다.
- 이미 관리자인 유저를 다시 지정해도 안전하다 (idempotent).
- dev-login 유저도 이메일만 있으면 승격 가능 — 로컬 콘솔 테스트용으로,
  `/auth/dev-login` 자체가 dev 환경 한정이므로 이 경로도 자연히 dev 한정이다.
- 대상 유저가 존재하지 않으면 승격하지 않고 안내만 출력한다 (먼저 로그인/가입 필요).
"""

from __future__ import annotations

import argparse
import asyncio
import os
import sys
from dataclasses import dataclass, field

# Ensure the project root (backend/) is on sys.path
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))

from app.core.config import get_settings
from app.domains.admin.repository import AdminRepository
from app.domains.auth.models import User
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker


@dataclass(slots=True)
class BootstrapReport:
    """Outcome of applying ``INITIAL_ADMIN_EMAILS`` against the current DB."""

    promoted: list[str] = field(default_factory=list)
    already_admin: list[str] = field(default_factory=list)
    not_found: list[str] = field(default_factory=list)


async def promote_user(repo: AdminRepository, email: str) -> User | None:
    """Promote the non-deleted user with ``email`` to ``is_admin=True``.

    Returns the updated (or already-admin) user, or ``None`` when no such
    user exists — the caller decides whether that is an error.
    """
    user = await repo.get_user_by_email(email)
    if user is None:
        return None
    if user.is_admin:
        return user
    updated = await repo.patch_user(user.id, is_active=None, is_admin=True)
    return updated


async def bootstrap_from_settings(repo: AdminRepository, emails: list[str]) -> BootstrapReport:
    """Apply every configured bootstrap email, deduplicated, idempotently."""
    report = BootstrapReport()
    for email in dict.fromkeys(e.strip() for e in emails if e.strip()):
        before = await repo.get_user_by_email(email)
        if before is None:
            report.not_found.append(email)
            continue
        if before.is_admin:
            report.already_admin.append(email)
            continue
        await promote_user(repo, email)
        report.promoted.append(email)
    return report


async def _run(email: str | None, bootstrap: bool) -> int:
    settings = get_settings()
    engine = create_async_engine(settings.database_url, echo=False)
    async_session: sessionmaker[AsyncSession] = sessionmaker(  # type: ignore[type-arg]
        engine, class_=AsyncSession, expire_on_commit=False
    )

    exit_code = 0
    async with async_session() as session, session.begin():
        repo = AdminRepository(session)

        if bootstrap:
            emails = settings.initial_admin_emails
            if not emails:
                print("INITIAL_ADMIN_EMAILS 가 설정되어 있지 않습니다. 아무 작업도 하지 않습니다.")
            else:
                report = await bootstrap_from_settings(repo, emails)
                for e in report.promoted:
                    print(f"  OK  {e:35s}  관리자로 승격")
                for e in report.already_admin:
                    print(f"SKIP  {e:35s}  이미 관리자")
                for e in report.not_found:
                    print(f" MISS {e:35s}  해당 이메일 유저 없음 (먼저 로그인/가입 필요)")
                    exit_code = 1
        else:
            assert email is not None
            user = await promote_user(repo, email)
            if user is None:
                print(f"유저를 찾을 수 없습니다: {email} (먼저 로그인/가입이 필요합니다)")
                exit_code = 1
            elif user.is_admin:
                print(f"OK  {email}  (id={user.id}) 관리자로 승격되었습니다.")

    await engine.dispose()
    return exit_code


def main() -> None:
    parser = argparse.ArgumentParser(description="유저를 is_admin=True 로 승격합니다 (BC-88).")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("email", nargs="?", default=None, help="승격할 유저의 이메일")
    group.add_argument(
        "--bootstrap",
        action="store_true",
        help="INITIAL_ADMIN_EMAILS 환경변수에 지정된 모든 이메일을 일괄 승격",
    )
    args = parser.parse_args()

    exit_code = asyncio.run(_run(args.email, args.bootstrap))
    sys.exit(exit_code)


if __name__ == "__main__":
    main()

"""Unit tests for ReferralService — in-memory fakes, no DB."""

from __future__ import annotations

from dataclasses import dataclass, field
from uuid import UUID, uuid4

import pytest
from app.core.exceptions import ConflictError, NotFoundError
from app.domains.referral.service import ReferralService


# ---------------------------------------------------------------------------
# Fake repository
# ---------------------------------------------------------------------------


@dataclass
class FakeReferralRepository:
    _codes: dict[UUID, str] = field(default_factory=dict)
    # code → referrer_id
    _code_to_owner: dict[str, UUID] = field(default_factory=dict)
    # referrer_id → list of referee_ids
    _invitations: dict[UUID, list[UUID]] = field(default_factory=dict)
    # referee_id → referrer_id (open row)
    _open_referrals: dict[UUID, UUID] = field(default_factory=dict)
    # referee_id → referrer_id (completed)
    _completed: dict[UUID, UUID] = field(default_factory=dict)

    async def get_or_create_code(self, user_id: UUID) -> str:
        if user_id not in self._codes:
            code = str(user_id)[:6].upper().replace("-", "A")
            self._codes[user_id] = code
            self._code_to_owner[code] = user_id
        return self._codes[user_id]

    async def get_stats(self, user_id: UUID) -> tuple[int, int]:
        invited = len(self._invitations.get(user_id, []))
        completed = sum(
            1 for r, owner in self._completed.items() if owner == user_id
        )
        return invited, completed

    async def apply_referral(self, *, referee_id: UUID, code: str) -> None:
        if code not in self._code_to_owner:
            raise NotFoundError("referral code not found", code="REFERRAL_NOT_FOUND")
        # Idempotent — already has an open referral
        if referee_id in self._open_referrals:
            return
        referrer_id = self._code_to_owner[code]
        self._open_referrals[referee_id] = referrer_id
        self._invitations.setdefault(referrer_id, []).append(referee_id)

    async def complete_referral(self, user_id: UUID) -> None:
        if user_id not in self._open_referrals:
            return
        referrer_id = self._open_referrals.pop(user_id)
        self._completed[user_id] = referrer_id


def _svc() -> tuple[ReferralService, FakeReferralRepository]:
    repo = FakeReferralRepository()
    return ReferralService(repo=repo), repo  # type: ignore[arg-type]


# ---------------------------------------------------------------------------
# get_my_referral
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_get_my_referral_creates_code_on_first_call() -> None:
    svc, repo = _svc()
    user = uuid4()
    result = await svc.get_my_referral(user)
    assert result.code  # non-empty code was generated
    assert result.invited_count == 0
    assert result.completed_count == 0


@pytest.mark.asyncio
async def test_get_my_referral_stable_code_on_repeat_calls() -> None:
    svc, _ = _svc()
    user = uuid4()
    first = await svc.get_my_referral(user)
    second = await svc.get_my_referral(user)
    assert first.code == second.code


# ---------------------------------------------------------------------------
# apply_referral
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_apply_referral_self_referral_raises_conflict() -> None:
    svc, _ = _svc()
    user = uuid4()
    stats = await svc.get_my_referral(user)  # generates code
    with pytest.raises(ConflictError) as exc_info:
        await svc.apply_referral(referee_id=user, code=stats.code)
    assert exc_info.value.code == "SELF_REFERRAL"


@pytest.mark.asyncio
async def test_apply_referral_unknown_code_raises_not_found() -> None:
    svc, _ = _svc()
    with pytest.raises(NotFoundError):
        await svc.apply_referral(referee_id=uuid4(), code="XXXXXX")


@pytest.mark.asyncio
async def test_apply_referral_happy_path_and_idempotent() -> None:
    svc, repo = _svc()
    referrer = uuid4()
    referee = uuid4()
    stats = await svc.get_my_referral(referrer)

    await svc.apply_referral(referee_id=referee, code=stats.code)
    # Second call is a no-op, should not raise
    await svc.apply_referral(referee_id=referee, code=stats.code)

    invited, completed = await repo.get_stats(referrer)
    assert invited == 1
    assert completed == 0


# ---------------------------------------------------------------------------
# complete_referral_if_eligible
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_complete_referral_below_duration_threshold_is_noop() -> None:
    svc, repo = _svc()
    referrer = uuid4()
    referee = uuid4()
    stats = await svc.get_my_referral(referrer)
    await svc.apply_referral(referee_id=referee, code=stats.code)

    # 59 seconds — just below the 60-second gate
    await svc.complete_referral_if_eligible(user_id=referee, duration_sec=59)
    _, completed = await repo.get_stats(referrer)
    assert completed == 0


@pytest.mark.asyncio
async def test_complete_referral_at_threshold_credits_referrer() -> None:
    svc, repo = _svc()
    referrer = uuid4()
    referee = uuid4()
    stats = await svc.get_my_referral(referrer)
    await svc.apply_referral(referee_id=referee, code=stats.code)

    await svc.complete_referral_if_eligible(user_id=referee, duration_sec=60)
    _, completed = await repo.get_stats(referrer)
    assert completed == 1


@pytest.mark.asyncio
async def test_complete_referral_without_open_row_is_noop() -> None:
    svc, _ = _svc()
    # Should not raise even with no referral row
    await svc.complete_referral_if_eligible(user_id=uuid4(), duration_sec=300)

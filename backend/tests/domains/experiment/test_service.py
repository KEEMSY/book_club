"""Unit tests for ExperimentService — in-memory fakes, no DB."""

from __future__ import annotations

import hashlib
from dataclasses import dataclass, field
from datetime import UTC, datetime
from uuid import UUID, uuid4

import pytest

from app.domains.experiment.service import ExperimentService


# ---------------------------------------------------------------------------
# Fake domain objects (mirror real ORM models, no SQLAlchemy dependency)
# ---------------------------------------------------------------------------


@dataclass
class _FakeExperiment:
    id: UUID
    experiment_key: str
    variants: list[str]
    is_active: bool = True


@dataclass
class _FakeUserExperiment:
    id: UUID
    user_id: UUID
    experiment_key: str
    variant: str
    assigned_at: datetime
    converted_at: datetime | None = None


# ---------------------------------------------------------------------------
# Fake repository
# ---------------------------------------------------------------------------


@dataclass
class FakeExperimentRepository:
    """In-memory stand-in; replicates the SHA-256 deterministic assignment logic
    from the real SQLAlchemy repository so tests stay DB-free."""

    _experiments: list[_FakeExperiment] = field(default_factory=list)
    _assignments: list[_FakeUserExperiment] = field(default_factory=list)

    async def get_active_experiments(self) -> list[_FakeExperiment]:
        return [e for e in self._experiments if e.is_active]

    async def get_or_assign_variant(
        self,
        *,
        user_id: UUID,
        experiment_key: str,
        variants: list[str],
    ) -> _FakeUserExperiment:
        # Fast path: row already exists.
        for row in self._assignments:
            if row.user_id == user_id and row.experiment_key == experiment_key:
                return row

        # Deterministic variant selection — mirrors repository.py exactly.
        digest = hashlib.sha256(
            f"{user_id.hex}{experiment_key}".encode()
        ).hexdigest()
        variant = variants[int(digest, 16) % len(variants)]

        row = _FakeUserExperiment(
            id=uuid4(),
            user_id=user_id,
            experiment_key=experiment_key,
            variant=variant,
            assigned_at=datetime.now(tz=UTC),
        )
        self._assignments.append(row)
        return row

    async def get_assignments(self, user_id: UUID) -> list[_FakeUserExperiment]:
        return [a for a in self._assignments if a.user_id == user_id]

    async def record_conversion(
        self, *, user_id: UUID, experiment_key: str
    ) -> None:
        for row in self._assignments:
            if (
                row.user_id == user_id
                and row.experiment_key == experiment_key
                and row.converted_at is None
            ):
                row.converted_at = datetime.now(tz=UTC)
                return
        # Missing row → silent no-op (matches real implementation).

    async def get_experiment_stats(
        self, experiment_key: str
    ) -> dict[str, dict[str, int | float]]:
        rows = [a for a in self._assignments if a.experiment_key == experiment_key]
        stats: dict[str, dict[str, int | float]] = {}
        for row in rows:
            bucket = stats.setdefault(
                row.variant, {"total": 0, "converted": 0, "conversion_rate": 0.0}
            )
            bucket["total"] = int(bucket["total"]) + 1
            if row.converted_at is not None:
                bucket["converted"] = int(bucket["converted"]) + 1
        for variant, data in stats.items():
            total = int(data["total"])
            converted = int(data["converted"])
            data["conversion_rate"] = round(converted / total, 4) if total > 0 else 0.0
        return stats


# ---------------------------------------------------------------------------
# Helper
# ---------------------------------------------------------------------------


def _svc() -> tuple[ExperimentService, FakeExperimentRepository]:
    repo = FakeExperimentRepository()
    return ExperimentService(repo=repo), repo  # type: ignore[arg-type]


# ---------------------------------------------------------------------------
# Tests
# ---------------------------------------------------------------------------


@pytest.mark.asyncio
async def test_get_user_assignments_empty() -> None:
    """No active experiments → empty assignment list returned."""
    svc, _ = _svc()
    result = await svc.get_user_assignments(uuid4())
    assert result.assignments == []


@pytest.mark.asyncio
async def test_get_user_assignments_assigns_all_active() -> None:
    """Two active experiments → each gets its own ExperimentAssignment entry."""
    svc, repo = _svc()
    repo._experiments = [
        _FakeExperiment(id=uuid4(), experiment_key="exp_a", variants=["control", "treatment"]),
        _FakeExperiment(id=uuid4(), experiment_key="exp_b", variants=["v1", "v2", "v3"]),
    ]
    user = uuid4()
    result = await svc.get_user_assignments(user)

    assert len(result.assignments) == 2
    keys = {a.experiment_key for a in result.assignments}
    assert keys == {"exp_a", "exp_b"}
    # Every assignment must carry a valid variant.
    for assignment in result.assignments:
        exp = next(e for e in repo._experiments if e.experiment_key == assignment.experiment_key)
        assert assignment.variant in exp.variants


@pytest.mark.asyncio
async def test_get_user_assignments_deterministic() -> None:
    """Same user + same experiment → identical variant on two separate calls."""
    svc, repo = _svc()
    repo._experiments = [
        _FakeExperiment(id=uuid4(), experiment_key="sticky_exp", variants=["A", "B"]),
    ]
    user = uuid4()
    first = await svc.get_user_assignments(user)
    second = await svc.get_user_assignments(user)

    assert len(first.assignments) == 1
    assert first.assignments[0].variant == second.assignments[0].variant


@pytest.mark.asyncio
async def test_get_user_assignments_skips_inactive() -> None:
    """Inactive experiments must not appear in the returned assignments."""
    svc, repo = _svc()
    repo._experiments = [
        _FakeExperiment(
            id=uuid4(), experiment_key="active_exp", variants=["control", "treatment"]
        ),
        _FakeExperiment(
            id=uuid4(),
            experiment_key="inactive_exp",
            variants=["x", "y"],
            is_active=False,
        ),
    ]
    result = await svc.get_user_assignments(uuid4())

    assert len(result.assignments) == 1
    assert result.assignments[0].experiment_key == "active_exp"


@pytest.mark.asyncio
async def test_record_conversion_updates_assignment() -> None:
    """After record_conversion, the assignment row should have converted_at set."""
    svc, repo = _svc()
    repo._experiments = [
        _FakeExperiment(id=uuid4(), experiment_key="conv_exp", variants=["ctrl", "treat"]),
    ]
    user = uuid4()
    # Force assignment creation.
    await svc.get_user_assignments(user)

    assert len(repo._assignments) == 1
    assert repo._assignments[0].converted_at is None

    await svc.record_conversion(user_id=user, experiment_key="conv_exp")

    assert repo._assignments[0].converted_at is not None


@pytest.mark.asyncio
async def test_record_conversion_no_assignment() -> None:
    """record_conversion with no existing assignment must complete without error."""
    svc, _ = _svc()
    # Should not raise.
    await svc.record_conversion(user_id=uuid4(), experiment_key="nonexistent_exp")


@pytest.mark.asyncio
async def test_sha256_variant_distribution() -> None:
    """100 distinct users assigned to a 2-variant experiment must each land
    between 30 % and 70 % — confirming a reasonable distribution, not a
    pathological all-one-bucket outcome."""
    svc, repo = _svc()
    variants = ["control", "treatment"]
    repo._experiments = [
        _FakeExperiment(id=uuid4(), experiment_key="dist_exp", variants=variants),
    ]

    for _ in range(100):
        await svc.get_user_assignments(uuid4())

    counts = {"control": 0, "treatment": 0}
    for a in repo._assignments:
        counts[a.variant] += 1

    total = sum(counts.values())
    assert total == 100
    for variant, count in counts.items():
        pct = count / total
        assert 0.30 <= pct <= 0.70, (
            f"variant '{variant}' got {count}/100 ({pct:.0%}) — distribution looks wrong"
        )


@pytest.mark.asyncio
async def test_get_user_assignments_existing_not_reassigned() -> None:
    """A pre-existing assignment row must be returned as-is, with no new row created."""
    svc, repo = _svc()
    repo._experiments = [
        _FakeExperiment(
            id=uuid4(), experiment_key="stable_exp", variants=["alpha", "beta"]
        ),
    ]
    user = uuid4()

    # First call seeds the assignment.
    first_result = await svc.get_user_assignments(user)
    first_variant = first_result.assignments[0].variant
    assert len(repo._assignments) == 1

    # Second call must reuse the same row — no duplicate insertion.
    second_result = await svc.get_user_assignments(user)
    assert len(repo._assignments) == 1
    assert second_result.assignments[0].variant == first_variant

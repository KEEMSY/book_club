"""Reading domain — sessions (timer/manual), heatmap (DailyReadingStat),
5-tier grade (UserGrade), and reading goals (Goal).

Public surface (stable across domain boundaries):
- ``router`` — FastAPI router mounted under ``/reading``.
- ``schemas`` — Pydantic DTOs that the router accepts / returns.
- ``providers`` — FastAPI ``Depends`` factories and event-bus registration
  hooks so ``app.main`` can wire subscribers at startup.
- ``grade_policy`` / ``streak_policy`` — pure domain functions reused by
  the service and testable without a session.

Models, repositories, and the service live as internals and must not be
imported across domain boundaries (CLAUDE.md §3.3).
"""

from app.domains.reading.models import GoalPeriod, ReadingSessionSource

__all__ = ["GoalPeriod", "ReadingSessionSource"]

"""merge m29 (club_rooms) and m30 (offline_events) heads

Revision ID: 0018
Revises: 0017, a4f2c8d91b3e
Create Date: 2026-06-08

Merge migration — no DDL changes.
"""

from __future__ import annotations

revision = "0018"
down_revision = ("0017", "a4f2c8d91b3e")
branch_labels = None
depends_on = None


def upgrade() -> None:
    pass


def downgrade() -> None:
    pass

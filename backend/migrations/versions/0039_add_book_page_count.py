"""Add page_count to books (M56).

Revision ID: 0039
Revises: 0038
Create Date: 2026-06-18

Club reading plans (M52) derive a weekly page target from the book's total
page count, falling back to a 200-page default when unknown. Until now the
catalog had no page count at all, so every plan used the fallback. The Naver
(``itemPage`` via fallback) and Kakao adapters can surface a page count on
some titles, so we persist it here. Nullable because most external rows omit
it; the plan logic keeps its 200-page default for NULLs.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision: str = "0039"
down_revision: str | None = "0038"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.add_column(
        "books",
        sa.Column("page_count", sa.Integer(), nullable=True),
    )


def downgrade() -> None:
    op.drop_column("books", "page_count")

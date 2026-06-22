"""M69 discovery enhancement — pg_trgm autocomplete indexes.

Search autocomplete (``GET /search/autocomplete``) ranks book titles and authors
by trigram similarity. ``pg_trgm`` provides both the ``%`` similarity operator
and ``similarity()`` ranking function; the two GIN indexes make the ``%`` lookups
index-backed rather than sequential scans over the whole catalog.

The four book-recommendation channels (taste_match / trending / club_picks /
ai_picks) add no tables — they read existing reading, club, and library rows.

``down_revision`` chains onto ``0045`` (M68's community-2 migration, which landed
in parallel) to keep a single linear head. These pg_trgm indexes are independent
of M68's tables, so ordering after it is safe. ``IF NOT EXISTS`` keeps the DDL
idempotent regardless of how the heads are ultimately resolved.
"""

from __future__ import annotations

from collections.abc import Sequence

from alembic import op

# revision identifiers, used by Alembic.
revision: str = "0046"
down_revision: str | None = "0045"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.execute("CREATE EXTENSION IF NOT EXISTS pg_trgm")
    op.execute(
        "CREATE INDEX IF NOT EXISTS idx_books_title_trgm ON books USING GIN (title gin_trgm_ops)"
    )
    op.execute(
        "CREATE INDEX IF NOT EXISTS idx_books_author_trgm ON books USING GIN (author gin_trgm_ops)"
    )


def downgrade() -> None:
    op.execute("DROP INDEX IF EXISTS idx_books_author_trgm")
    op.execute("DROP INDEX IF EXISTS idx_books_title_trgm")
    # pg_trgm is left installed — other features may rely on it (e.g. the
    # users.nickname trigram index from migration 0025).

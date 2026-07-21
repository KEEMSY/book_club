"""Add full-text search indexes for books and users.

Revision ID: 0025
Revises: 0024
Create Date: 2026-06-13

Adds:
- pg_trgm extension for trigram similarity searches on nickname.
- ``search_vector`` generated tsvector column on ``books`` using the
  ``korean`` text search config when available, falling back to ``simple``
  so the migration succeeds even without the ``pg_korean`` extension.
- GIN index on ``books.search_vector`` for fast full-text search.
- GIN trigram index on ``users.nickname`` for fast ILIKE-style lookups.

Design notes:
- ``GENERATED ALWAYS AS ... STORED`` keeps the vector in sync with writes
  automatically — no trigger or application-side update required.
- The Korean fallback check is done at migration time: if the ``korean``
  configuration does not exist (raises ``InvalidParameterValue`` / query
  returns nothing) we use ``simple`` instead, which still tokenises CJK
  characters as individual words and is universally available.
- ``pg_trgm`` is needed for the trigram GIN operator class (``gin_trgm_ops``)
  used on ``users.nickname``.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision: str = "0025"
down_revision: str | None = "0024"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None

# SQL to probe whether the 'korean' text search configuration exists.
_CHECK_KOREAN = "SELECT 1 FROM pg_ts_config WHERE cfgname = 'korean'"


def _resolve_ts_config(conn: sa.engine.Connection) -> str:
    """Return 'korean' if available, else 'simple'."""
    row = conn.execute(sa.text(_CHECK_KOREAN)).fetchone()
    return "korean" if row else "simple"


def upgrade() -> None:
    conn = op.get_bind()

    # 1. Enable pg_trgm for trigram similarity on nickname.
    op.execute("CREATE EXTENSION IF NOT EXISTS pg_trgm")

    # 2. Determine which text search config to use.
    ts_config = _resolve_ts_config(conn)

    # 3. Add generated tsvector column to books.
    #    GENERATED ALWAYS AS … STORED is DDL that Alembic cannot express via
    #    op.add_column, so we fall back to raw DDL via op.execute.
    op.execute(
        f"""
        ALTER TABLE books
          ADD COLUMN IF NOT EXISTS search_vector tsvector
          GENERATED ALWAYS AS (
            to_tsvector(
              '{ts_config}',
              coalesce(title, '') || ' ' ||
              coalesce(author, '') || ' ' ||
              coalesce(description, '')
            )
          ) STORED
        """
    )

    # 4. GIN index on the generated column for full-text book searches.
    op.execute("CREATE INDEX IF NOT EXISTS idx_books_search ON books USING GIN(search_vector)")

    # 5. GIN trigram index on users.nickname for fast partial-match lookups.
    op.execute(
        "CREATE INDEX IF NOT EXISTS idx_users_nickname_trgm "
        "ON users USING GIN(nickname gin_trgm_ops)"
    )


def downgrade() -> None:
    op.execute("DROP INDEX IF EXISTS idx_users_nickname_trgm")
    op.execute("DROP INDEX IF EXISTS idx_books_search")
    op.execute("ALTER TABLE books DROP COLUMN IF EXISTS search_vector")
    # Leave pg_trgm in place — dropping shared extensions can break other objects.

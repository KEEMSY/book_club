"""user_books.status — add wishlist value.

Revision ID: 0010_user_book_wishlist
Revises: 0009_challenge_tables
Create Date: 2026-04-29

The ``user_books.status`` column is VARCHAR (native_enum=False) so we only
need to update the CHECK constraint to allow the new value.  No data migration
is required because existing rows are unaffected.
"""

from __future__ import annotations

from alembic import op

revision = "0010_user_book_wishlist"
down_revision = "0009_challenge_tables"
branch_labels = None
depends_on = None

_OLD_VALUES = ("reading", "completed", "paused", "dropped")
_NEW_VALUES = ("reading", "completed", "paused", "dropped", "wishlist")
_CHECK_NAME = "ck_user_books_status"
_TABLE = "user_books"
_COLUMN = "status"


def upgrade() -> None:
    op.drop_constraint(_CHECK_NAME, _TABLE, type_="check")
    values_sql = ", ".join(f"'{v}'" for v in _NEW_VALUES)
    op.execute(
        f"ALTER TABLE {_TABLE} ADD CONSTRAINT {_CHECK_NAME} "
        f"CHECK ({_COLUMN} IN ({values_sql}))"
    )


def downgrade() -> None:
    op.execute(
        f"UPDATE {_TABLE} SET {_COLUMN} = 'reading' WHERE {_COLUMN} = 'wishlist'"
    )
    op.drop_constraint(_CHECK_NAME, _TABLE, type_="check")
    values_sql = ", ".join(f"'{v}'" for v in _OLD_VALUES)
    op.execute(
        f"ALTER TABLE {_TABLE} ADD CONSTRAINT {_CHECK_NAME} "
        f"CHECK ({_COLUMN} IN ({values_sql}))"
    )

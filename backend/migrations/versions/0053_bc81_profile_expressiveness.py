"""BC-81 — profile expressiveness fields (epic BC-77).

Adds four nullable columns to ``users`` so a member can personalize their
public profile beyond nickname/bio/avatar:

- ``cover_image_url`` — banner image shown behind the profile header.
- ``theme`` — a predefined palette key (see ``ProfileTheme`` in
  ``app/domains/auth/models.py``); portable string enum + CHECK constraint,
  same convention as ``users.provider`` in 0002.
- ``featured_book_id`` — FK to ``books.id``. ``ON DELETE SET NULL`` so a
  catalog row deletion (rare — ``UserBook.book_id`` is RESTRICT, but a book
  can still in principle be removed once nothing references it) silently
  un-features rather than failing the delete or orphaning the column.
- ``featured_quote`` — a short quote the user pins to their profile,
  independent of ``featured_book_id`` (a quote with no book attached is
  allowed) and length-capped like ``bio``.

All four are NULL by default, so existing rows need no backfill.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision: str = "0053"
down_revision: str | None = "0052"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None

_THEME_CHECK = "ck_users_theme"
_THEME_VALUES = ("classic", "sepia", "midnight", "forest", "sunset", "ocean")
_FK_NAME = "fk_users_featured_book_id_books"
_FK_INDEX = "ix_users_featured_book_id"


def upgrade() -> None:
    op.add_column("users", sa.Column("cover_image_url", sa.String(length=1024), nullable=True))
    op.add_column("users", sa.Column("theme", sa.String(length=16), nullable=True))
    op.create_check_constraint(
        _THEME_CHECK,
        "users",
        "theme IN ({})".format(", ".join(f"'{v}'" for v in _THEME_VALUES)),
    )
    op.add_column("users", sa.Column("featured_book_id", sa.UUID(as_uuid=True), nullable=True))
    op.create_index(_FK_INDEX, "users", ["featured_book_id"])
    op.create_foreign_key(
        _FK_NAME,
        "users",
        "books",
        ["featured_book_id"],
        ["id"],
        ondelete="SET NULL",
    )
    op.add_column("users", sa.Column("featured_quote", sa.String(length=300), nullable=True))


def downgrade() -> None:
    op.drop_column("users", "featured_quote")
    op.drop_constraint(_FK_NAME, "users", type_="foreignkey")
    op.drop_index(_FK_INDEX, table_name="users")
    op.drop_column("users", "featured_book_id")
    op.drop_constraint(_THEME_CHECK, "users", type_="check")
    op.drop_column("users", "theme")
    op.drop_column("users", "cover_image_url")

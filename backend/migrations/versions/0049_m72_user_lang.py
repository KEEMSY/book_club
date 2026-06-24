"""M72 i18n — per-user preferred language.

Adds ``users.preferred_lang`` so the backend can localize push notifications and
email (which have no ``Accept-Language`` header) to the language the user last
selected in-app. Request-scoped responses still rely on the ``Accept-Language``
header parsed by ``LanguageMiddleware``; this column is the persistent fallback
for out-of-band delivery.

``VARCHAR(5)`` accommodates BCP-47 region tags (e.g. ``pt-BR``) even though the
launch set is ``ko``/``en``/``ja``. ``NOT NULL DEFAULT 'ko'`` backfills existing
rows to the current behavior.

down_revision chains onto ``0048`` (M71 agora tokens) to keep a single linear
head per the Phase 16 migration plan (0047 → 0048 → 0049).
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision: str = "0049"
down_revision: str | None = "0048"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.add_column(
        "users",
        sa.Column(
            "preferred_lang",
            sa.String(length=5),
            nullable=False,
            server_default="ko",
        ),
    )


def downgrade() -> None:
    op.drop_column("users", "preferred_lang")

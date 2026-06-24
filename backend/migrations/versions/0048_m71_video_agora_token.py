"""M71 — persist the Agora join token and host uid on a video session.

The video-call MVP (M68) derived a stub token on the fly. M71 wires a real
Agora token builder, so the issued ``agora_token`` and the host's ``agora_uid``
are stored alongside the session for auditing and re-join. Both columns are
nullable so the existing live rows backfill cleanly.

``down_revision`` chains onto ``0047`` (M70) to keep a single linear head.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision: str = "0048"
down_revision: str | None = "0047"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.add_column("video_sessions", sa.Column("agora_uid", sa.Integer(), nullable=True))
    op.add_column("video_sessions", sa.Column("agora_token", sa.Text(), nullable=True))


def downgrade() -> None:
    op.drop_column("video_sessions", "agora_token")
    op.drop_column("video_sessions", "agora_uid")

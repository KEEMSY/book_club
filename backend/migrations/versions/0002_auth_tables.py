"""auth tables — users + device_tokens.

Revision ID: 0002_auth_tables
Revises: 0001_init
Create Date: 2026-04-20

Introduces the auth domain schema for Milestone 1.

Design choices:
- Portable string enums (``native_enum=False``) for ``auth_provider`` and
  ``device_platform`` so migrations stay engine-agnostic and we can add
  providers without an ALTER TYPE dance. Length is generous (16/8) to absorb
  future values (e.g. "google", "line").
- ``provider_sub`` is VARCHAR(255) because Kakao IDs are numeric strings
  and Apple ``sub`` is ~44 chars, both well within.
- Device tokens are UNIQUE on token itself: FCM allocates tokens per install,
  and the same token can migrate between users (reinstall / handoff) so we
  upsert against ``token`` rather than (user, token).
- ``deleted_at`` implements a soft-delete on users; Apple's account-deletion
  review requirement only mandates the data is unreachable, not immediately
  hard-deleted. A periodic purge job (future) can remove soft-deleted rows.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

# revision identifiers, used by Alembic.
revision: str = "0002_auth_tables"
down_revision: str | None = "0001_init"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "users",
        sa.Column("id", sa.UUID(as_uuid=True), primary_key=True, nullable=False),
        sa.Column(
            "provider",
            sa.String(length=16),
            nullable=False,
        ),
        sa.Column("provider_sub", sa.String(length=255), nullable=False),
        sa.Column("email", sa.String(length=320), nullable=True),
        sa.Column("nickname", sa.String(length=64), nullable=False),
        sa.Column("profile_image_url", sa.String(length=1024), nullable=True),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.Column("last_login_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("deleted_at", sa.DateTime(timezone=True), nullable=True),
        sa.CheckConstraint(
            "provider IN ('kakao', 'apple')",
            name="ck_users_provider",
        ),
        sa.UniqueConstraint("provider", "provider_sub", name="uq_users_provider_sub"),
    )

    op.create_table(
        "device_tokens",
        sa.Column("id", sa.UUID(as_uuid=True), primary_key=True, nullable=False),
        sa.Column(
            "user_id",
            sa.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("token", sa.String(length=512), nullable=False),
        sa.Column(
            "platform",
            sa.String(length=8),
            nullable=False,
        ),
        sa.Column(
            "created_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.Column(
            "last_seen_at",
            sa.DateTime(timezone=True),
            server_default=sa.func.now(),
            nullable=False,
        ),
        sa.CheckConstraint(
            "platform IN ('ios', 'aos')",
            name="ck_device_tokens_platform",
        ),
        sa.UniqueConstraint("token", name="uq_device_tokens_token"),
    )
    op.create_index(
        "ix_device_tokens_user_id",
        "device_tokens",
        ["user_id"],
    )


def downgrade() -> None:
    op.drop_index("ix_device_tokens_user_id", table_name="device_tokens")
    op.drop_table("device_tokens")
    op.drop_table("users")

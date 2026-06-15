"""Add user_taste_profiles and user_onboarding_interests tables (M44).

Revision ID: 0030
Revises: 0029
Create Date: 2026-06-15

``user_taste_profiles`` stores a per-user JSONB vector of genre/author
frequency derived from the user's completed books. Updated lazily on each
book completion (fire-and-forget from the reading domain).

``user_onboarding_interests`` records the explicit genre/author/keyword
preferences the user selects during onboarding. Used as a cold-start signal
when the taste profile is absent or the completed-book count is below the
cold-start threshold (< 3 books).

Both tables cascade-delete with the owning user row.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = "0030"
down_revision: str | None = "0029"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.create_table(
        "user_taste_profiles",
        sa.Column(
            "user_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            primary_key=True,
        ),
        sa.Column(
            "genre_vector",
            postgresql.JSONB(astext_type=sa.Text()),
            nullable=False,
            server_default=sa.text("'{}'::jsonb"),
        ),
        sa.Column(
            "author_vector",
            postgresql.JSONB(astext_type=sa.Text()),
            nullable=False,
            server_default=sa.text("'{}'::jsonb"),
        ),
        sa.Column(
            "updated_at",
            sa.DateTime(timezone=True),
            nullable=False,
            server_default=sa.text("now()"),
        ),
    )

    op.create_table(
        "user_onboarding_interests",
        sa.Column(
            "id",
            postgresql.UUID(as_uuid=True),
            primary_key=True,
            server_default=sa.text("gen_random_uuid()"),
        ),
        sa.Column(
            "user_id",
            postgresql.UUID(as_uuid=True),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("category", sa.String(32), nullable=False),
        sa.Column("value", sa.String(64), nullable=False),
        sa.UniqueConstraint(
            "user_id", "category", "value", name="uq_onboarding_interests_user_cat_val"
        ),
    )
    op.create_index(
        "idx_onboarding_interests_user",
        "user_onboarding_interests",
        ["user_id"],
    )


def downgrade() -> None:
    op.drop_index("idx_onboarding_interests_user", table_name="user_onboarding_interests")
    op.drop_table("user_onboarding_interests")
    op.drop_table("user_taste_profiles")

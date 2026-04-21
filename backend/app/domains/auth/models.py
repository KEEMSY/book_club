"""SQLAlchemy ORM models for the auth domain.

- ``User`` represents a social-login user. One row per unique
  (provider, provider_sub) pair. Apple may omit email after first sign-in;
  we treat email as optional and regenerate the displayed nickname at login
  time when absent. ``deleted_at`` implements a soft-delete so we can satisfy
  Apple's "account deletion" review requirement without losing the sub/uid
  mapping immediately (hard-delete batch comes later).
- ``DeviceToken`` stores FCM push tokens (iOS goes through FCM -> APNS, per
  the design doc). ``token`` is globally unique so a token migrating between
  users (reinstall / device swap) still only occupies one row.
"""

from __future__ import annotations

import enum
import uuid
from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, String, UniqueConstraint, func
from sqlalchemy import Enum as SAEnum
from sqlalchemy.dialects.postgresql import UUID as PGUUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.core.db import Base


class AuthProvider(enum.StrEnum):
    """Supported social login providers."""

    KAKAO = "kakao"
    APPLE = "apple"


class DevicePlatform(enum.StrEnum):
    """Mobile platform that registered a push token."""

    IOS = "ios"
    AOS = "aos"


class User(Base):
    """Registered Book Club user (one row per provider identity)."""

    __tablename__ = "users"
    __table_args__ = (UniqueConstraint("provider", "provider_sub", name="uq_users_provider_sub"),)

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    provider: Mapped[AuthProvider] = mapped_column(
        SAEnum(
            AuthProvider,
            name="auth_provider",
            values_callable=lambda enum_cls: [member.value for member in enum_cls],
            native_enum=False,
            length=16,
        ),
        nullable=False,
    )
    provider_sub: Mapped[str] = mapped_column(String(255), nullable=False)
    email: Mapped[str | None] = mapped_column(String(320), nullable=True)
    nickname: Mapped[str] = mapped_column(String(64), nullable=False)
    profile_image_url: Mapped[str | None] = mapped_column(String(1024), nullable=True)

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )
    last_login_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    deleted_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)

    device_tokens: Mapped[list[DeviceToken]] = relationship(
        "DeviceToken",
        back_populates="user",
        cascade="all, delete-orphan",
        passive_deletes=True,
    )


class DeviceToken(Base):
    """FCM device token registered per mobile install."""

    __tablename__ = "device_tokens"
    __table_args__ = (UniqueConstraint("token", name="uq_device_tokens_token"),)

    id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True), primary_key=True, default=uuid.uuid4
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        PGUUID(as_uuid=True),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    token: Mapped[str] = mapped_column(String(512), nullable=False)
    platform: Mapped[DevicePlatform] = mapped_column(
        SAEnum(
            DevicePlatform,
            name="device_platform",
            values_callable=lambda enum_cls: [member.value for member in enum_cls],
            native_enum=False,
            length=8,
        ),
        nullable=False,
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )
    last_seen_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True), nullable=False, server_default=func.now()
    )

    user: Mapped[User] = relationship("User", back_populates="device_tokens")

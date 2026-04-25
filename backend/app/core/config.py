"""Application settings loaded from environment variables."""

from __future__ import annotations

from functools import lru_cache
from typing import Literal

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Runtime configuration.

    All secrets are sourced from environment variables; a local `.env` file is
    loaded for convenience in development only. Production deploys inject
    secrets through Fly.io secrets.
    """

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )

    env: Literal["dev", "staging", "prod", "test"] = Field(default="dev")

    database_url: str = Field(
        default="postgresql+asyncpg://bookclub:bookclub@localhost:5432/bookclub"
    )
    redis_url: str = Field(default="redis://localhost:6379/0")

    s3_endpoint_url: str = Field(default="http://localhost:9000")
    s3_bucket: str = Field(default="bookclub-local")
    s3_access_key: str = Field(default="minio")
    s3_secret_key: str = Field(default="minio12345")
    s3_region: str = Field(default="auto")

    jwt_secret: str = Field(default="change-me-in-production-this-is-not-secure-at-all")
    jwt_alg: str = Field(default="HS256")
    jwt_access_ttl_seconds: int = Field(default=60 * 60)
    jwt_refresh_ttl_seconds: int = Field(default=60 * 60 * 24 * 30)

    kakao_rest_api_key: str = Field(default="")
    naver_client_id: str = Field(default="")
    naver_client_secret: str = Field(default="")
    naver_book_api_url: str = Field(default="https://openapi.naver.com/v1/search/book.json")
    kakao_book_api_url: str = Field(default="https://dapi.kakao.com/v3/search/book")

    apple_client_id: str = Field(default="")
    apple_keys_url: str = Field(default="https://appleid.apple.com/auth/keys")
    apple_issuer: str = Field(default="https://appleid.apple.com")

    cors_allow_origins: list[str] = Field(
        default_factory=lambda: [
            "http://localhost",
            "http://localhost:3000",
            "http://localhost:8000",
            "http://localhost:8080",
        ]
    )

    # Firebase credentials for FCM push notifications. Left empty in dev so
    # NullPushAdapter is selected automatically (CLAUDE.md §2 push stack).
    firebase_credentials_json: str = Field(default="")
    firebase_project_id: str = Field(default="")


@lru_cache(maxsize=1)
def get_settings() -> Settings:
    """Return a cached Settings instance."""
    return Settings()

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
    # Public-facing URL for presigned URLs. Defaults to s3_endpoint_url so
    # production (Cloudflare R2) works without extra config. In Docker dev,
    # s3_endpoint_url=http://minio:9000 (internal) but presigned PUTs must use
    # http://localhost:9000 so the browser/app can reach MinIO directly.
    s3_public_endpoint_url: str = Field(default="")
    s3_bucket: str = Field(default="bookclub-local")
    s3_access_key: str = Field(default="minio")
    s3_secret_key: str = Field(default="minio12345")
    s3_region: str = Field(default="auto")

    @property
    def s3_presign_endpoint_url(self) -> str:
        return self.s3_public_endpoint_url or self.s3_endpoint_url

    jwt_secret: str = Field(default="change-me-in-production-this-is-not-secure-at-all")
    jwt_alg: str = Field(default="HS256")
    jwt_access_ttl_seconds: int = Field(default=60 * 60)
    jwt_refresh_ttl_seconds: int = Field(default=60 * 60 * 24 * 30)

    kakao_rest_api_key: str = Field(default="")
    naver_client_id: str = Field(default="")
    naver_client_secret: str = Field(default="")
    naver_book_api_url: str = Field(default="https://openapi.naver.com/v1/search/book.json")
    kakao_book_api_url: str = Field(default="https://dapi.kakao.com/v3/search/book")

    # Anthropic Claude API key for the AI reading assistant (M63). Unset → the
    # StubClaudeAdapter is selected so dev/test work without a real key.
    anthropic_api_key: str = Field(default="")
    anthropic_model: str = Field(default="claude-haiku-4-5-20251001")

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

    # Admin key for privileged management endpoints. Unset → endpoints return 404.
    admin_key: str = Field(default="")

    # Agora RTC credentials for club video calls (M71). Both empty → the
    # StubAgoraTokenAdapter is selected so dev/test work without a real account.
    agora_app_id: str = Field(default="")
    agora_app_certificate: str = Field(default="")

    # --- Feature flags (scope cleanup, BC-1) -------------------------------
    # Non-MVP domains are gated so they can be deferred (disabled) without
    # deleting code. MVP core (auth/book/reading/feed/notification) and infra
    # (health/dev/admin) are always on and have no flag. Default True preserves
    # current behavior; the scope audit (BC-16~20) flips individual defaults to
    # False for deferred domains. A disabled domain's router is not mounted, so
    # its endpoints return 404 while the code stays in place for later review.
    # Deferred (BC-16): social graph (follow/block) exceeds the reading-log MVP.
    # MVP feed/notification reference it only via lazy model/event imports that
    # stay importable, so the app still builds; the follow-based feed tab and the
    # follow-received notification simply go dormant.
    feature_social_enabled: bool = Field(default=True)
    # Deferred (BC-16): community posts/profiles domain; no MVP-core dependency.
    feature_community_enabled: bool = Field(default=False)
    # Deferred (BC-16): reading clubs (group feature) exceed MVP; only non-MVP
    # domains (video/ai_assistant/discovery/search) depend on it.
    feature_club_enabled: bool = Field(default=True)
    feature_challenge_enabled: bool = Field(default=True)
    feature_discovery_enabled: bool = Field(default=False)
    feature_search_enabled: bool = Field(default=False)
    feature_curation_enabled: bool = Field(default=False)
    feature_event_enabled: bool = Field(default=False)
    feature_referral_enabled: bool = Field(default=True)
    feature_reminder_enabled: bool = Field(default=True)
    feature_retention_enabled: bool = Field(default=True)
    feature_experiment_enabled: bool = Field(default=True)
    feature_subscription_enabled: bool = Field(default=True)
    feature_shield_enabled: bool = Field(default=True)
    feature_review_enabled: bool = Field(default=True)
    # Deferred by BC-18 (advanced features): ai_assistant/video carry large
    # external SDK cost, team is out of consumer MVP scope. Router stays
    # mounted-conditional; code is untouched. Flip back to True to re-scope.
    feature_ai_assistant_enabled: bool = Field(default=False)  # Claude API billing
    feature_share_enabled: bool = Field(default=True)
    # Deferred (BC-16): club video calls (M71, Agora); coupled to club, which is
    # deferred, so video is deferred with it.
    feature_video_enabled: bool = Field(default=False)
    # Deferred (BC-18): B2B team plan, out of consumer MVP scope.
    feature_team_enabled: bool = Field(default=False)


@lru_cache(maxsize=1)
def get_settings() -> Settings:
    """Return a cached Settings instance."""
    return Settings()

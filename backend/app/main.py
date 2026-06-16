"""FastAPI application factory."""

from __future__ import annotations

import os
from collections.abc import AsyncIterator
from contextlib import asynccontextmanager

import sentry_sdk
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from prometheus_fastapi_instrumentator import Instrumentator

from app import __version__
from app.api import health
from app.api.admin import router as admin_router
from app.core.config import get_settings
from app.core.exceptions import register_exception_handlers
from app.core.middleware import LastActiveMiddleware
from app.domains.admin.router import router as admin_dashboard_router
from app.domains.auth.router import router as auth_router
from app.domains.book.events import UserBookCompleted
from app.domains.book.router import router as book_router
from app.domains.challenge.events import BadgeEarned
from app.domains.challenge.providers import get_challenge_service_singleton
from app.domains.challenge.router import router as challenge_router
from app.domains.club.router import router as club_router
from app.domains.club.ws_router import router as club_ws_router
from app.domains.community.router import router as community_router
from app.domains.curation.router import router as curation_router
from app.domains.discovery.providers import run_cf_retrain
from app.domains.discovery.router import router as discovery_router
from app.domains.experiment.router import router as experiment_router
from app.domains.feed.events import CommentAdded, ReactionAdded
from app.domains.feed.router import router as feed_router
from app.domains.notification.providers import create_scheduler, get_notification_service
from app.domains.notification.router import router as notification_router
from app.domains.reading.events import ReadingSessionCompleted, UserGradeRecomputed
from app.domains.reading.providers import get_event_bus
from app.domains.reading.router import me_router as reading_me_router
from app.domains.reading.router import router as reading_router
from app.domains.referral.router import router as referral_router
from app.domains.reminder.router import router as reminder_router
from app.domains.retention.router import router as retention_router
from app.domains.search.router import router as search_router
from app.domains.social.events import FollowReceived
from app.domains.social.router import router as social_router
from app.domains.shield.router import router as shield_router
from app.domains.subscription.router import router as subscription_router


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncIterator[None]:
    """Wire event bus subscribers and start the APScheduler on startup."""
    notification_svc = get_notification_service()
    challenge_svc = get_challenge_service_singleton()
    bus = get_event_bus()

    bus.subscribe(ReactionAdded, notification_svc.on_reaction_added)
    bus.subscribe(CommentAdded, notification_svc.on_comment_added)
    bus.subscribe(UserGradeRecomputed, notification_svc.on_grade_up)
    bus.subscribe(FollowReceived, notification_svc.on_follow_received)
    bus.subscribe(BadgeEarned, notification_svc.on_badge_earned)
    bus.subscribe(ReadingSessionCompleted, challenge_svc.on_reading_session_completed)
    bus.subscribe(UserBookCompleted, challenge_svc.on_user_book_completed)
    bus.subscribe(UserGradeRecomputed, challenge_svc.on_grade_recomputed)

    scheduler = create_scheduler(notification_svc)
    scheduler.add_job(
        run_cf_retrain,
        "cron",
        day_of_week="sun",
        hour=3,
        minute=0,
        id="cf_retrain",
    )
    scheduler.start()

    yield

    scheduler.shutdown(wait=False)


def _init_sentry() -> None:
    """Initialise Sentry only when SENTRY_DSN is set in the environment.

    Keeping initialisation conditional avoids noise in local / CI runs where
    no DSN is configured while ensuring production errors are reported.
    """
    dsn = os.getenv("SENTRY_DSN")
    if dsn:
        sentry_sdk.init(dsn=dsn, traces_sample_rate=0.1)


def create_app() -> FastAPI:
    """Build and configure the FastAPI application.

    Use a factory (instead of a module-level global) so tests and alternative
    entry points can assemble their own configured instances cleanly.
    """
    _init_sentry()
    settings = get_settings()

    app = FastAPI(
        title="Book Club API",
        version=__version__,
        docs_url="/docs" if settings.env != "prod" else None,
        redoc_url=None,
        lifespan=lifespan,
    )

    # In dev, allow all localhost ports so `flutter run -d chrome` works
    # regardless of which ephemeral port the dev server picks.
    origin_regex = r"http://localhost(:\d+)?" if settings.env == "dev" else None
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_allow_origins,
        allow_origin_regex=origin_regex,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    register_exception_handlers(app)
    app.add_middleware(LastActiveMiddleware)
    app.include_router(health.router)
    app.include_router(auth_router)
    app.include_router(book_router)
    app.include_router(reading_router)
    app.include_router(reading_me_router)
    app.include_router(feed_router)
    app.include_router(notification_router)
    app.include_router(social_router)
    app.include_router(community_router)
    app.include_router(challenge_router)
    app.include_router(discovery_router)
    app.include_router(admin_router)
    app.include_router(admin_dashboard_router)
    app.include_router(club_router)
    app.include_router(club_ws_router)
    app.include_router(referral_router)
    app.include_router(reminder_router)
    app.include_router(subscription_router)
    app.include_router(search_router)
    app.include_router(curation_router)
    app.include_router(experiment_router)
    app.include_router(retention_router)
    app.include_router(shield_router)

    # Expose /metrics for Prometheus scraping; instrument after all routers are
    # registered so every route is covered from the start.
    Instrumentator().instrument(app).expose(app)

    return app


app = create_app()

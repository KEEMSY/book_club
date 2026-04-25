"""FastAPI application factory."""

from __future__ import annotations

from collections.abc import AsyncIterator
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app import __version__
from app.api import health
from app.core.config import get_settings
from app.core.exceptions import register_exception_handlers
from app.domains.auth.router import router as auth_router
from app.domains.book.router import router as book_router
from app.domains.feed.events import CommentAdded, ReactionAdded
from app.domains.feed.router import router as feed_router
from app.domains.notification.providers import create_scheduler, get_notification_service
from app.domains.notification.router import router as notification_router
from app.domains.reading.events import UserGradeRecomputed
from app.domains.reading.providers import get_event_bus
from app.domains.reading.router import router as reading_router


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncIterator[None]:
    """Wire event bus subscribers and start the APScheduler on startup."""
    notification_svc = get_notification_service()
    bus = get_event_bus()

    bus.subscribe(ReactionAdded, notification_svc.on_reaction_added)
    bus.subscribe(CommentAdded, notification_svc.on_comment_added)
    bus.subscribe(UserGradeRecomputed, notification_svc.on_grade_up)

    scheduler = create_scheduler(notification_svc)
    scheduler.start()

    yield

    scheduler.shutdown(wait=False)


def create_app() -> FastAPI:
    """Build and configure the FastAPI application.

    Use a factory (instead of a module-level global) so tests and alternative
    entry points can assemble their own configured instances cleanly.
    """
    settings = get_settings()

    app = FastAPI(
        title="Book Club API",
        version=__version__,
        docs_url="/docs" if settings.env != "prod" else None,
        redoc_url=None,
        lifespan=lifespan,
    )

    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.cors_allow_origins,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    register_exception_handlers(app)
    app.include_router(health.router)
    app.include_router(auth_router)
    app.include_router(book_router)
    app.include_router(reading_router)
    app.include_router(feed_router)
    app.include_router(notification_router)

    return app


app = create_app()

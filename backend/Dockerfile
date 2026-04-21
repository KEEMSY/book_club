# syntax=docker/dockerfile:1.7
#
# Book Club backend — multi-stage image.
#
# Stages:
#   builder      — resolve & install Python deps into /app/.venv using uv
#   development  — dev image with live reload (uvicorn --reload)
#   production   — lean runtime image, non-root user
#
# Usage:
#   docker build --target development -t bookclub-api:dev backend/
#   docker build --target production  -t bookclub-api:prod backend/
#
# Compose uses `target: development`.

# ───────────────────────── builder ─────────────────────────
FROM python:3.12-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    UV_LINK_MODE=copy \
    UV_PROJECT_ENVIRONMENT=/app/.venv

# Build-time deps for any wheels that need compilation (asyncpg ships wheels, but
# keep gcc available for safety); removed in the runtime stages.
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir uv==0.5.11

WORKDIR /app

# Install deps first (better layer caching). README.md is referenced by
# pyproject.toml so it must be present for `uv sync` to succeed.
COPY pyproject.toml uv.lock README.md ./
RUN uv sync --frozen --no-dev --no-install-project

# Copy source and install project itself.
COPY app ./app
COPY migrations ./migrations
COPY alembic.ini ./
RUN uv sync --frozen --no-dev

# ───────────────────── base runtime (shared) ────────────────
FROM python:3.12-slim AS runtime-base

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/app/.venv/bin:${PATH}" \
    VIRTUAL_ENV=/app/.venv

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd --system --gid 1000 app \
    && useradd  --system --uid 1000 --gid app --home /app --shell /usr/sbin/nologin app

WORKDIR /app

# ───────────────────────── development ─────────────────────
# Live-reload image. Source is typically bind-mounted via docker-compose so
# edits trigger uvicorn's reloader. We still copy a baseline to make the image
# standalone-runnable.
FROM runtime-base AS development

# Install uv for development convenience (e.g. `uv run pytest` inside the container).
RUN pip install --no-cache-dir uv==0.5.11

COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app/pyproject.toml /app/uv.lock /app/alembic.ini /app/README.md /app/
COPY --from=builder /app/app /app/app
COPY --from=builder /app/migrations /app/migrations

# Dev is usually run as root because the bind-mount may be owned by the host
# user; for stricter isolation flip USER to `app` and align host UIDs.
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]

# ───────────────────────── production ──────────────────────
FROM runtime-base AS production

COPY --from=builder --chown=app:app /app/.venv     /app/.venv
COPY --from=builder --chown=app:app /app/app       /app/app
COPY --from=builder --chown=app:app /app/migrations /app/migrations
COPY --from=builder --chown=app:app /app/alembic.ini /app/alembic.ini
COPY --from=builder --chown=app:app /app/pyproject.toml /app/pyproject.toml

USER app

EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "2", "--no-access-log"]

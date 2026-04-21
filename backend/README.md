# Book Club Backend

FastAPI modular monolith for Book Club (reading tracker + book-group feed).

## Requirements

- Python 3.12
- [uv](https://docs.astral.sh/uv/) for dependency and virtualenv management
- PostgreSQL 16 (for migrations / integration tests)

## Setup

```bash
uv sync
```

## Run (dev)

```bash
uv run uvicorn app.main:app --reload
```

## Test / Lint / Type-check

```bash
uv run pytest
uv run ruff check .
uv run ruff format --check .
uv run mypy app
```

## Migrations

```bash
uv run alembic upgrade head
uv run alembic revision -m "description"
```

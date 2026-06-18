# GitHub Actions workflows

This directory holds CI pipelines for the Book Club monorepo. Workflows are
scoped by path filter so mobile-only PRs don't run backend checks (and vice
versa), and every workflow uses concurrency groups keyed on `github.ref` so
new pushes cancel stale runs.

## Workflows

### `backend.yml`

**Triggers**
- `push` on `main`
- `pull_request` when the diff touches `backend/**` or `.github/workflows/backend.yml`

**Jobs**
- `lint-and-type` — `uv sync --locked`, `ruff check`, `ruff format --check`, `mypy app`
- `test` — `alembic upgrade head` against a `postgres:16-alpine` service
  container (same pin as `docker-compose.yml`) plus `redis:7-alpine`, then
  `pytest -q`. Uses a throwaway CI-only `JWT_SECRET`.
- `docker-build` — PR only. `docker build --target production` via Buildx
  with GitHub Actions cache (`type=gha`) so layers are reused across runs.

**Reproduce locally** (from `backend/`):

```bash
uv sync --locked
uv run ruff check .
uv run ruff format --check .
uv run mypy app
uv run alembic upgrade head   # requires a running postgres
uv run pytest -q
docker build --target production -t bookclub-api:ci .
```

### `mobile.yml`

**Triggers**
- `push` on `main`
- `pull_request` when the diff touches `mobile/**` or `.github/workflows/mobile.yml`

**Jobs**
- `analyze-and-test` — `flutter pub get`, `dart format --set-exit-if-changed .`,
  `flutter analyze`, `flutter test`. Flutter is pinned to `3.41.5` on the
  stable channel with pub cache keyed on `mobile/pubspec.lock`.
- `build-android` — `needs: analyze-and-test`. JDK 17 + `flutter build apk
  --release` to verify the Android release toolchain compiles.
- `build-ios` — `needs: analyze-and-test`, `macos-latest`. `flutter build ios
  --no-codesign --release` to verify the iOS release build without
  provisioning. Signing + TestFlight upload is a separate M60 release job.

Generated sources (`*.g.dart`, `*.freezed.dart`) are committed, so build jobs
do not run `build_runner`.

**Reproduce locally** (from `mobile/`):

```bash
flutter pub get
dart format --set-exit-if-changed .
flutter analyze
flutter test
flutter build apk --release
flutter build ios --no-codesign --release   # macOS only
```

### `deploy.yml`

**Triggers**
- `push` on `main` when the diff touches `backend/**` or `.github/workflows/deploy.yml`.
  PRs never deploy.

**Jobs**
- `deploy` — `flyctl deploy --remote-only` from `backend/` (picks up
  `backend/fly.toml`, builds on Fly's remote builders). Alembic migrations run
  via the `release_command` in `fly.toml`, not from this workflow.

Concurrency group `deploy-production` with `cancel-in-progress: false` so an
in-flight deploy finishes cleanly instead of being aborted mid-release.

## Secrets

- **`backend.yml` / `mobile.yml`** — none. CI uses a throwaway `JWT_SECRET`
  and unsigned mobile builds.
- **`deploy.yml`** — `FLY_API_TOKEN` (repo secret). All backend runtime
  secrets live in Fly.io secrets, never in the workflow. See
  [`docs/ops/fly-secrets.md`](../../docs/ops/fly-secrets.md).

## Adding a new workflow

New workflows in this repo should follow the same baseline:

1. **Path filters** on `pull_request` to avoid cross-domain noise.
2. **Concurrency group** `<workflow-name>-${{ github.ref }}` with
   `cancel-in-progress: true`.
3. **Pin actions** to a major version tag (`@v4`, `@v3`). SHA pinning is
   reserved for security-sensitive workflows (release signing, deploy).
4. **Pin service images** to the same versions `docker-compose.yml` uses so
   CI and local dev exercise identical backing stores.
5. **Pin tool versions** that affect analyzer / formatter output (e.g.
   `flutter-version: 3.41.5`) so deterministic checks don't drift beneath us.
6. **Lockfile-enforced installs** — `uv sync --locked`, `flutter pub get`
   against a committed `pubspec.lock`. Never use unpinned `uv sync` in CI.
7. **No secrets in the workflow file.** Use `${{ secrets.* }}`.

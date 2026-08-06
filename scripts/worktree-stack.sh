#!/usr/bin/env bash
# Bring an isolated docker stack up/down for the CURRENT worktree so container
# operations (restart / migrate / DB writes) never interfere with another
# session's stack. BC-59 / CLAUDE.md §6.4.
#
# Usage:
#   scripts/worktree-stack.sh <name> <offset> [compose args...]
# Examples:
#   scripts/worktree-stack.sh bc59 40 up -d          # api :8040 db :5472 redis :6419 ...
#   scripts/worktree-stack.sh bc59 40 up -d db redis # only some services
#   scripts/worktree-stack.sh bc59 40 down
#
#   name   suffix for the compose project → bookclub-<name>
#   offset integer added to every published host port (keep small & distinct
#          per worktree, e.g. the ticket number)
#
# Internal api↔db↔redis wiring uses compose service names, so each project gets
# its own network automatically; only host-published ports need the offset.
# The web app for this stack must target the offset API port:
#   flutter run -d web-server --dart-define=API_BASE_URL=http://localhost:<API_PORT>
set -euo pipefail

name="${1:?usage: worktree-stack.sh <name> <offset> [compose args]}"
offset="${2:?offset required (integer), e.g. 40}"
shift 2
args=("$@")
[ ${#args[@]} -eq 0 ] && args=(up -d)

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

# .env holds shared secrets and is required by the api service's env_file.
# Symlink it from the main worktree if this worktree has none, so isolated
# stacks reuse a single secret source instead of drifting copies.
if [ ! -e .env ]; then
  main_wt="$(git worktree list --porcelain | awk '/^worktree /{print $2; exit}')"
  if [ -n "${main_wt:-}" ] && [ -e "$main_wt/.env" ]; then
    ln -s "$main_wt/.env" .env
    echo "linked .env -> $main_wt/.env"
  else
    echo "WARN: no .env found (api service needs one)" >&2
  fi
fi

export API_PORT=$((8000 + offset)) \
  DB_PORT=$((5432 + offset)) \
  REDIS_PORT=$((6379 + offset)) \
  MINIO_API_PORT=$((9000 + offset)) \
  MINIO_CONSOLE_PORT=$((9001 + offset)) \
  PROM_PORT=$((9090 + offset)) \
  GRAFANA_PORT=$((3000 + offset))

echo "stack=bookclub-${name}  api=:${API_PORT} db=:${DB_PORT} redis=:${REDIS_PORT} minio=:${MINIO_API_PORT}/${MINIO_CONSOLE_PORT}"
exec docker compose -p "bookclub-${name}" "${args[@]}"

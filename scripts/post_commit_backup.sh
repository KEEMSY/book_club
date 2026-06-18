#!/usr/bin/env bash
# Claude Code PostToolUse hook — Bash tool 에서 git commit 이 실행됐을 때
# DB 스냅샷을 backups/ 에 저장하고 최근 20개 초과분을 자동 삭제한다.
#
# 환경 변수 (Claude Code 가 주입):
#   CLAUDE_TOOL_INPUT_COMMAND  — 실제로 실행된 Bash 명령어 문자열

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="${REPO_ROOT}/backups"
KEEP=20   # 유지할 최대 백업 개수

# git commit 명령이 포함된 경우에만 실행
if ! echo "${CLAUDE_TOOL_INPUT_COMMAND:-}" | grep -qE 'git commit'; then
    exit 0
fi

# DB 컨테이너가 running 상태인지 확인 (없으면 조용히 종료)
if ! docker inspect --format='{{.State.Running}}' bookclub-db-1 2>/dev/null | grep -q true; then
    exit 0
fi

mkdir -p "${BACKUP_DIR}"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/bookclub_${TIMESTAMP}.sql"

docker exec bookclub-db-1 pg_dump -U bookclub bookclub > "${BACKUP_FILE}"
echo "[backup] ✅ ${BACKUP_FILE} ($(du -sh "${BACKUP_FILE}" | cut -f1))"

# 오래된 백업 자동 삭제 (최근 KEEP 개만 유지)
EXCESS=$(ls -t "${BACKUP_DIR}"/*.sql 2>/dev/null | tail -n +"$((KEEP + 1))")
if [[ -n "${EXCESS}" ]]; then
    echo "${EXCESS}" | xargs rm -f
    COUNT=$(echo "${EXCESS}" | wc -l | tr -d ' ')
    echo "[backup] 🗑️  오래된 백업 ${COUNT}개 삭제 (최근 ${KEEP}개 유지)"
fi

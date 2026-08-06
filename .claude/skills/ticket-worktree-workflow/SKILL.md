---
name: ticket-worktree-workflow
description: Execute Book Club work as Jira-ticket-scoped git worktrees with the feature/backlog/hotfix branch convention, running independent tickets in parallel and syncing status back to Jira. Use when the user says "티켓으로 진행", "워크트리로 병렬", "BC-xx 작업 시작", "parallel tickets", or asks to work multiple Jira tickets at once.
---

# Ticket → Worktree → Parallel → Jira workflow

Codifies CLAUDE.md §6.1. Every unit of work maps to one Jira ticket (BC project),
one git worktree, one branch, one PR. Independent tickets run in parallel via
worktrees so their working trees never collide.

## Branch convention (by task nature)

| type | 용도 | 예시 |
|------|------|------|
| `feature/<TICKET>` | 신규 기능·확장·배포 파이프라인 | `feature/BC-3` |
| `backlog/<TICKET>` | 스코프 정리·기술부채·리팩터링 | `backlog/BC-16` |
| `hotfix/<TICKET>` | 긴급 수정 | `hotfix/BC-42` |

## Procedure

1. **Confirm the ticket exists** in Jira (BC project). No ticket → create one first.
   The personal Atlassian MCP is `mcp__atlassian-personal__*` (Jira only).
2. **Create the worktree** (never work directly on `main` for a ticket):
   ```bash
   git worktree add ../book_club-<TICKET> -b <type>/<TICKET>
   ```
3. **Do the work** inside the worktree. Match surrounding code style (CLAUDE.md §4).
4. **Quality gate before commit** (CLAUDE.md §4):
   - backend: `cd backend && ruff check . && ruff format --check . && mypy app` (+ pytest for services)
   - mobile: `cd mobile && dart analyze` (0 warnings) + affected widget/unit tests
5. **Commit** — 제목 한국어, `<type>: <요약>`, 본문에 왜. End commit body with the
   Co-Authored-By trailer.
6. **Push + PR** — `git push -u origin <type>/<TICKET>`, then open the PR using the
   **`pr-description`** skill's review-friendly format (요약·Jira·변경사항·배경/왜·검증·
   리뷰포인트·리스크/롤아웃·체크리스트). Write the body to a file and pass it with
   `gh pr create --title "<type>/<TICKET> <요약>" --body-file <file>`. Include the
   ticket key. PR 1건 = 티켓 1건 (Squash merge).
7. **Gate merge on CI green** — never merge until the full CI suite (lint/type/test
   **and** release-build jobs where applicable) is green. Watch with
   `gh pr checks <n> --watch`. A red or pending check blocks the merge.
8. **Sync Jira** — post a summary comment on the ticket
   (`jira_add_comment`) and, on merge, transition it to 완료
   (`jira_transition_issue`, transition id `41` on the BC board).
9. **Clean up** after merge: stop any process started from the worktree (dev
   servers etc.) FIRST, then `git worktree remove ../book_club-<TICKET>`. Removing
   a worktree while a server serves from it breaks that server.

## main protection & shared-resource isolation (CLAUDE.md §6.4)

- `main` is GitHub-branch-protected: **PR-merge only** (direct `git push origin main`
  is rejected with `GH006`), no force-push/deletion, `enforce_admins`. No worktree
  or session can change main except by merging a green-CI PR.
- Shared local resources are session-common: run the Flutter web dev server from the
  **main worktree** (not a per-ticket worktree); do destructive DB work only on a
  throwaway `book_club_test` DB (never `TRUNCATE`/`UPDATE` the shared dev DB); don't
  kill another session's server/port.

## Parallel execution

- Dispatch one subagent per independent ticket, each `cd`-ed into its own worktree
  path. Because worktrees have separate working directories, agents don't interfere.
- **Shared-file conflict risk:** edits to central files (`backend/app/main.py`,
  `backend/app/core/config.py`, `mobile/lib/core/router/*`, mobile shell) will
  conflict at PR-merge time. Keep central-file edits minimal and per-domain;
  resolve conflicts when merging PRs sequentially.

## Feature-flag pattern (scope cleanup)

Non-MVP features are gated, never deleted outright, so a decision is reversible.

- **Backend:** `backend/app/core/config.py` has `feature_<domain>_enabled: bool`
  (default `True`). `backend/app/main.py` mounts each non-MVP router under
  `if settings.feature_<domain>_enabled:`. Defer a domain → flip its default to
  `False` (router stops mounting, endpoints 404, code stays).
- **Mobile:** `mobile/lib/core/config/feature_flags.dart` has `FeatureFlags.<name>`
  (default `true`). UI entry points (nav items, route guards, buttons) read the
  flag. Defer a feature → set its flag to `false` and gate its entry points.
- MVP core (auth/book/reading/feed/notification) has no flag and is always on.
- Record the keep / defer / remove decision + rationale in the Jira ticket.

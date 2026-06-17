## Book Club — 개발 환경 편의 명령 모음
##
## 사용법: make <target>
## 예시:   make db-backup
##         make db-restore FILE=backups/bookclub_20260617_140000.sql
##         make seed

SHELL := /bin/bash
.DEFAULT_GOAL := help

COMPOSE       := docker-compose -f docker-compose.yml
DB_CONTAINER  := bookclub-db-1
DB_USER       := bookclub
DB_NAME       := bookclub
BACKUP_DIR    := backups
BACKUP_FILE   := $(BACKUP_DIR)/bookclub_$(shell date +%Y%m%d_%H%M%S).sql

# ─── 도움말 ───────────────────────────────────────────────────────────────────

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

# ─── 서비스 ───────────────────────────────────────────────────────────────────

.PHONY: up
up: ## 전체 스택 시작 (백그라운드)
	$(COMPOSE) up -d

.PHONY: down
down: ## 컨테이너만 중지 (볼륨·데이터 보존 ✅)
	$(COMPOSE) down

.PHONY: down-volumes
down-volumes: ## ⚠️  컨테이너 + 볼륨 전체 삭제 (데이터 유실 위험)
	@echo "⚠️  postgres_data 볼륨도 삭제됩니다. 정말 실행하시겠습니까? [y/N]" && read ans && [ "$${ans:-N}" = y ]
	$(COMPOSE) down -v

.PHONY: restart-api
restart-api: ## API 컨테이너만 재시작 (의존성 추가 후 이미지 재빌드 포함)
	$(COMPOSE) build api
	$(COMPOSE) up -d --no-deps api

.PHONY: logs
logs: ## API 로그 실시간 출력
	$(COMPOSE) logs -f api

.PHONY: status
status: ## 컨테이너 상태 확인
	$(COMPOSE) ps

# ─── DB 백업 / 복원 ───────────────────────────────────────────────────────────

.PHONY: db-backup
db-backup: ## DB 덤프 생성 → backups/ 폴더 (타임스탬프 파일명)
	@mkdir -p $(BACKUP_DIR)
	docker exec $(DB_CONTAINER) pg_dump -U $(DB_USER) $(DB_NAME) > $(BACKUP_FILE)
	@echo "✅  백업 완료: $(BACKUP_FILE)"
	@ls -lh $(BACKUP_FILE)

.PHONY: db-restore
db-restore: ## 백업 파일 복원  예: make db-restore FILE=backups/xxx.sql
ifndef FILE
	$(error FILE 변수를 지정하세요. 예: make db-restore FILE=backups/bookclub_20260617_140000.sql)
endif
	@echo "⚠️  $(DB_NAME) 데이터베이스를 $(FILE) 로 덮어씁니다. [y/N]" && read ans && [ "$${ans:-N}" = y ]
	docker exec -i $(DB_CONTAINER) psql -U $(DB_USER) -d $(DB_NAME) -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
	docker exec -i $(DB_CONTAINER) psql -U $(DB_USER) $(DB_NAME) < $(FILE)
	@echo "✅  복원 완료"

.PHONY: db-backup-list
db-backup-list: ## 저장된 백업 목록 확인
	@ls -lht $(BACKUP_DIR)/*.sql 2>/dev/null || echo "(백업 파일 없음 — make db-backup 으로 생성)"

# ─── 마이그레이션 ─────────────────────────────────────────────────────────────

.PHONY: migrate
migrate: ## 최신 마이그레이션 적용
	$(COMPOSE) exec api alembic upgrade head

.PHONY: migrate-status
migrate-status: ## 현재 마이그레이션 버전 확인
	$(COMPOSE) exec api alembic current

# ─── 시드 데이터 ──────────────────────────────────────────────────────────────

.PHONY: seed
seed: ## 테스트 사용자·챌린지·실험 데이터 전부 시드
	$(COMPOSE) exec api python scripts/seed_test_users.py
	$(COMPOSE) exec api python scripts/seed_challenges.py
	$(COMPOSE) exec api python scripts/seed_experiments.py
	@echo "✅  시드 완료"

.PHONY: seed-users
seed-users: ## 테스트 사용자만 시드
	$(COMPOSE) exec api python scripts/seed_test_users.py

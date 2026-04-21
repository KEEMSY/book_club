# Book Club

독서 시간 · 권수를 기록하고, 같은 책을 읽은 사용자들과 대화하는 모바일 앱.
(나이키 런클럽의 독서 버전)

## 구조

```
book_club/
  backend/          FastAPI + Postgres + Redis (모듈러 모놀리스)
  mobile/           Flutter (iOS + Android)
  docs/
    plans/          설계·구현 계획 문서
    backlog/        아이디어 저장소
    legal/          약관·개인정보처리방침
  .github/workflows CI 파이프라인
  CLAUDE.md         협업 규칙
```

## 문서

- 설계: [`docs/plans/2026-04-20-book-club-design.md`](docs/plans/2026-04-20-book-club-design.md)
- Phase 1 계획: [`docs/plans/2026-04-20-book-club-phase1-implementation.md`](docs/plans/2026-04-20-book-club-phase1-implementation.md)
- 규칙: [`CLAUDE.md`](CLAUDE.md)
- 백로그: [`docs/backlog/IDEAS.md`](docs/backlog/IDEAS.md)

## 로컬 실행

### 요구 사항

- Docker Desktop (또는 Colima) · Docker Compose v2
- Flutter 3.x (모바일 작업 시)

### Backend (Docker Compose)

```bash
# 1) 환경변수 템플릿 복사 (최초 1회)
cp .env.example .env

# 2) 전체 스택 빌드 + 기동 (api + db + redis + minio)
docker compose up -d --build

# 3) 최초 기동 시 DB 마이그레이션 적용
docker compose exec api uv run alembic upgrade head

# 4) 헬스체크
curl -s http://localhost:8000/health | jq
# → {"status":"ok","version":"0.0.0"}

# 5) 로그 추적
docker compose logs -f api

# 6) 테스트 실행 (컨테이너 내부)
docker compose exec api uv run pytest
```

#### 포트

| 서비스 | 포트 | 비고 |
|---|---|---|
| api (FastAPI) | 8000 | `/health`, `/docs` |
| db (Postgres 16) | 5432 | user/pass/db = `bookclub` |
| redis (Redis 7) | 6379 | |
| minio S3 API | 9000 | `S3_ENDPOINT_URL` |
| minio 콘솔 | 9001 | 로그인: `minioadmin` / `minioadmin` |

#### 정리

```bash
# 컨테이너만 중지 (볼륨 유지)
docker compose down

# 볼륨까지 초기화 (DB · MinIO 데이터 전부 삭제)
docker compose down -v
```

### Mobile

```bash
cd mobile
flutter pub get
flutter run
```

## 버저닝

앱스토어 출시 전까지는 `0.0.X` — PATCH 만 증가. 상세 규칙은 `CLAUDE.md` §7.

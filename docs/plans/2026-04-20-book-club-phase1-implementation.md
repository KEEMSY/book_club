---
title: Book Club — Phase 1 (MVP) 구현 계획
version: 0.1.0
status: approved
author: sy
created: 2026-04-20
updated: 2026-04-20
related: 2026-04-20-book-club-design.md
---

# Book Club — Phase 1 구현 계획

> **For Claude:** REQUIRED SUB-SKILL: Use `superpowers:executing-plans` to implement this plan task-by-task.
> **Area agents:** 각 Milestone 은 지정된 글로벌 에이전트에게 분배된다. 에이전트는 작업 시작 전 `CLAUDE.md` 와 `docs/plans/2026-04-20-book-club-design.md` 를 읽는다.

**Goal:** 독서 타이머·잔디·5단계 등급·책 그룹 피드를 갖춘 Flutter 모바일 앱 MVP(v0.0.1) 를 스테이징에 배포한다.

**Architecture:** 모듈러 모놀리스 FastAPI + Postgres + Redis + R2, 3-Layer + Port/Adapter. Flutter + Riverpod + go_router. 5개 도메인(auth / book / reading / feed / notification) 을 feature-first 로 1:1 매핑.

**Tech Stack:** Python 3.12 · FastAPI · SQLAlchemy 2 async · Alembic · Pydantic v2 · Postgres 16 · Redis 7 · Cloudflare R2 · Flutter 3 · Riverpod · go_router · freezed · dio + retrofit · FCM · Fly.io · Neon · Upstash · Docker Compose.

**TDD 원칙 (모든 Task 공통):**
1. 실패하는 테스트 먼저
2. 테스트 실패 확인
3. 최소 구현
4. 테스트 통과 확인
5. 리팩터링 (필요 시)
6. 커밋

---

## 마일스톤 개요

| # | 이름 | 담당 에이전트 | 의존 |
|---|---|---|---|
| M0 | 스캐폴딩 · 인프라 기반 | DevOps Automator | — |
| M1 | Auth (카카오·애플 로그인) | Backend Architect + Mobile App Builder | M0 |
| M2 | Book 카탈로그 · 검색 · 서재 | Backend Architect + Mobile App Builder | M1 |
| M3 | Reading — 타이머 · 세션 · 잔디 · 등급 | Backend Architect + Mobile App Builder | M2 |
| M4 | Feed — 포스트 · 리액션 · 댓글 | Backend Architect + Mobile App Builder | M3 |
| M5 | Notification · 주간 리포트 · 푸시 | Backend Architect + Mobile App Builder | M3, M4 |
| M6 | v0.0.1 릴리스 준비 · 스테이징 배포 · QA | DevOps Automator + Evidence Collector | All |

**각 마일스톤 시작 전:** `docs/backlog/IDEAS.md` 리뷰 (CLAUDE.md §8.2).

---

# Milestone 0 — 스캐폴딩 & 인프라 기반

**담당:** DevOps Automator + Backend Architect (초기 레이아웃)
**종료 조건:** `docker compose up` 으로 로컬 개발 환경이 뜨고, `GET /health` 가 200 을 반환하며, CI 가 PR 당 실행된다.

### Task 0.1 — 모노레포 디렉토리 레이아웃
**Files:**
- Create: `backend/`, `mobile/`, `.github/workflows/`
- Create: `README.md` (프로젝트 개요, 로컬 실행 방법 최소)

**Steps:**
1. 위 디렉토리 생성
2. `README.md` 에 프로젝트 설명 + 로컬 실행 가이드 placeholder 작성
3. 커밋: `chore: 모노레포 디렉토리 초기 레이아웃`

### Task 0.2 — Python/FastAPI 프로젝트 부트스트랩
**Files:**
- Create: `backend/pyproject.toml` (uv 또는 poetry)
- Create: `backend/app/main.py`
- Create: `backend/app/core/config.py` (pydantic-settings)
- Create: `backend/app/core/db.py` (async engine + session factory)
- Create: `backend/app/__init__.py` 외 필요 init 들
- Create: `backend/tests/conftest.py`
- Create: `backend/tests/test_health.py`

**Steps:**
1. 실패 테스트: `GET /health → 200 {"status": "ok"}`
2. FastAPI 앱 생성, `/health` 라우트 추가
3. 테스트 통과 확인
4. ruff · mypy 설정 추가 (`pyproject.toml` 내 [tool.ruff], [tool.mypy])
5. 커밋: `feat(backend): FastAPI 스켈레톤 + 헬스체크`

### Task 0.3 — Flutter 프로젝트 부트스트랩
**Files:**
- Create: `mobile/` (via `flutter create --org kr.mission-driven.bookclub`)
- Modify: `mobile/pubspec.yaml` — Riverpod, go_router, freezed, dio, retrofit 의존성 추가
- Create: `mobile/lib/main.dart`, `mobile/lib/app.dart`
- Create: `mobile/lib/core/theme/`, `mobile/lib/core/router/`
- Create: `mobile/test/smoke_test.dart`

**Steps:**
1. `flutter create` 로 iOS+Android 프로젝트 생성
2. 의존성 추가 및 `flutter pub get`
3. 기본 MaterialApp + 홈 화면(placeholder) + smoke 테스트
4. `flutter analyze` / `flutter test` 통과 확인
5. 커밋: `feat(mobile): Flutter 프로젝트 스켈레톤`

### Task 0.4 — Docker Compose (개발 환경)
**Files:**
- Create: `docker-compose.yml`
- Create: `backend/Dockerfile` (dev + prod multi-stage)
- Create: `.env.example`

**Services:** `api` (fastapi, uvicorn --reload), `db` (postgres:16), `redis` (redis:7), `minio` (R2 로컬 대체)

**Steps:**
1. `.env.example` 정의 (DATABASE_URL, REDIS_URL, S3_ENDPOINT, S3_BUCKET 등)
2. Compose 로 api + db + redis + minio 구동
3. `curl localhost:8000/health` 로 검증
4. 커밋: `chore: Docker Compose 로컬 개발 환경`

### Task 0.5 — Alembic + 최초 마이그레이션
**Files:**
- Create: `backend/alembic.ini`, `backend/migrations/`
- Create: `backend/migrations/env.py` (async 지원)
- Create: `backend/migrations/versions/0001_init.py` (빈 초기 리비전)

**Steps:**
1. Alembic 초기화 (async template)
2. `alembic upgrade head` 가 빈 DB 에 적용되는지 확인
3. 커밋: `feat(backend): Alembic 초기화`

### Task 0.6 — GitHub Actions CI
**Files:**
- Create: `.github/workflows/backend.yml` — ruff, mypy, pytest (postgres service)
- Create: `.github/workflows/mobile.yml` — `dart analyze`, `flutter test`

**Steps:**
1. PR / push on `main` 트리거
2. CI green 확인 (로컬에서 act 또는 draft PR 로)
3. 커밋: `ci: backend + mobile 기본 CI 파이프라인`

### Task 0.7 — 공통 계층 스캐폴드
**Files:**
- Create: `backend/app/core/http/base_client.py` (재시도·타임아웃 래퍼)
- Create: `backend/app/core/storage/r2_client.py` (boto3 S3 호환)
- Create: `backend/app/core/security.py` (JWT 발급·검증)
- Create: `backend/app/core/exceptions.py` (도메인 기본 예외)
- Create: `backend/app/shared/event_bus.py` (인터페이스만; 구현은 M3)

**Steps:**
- 각 모듈은 **인터페이스 + 최소 stub** 만. 실구현은 필요 시 도메인에서 완성.
- 간단한 단위 테스트 추가 (JWT encode/decode 라운드트립 등).
- 커밋: `feat(backend): core 공용 계층 스캐폴드`

### M0 완료 조건
- `docker compose up` 으로 전체 스택 기동
- `GET /health` 200
- `flutter run` 으로 모바일 빌드 성공
- CI green
- **커밋 태그:** `v0.0.0-scaffold`

---

# Milestone 1 — Auth (카카오 + 애플 로그인)

**담당:** Backend Architect + Mobile App Builder
**종료 조건:** Flutter 앱에서 카카오/애플 로그인을 누르면 JWT 를 받아 저장하고, 인증된 요청으로 `/me` 가 사용자 프로필을 반환한다.

## 1.A Backend

### Task 1.1 — User · DeviceToken 모델 + 마이그레이션
**Files:**
- Create: `backend/app/domains/auth/models.py`
- Create: `backend/migrations/versions/0002_auth_tables.py`
- Create: `backend/tests/domains/auth/test_models.py`

**규칙:** UNIQUE(provider, provider_sub), DeviceToken 테이블 (user_id, token, platform).

### Task 1.2 — Port 정의
**Files:**
- Create: `backend/app/domains/auth/ports.py`

**Ports:**
- `UserRepositoryPort` — get_by_provider_sub, create, update_last_login
- `DeviceTokenRepositoryPort` — upsert, get_active_tokens_for_user
- `KakaoOAuthPort` — exchange_code_for_user (카카오 accessToken 받아 사용자 정보 반환)
- `AppleOAuthPort` — verify_identity_token (애플 identity_token JWT 서명 검증 + sub 추출)

### Task 1.3 — Repository 구현 (TDD)
**Files:**
- Create: `backend/app/domains/auth/repository.py`
- Create: `backend/tests/domains/auth/test_repository.py` (testcontainers postgres)

### Task 1.4 — External Adapter 구현 (TDD, 픽스처 기반)
**Files:**
- Create: `backend/app/domains/auth/adapters/kakao_oauth_adapter.py`
- Create: `backend/app/domains/auth/adapters/apple_oauth_adapter.py`
- Create: `backend/tests/domains/auth/test_adapters.py`
- Create: `backend/tests/fixtures/kakao/*.json`, `backend/tests/fixtures/apple/*.json`

**검증 포인트:**
- 애플 identity_token: Apple 공개키로 JWT 서명 검증 + aud / iss / exp 체크
- 카카오: access_token → user info 호출, 에러 응답 시 `AuthExternalError` 로 매핑

### Task 1.5 — Service (TDD, Fake Port 주입)
**Files:**
- Create: `backend/app/domains/auth/service.py`
- Create: `backend/tests/domains/auth/test_service.py`

**Methods:**
- `login_with_kakao(code) -> (User, jwt)` — 없으면 신규 생성
- `login_with_apple(identity_token) -> (User, jwt)`
- `issue_tokens(user) -> (access, refresh)`
- `register_device_token(user, token, platform)`

### Task 1.6 — Router + DTO
**Files:**
- Create: `backend/app/domains/auth/router.py`
- Create: `backend/app/domains/auth/schemas.py`
- Create: `backend/tests/domains/auth/test_router.py`

**Endpoints:**
- `POST /auth/kakao` — body `{ code }`
- `POST /auth/apple` — body `{ identity_token, authorization_code? }`
- `POST /auth/refresh`
- `POST /auth/device-tokens`
- `GET /me`

### Task 1.7 — 인증 의존성 (`Depends(get_current_user)`)
**Files:**
- Modify: `backend/app/core/security.py`
- Create: `backend/app/core/deps.py`

### 1.B Mobile

### Task 1.8 — Auth Feature 디렉토리 세팅
**Files:**
- Create: `mobile/lib/features/auth/` — `presentation/`, `application/`, `data/`, `domain/`

### Task 1.9 — 카카오 SDK 연동 (`kakao_flutter_sdk_user`)
- iOS · Android 네이티브 설정 (Info.plist, AndroidManifest)
- 카카오 로그인 → authCode → 백엔드 `/auth/kakao` 호출 → JWT 저장 (flutter_secure_storage)

### Task 1.10 — 애플 로그인 (`sign_in_with_apple`)
- iOS entitlement 설정
- identity_token → 백엔드 `/auth/apple` 호출

### Task 1.11 — AuthRepository · AuthNotifier (Riverpod)
**Files:**
- `data/auth_repository.dart` (dio)
- `application/auth_notifier.dart` (StateNotifier<AuthState>)
- `presentation/login_screen.dart`

### Task 1.12 — 라우터 가드
- 미인증 시 `/login` 으로 리다이렉트 (go_router redirect)

### 1.C Integration

### Task 1.13 — E2E: 카카오 로그인 → /me 성공
- Flutter integration_test
- 테스트 환경에서는 카카오는 mock server 사용 or 수동 테스트 flag

### M1 완료 조건
- 카카오 + 애플 로그인 성공 후 홈 화면 진입
- `flutter test` / `pytest` green
- 커밋 태그: `v0.0.1-m1`

---

# Milestone 2 — Book 카탈로그 · 검색 · 서재

**담당:** Backend Architect + Mobile App Builder
**종료 조건:** 사용자가 책을 검색(네이버)하고 "내 서재에 담기" 하면 `UserBook` 이 생성되며, 서재 탭에서 상태별로 리스트를 볼 수 있다.

## 2.A Backend

### Task 2.1 — Book · UserBook 모델 + 마이그레이션
**Files:** `backend/app/domains/book/models.py`, `backend/migrations/versions/0003_book_tables.py`

### Task 2.2 — Port 정의
- `BookRepositoryPort` — upsert_by_isbn, get_by_id, get_user_library
- `UserBookRepositoryPort` — create, update_status, set_rating_review
- `BookSearchPort` — search(query, page) → List[BookDTO]

### Task 2.3 — Repository (TDD)

### Task 2.4 — 외부 어댑터 (TDD, 픽스처)
- `adapters/naver_book_adapter.py` — X-Naver-Client-Id/Secret 헤더
- `adapters/kakao_book_adapter.py` — Bearer 카카오 REST API 키
- `adapters/composite_book_search_adapter.py` — 네이버 실패 시 카카오 폴백

### Task 2.5 — Service (TDD)
**Methods:**
- `search_books(query)` — 외부 검색 + 로컬 Book upsert
- `add_to_library(user, book_id)` — UserBook 생성 (status=reading)
- `update_status(user, user_book, status)`
- `submit_review(user, user_book, rating, one_line_review)` — status=completed 일 때만

### Task 2.6 — Router
- `GET /books/search?q=...`
- `GET /books/{id}`
- `POST /me/library` — body `{ book_id }`
- `PATCH /me/library/{user_book_id}` — status / review
- `GET /me/library?status=reading`

## 2.B Mobile

### Task 2.7 — Book Feature 구조 + API 클라이언트 (retrofit)
### Task 2.8 — 검색 화면 (debounce 300ms, pagination)
### Task 2.9 — 책 상세 화면 + "서재에 담기" CTA
### Task 2.10 — 서재 탭 (status 세그먼트: 읽는 중 / 완독 / 일시정지 / 포기)
### Task 2.11 — 완독 처리 시 별점 + 한줄 리뷰 모달

### M2 완료 조건
- 검색 → 서재 추가 → 서재 탭 노출 → 완독 → 리뷰 작성 전체 플로우 동작
- 커밋 태그: `v0.0.1-m2`

---

# Milestone 3 — Reading: 타이머 · 잔디 · 등급

**담당:** Backend Architect + Mobile App Builder (핵심 마일스톤)
**종료 조건:** 타이머로 독서 세션을 시작·종료하면 공식 기록으로 저장되고, 잔디와 등급이 업데이트되며, 등급에 따라 타이머 테마 컬러가 바뀐다.

## 3.A Backend

### Task 3.1 — 모델 + 마이그레이션
- `ReadingSession`, `DailyReadingStat`, `UserGrade`, `Goal`, `Streak` (UserGrade 에 streak 필드 포함 가능)
- `backend/migrations/versions/0004_reading_tables.py`

### Task 3.2 — Port 정의
- `ReadingSessionRepositoryPort`
- `DailyStatRepositoryPort` (upsert_by_day)
- `UserGradeRepositoryPort`
- `GoalRepositoryPort`

### Task 3.3 — GradePolicy (순수 도메인 함수)
**Files:** `backend/app/domains/reading/grade_policy.py`

```python
GRADE_THRESHOLDS = [
    (1, 0, 0),
    (2, 3, 10 * 3600),
    (3, 10, 50 * 3600),
    (4, 30, 150 * 3600),
    (5, 100, 500 * 3600),
]

def calculate_grade(total_books: int, total_seconds: int) -> int:
    # AND 조건: 두 임계 모두 만족해야 승급
    ...
```

TDD: 경계값 10 가지 이상 케이스.

### Task 3.4 — StreakPolicy
- 연속 독서일 계산 (어제 세션 있으면 +1, 없으면 1 리셋, 오늘 기록만 있으면 유지)

### Task 3.5 — Repository (TDD)

### Task 3.6 — Service (TDD, 이벤트 발행)
**Methods:**
- `start_session(user, user_book) -> session_id` — 활성 세션 중복 방지
- `end_session(session_id, ended_at) -> ReadingSession` — duration 계산, source=timer
- `log_manual_session(user, user_book, minutes, note)` — source=manual, 등급/잔디 영향 X
- `get_heatmap(user, from_date, to_date) -> List[DailyStat]`
- `get_grade(user) -> UserGradeDTO`

**Event:** `ReadingSessionCompleted` → 등급 재계산 + 스트릭 갱신 + 일일 집계 upsert + WeeklyReport 데이터 적재 (M5 소비자)

### Task 3.7 — 이벤트 버스 실구현
- `backend/app/shared/event_bus.py` — 로컬 인메모리 (after_commit 훅 기반) 로 시작
- Redis Pub/Sub 은 멀티 인스턴스 배포 시 전환

### Task 3.8 — Router
- `POST /reading/sessions/start`
- `POST /reading/sessions/{id}/end`
- `POST /reading/sessions/manual`
- `GET /reading/heatmap?from=&to=`
- `GET /reading/grade`
- `POST /reading/goals`, `GET /reading/goals/current`

## 3.B Mobile (핵심 UX)

### Task 3.9 — Reading Feature 구조
### Task 3.10 — 타이머 화면
- Start / Pause / Resume / End 상태 머신 (Riverpod StateNotifier)
- 경과 시간 표시 + 등급 컬러 기반 프로그레스 링
- 일시정지 누적 시간 차감 로직 로컬에서 계산, 최종 duration 은 서버가 재계산
### Task 3.11 — 백그라운드 타이머
- Android: `flutter_background_service` Foreground Service
- iOS: 앱 백그라운드 진입 시 시작 시각만 보관, 복귀 시 재계산 (장시간 백그라운드 이슈 고려)
### Task 3.12 — 잔디 히트맵 위젯
- 주간 7일 × 연간 52주 그리드, 색 강도 = duration_sec 구간 매핑
### Task 3.13 — 등급 화면 + 테마 적용
- `GradeTheme` 5종 ColorScheme, 전역 테마에 주입
### Task 3.14 — 독서 목표 설정 UI (주/월/연)

## 3.C 정책 검증

### Task 3.15 — 어뷰징 방지 테스트
- 수동 세션은 UserGrade / DailyStat 에 반영되지 않는지 통합 테스트로 검증
- 동시에 활성 세션 2개 생성 시 409 반환

### M3 완료 조건
- 타이머 세션 종료 → 잔디에 한 칸 쌓이고 등급 승급 시 테마 컬러 전환
- 커밋 태그: `v0.0.1-m3`

---

# Milestone 4 — Feed (책 그룹 포스트 · 리액션 · 댓글)

**담당:** Backend Architect + Mobile App Builder
**종료 조건:** 책 상세 하단에서 해당 책의 피드를 조회하고, 포스트·리액션·댓글을 작성할 수 있다.

## 4.A Backend

### Task 4.1 — 모델 + 마이그레이션
- `Post`, `Reaction`, `Comment`
- 인덱스: `Post(book_id, created_at desc)`, `Comment(post_id, created_at)`, `Reaction UNIQUE(post, user, type)`

### Task 4.2 — Port & Repository

### Task 4.3 — Service
- `create_post(user, book, type, content, images[])`
- `toggle_reaction(user, post, type)`
- `list_posts_by_book(book, cursor, limit)` — 커서 기반
- `add_comment(user, post, content, parent_id?)` — 1단계 답글만

### Task 4.4 — 이미지 업로드
- 사전서명 URL 발급 (`POST /uploads/presign`) — R2 S3 presign
- 클라이언트가 직접 업로드 후 URL 을 포스트 생성에 포함

### Task 4.5 — Router
- `GET /books/{book_id}/posts?cursor=`
- `POST /books/{book_id}/posts`
- `POST /posts/{id}/reactions`
- `DELETE /posts/{id}/reactions/{type}`
- `POST /posts/{id}/comments`
- `GET /posts/{id}/comments?cursor=`

## 4.B Mobile

### Task 4.6 — Feed Feature 구조
### Task 4.7 — 책 상세 하단 피드 리스트 (무한 스크롤)
### Task 4.8 — 포스트 작성 화면 (type 선택, 이미지 첨부)
### Task 4.9 — 리액션 바 (5종 이모지)
### Task 4.10 — 댓글 화면 + 1단계 답글

### M4 완료 조건
- 같은 책을 담은 두 계정으로 각각 포스트·리액션·댓글 교환 가능
- 커밋 태그: `v0.0.1-m4`

---

# Milestone 5 — Notification & 주간 리포트

**담당:** Backend Architect + Mobile App Builder
**종료 조건:** 리액션·댓글·등급 승급·주간 리포트 알림이 인앱 + 푸시로 전달된다.

## 5.A Backend

### Task 5.1 — 모델 + 마이그레이션 (`Notification`, `WeeklyReport`)
### Task 5.2 — FCM 어댑터 (Port + Adapter)
### Task 5.3 — Service — 이벤트 소비자
- `on_reaction_created` → 포스트 작성자에게 알림
- `on_comment_created` → 포스트 작성자 + 상위 댓글 작성자
- `on_grade_up` → 당사자
- `on_weekly_report_generated` → 당사자

### Task 5.4 — 주간 리포트 배치
- APScheduler 또는 Fly machines cron
- 매주 일요일 21:00 KST 에 지난 주(월-일) 집계 → WeeklyReport 생성 → 푸시

### Task 5.5 — Router
- `GET /notifications?cursor=`
- `POST /notifications/{id}/read`
- `GET /reports/weekly?week=`

## 5.B Mobile

### Task 5.6 — FCM 세팅 (iOS APNS, Android)
### Task 5.7 — 디바이스 토큰 등록 (로그인 성공 시 + 토큰 갱신 시)
### Task 5.8 — 알림 센터 화면
### Task 5.9 — 주간 리포트 화면 (총 시간, 세션 수, 최다 요일, 최장 세션)

### M5 완료 조건
- 리액션·댓글 시 수신자에게 푸시 도달
- 일요일 스케줄러가 실제 WeeklyReport 생성
- 커밋 태그: `v0.0.1-m5`

---

# Milestone 6 — v0.0.1 릴리스 & 스테이징 배포

**담당:** DevOps Automator + Evidence Collector (QA)
**종료 조건:** Fly.io 에 백엔드 배포, TestFlight / Play 내부 테스트 트랙에 모바일 업로드. 버전 `v0.0.1` 태그.

### Task 6.1 — 프로덕션 Dockerfile · Fly.io 구성
- `fly.toml` (region: nrt), Health check, secrets 설정
### Task 6.2 — Neon Postgres 연결 · Alembic upgrade
### Task 6.3 — Upstash Redis 설정 + 이벤트 버스 Redis 모드 전환 확인
### Task 6.4 — Cloudflare R2 버킷 + CORS 설정
### Task 6.5 — Sentry 백엔드 · Flutter 연동
### Task 6.6 — iOS · Android 서명 키 생성 및 CI 업로드
### Task 6.7 — 개인정보처리방침·이용약관 템플릿 문서 추가 (`docs/legal/`)
### Task 6.8 — QA 시트: Evidence Collector 로 핵심 플로우 스크린샷 기반 검증
1. 로그인 2. 책 검색 3. 서재 추가 4. 타이머 세션 5. 잔디/등급 6. 피드 포스트 7. 리액션/댓글 8. 주간 리포트 푸시
### Task 6.9 — `v0.0.1` 태그 + GitHub Release 노트
### Task 6.10 — 백로그 리뷰 → Phase 2 스코프 초안 작성

### M6 완료 조건
- Fly.io 스테이징에서 전 플로우 동작
- TestFlight 내부 테스터 초대
- `git tag v0.0.1 && git push --tags`

---

## 에이전트 분배 전략

- **M0**: DevOps Automator 주도, Backend Architect 보조
- **M1–M5 (Backend)**: Backend Architect (도메인별 독립 브랜치: `feat/auth`, `feat/book`, `feat/reading`, `feat/feed`, `feat/notification`)
- **M1–M5 (Mobile)**: Mobile App Builder (도메인 작업은 **백엔드 완료 후 병렬**)
- **M6**: DevOps Automator + Evidence Collector
- **횡단:** Code Reviewer 가 각 PR 리뷰 (CLAUDE.md §3 레이어 규칙 위반 체크)
- **횡단:** UI/UX Designer 는 M2 ~ M4 의 Flutter 태스크 전 사전 와이어프레임 제공

## 병렬화 가이드

- M1 백엔드 완료 후 M2 백엔드 시작 가능 — **동시에 M1 모바일 작업 진행**.
- M3 는 종속성이 크므로 **직렬**로 진행 권장 (타이머·잔디·등급은 한 번에 끝내야 회귀 줄어듦).
- M4·M5 는 **M3 이후 병렬** 가능.

## 리스크 및 대응

| 리스크 | 대응 |
|---|---|
| iOS 백그라운드 타이머 30분 제한 | 앱 복귀 시 실제 경과 재계산 + 30분 이상 공백 감지 시 세션 자동 종료 제안 |
| 카카오 API 쿼터 초과 | 네이버 우선 사용 + 검색 결과 Postgres 캐시 (`Book.isbn13`) |
| Apple 심사 시 소셜 로그인 정책 | Apple Sign In 최우선 구현 + 계정 삭제 엔드포인트 `DELETE /me` 포함 |
| 동시 세션 생성 레이스 | `ReadingSession` 에 UNIQUE partial index (`user_id WHERE ended_at IS NULL`) |
| 푸시 토큰 만료 누수 | `DeviceToken.last_seen_at` 갱신 + 30일 미수신 토큰 비활성화 배치 |

## 아이디어 백로그 동기화

각 마일스톤 완료 시 `docs/backlog/IDEAS.md` 의 관련 항목을 리뷰하여:
- 구현 완료된 것은 `[x]` 로 표시
- 다음 마일스톤으로 이동할 것은 라벨 변경
- 폐기된 것은 취소선 + 사유

---

## Changelog

- **0.1.3** (2026-04-22) — **Kakao OAuth contract hotfix (post-M1).** `POST /auth/kakao` 가 `{ access_token }` 를 받도록 재조정. Kakao Flutter SDK 가 네이티브 iOS/Android 에서 authorization code 대신 access_token 을 반환하므로 백엔드의 token-exchange 스텝 제거, `GET /v2/user/me` 직접 호출. 에러 코드 `KAKAO_TOKEN_EXCHANGE_FAILED` · `KAKAO_TOKEN_MALFORMED` 삭제, `KAKAO_TOKEN_INVALID` (401/403) 신설. 계약 파괴적 변경이지만 프로덕션 클라이언트 0, 모바일도 동일 변경에 포함. 태그 `v0.0.2`.
- **0.1.0** (2026-04-20) — 초기 Phase 1 구현 계획. 6개 마일스톤 · 에이전트 분배 전략 포함.
- **0.1.2** (2026-04-20) — **Milestone 1 (Auth · 카카오/애플) 완료.** 태그 `v0.0.1-m1`.
  - Backend: 8 커밋, 65 테스트(59 pass + 6 postgres-integration skip). User·DeviceToken 모델, Port/Adapter 엄수, Kakao OAuth + Apple Sign-In (JWT + JWKS 캐시), AuthService, `/auth/*` · `/me` · `DELETE /me`, `get_current_user` 의존성, soft-delete 지원.
  - Mobile: 9 커밋, 29 테스트. Auth feature 레이어, kakao_flutter_sdk_user + sign_in_with_apple 네이티브 연동, Dio Auth/Refresh 인터셉터(401 큐잉·자동 리프레시), AuthNotifier 상태 머신, 세션 복구, Airbnb 톤 로그인 화면, go_router 인증 가드.
  - 디자인 시스템 반복: Claude → Apple → Airbnb (2030 여성 타겟 반영). 네이밍 중립화(AppPalette) 로 향후 교체 1-파일 수정.
  - Follow-up: Kakao `code` ↔ `access_token` contract 재조정 필요 (backlog 참조).
- **0.1.1** (2026-04-20) — **Milestone 0 (스캐폴딩 · 인프라 기반) 완료.** 태그 `v0.0.0-scaffold`.
  - 모노레포 레이아웃 (backend / mobile / docs / .github)
  - FastAPI 스켈레톤 + Alembic 초기화 + core 공용 계층 (http client · R2 storage · JWT · 예외 · 이벤트 버스)
  - Flutter 스켈레톤 (Riverpod · go_router · freezed · dio · flutter_secure_storage)
  - Claude (Anthropic) 디자인 시스템 Flutter 테마 적용 (Fraunces/Inter 타이포, 5등급 시맨틱 컬러)
  - Docker Compose 로컬 개발 환경 (api · postgres:16-alpine · redis:7-alpine · minio + minio-init)
  - GitHub Actions CI (backend: ruff / mypy / pytest / docker build · mobile: format / analyze / test)
  - 품질 게이트 전부 green: backend pytest 12/12, mobile test 9/9.

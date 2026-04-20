---
title: Book Club — 독서 트래킹 & 책 기반 토론 앱 설계
version: 0.1.0
status: approved
author: sy
created: 2026-04-20
updated: 2026-04-20
---

# Book Club — 설계 문서

## 1. 컨셉

나이키 런클럽의 독서 버전. 사용자는 자신이 읽은 책과 독서 시간을 기록하고,
동일한 책을 읽은 사용자들과 책 단위의 피드에서 감상을 나눈다.

### 1.1 핵심 가치

- **기록**: 독서 시간을 타이머로 측정하여 공식 기록으로 남긴다.
- **성장**: GitHub 잔디 형태의 일별 독서 히트맵과 5단계 등급 체계로 동기부여.
- **대화**: 같은 책을 읽은 사용자들이 책 단위의 피드에서 대화한다.

## 2. 타겟 & 범위

### 2.1 타겟 사용자

한국어 사용자, 모바일 중심(iOS + Android). 독서 습관 형성과 기록 공유에 관심 있는 이용자.

### 2.2 MVP 범위 (Phase 1)

- 카카오 / 애플 소셜 로그인
- 네이버 책 검색 API 기반 책 등록 (카카오 폴백)
- 독서 타이머 + 수동 독서 로그
- 잔디 히트맵
- 5단계 등급 + 등급별 테마 색
- 독서 목표 설정(주/월/연), 별점 + 한줄 리뷰, 연속 독서 스트릭, 주간 리포트
- 책 그룹 피드: 포스트(하이라이트 / 감상 / 질문 / 토론 주제) + 이모지 리액션 + 댓글

### 2.3 Phase 2 이후 후보

팔로우 / DM 등 풀 소셜 그래프, 하이라이트·메모 공유, 챌린지, 배지, 추천, 위시리스트,
오프라인 독서 클럽 개설. 세부는 Phase 1 완료 시점에 백로그에서 재선정.

## 3. 기술 스택

### 3.1 확정 스택

| 영역 | 선택 | 이유 |
|---|---|---|
| 모바일 | Flutter | iOS + Android 단일 코드베이스, 한국 개발자 생태계 성숙 |
| 백엔드 | FastAPI + Postgres | 옆 astrology 프로젝트와 스택 통일, 도메인 로직 자유도 |
| 캐시 / 큐 | Redis | 리더보드, 실시간 리액션 카운트, FCM 토큰, 내부 이벤트 버스 |
| 스토리지 | Cloudflare R2 (S3 호환) | 무료 egress, 책 표지·프로필 이미지 트래픽에 유리 |
| 인증 | 카카오 OAuth + Apple Sign In | 한국 사용자 진입 장벽 최소화, iOS 심사 정책 준수 |
| 외부 데이터 | 네이버 책 검색 API + 카카오 책 API 폴백 | 국내 서적 커버리지 |
| 푸시 | FCM (+ APNS via FCM) | 크로스 플랫폼 단일 파이프라인 |

### 3.2 Flutter 상세

- 상태관리: Riverpod
- 라우팅: go_router
- 모델: freezed + json_serializable
- HTTP: dio + retrofit
- 백그라운드 타이머: `flutter_background_service`(Android foreground) + iOS `BGTaskScheduler`

## 4. 아키텍처

### 4.1 전체 구조

```
Flutter App (iOS + Android)
        │ HTTPS / JWT
        ▼
FastAPI (모듈러 모놀리스 · 3-Layer · Port/Adapter)
        │
  ┌─────┼─────────────────────────────────────┐
  ▼     ▼         ▼             ▼             ▼
Postgres  Redis  R2 Storage  FCM/APNS  외부 API
                                       (네이버·카카오·Apple)
```

### 4.2 레이어 규칙 (3-Layer)

| 레이어 | 책임 | 금지 |
|---|---|---|
| Router | HTTP 요청·응답, DTO 변환, 인증 의존성 | 비즈니스 로직, DB·외부 호출 |
| Service | 도메인 로직, 트랜잭션 경계, 도메인 간 오케스트레이션 | HTTP/FastAPI 의존성 |
| Repository | DB 쿼리, 세션 관리 | 비즈니스 규칙, 외부 HTTP 호출 |

### 4.3 Port/Adapter (외부 경계)

도메인은 외부 구체 구현이 아닌 **Port(Protocol)** 에만 의존한다.
외부 연동(책 검색, OAuth, FCM, R2)은 모두 어댑터로 분리된다.

```
domains/<domain>/
  router.py           # (driving adapter)
  service.py          # ports.py 의 Protocol 에만 의존
  ports.py            # 도메인이 필요로 하는 것을 선언
  repository.py       # (driven adapter) DB
  adapters/           # (driven adapter) 외부 HTTP·SDK
  models.py           # SQLAlchemy (repository 내부에서만)
  schemas.py          # Pydantic DTO (router 경계)
```

단순 CRUD 도메인은 Repository Port ↔ 구현 1:1 유지. 복수 구현이 예상되는
**외부 연동만 엄격히 Port 규칙** 을 지킨다(과설계 방지).

### 4.4 도메인 구성

- `auth` — 사용자, 소셜 로그인, JWT, 디바이스 토큰
- `book` — 전역 책 카탈로그, 사용자 서재(UserBook), 외부 책 검색
- `reading` — 독서 세션(타이머·수동), 잔디, 등급, 목표, 스트릭
- `feed` — 책 그룹 포스트, 리액션, 댓글
- `notification` — 인앱 알림, 푸시, 주간 리포트

### 4.5 도메인 간 통신

- 동기: Service → 다른 도메인 Service 직접 호출 (모놀리스)
- 비동기: 내부 이벤트 버스 (Redis Pub/Sub 또는 SQLAlchemy after_commit 훅 중 선택; 구현 시 확정)
  - 예: 독서 세션 종료 → 등급 재계산 + 스트릭 갱신 + 주간 리포트 데이터 적재

## 5. 핵심 도메인 모델 (요약)

세부 컬럼 및 인덱스는 구현 단계에서 마이그레이션과 함께 확정한다.

- **User** (auth): provider(kakao|apple), provider_sub, email, nickname
- **Book** (book): isbn13, title, author, publisher, cover_url, source
- **UserBook** (book): user×book, status(reading|completed|paused|dropped), rating, one_line_review
- **ReadingSession** (reading): user×user_book, started_at, ended_at, duration_sec, source(timer|manual)
- **DailyReadingStat** (reading): 잔디용 (user_id, date) 집계 테이블
- **UserGrade** (reading): 현재 등급 스냅샷 (total_books, total_seconds, streak_days)
- **Goal** (reading): period(weekly|monthly|yearly), target_books, target_seconds
- **Post** (feed): book_id, user_id, post_type(highlight|thought|question|discussion), content
- **Reaction** (feed): post×user×type (idea|fire|think|clap|heart)
- **Comment** (feed): post_id, parent_id(1단계 답글까지), content
- **Notification / WeeklyReport** (notification)

### 5.1 핵심 정책

- **공식 기록:** `ReadingSession.source = timer` 만 등급·잔디·리더보드에 반영.
  `source = manual` 은 개인 로그와 권수 카운트에만 사용.
- **등급 판정:** 5단계, 총 권수 AND 총 시간 **둘 다** 임계치 도달 시 승급.
  새싹 독자 / 탐독자 / 애독자 / 열혈 독자 / 서재 마스터.
- **책 그룹 = book_id**: 별도 테이블 없이 동일 책 = 동일 그룹.
- **리액션:** 같은 타입 중복 금지, 다른 타입 동시 허용.

### 5.2 등급 테마

| 등급 | 이름 | 임계 (초기값 · 튜닝 대상) | 테마 색 |
|---|---|---|---|
| 1 | 새싹 독자 | 기본 | 라이트 그린 |
| 2 | 탐독자 | 3권 + 10h | 에메랄드 |
| 3 | 애독자 | 10권 + 50h | 블루 |
| 4 | 열혈 독자 | 30권 + 150h | 퍼플 |
| 5 | 서재 마스터 | 100권 + 500h | 골드 |

## 6. 프론트엔드 구조

```
lib/
  core/        # theme, router, dio, exceptions, riverpod di
  features/    # 백엔드 도메인과 1:1
    auth/ book/ reading/ feed/ notification/
  shared/      # 공용 위젯, 유틸
```

등급별 `ColorScheme` 5종을 타이머 화면 / 진행 링 / 프로필 배지에 반영.

## 7. 인프라 & 운영

### 7.1 환경

- 로컬: Docker Compose (fastapi · postgres · redis · MinIO — R2 로컬 대체)
- 스테이징·베타: Fly.io (FastAPI) + Neon (Postgres) + Upstash Redis + Cloudflare R2
- 모바일 배포: TestFlight / Play 내부 테스트 트랙 (Fastlane 또는 Codemagic)

### 7.2 CI / CD

- GitHub Actions: lint(ruff) → type(mypy) → test(pytest) → Docker 빌드 → 배포
- 모바일 CI: dart analyze / flutter test / 빌드 아티팩트 업로드

### 7.3 모니터링

- Sentry: 크래시·에러
- 구조화 로깅(JSON)
- Grafana Cloud 무료 티어(베타 규모 기준)

## 8. 테스트 전략

### 8.1 백엔드

- **단위 (Service)**: Port 에 Fake 주입, DB 없음. 도메인 로직 중심.
- **통합 (Repository / Router)**: testcontainers Postgres + pytest-asyncio.
- **외부 어댑터 계약 테스트**: 네이버 / 카카오 API 응답 픽스처 스냅샷.

### 8.2 프론트

- Widget 테스트: 주요 화면·상태 전환
- Integration 테스트: 타이머 플로우, 로그인 플로우

### 8.3 정책

- 커버리지 수치 강제 X
- **도메인 서비스는 단위 테스트 필수**

## 9. 레포 구조

```
book_club/
  backend/            # FastAPI
  mobile/             # Flutter
  docs/
    plans/            # 설계 문서
    backlog/          # 아이디어 백로그
  .github/workflows/
  CLAUDE.md
```

## 10. 버저닝 정책

### 10.1 애플리케이션 버전

- 앱스토어 출시 **전**: `0.0.X` — PATCH 자리만 증가
  - `0.0.1` = Phase 1(MVP) 완료 및 첫 스테이징 배포
  - 이후 의미 있는 기능 머지 + 스테이징 배포 시 PATCH 증가
- 앱스토어 **출시 시** `0.1.0` 으로 승격
- 이후 시맨틱 버저닝 (MAJOR / MINOR / PATCH)
- 증가 트리거: **스테이징/프로덕션 배포 태그 시점**
- 로컬 / 개발 중 버전에는 `-dev` 접미사 사용

### 10.2 문서 버전

각 설계 문서 상단 frontmatter 의 `version`, 본문 마지막 `## Changelog` 에 변경 기록.
오탈자·포맷팅 수정은 버전 증가 대상 아님.

## 11. 백로그 & 아이디어 프로세스

작업 중 떠오른 개선 아이디어는 현재 작업을 중단하지 않고 `docs/backlog/IDEAS.md` 에 기록한 뒤 원래 작업으로 복귀한다. Phase 범위 밖의 기능을 즉시 구현하지 않는다.
각 Phase 시작 전에는 반드시 `docs/backlog/IDEAS.md` 를 리뷰하여 다음 Phase 범위에 편입할 항목을 선별한다.

---

## Changelog

- **0.1.0** (2026-04-20) — 초기 설계 문서 작성. MVP 범위 · 스택 · 아키텍처 · 도메인 모델 · 버저닝·백로그 프로세스 확정.

# Fly.io 시크릿 관리 가이드

Book Club 백엔드를 Fly.io 에 배포할 때 필요한 시크릿(secret)·환경변수 관리 방법을 정리한다.
`deploy.yml` 워크플로(M58)와 프로덕션 앱 설정(M59)의 전제 문서다.

> **원칙 (CLAUDE.md §9)**: 시크릿은 `.env` + Fly.io secrets 로만 관리하고 레포에 커밋하지 않는다.
> `backend/fly.toml` 에는 비밀이 아닌 값(앱 이름, 리전, 포트)만 둔다.

---

## 1. 시크릿이 동작하는 방식

- `flyctl secrets set` 으로 설정한 값은 **암호화되어 저장**되고, 런타임에 머신의 환경변수로 주입된다.
- 백엔드는 `app/core/config.py` 의 pydantic-settings 가 환경변수를 읽는다(대소문자 무시).
  예) `JWT_SECRET` 환경변수 → `settings.jwt_secret`.
- 시크릿을 바꾸면 Fly 가 자동으로 머신을 롤링 재시작한다.

---

## 2. GitHub Actions 에 필요한 시크릿

`deploy.yml` 은 단 하나의 레포 시크릿만 사용한다.

| 시크릿 | 용도 | 발급 방법 |
|---|---|---|
| `FLY_API_TOKEN` | GitHub Actions 가 `flyctl deploy` 를 실행할 권한 | `flyctl tokens create deploy -a book-club-api` |

설정 위치: GitHub 레포 → **Settings → Secrets and variables → Actions → New repository secret**.

```bash
# 토큰 발급 (배포 전용, 최소 권한 토큰 권장)
flyctl tokens create deploy -a book-club-api
# 출력된 값을 GitHub 레포 시크릿 FLY_API_TOKEN 에 등록
```

---

## 3. Fly 앱에 설정할 백엔드 시크릿

아래 값은 `flyctl secrets set KEY=value -a book-club-api` 로 설정한다.
기본값이 있는 항목이라도 **프로덕션에서는 반드시 실제 값으로 덮어써야 한다**.

### 3.1 필수 (없으면 부팅/핵심 기능 실패)

| 환경변수 | 설명 | 출처 |
|---|---|---|
| `ENV` | 실행 환경. 프로덕션은 `prod` | — |
| `DATABASE_URL` | Postgres 비동기 DSN (`postgresql+asyncpg://...`) | Fly Postgres / Neon |
| `REDIS_URL` | Redis 연결 문자열 | Upstash / Fly Redis |
| `JWT_SECRET` | JWT 서명 키. **강한 난수 필수** | `openssl rand -hex 32` |

### 3.2 오브젝트 스토리지 (Cloudflare R2, M59)

| 환경변수 | 설명 |
|---|---|
| `S3_ENDPOINT_URL` | R2 S3 호환 엔드포인트 (`https://<account>.r2.cloudflarestorage.com`) |
| `S3_PUBLIC_ENDPOINT_URL` | 공개 읽기용 커스텀 도메인 / r2.dev URL |
| `S3_BUCKET` | 프로덕션 버킷 이름 |
| `S3_ACCESS_KEY` | R2 API 토큰 Access Key ID |
| `S3_SECRET_KEY` | R2 API 토큰 Secret Access Key |
| `S3_REGION` | `auto` (R2 기본) |

### 3.3 외부 API · 소셜 로그인

| 환경변수 | 설명 | 출처 |
|---|---|---|
| `KAKAO_REST_API_KEY` | 카카오 책 API(폴백) REST 키 | developers.kakao.com |
| `NAVER_CLIENT_ID` | 네이버 책 API 클라이언트 ID | developers.naver.com |
| `NAVER_CLIENT_SECRET` | 네이버 책 API 시크릿 | developers.naver.com |
| `APPLE_CLIENT_ID` | Apple Sign In 번들/서비스 ID | Apple Developer |

### 3.4 푸시 · 모니터링 · 운영

| 환경변수 | 설명 |
|---|---|
| `FIREBASE_CREDENTIALS_JSON` | FCM 서비스 계정 JSON 전체 (한 줄 문자열) |
| `FIREBASE_PROJECT_ID` | Firebase 프로젝트 ID |
| `SENTRY_DSN` | Sentry 프로덕션 DSN. 설정 시에만 Sentry 활성화 |
| `ADMIN_KEY` | 관리자 전용 엔드포인트 보호 키 |
| `CORS_ALLOW_ORIGINS` | 허용 오리진(JSON 배열). 앱 클라이언트만 호출하면 생략 가능 |

---

## 4. 일괄 설정 예시

여러 값을 한 번에 설정하면 머신 재시작도 한 번만 일어난다.

```bash
flyctl secrets set -a book-club-api \
  ENV=prod \
  DATABASE_URL='postgresql+asyncpg://user:pass@host:5432/bookclub' \
  REDIS_URL='redis://default:pass@host:6379/0' \
  JWT_SECRET="$(openssl rand -hex 32)" \
  S3_ENDPOINT_URL='https://<account>.r2.cloudflarestorage.com' \
  S3_PUBLIC_ENDPOINT_URL='https://cdn.bookclub.app' \
  S3_BUCKET='bookclub-prod' \
  S3_ACCESS_KEY='...' \
  S3_SECRET_KEY='...' \
  S3_REGION='auto' \
  KAKAO_REST_API_KEY='...' \
  NAVER_CLIENT_ID='...' \
  NAVER_CLIENT_SECRET='...' \
  APPLE_CLIENT_ID='kr.mission-driven.bookclub' \
  FIREBASE_PROJECT_ID='book-club-prod' \
  SENTRY_DSN='https://...@o0.ingest.sentry.io/0' \
  ADMIN_KEY="$(openssl rand -hex 16)"
```

FCM 자격증명처럼 큰 JSON 은 파일에서 직접 읽어 설정한다.

```bash
flyctl secrets set -a book-club-api \
  FIREBASE_CREDENTIALS_JSON="$(cat firebase-service-account.json)"
```

---

## 5. 운영 명령 요약

```bash
# 설정된 시크릿 이름 목록 (값은 표시되지 않음)
flyctl secrets list -a book-club-api

# 시크릿 제거
flyctl secrets unset OLD_KEY -a book-club-api

# 시크릿 변경 후 재배포 없이 머신만 재시작 (set/unset 시 자동 수행됨)
flyctl apps restart book-club-api
```

---

## 6. 마이그레이션 주의

DB 스키마 변경은 `backend/fly.toml` 의 `release_command = "alembic upgrade head"` 가
각 배포마다 자동 실행한다. 따라서 `deploy.yml` 워크플로에서 별도로 마이그레이션을 돌리지 않는다.
`release_command` 가 실패하면 새 릴리스는 트래픽을 받지 않고 롤백되므로,
마이그레이션은 항상 앱과 동일한 시크릿/네트워크 컨텍스트에서 실행된다.

---

## 7. 체크리스트

배포 전 다음을 확인한다.

- [ ] `FLY_API_TOKEN` 이 GitHub 레포 시크릿에 등록되어 있다.
- [ ] §3.1 필수 4종이 `flyctl secrets list` 에 보인다.
- [ ] `JWT_SECRET` 이 기본값이 아닌 강한 난수다.
- [ ] `ENV=prod` 로 설정되어 있다.
- [ ] R2 / FCM / Sentry 자격증명이 설정되어 있다(M59 범위).

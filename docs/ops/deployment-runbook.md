# 프로덕션 배포 런북 (Fly.io)

Book Club 백엔드(FastAPI)를 Fly.io 에 **처음 배포**하거나 **재배포·롤백**할 때
따라가는 단계별 가이드. 명령은 모두 `backend/` 디렉토리에서 실행하는 것을 전제로 한다
(`fly.toml` 이 그곳에 있다).

> 관련 문서
> - 시크릿 인벤토리: [`fly-secrets.md`](./fly-secrets.md)
> - R2 버킷 설정: [`r2-setup.md`](./r2-setup.md)
> - 앱 설정: [`../../backend/fly.toml`](../../backend/fly.toml)
> - CI 자동 배포: `.github/workflows/deploy.yml` (M58)

---

## 0. 사전 요건

- [ ] `flyctl` 설치 — `brew install flyctl` (macOS) 또는 `curl -L https://fly.io/install.sh | sh`
- [ ] Fly 로그인 — `fly auth login` (브라우저 인증)
- [ ] 조직 권한 확인 — `fly orgs list` 에 배포 대상 조직이 보일 것
- [ ] Postgres / Redis 매니지드 인스턴스 준비 (Fly Postgres·Neon / Upstash 등) — DSN 확보
- [ ] Cloudflare R2 버킷 생성 완료 ([`r2-setup.md`](./r2-setup.md) 참조) — `S3_*` 자격증명 확보
- [ ] Sentry 프로젝트 생성 → `SENTRY_DSN` 확보 (선택, 강력 권장)
- [ ] FCM 서비스 계정 JSON 확보 (`FIREBASE_CREDENTIALS_JSON`)

> ⚠️ 자격증명이 없으면 1~3 단계까지만 수행 가능. 실제 `fly deploy` 는
> §3.1 필수 시크릿 4종이 설정된 뒤에만 성공한다.

---

## 1. Fly 앱 생성 (최초 1회)

```bash
# 앱 이름은 fly.toml 의 app = "book-club-api" 와 일치해야 한다.
fly apps create book-club-api
```

이미 존재하면 `Error: app already exists` 가 뜨므로 건너뛴다.
앱 이름을 바꾸려면 `backend/fly.toml` 의 `app` 값을 먼저 수정한다.

---

## 2. 시크릿 설정

자세한 목록·발급법은 [`fly-secrets.md`](./fly-secrets.md). 한 번에 설정하면
머신 재시작도 한 번만 일어난다.

```bash
fly secrets set -a book-club-api \
  ENV=prod \
  DATABASE_URL='postgresql+asyncpg://user:pass@host:5432/bookclub' \
  REDIS_URL='redis://default:pass@host:6379/0' \
  JWT_SECRET="$(openssl rand -hex 32)" \
  S3_ENDPOINT_URL='https://<account>.r2.cloudflarestorage.com' \
  S3_PUBLIC_ENDPOINT_URL='https://cdn.bookclub.app' \
  S3_BUCKET='book-club-prod' \
  S3_ACCESS_KEY='...' S3_SECRET_KEY='...' S3_REGION='auto' \
  NAVER_CLIENT_ID='...' NAVER_CLIENT_SECRET='...' \
  KAKAO_REST_API_KEY='...' \
  APPLE_CLIENT_ID='kr.mission-driven.bookclub' \
  FIREBASE_PROJECT_ID='book-club-prod' \
  SENTRY_DSN='https://...@o0.ingest.sentry.io/0' \
  ADMIN_KEY="$(openssl rand -hex 16)"

# 큰 JSON 은 파일에서 직접 주입
fly secrets set -a book-club-api \
  FIREBASE_CREDENTIALS_JSON="$(cat firebase-service-account.json)"
```

설정 확인 (값은 표시되지 않고 이름·다이제스트만 보인다):

```bash
fly secrets list -a book-club-api
```

체크: `ENV / DATABASE_URL / REDIS_URL / JWT_SECRET` 4종이 보여야 첫 배포가 부팅된다.

---

## 3. 첫 배포

```bash
# 원격 빌더에서 Dockerfile(production 타깃) 빌드 후 배포.
fly deploy --remote-only
```

배포 흐름:

1. 원격 빌더가 `backend/Dockerfile` 의 `production` 스테이지를 빌드.
2. `fly.toml` 의 `release_command = "alembic upgrade head"` 가 **트래픽 전에** 1회 실행.
   - 마이그레이션 실패 시 새 릴리스는 트래픽을 받지 못하고 자동 롤백된다.
3. 새 머신이 뜨고 `/health/ready` 체크(grace 30s)를 통과하면 트래픽 전환.

> CI(`deploy.yml`)는 `main` 머지 시 `FLY_API_TOKEN` 으로 같은 배포를 자동 실행한다.
> 수동 배포는 핫픽스·최초 부트스트랩 용도로 사용한다.

---

## 4. 배포 검증

### 4.1 마이그레이션 상태

```bash
fly ssh console -a book-club-api -C "alembic current"
# 출력의 리비전이 로컬 `alembic heads` 와 일치하는지 확인
```

### 4.2 헬스체크

```bash
# 라이브니스 (프로세스 생존)
curl -fsS https://book-club-api.fly.dev/health
# → {"status":"ok","version":"0.9.x"}

# 레디니스 (DB 연결 포함) — 200 + db:ok 여야 정상
curl -fsS https://book-club-api.fly.dev/health/ready
# → {"status":"ok","db":"ok","version":"0.9.x"}
# DB 미연결 시 503 + {"status":"degraded","db":"error",...}
```

### 4.3 머신·로그 상태

```bash
fly status -a book-club-api          # 머신 health 가 passing 인지
fly logs -a book-club-api            # 부팅 로그·스택트레이스 확인
```

---

## 5. 모니터링 초기 확인

### 5.1 Sentry

- `SENTRY_DSN` 이 설정된 경우에만 SDK 가 활성화된다 (코드: `app/main.py` 의 `_init_sentry`,
  `traces_sample_rate=0.1`).
- 확인: Sentry 프로젝트 대시보드에 첫 배포 release 가 잡히는지, 강제 에러 발생 시
  이벤트가 들어오는지. (강제 에러는 스테이징에서만 수행)

### 5.2 Grafana / Prometheus

- 앱은 `prometheus-fastapi-instrumentator` 로 `/metrics` 를 노출한다
  (`app/main.py`). Prometheus 가 이를 스크레이프한다.
  로컬 스택은 `docker-compose.yml` 의 `prometheus`/`grafana` 서비스 참조.
- 초기 확인 지표:
  - **요청률·5xx 비율** — 배포 직후 5xx 스파이크 없는지
  - **레이턴시 p50/p95** — 평소 baseline 대비
  - **DB 커넥션 풀** — `/health/ready` 가 지속적으로 200 인지
- 프로덕션 Grafana 대시보드 프로비저닝은 인프라 레포/후속 작업 범위.

---

## 6. 롤백

새 릴리스에 문제가 있으면 직전 이미지로 즉시 되돌린다.

```bash
# 1) 릴리스 이력 확인 — 직전 정상 버전·이미지 식별
fly releases list -a book-club-api

# 2) 직전 이미지로 재배포
fly deploy -a book-club-api --image <previous-image-ref>

# (대안) 버전 번호로 롤백
fly releases rollback <version> -a book-club-api
```

주의: 마이그레이션이 **파괴적**(컬럼 drop 등)이었다면 코드 롤백만으로는 부족하다.
이 경우 다운 마이그레이션 또는 hotfix 전진 배포를 우선 검토한다.

---

## 7. 배포 체크리스트

- [ ] §0 사전 요건 충족 (flyctl·로그인·DSN·R2)
- [ ] `fly secrets list` 에 필수 시크릿 표시
- [ ] `fly deploy --remote-only` 성공, `release_command` 통과
- [ ] `alembic current` 가 최신 head
- [ ] `/health` 200, `/health/ready` 200 (`db:ok`)
- [ ] `fly status` 머신 health passing
- [ ] Sentry 에 release 잡힘 (DSN 설정 시)
- [ ] 롤백 절차(직전 이미지 ref) 메모해둠

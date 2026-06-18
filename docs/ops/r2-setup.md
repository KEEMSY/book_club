# Cloudflare R2 프로덕션 설정 가이드

Book Club 의 이미지·파일 업로드(프로필, 책 표지 캐시 등)는 S3 호환 오브젝트
스토리지를 쓴다. 로컬은 MinIO(`docker-compose.yml`), 프로덕션은 **Cloudflare R2**.
이 문서는 프로덕션 R2 버킷을 준비하고 Fly 시크릿에 연결하는 절차를 정리한다.

> 코드 연동점: `backend/app/core/config.py` 의 `S3_*` 설정값
> (`s3_endpoint_url`, `s3_public_endpoint_url`, `s3_bucket`, `s3_access_key`,
> `s3_secret_key`, `s3_region`). 시크릿 등록은 [`fly-secrets.md`](./fly-secrets.md) §3.2.

---

## 1. 버킷 생성

Cloudflare 대시보드 → **R2 → Create bucket**.

- 이름: `book-club-prod`
- 위치(Location hint): **APAC** (한국 사용자 기준)
- 생성 후 **Settings** 에서 S3 API 엔드포인트 확인:
  `https://<account_id>.r2.cloudflarestorage.com`

> 개발/스테이징은 `book-club-dev` / `book-club-staging` 로 분리해 프로덕션
> 데이터와 절대 섞지 않는다.

---

## 2. 공개 읽기 도메인

업로드된 객체를 앱이 읽으려면 공개 URL 이 필요하다. 두 방법 중 택1.

- **권장 — 커스텀 도메인**: R2 버킷 → **Settings → Public access → Custom Domains**
  에서 `cdn.bookclub.app` 연결. Cloudflare DNS 가 자동으로 인증서를 발급한다.
  → `S3_PUBLIC_ENDPOINT_URL=https://cdn.bookclub.app`
- **간이 — r2.dev**: 버킷의 `r2.dev` 개발 URL 을 활성화.
  → `S3_PUBLIC_ENDPOINT_URL=https://pub-xxxx.r2.dev` (운영 트래픽엔 비권장)

`S3_ENDPOINT_URL` 은 쓰기(presign PUT)용 S3 API 엔드포인트, `S3_PUBLIC_ENDPOINT_URL`
은 읽기용 공개 도메인이다. 코드상 후자가 비면 전자로 폴백한다
(`config.py: s3_presign_endpoint_url`).

---

## 3. CORS 정책

Flutter 앱(웹/네이티브) 또는 presigned URL 로 브라우저가 직접 업로드/조회할 때만
필요. 네이티브 전용이면 생략 가능하나, 웹 빌드를 고려해 설정해두길 권장.

R2 버킷 → **Settings → CORS Policy** 에 등록:

```json
[
  {
    "AllowedOrigins": [
      "https://bookclub.app",
      "https://app.bookclub.app",
      "capacitor://localhost",
      "http://localhost:*"
    ],
    "AllowedMethods": ["GET", "PUT", "HEAD"],
    "AllowedHeaders": ["*"],
    "ExposeHeaders": ["ETag"],
    "MaxAgeSeconds": 3600
  }
]
```

> `localhost` 항목은 개발 편의용. 프로덕션 버킷에서는 실제 앱 도메인만 남기는 것을
> 권장한다.

---

## 4. R2 API 토큰 발급

Cloudflare 대시보드 → **R2 → Manage R2 API Tokens → Create API Token**.

- Permissions: **Object Read & Write**
- 적용 범위(Bucket): `book-club-prod` 로 한정 (최소 권한)
- 발급 결과:
  - **Access Key ID** → `S3_ACCESS_KEY`
  - **Secret Access Key** → `S3_SECRET_KEY` (이 화면에서만 표시 — 즉시 보관)

R2 는 리전 개념이 없으므로 `S3_REGION=auto` 를 사용한다.

---

## 5. Fly 시크릿에 연결

```bash
fly secrets set -a book-club-api \
  S3_ENDPOINT_URL='https://<account_id>.r2.cloudflarestorage.com' \
  S3_PUBLIC_ENDPOINT_URL='https://cdn.bookclub.app' \
  S3_BUCKET='book-club-prod' \
  S3_ACCESS_KEY='<access-key-id>' \
  S3_SECRET_KEY='<secret-access-key>' \
  S3_REGION='auto'
```

---

## 6. 검증

```bash
# 자격증명·엔드포인트가 맞는지 awscli 로 확인 (R2 는 S3 호환)
aws s3 ls s3://book-club-prod \
  --endpoint-url "https://<account_id>.r2.cloudflarestorage.com"

# 앱 기동 후 업로드 플로(presign → PUT → 공개 URL GET)가 동작하는지
# 스테이징에서 1회 스모크 테스트
```

체크리스트:

- [ ] `book-club-prod` 버킷 생성, 위치 APAC
- [ ] 공개 도메인(`cdn.bookclub.app` 또는 r2.dev) 연결 → `S3_PUBLIC_ENDPOINT_URL`
- [ ] CORS 정책 등록(웹/브라우저 업로드 시)
- [ ] Object R/W API 토큰 발급 → `S3_ACCESS_KEY` / `S3_SECRET_KEY`
- [ ] Fly 시크릿 6종(`S3_*`) 설정 완료
- [ ] presign 업로드·공개 읽기 스모크 테스트 통과

# 앱 배포 시크릿 가이드 (웹 · Android · iOS)

Book Club **클라이언트**(Flutter 웹/모바일)를 배포할 때 GitHub Actions 가 사용하는
레포지토리 시크릿을 정리한다. 백엔드(Fly.io) 시크릿은 별도 문서
[`fly-secrets.md`](./fly-secrets.md) 가 담당한다.

> **원칙 (CLAUDE.md §9)**: 시크릿은 레포에 커밋하지 않는다. 모든 값은
> GitHub 레포 → **Settings → Secrets and variables → Actions → New repository secret**
> 에 등록한다. 키스토어·인증서·서비스계정 JSON 등 바이너리/멀티라인은 base64 로 인코딩해 넣는다.

## 워크플로별 시크릿 매핑

| 워크플로 | 대상 | 관련 티켓 |
|---|---|---|
| `.github/workflows/deploy-web.yml` | Flutter 웹 → Cloudflare Pages | BC-3 / BC-4 |
| `.github/workflows/mobile.yml` (`release-android`) | Android AAB → Play 내부 트랙 | BC-7 / BC-8 |
| `.github/workflows/mobile.yml` (`release-ios`) | iOS IPA → TestFlight | BC-7 / BC-9 |
| `.github/workflows/deploy.yml` | 백엔드 → Fly.io | (fly-secrets.md) |

> **공통 동작 원칙 — env-guard**: 모든 배포/업로드 스텝은 관련 시크릿이 **존재할 때만** 실행된다.
> 시크릿이 없으면 빌드·검증까지만 수행하고 배포/업로드는 스킵되어 CI 가 green 을 유지한다.
> 따라서 아래 시크릿을 **하나도 등록하지 않아도 파이프라인은 깨지지 않으며**, 등록하는 순간
> 해당 배포 경로가 활성화된다.

---

## 1. 웹 — Cloudflare Pages (BC-4)

`deploy-web.yml` 은 push-to-main 에서 `CLOUDFLARE_API_TOKEN` 이 설정돼 있을 때만
`wrangler pages deploy` 로 배포한다.

| 시크릿 | 용도 | 발급 방법 |
|---|---|---|
| `CLOUDFLARE_API_TOKEN` | Pages 배포 권한 | Cloudflare 대시보드 → My Profile → API Tokens → **Create Token** → "Edit Cloudflare Pages" 템플릿 |
| `CLOUDFLARE_ACCOUNT_ID` | 배포 대상 계정 | Cloudflare 대시보드 우측 사이드바 Account ID |
| `KAKAO_JAVASCRIPT_APP_KEY` | 웹 카카오 로그인의 OAuth `client_id`. 미설정 시 웹 로그인 KOE101 (BC-34) | 카카오 developers → 내 앱 → 앱 키 → **JavaScript 키** |

선행 조건: Cloudflare Pages 프로젝트 `book-club-web` 이 미리 생성돼 있어야 한다(BC-4).
카카오 로그인은 추가로 콘솔 플랫폼 설정이 필요하다 — [`kakao-login-setup.md`](./kakao-login-setup.md) 참조.

---

## 2. Android — 서명 + Play 업로드 (BC-8)

`mobile.yml` 의 `release-android` 잡. 키스토어가 있으면 AAB 를 서명하고, 서비스계정까지
있으면 Play 내부 테스트 트랙에 업로드한다.

| 시크릿 | 용도 | 발급/인코딩 방법 |
|---|---|---|
| `ANDROID_KEYSTORE_BASE64` | 업로드 키스토어(.jks) base64 | `base64 -i upload-keystore.jks \| pbcopy` (macOS) |
| `ANDROID_KEYSTORE_PASSWORD` | 키스토어 비밀번호 | 키스토어 생성 시 지정 |
| `ANDROID_KEY_ALIAS` | 키 별칭 | 키스토어 생성 시 지정 (예: `upload`) |
| `ANDROID_KEY_PASSWORD` | 키 비밀번호 | 키스토어 생성 시 지정 |
| `PLAY_SERVICE_ACCOUNT_JSON` | Play Developer API 서비스계정 JSON 원문 | Google Cloud Console → 서비스계정 → 키 생성(JSON), Play Console 에서 권한 부여 |

키스토어 생성 예시:

```bash
keytool -genkey -v -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Gradle 서명 config 는 `mobile/android/app/build.gradle.kts` 가 이미 env
(`KEYSTORE_PATH`/`KEYSTORE_PASSWORD`/`KEY_ALIAS`/`KEY_PASSWORD`) 로 읽는다.
CI 는 `ANDROID_KEYSTORE_BASE64` 를 디코드해 `KEYSTORE_PATH` 를 채운다.

**선행 조건**: Play Console 에 앱(`kr.missiondriven.bookclub`)이 존재하고
최소 1회 수동 업로드가 완료돼 있어야 한다(Play API 는 최초 버전을 생성하지 못함).

---

## 3. iOS — 서명 + TestFlight (BC-9)

`mobile.yml` 의 `release-ios` 잡. 배포 인증서가 있으면 서명된 IPA 를 export 하고,
App Store Connect API 키까지 있으면 TestFlight 에 업로드한다.

| 시크릿 | 용도 | 발급/인코딩 방법 |
|---|---|---|
| `IOS_DIST_CERT_BASE64` | Apple Distribution 인증서(.p12) base64 | Keychain 에서 인증서+개인키 export → `.p12` → `base64 -i dist.p12 \| pbcopy` |
| `IOS_DIST_CERT_PASSWORD` | .p12 export 비밀번호 | export 시 지정 |
| `IOS_PROVISIONING_PROFILE_BASE64` | App Store 배포 provisioning profile(.mobileprovision) base64 | Apple Developer → Profiles → 다운로드 → `base64 -i dist.mobileprovision \| pbcopy` |
| `IOS_PROVISIONING_PROFILE_NAME` | 프로파일 이름(ExportOptions 매핑용) | 프로파일 생성 시 지정한 이름 |
| `IOS_TEAM_ID` | Apple 개발자 팀 ID | Apple Developer → Membership → Team ID (10자 영숫자) |
| `APP_STORE_CONNECT_API_KEY_ID` | ASC API 키 ID | App Store Connect → Users and Access → Integrations → **App Store Connect API** |
| `APP_STORE_CONNECT_API_ISSUER_ID` | ASC API issuer ID | 위 화면 상단 Issuer ID |
| `APP_STORE_CONNECT_API_PRIVATE_KEY` | ASC API .p8 **원문**(base64 아님) | 키 생성 시 1회 다운로드되는 `AuthKey_XXXX.p8` 파일 내용 그대로 |

> `APP_STORE_CONNECT_API_PRIVATE_KEY` 는 멀티라인 PEM 원문을 그대로 붙여넣는다(GitHub 시크릿은 멀티라인 허용). base64 로 감싸지 않는다.

**선행 조건**: App Store Connect 에 앱 레코드가 존재하고, 배포 인증서·App Store 프로파일이 발급돼 있어야 한다.

---

## 4. 백엔드 — Fly.io

`deploy.yml` 은 `FLY_API_TOKEN` 하나만 사용한다. 백엔드 런타임 시크릿(DB/Redis/JWT/R2 등)
전체 인벤토리와 발급 방법은 [`fly-secrets.md`](./fly-secrets.md) 를 참조한다.

---

## 5. 전체 체크리스트

배포 트랙을 활성화하려면 대상별로 다음을 등록한다. **부분 등록도 안전**하다(미등록 경로는 스킵).

**웹 (BC-4)**
- [ ] `CLOUDFLARE_API_TOKEN`
- [ ] `CLOUDFLARE_ACCOUNT_ID`
- [ ] `KAKAO_JAVASCRIPT_APP_KEY` (웹 카카오 로그인)
- [ ] Cloudflare Pages 프로젝트 `book-club-web` 생성
- [ ] 카카오 콘솔 웹 플랫폼 도메인 등록 (kakao-login-setup.md)

**Android (BC-8)**
- [ ] `ANDROID_KEYSTORE_BASE64` / `ANDROID_KEYSTORE_PASSWORD` / `ANDROID_KEY_ALIAS` / `ANDROID_KEY_PASSWORD`
- [ ] `PLAY_SERVICE_ACCOUNT_JSON`
- [ ] Play Console 앱 최초 수동 업로드 완료

**iOS (BC-9)**
- [ ] `IOS_DIST_CERT_BASE64` / `IOS_DIST_CERT_PASSWORD`
- [ ] `IOS_PROVISIONING_PROFILE_BASE64` / `IOS_PROVISIONING_PROFILE_NAME` / `IOS_TEAM_ID`
- [ ] `APP_STORE_CONNECT_API_KEY_ID` / `APP_STORE_CONNECT_API_ISSUER_ID` / `APP_STORE_CONNECT_API_PRIVATE_KEY`
- [ ] App Store Connect 앱 레코드 + 배포 인증서·프로파일 발급

**백엔드**
- [ ] `FLY_API_TOKEN` (상세는 fly-secrets.md)

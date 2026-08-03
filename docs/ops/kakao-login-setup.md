# 카카오 로그인 설정 (KOE101 대응)

카카오 로그인이 아래 화면으로 막히면, **런타임이 보내는 식별자와 카카오 개발자 콘솔
등록 정보가 어긋난 것**이다. 콘솔 등록이 빠졌을 수도 있고 앱이 값을 잘못(또는 비워서)
보내고 있을 수도 있으니 양쪽을 다 본다 — 실제로 이 앱의 웹 KOE101 은 앱 코드가
`client_id` 를 빈 값으로 보낸 것이 1차 원인이었다(BC-26).

```
앱 관리자 설정 오류 (KOE101)
서비스 설정에 오류가 있어, 이용할 수 없습니다.
```

카카오는 `kauth.kakao.com/oauth/authorize` 요청의 `client_id` 와 플랫폼 식별자
(`android_key_hash` / `ios_bundle_id` / 웹 도메인)를 콘솔 등록값과 대조한다.
하나라도 불일치하면 KOE101 이다.

**가장 먼저 볼 것은 에러 화면 주소창의 `client_id=` 값이다** (§5). 리다이렉트 URI
불일치는 KOE101 이 아니라 KOE006 으로 나므로 의심 순서가 다르다.
실제 사고 기록은 [`kakao-login-koe101-postmortem.md`](./kakao-login-koe101-postmortem.md) 에 있다.

## 1. 이 앱이 보내는 값

| 플랫폼 | 콘솔에 등록해야 하는 값 | 코드상 출처 |
|---|---|---|
| Android | 패키지명 `kr.missiondriven.bookclub` | `mobile/android/app/build.gradle.kts` `applicationId` |
| Android | 키 해시 (디버그 + 릴리즈 각각) | `mobile/scripts/kakao_key_hash.sh` |
| iOS | 번들 ID `kr.mission-driven.bookclub` (하이픈 포함) | `ios/Runner.xcodeproj` `PRODUCT_BUNDLE_IDENTIFIER` |
| Web | JavaScript SDK 도메인 — `스키마 + 호스트 (+ 포트)`, 경로 없음 | 실행/배포 환경 (§2-1) |
| 공통 | 네이티브 앱 키 = `client_id` (iOS/Android) | `--dart-define=KAKAO_NATIVE_APP_KEY` |
| 공통 | JavaScript 키 = `client_id` (Web) | `--dart-define=KAKAO_JAVASCRIPT_APP_KEY` |

**Android 패키지명과 iOS 번들 ID 의 표기가 다르다.** Android `applicationId` 는
하이픈을 쓸 수 없어 `missiondriven` 으로 붙여 쓰고, iOS 는 `mission-driven` 을 유지한다.
콘솔에는 **두 값을 각각** 등록해야 한다.

## 2. 콘솔 체크리스트

developers.kakao.com → 내 애플리케이션 → 해당 앱:

1. **앱 설정 → 플랫폼 키 → JavaScript 키** (웹을 쓰는 경우)
   - [ ] **JavaScript SDK 도메인** 등록 — `스키마 + 호스트 (+ 포트)`, 경로는 넣지 않는다
     - 로컬: `http://localhost:8080` — `flutter run` 은 포트를 랜덤 배정하므로
       `--web-port=8080` 으로 **고정한 뒤** 그 값을 등록한다 (§4)
     - 배포: `https://book-club-web.pages.dev` (`deploy-web.yml` 의 `--project-name`)
     - `localhost` 와 `127.0.0.1` 은 서로 다른 도메인이다. 쓰는 쪽을 등록한다.
     - Cloudflare Pages 프리뷰 배포는 별도 서브도메인을 받는다. 와일드카드 지원이
       공식 문서에 명시돼 있지 않아, 프리뷰에서 로그인하려면 개별 등록이 필요할 수 있다.
   - [ ] **리다이렉트 URI** 등록 — 앱이 웹에서 보내는 `redirect_uri` 는 실제 URI 가 아니라
     문자열 `'JS-SDK'` (팝업 방식) 이므로 이 값이 검증에 쓰이지는 않는다. 다만 콘솔에서
     필수 필드로 요구하는 경우가 있어 위 도메인과 같은 값을 넣어둔다.
   - 네이티브(Android/iOS)는 SDK 가 커스텀 스킴 `kakao<네이티브앱키>://oauth` 를 쓰며
     (`KakaoSdk.redirectUri`), 이 필드가 아니라 아래 4·5 의 플랫폼 등록으로 검증된다.
2. **제품 설정 → 카카오 로그인**
   - [ ] 활성화 스위치 **ON** (OFF 면 KOE101 / KOE004)
3. **제품 설정 → 카카오 로그인 → 동의항목**
   - [ ] 닉네임 / 프로필 사진 — 필수 또는 선택 동의
   - [ ] 이메일 — 선택 동의 (백엔드는 `email` null 을 허용한다)
4. **앱 설정 → 플랫폼 → Android**
   - [ ] 패키지명 `kr.missiondriven.bookclub`
   - [ ] 디버그 키 해시, 릴리즈 키 해시 (§3)
5. **앱 설정 → 플랫폼 → iOS**
   - [ ] 번들 ID `kr.mission-driven.bookclub`
6. **앱 설정 → 앱 키 (플랫폼 키)**
   - [ ] 네이티브 앱 키가 `KAKAO_NATIVE_APP_KEY` 와 일치 (iOS/Android 의 `client_id`)
   - [ ] JavaScript 키가 `KAKAO_JAVASCRIPT_APP_KEY` 와 일치 (웹의 `client_id`)
   - REST API 키는 로그인에 쓰이지 않는다 — 책 검색 폴백용(`KAKAO_REST_API_KEY`)이다.

## 3. Android 키 해시 산출

```bash
# 디버그 keystore (~/.android/debug.keystore)
./mobile/scripts/kakao_key_hash.sh

# 릴리즈 keystore
./mobile/scripts/kakao_key_hash.sh /path/to/release.keystore <alias>
```

디버그와 릴리즈 해시는 서로 다르다. **둘 다 등록**해야 디버그 빌드와 스토어 빌드가
모두 동작한다. Play App Signing 을 쓰면 Play Console 이 재서명한 인증서의 해시도
등록해야 한다 (Play Console → 앱 무결성 → 앱 서명 키 인증서의 SHA-1 을 base64 로 변환).

```bash
# Play Console 이 제공하는 SHA-1 (콜론 표기) → 카카오 키 해시
echo "AB:CD:..." | xxd -r -p | openssl base64
```

## 4. 빌드 시 키 주입

```bash
# 로컬 (네이티브 키는 소스에 기본값이 박혀 있어 생략 가능)
flutter run

# 웹 — JavaScript 키가 없으면 client_id 가 비어 KOE101 이 난다.
# 포트를 고정하지 않으면 랜덤 배정되어 등록 도메인과 어긋난다.
flutter run -d chrome --web-port=8080 \
  --dart-define=KAKAO_JAVASCRIPT_APP_KEY=<js_key>

# 릴리즈
flutter build appbundle \
  --dart-define=KAKAO_NATIVE_APP_KEY=<native_key> \
  --dart-define=KAKAO_JAVASCRIPT_APP_KEY=<js_key>
```

Android 매니페스트의 OAuth 리다이렉트 스킴(`kakao<네이티브앱키>`)은 Gradle
`manifestPlaceholders` 로 치환된다. 릴리즈 빌드에서 네이티브 키를 바꿨다면
`-PkakaoNativeAppKey=<native_key>` 도 함께 넘겨야 스킴이 어긋나지 않는다.

`KAKAO_JAVASCRIPT_APP_KEY` 를 생략하면 `KAKAO_MAP_KEY` 값을 대신 사용한다.
지도 기능과 같은 카카오 앱의 JavaScript 키이므로 값이 같다.

**`dart-define` 은 컴파일 타임 상수다.** 이미 실행 중인 앱에서 로그인 버튼을 다시 누르거나
hot reload / hot restart 를 해도 반영되지 않는다. 반드시 프로세스를 종료하고 위 명령으로
다시 실행해야 한다. 반면 **콘솔 설정 변경은 서버 측이라 재빌드가 불필요**하고 로그인
재시도만으로 반영된다 — 이 둘을 혼동하면 "설정했는데 여전히 KOE101" 이 된다.

배포 웹은 `deploy-web.yml` 이 `secrets.KAKAO_JAVASCRIPT_APP_KEY` 를 주입한다(BC-34).
시크릿 등록 절차는 [`app-deploy-secrets.md`](./app-deploy-secrets.md) 참조.

## 5. 다른 에러 코드와 구분

| 코드 | 의미 | 조치 |
|---|---|---|
| KOE101 | `client_id` 무효/공백, 플랫폼 등록 불일치 | 아래 진단 순서 |
| KOE004 | 카카오 로그인 사용 설정 OFF | 활성화 스위치 ON (§2-2) |
| KOE006 | 리다이렉트 URI 미등록/불일치 | 플랫폼 키 하위에 URI 추가 (§2-1) |
| KOE320 | 인가 코드 재사용/만료 | 로그인 재시도 |
| 401 `KAKAO_TOKEN_INVALID` | 백엔드가 받은 access_token 거부 | 앱 토큰 갱신 경로 확인 |

**KOE101 진단 순서** — 에러 화면 주소창에 거부된 요청 파라미터가 그대로 남아 있다.

```
1. URL 의 client_id= 값 확인
   ├─ 비어 있음   → 앱 측 키 주입 문제. 재실행했는지 먼저 확인 (§4)
   └─ 값이 있음   → 2
2. 그 값이 콘솔의 해당 플랫폼 키와 같은가 (웹=JavaScript 키 / 네이티브=네이티브 앱 키)
   ├─ 불일치      → 키를 잘못 주입 중
   └─ 일치        → 3
3. 플랫폼 등록 확인 — 웹: JavaScript SDK 도메인 / Android: 패키지명+키해시 / iOS: 번들 ID
4. 카카오 로그인 활성화 · 동의항목
```

리다이렉트 URI 는 KOE101 의 원인이 아니다(KOE006 이다). 의심 순서에서 뒤로 둔다.
근거와 사고 경과는 [`kakao-login-koe101-postmortem.md`](./kakao-login-koe101-postmortem.md).

앱 내부에서는 KOE101 계열(`misconfigured` / `invalid_client`)을
`SOCIAL_LOGIN_MISCONFIGURED` 로 분류해, 재시도해도 소용없다는 안내 문구를 띄운다
(`mobile/lib/features/auth/data/kakao_login_adapter.dart`).

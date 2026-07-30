# 카카오 로그인 설정 (KOE101 대응)

카카오 로그인이 아래 화면으로 막히면 앱 코드가 아니라 **카카오 개발자 콘솔 등록 정보**와
런타임이 보내는 식별자가 어긋난 것이다.

```
앱 관리자 설정 오류 (KOE101)
서비스 설정에 오류가 있어, 이용할 수 없습니다.
```

카카오는 `kauth.kakao.com/oauth/authorize` 요청의 `client_id` 와 플랫폼 식별자
(`android_key_hash` / `ios_bundle_id` / 웹 도메인)를 콘솔 등록값과 대조한다.
하나라도 불일치하면 KOE101 이다.

## 1. 이 앱이 보내는 값

| 플랫폼 | 콘솔에 등록해야 하는 값 | 코드상 출처 |
|---|---|---|
| Android | 패키지명 `kr.missiondriven.bookclub` | `mobile/android/app/build.gradle.kts` `applicationId` |
| Android | 키 해시 (디버그 + 릴리즈 각각) | `mobile/scripts/kakao_key_hash.sh` |
| iOS | 번들 ID `kr.mission-driven.bookclub` (하이픈 포함) | `ios/Runner.xcodeproj` `PRODUCT_BUNDLE_IDENTIFIER` |
| Web | 서비스 도메인 (예: `http://localhost:8080`, 배포 도메인) | 배포 환경 |
| 공통 | 네이티브 앱 키 = `client_id` (iOS/Android) | `--dart-define=KAKAO_NATIVE_APP_KEY` |
| 공통 | JavaScript 키 = `client_id` (Web) | `--dart-define=KAKAO_JAVASCRIPT_APP_KEY` |

**Android 패키지명과 iOS 번들 ID 의 표기가 다르다.** Android `applicationId` 는
하이픈을 쓸 수 없어 `missiondriven` 으로 붙여 쓰고, iOS 는 `mission-driven` 을 유지한다.
콘솔에는 **두 값을 각각** 등록해야 한다.

## 2. 콘솔 체크리스트

developers.kakao.com → 내 애플리케이션 → 해당 앱:

1. **제품 설정 → 카카오 로그인**
   - [ ] 활성화 스위치 **ON** (OFF 상태가 KOE101 의 가장 흔한 원인)
   - [ ] Redirect URI 등록
     - Android/iOS 네이티브: `kakao<네이티브앱키>://oauth`
     - Web: 서비스 도메인 + 앱이 사용하는 콜백 경로
2. **제품 설정 → 카카오 로그인 → 동의항목**
   - [ ] 닉네임 / 프로필 사진 — 필수 또는 선택 동의
   - [ ] 이메일 — 선택 동의 (백엔드는 `email` null 을 허용한다)
3. **앱 설정 → 플랫폼 → Android**
   - [ ] 패키지명 `kr.missiondriven.bookclub`
   - [ ] 디버그 키 해시, 릴리즈 키 해시 (§3)
4. **앱 설정 → 플랫폼 → iOS**
   - [ ] 번들 ID `kr.mission-driven.bookclub`
5. **앱 설정 → 플랫폼 → Web** (웹 빌드를 쓰는 경우)
   - [ ] 사이트 도메인 등록
6. **앱 설정 → 앱 키**
   - [ ] 네이티브 앱 키가 `KAKAO_NATIVE_APP_KEY` 와 일치
   - [ ] JavaScript 키가 `KAKAO_JAVASCRIPT_APP_KEY` 와 일치

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

# 웹 — JavaScript 키가 없으면 client_id 가 비어 KOE101 이 난다
flutter run -d chrome --dart-define=KAKAO_JAVASCRIPT_APP_KEY=<js_key>

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

## 5. 다른 에러 코드와 구분

| 코드 | 의미 | 조치 |
|---|---|---|
| KOE101 | 앱 키·플랫폼 등록 불일치, 카카오 로그인 비활성 | 본 문서 §2 |
| KOE006 | Redirect URI 미등록 | 콘솔에 Redirect URI 추가 |
| KOE320 | 인가 코드 재사용/만료 | 로그인 재시도 |
| 401 `KAKAO_TOKEN_INVALID` | 백엔드가 받은 access_token 거부 | 앱 토큰 갱신 경로 확인 |

앱 내부에서는 KOE101 계열(`misconfigured` / `invalid_client`)을
`SOCIAL_LOGIN_MISCONFIGURED` 로 분류해, 재시도해도 소용없다는 안내 문구를 띄운다
(`mobile/lib/features/auth/data/kakao_login_adapter.dart`).

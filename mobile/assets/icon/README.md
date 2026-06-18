# 앱 아이콘 / 스플래시 에셋

이 디렉터리에 아래 PNG 파일을 추가한 뒤 생성 도구를 실행하세요.

## 필요한 파일

| 파일 | 크기 | 용도 |
|---|---|---|
| `app_icon.png` | 1024 × 1024 px | iOS/Android 런처 아이콘 · 스플래시 이미지 |
| `app_icon_foreground.png` | 108 × 108 dp (432 × 432 px @4x) | Android Adaptive Icon 전경 레이어 |

- 배경색은 `#FFFFFF` 로 설정되어 있습니다 (`flutter_launcher_icons.yaml`,
  `flutter_native_splash.yaml`).
- `app_icon.png` 는 여백 없는 정사각형, `app_icon_foreground.png` 는 Android
  Adaptive Icon 가이드(안전 영역 66dp)에 맞춰 중앙 정렬로 제작하세요.

## 생성 명령

PNG 파일을 추가한 뒤 `mobile/` 디렉터리에서 실행:

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

생성된 네이티브 리소스는 `android/`, `ios/` 하위에 기록됩니다.

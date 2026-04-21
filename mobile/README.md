# Book Club — Mobile (Flutter)

This directory contains the Book Club Flutter app (iOS + Android). For the overall project design see `../docs/plans/2026-04-20-book-club-design.md`. For Phase 1 scope see `../docs/plans/2026-04-20-book-club-phase1-implementation.md`.

## Prerequisites

- Flutter **3.41.x stable** (Dart 3.11+, SDK constraint `>=3.5.0 <4.0.0`)
- Xcode 15+ with iOS 13 simulator (iOS bundle id: `kr.mission-driven.bookclub`)
- Android SDK with an API 21+ device/emulator (applicationId: `kr.missiondriven.bookclub` — hyphen is not valid in Android app IDs)

Verify your toolchain:

```bash
flutter --version
flutter doctor
```

## Setup

```bash
cd mobile
flutter pub get
```

## Running against a local backend

The API base URL is resolved at runtime from `--dart-define=API_BASE_URL=...`, falling back to platform-aware defaults (`http://10.0.2.2:8000` on Android emulator, `http://localhost:8000` elsewhere).

```bash
# iOS simulator / desktop (localhost is reachable)
flutter run --dart-define=API_BASE_URL=http://localhost:8000

# Android emulator needs 10.0.2.2 to reach the host machine's localhost
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000
```

## Testing & analysis

```bash
flutter test
flutter analyze
dart format --set-exit-if-changed .
```

All three must pass with zero issues.

## Code generation

Retrofit clients, Riverpod code-gen providers, Freezed models, and json_serializable models all share one build_runner pipeline:

```bash
dart run build_runner build -d
# or, for continuous development
dart run build_runner watch -d
```

`-d` (= `--delete-conflicting-outputs`) keeps generated files in sync when signatures change.

## Directory layout

```
lib/
  main.dart                # ProviderScope + runApp
  app.dart                 # MaterialApp.router + AppTheme
  core/
    error/                 # AppException hierarchy
    network/               # dio provider + DioException -> AppException interceptor
    router/                # go_router configuration
    storage/               # flutter_secure_storage wrapper (JWT)
    theme/                 # AppTheme + placeholder GradeTheme (M3)
  features/                # 1:1 with backend domains
    auth/ book/ reading/ feed/ notification/
  shared/widgets/          # cross-feature presentational widgets
test/
  smoke_test.dart          # renders BookClubApp inside ProviderScope with overrides
```

## Design System

Book Club의 시각 언어는 **Apple (HIG + apple.com) 디자인 시스템**을 Flutter 로 이식한 것이다. 설계 원문은 `/awesome-design-md/design-md/apple/DESIGN.md` 를 참조한다.

- **테마 진입점**: `lib/core/theme/app_theme.dart`
  - `AppTheme.light` / `AppTheme.dark` — iOS systemBackground(`#F5F5F7`) / 순수 블랙(`#000000`) 을 기반으로 한 M3 `ThemeData` getter. `MaterialApp` 의 `theme` / `darkTheme` 에 그대로 연결해 사용한다.
  - `AppPalette.*` — 현재 디자인 시스템의 원색을 `Color` 상수로 노출한다 (`systemBlue`, `systemGray1‥6`, `label`, `secondaryLabel`, `separator`, `fill`). 이름을 브랜드 중립으로 유지해 향후 디자인 시스템 교체 시 호출부가 영향받지 않도록 한다.
  - 폰트는 `google_fonts` 로 로드한다. Apple 독점 폰트인 **SF Pro Display / SF Pro Text** 는 재배포가 불가능하므로 가장 근접한 가용 폰트인 **Inter** 로 대체 매핑되어 있으며, HIG의 타입 스케일(Large Title 34 / Title 1‥3 / Headline / Body / Callout / Subheadline / Footnote / Caption 1‥2) 과 음수 트래킹은 그대로 유지된다.

- **등급별 컬러 테마**: `lib/core/theme/grade_theme.dart`
  - `ReaderGrade` 5단계(새싹 독자 → 서재 마스터)에 각각 대응하는 `ColorScheme` 을 `GradeTheme.schemes` / `GradeTheme.darkSchemes` 에서 제공한다. 시드는 iOS 시스템 컬러 (systemGreen → systemTeal → systemBlue → systemIndigo → systemOrange) 를 그대로 사용한다.
  - 타이머·진행 링·프로필 배지에서는 `GradeTheme.apply(baseTheme, grade)` 로 기본 테마의 색 축만 교체한 `ThemeData` 를 얻을 수 있다. 타이포그래피·Spacing·Radius·Shadow 는 그대로 유지된다.

- **커스텀 토큰 (ThemeExtension)**
  - `AppSpacing` — `xs / sm / md / lg / xl` (4 / 8 / 16 / 24 / 32) iOS 8-pt 그리드
  - `AppRadius` — `sm / md / lg / xLarge / pill` (8 / 12 / 16 / 20 / 980) 코너 반경. 980px 는 "Learn more / Shop" 류 pill CTA 전용.
  - `AppShadows` — HIG 에 맞춘 "soft diffused studio light" 계열의 2단 섀도우 (제품 카드용 `rgba(0,0,0,0.22) 3px 5px 30px` + 근접 near-shadow).
  - 접근 패턴:
    ```dart
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    Padding(padding: EdgeInsets.all(spacing.md), child: ...);
    ```

## Milestone roadmap (this directory)

| Milestone | Scope |
|---|---|
| M0 (this task) | Scaffold, theme placeholders, router, dio core, secure storage, smoke test |
| M1 | Kakao + Apple login, auth-aware router guard, JWT persistence |
| M2 | Book search, library management, reviews |
| M3 | Timer, heatmap, grade, goals (unlocks `GradeTheme`) |
| M4 | Book feed, reactions, comments, image uploads |
| M5 | FCM push + weekly report screens |

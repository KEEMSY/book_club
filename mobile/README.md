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

Book Club의 시각 언어는 **Airbnb 디자인 시스템**을 Flutter 로 이식한 것이다. 타겟 사용자인 한국 20~30대 여성이 반응하는 감성적·따뜻·매거진 감성을 그대로 담을 수 있도록, Airbnb의 Rausch Red 단일 액센트 + 편집 디자인(editorial) 세리프 헤드라인 + 따뜻한 오프화이트 캔버스 조합을 채택했다. 설계 원문은 `/awesome-design-md/design-md/airbnb/DESIGN.md` 를 참조한다.

- **테마 진입점**: `lib/core/theme/app_theme.dart`
  - `AppTheme.light` / `AppTheme.dark` — Foggy 오프화이트(`#FAFAFA`) / 따뜻한 근-블랙(`#161616`) 을 기반으로 한 M3 `ThemeData` getter. `MaterialApp` 의 `theme` / `darkTheme` 에 그대로 연결해 사용한다.
  - `AppPalette.*` — 현재 디자인 시스템의 원색을 `Color` 상수로 노출한다 (`rausch`, `rauschDeep`, `nearBlack`, `secondaryGray`, `lightSurface`, `borderGray`, `luxePurple`, `plusMagenta`, `beachPeach`, `hackberry`, `babu` 등). 이름을 브랜드 중립으로 유지해 향후 디자인 시스템 교체 시 호출부가 영향받지 않도록 한다. 이전 시스템과의 호환을 위해 `AppPalette.brand` → `rausch`, `AppPalette.parchment` → `foggy` 별칭이 유지된다.
  - 폰트는 `google_fonts` 로 로드한다. Airbnb 독점 폰트인 **Cereal VF** 는 재배포가 불가능하므로 다음 두 계열로 대체한다:
    - **Playfair Display** — 편집 세리프. `displayLarge` / `displayMedium` / `displaySmall` / `headlineLarge` / `headlineMedium` 등 헤드라인 로트에 매핑. Cereal Medium의 따뜻한 편집 감성을 가장 근접하게 재현한다.
    - **Inter** — 휴머니스트 산세리프. 타이틀/바디/레이블 로트에 매핑. UI 명료성과 한글 글리프 폴백 품질이 Plus Jakarta Sans 대비 우수하다.
  - 타입 스케일·트래킹·line-height 는 DESIGN.md §3 을 그대로 따르되, 모바일 히어로(`displayLarge`)는 한 단계 키워 40pt / w500 / -0.44 로 설정해 인티메이트한 매거진 헤드라인 톤을 살린다.

- **등급별 컬러 테마**: `lib/core/theme/grade_theme.dart`
  - `ReaderGrade` 5단계(새싹 독자 → 서재 마스터)에 각각 대응하는 `ColorScheme` 을 `GradeTheme.schemes` / `GradeTheme.darkSchemes` 에서 제공한다. 시드는 Airbnb 팔레트에서 **Beach Peach → Rausch-lite → Rausch → Hackberry(plum) → Babu(deep teal)** 순으로 warm-to-deep 의 편집 레더를 따라 이동한다.
  - 타이머·진행 링·프로필 배지에서는 `GradeTheme.apply(baseTheme, grade)` 로 기본 테마의 색 축만 교체한 `ThemeData` 를 얻을 수 있다. 타이포그래피·Spacing·Radius·Shadow 는 그대로 유지된다.

- **커스텀 토큰 (ThemeExtension)**
  - `AppSpacing` — `xs / sm / md / lg / xl` (4 / 8 / 16 / 24 / 32) Airbnb 8-pt 매거진 그리드
  - `AppRadius` — `sm / md / lg / xLarge / pill` (8 / 12 / 16 / 20 / 1000) 코너 반경. 1000 은 "Become a host" 류 pill CTA 전용으로 50% 원형 컨트롤의 사각형 대체.
  - `AppShadows` — Airbnb 의 시그니처 3-layer 카드 섀도우 (`rgba(0,0,0,0.02) 0 0 0 1px` ring + `rgba(0,0,0,0.04) 0 2px 6px` + `rgba(0,0,0,0.10) 0 4px 8px`).
  - 접근 패턴:
    ```dart
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    Padding(padding: EdgeInsets.all(spacing.md), child: ...);
    ```

- **버튼 인터랙션**
  - `FilledButton` — Rausch Red 채움, 12px 반경, w500 라벨. 눌렸을 때 Deep Rausch(`#E00B41`) 로 톤 다운.
  - `OutlinedButton` — 중립 보더(`#C1C1C1`) + Rausch 텍스트 + 1000px pill 반경. 포커스 시 Rausch 2px 링(AA 대비 확보).
  - 터치 타겟 44×44 최소 보장 — 접근성 베이스라인 충족.

## Milestone roadmap (this directory)

| Milestone | Scope |
|---|---|
| M0 (this task) | Scaffold, theme placeholders, router, dio core, secure storage, smoke test |
| M1 | Kakao + Apple login, auth-aware router guard, JWT persistence |
| M2 | Book search, library management, reviews |
| M3 | Timer, heatmap, grade, goals (unlocks `GradeTheme`) |
| M4 | Book feed, reactions, comments, image uploads |
| M5 | FCM push + weekly report screens |

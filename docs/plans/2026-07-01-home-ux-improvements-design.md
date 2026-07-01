---
version: 1.0.0
date: 2026-07-01
phase: 16
feature: 홈 UX 개선 — 섹션 순서 조정 + 테스트 데이터 로그인
---

# 홈 UX 개선 설계

## 배경

Phase 16 진행 중 발견된 개발자 불편 사항 두 가지를 해결한다.

1. 홈 섹션 설정에서 온/오프만 가능 — 순서 조정 불가
2. 기능 동작 검증을 위한 테스트 데이터 부재

---

## Feature A — 홈 섹션 순서 조정

### 범위

재배치 대상은 **온/오프 가능한 4개 섹션**만.  
고정 카드(오늘 통계 · 올해 통계)는 항상 상단에 위치하며 순서 조정 불가.

재배치 대상 섹션:
- `streak` — 스트릭 카드
- `goal` — 목표 진행률
- `grade` — 등급 카드
- `heatmap` — 독서 잔디

### 데이터 모델 변경

`DashboardPrefs`에 `sectionOrder: List<String>` 필드 추가.

```dart
class DashboardPrefs {
  final bool showStreak;
  final bool showGoal;
  final bool showGrade;
  final bool showHeatmap;
  final List<String> sectionOrder;  // 추가

  static const List<String> defaultOrder = ['streak', 'goal', 'grade', 'heatmap'];
}
```

- `toJson` / `fromJson` 업데이트
- `fromJson`에서 `sectionOrder` 누락 시 `defaultOrder`로 폴백 (기존 저장값 하위호환)

### UI — `DashboardSettingsSheet`

`ReorderableListView`로 전환.

- 각 행: 드래그 핸들(`Icons.drag_handle`) + 섹션 이름·설명 + 스위치
- 드래그 완료 시 `notifier.reorder(oldIndex, newIndex)` 호출
- 스위치 토글은 기존 동작 유지
- 비활성(스위치 OFF) 섹션도 순서 목록에 유지 — 순서와 가시성은 독립적으로 관리

### 렌더링 — `DashboardScreen`

`prefs.sectionOrder`를 순회하며 섹션을 렌더링.

```dart
for (final id in prefs.sectionOrder) {
  switch (id) {
    case 'streak': if (prefs.showStreak) yield _StreakCard(...);
    case 'goal':   if (prefs.showGoal)   yield _GoalCard(...);
    case 'grade':  if (prefs.showGrade)  yield _GradeRow(...);
    case 'heatmap':if (prefs.showHeatmap) yield _HeatmapCard(...);
  }
}
```

### 퍼시스턴스

기존 `SharedPreferences` 키(`dashboard_prefs`)에 `sectionOrder` 배열을 JSON으로 추가 저장.  
기존 저장값에 `sectionOrder`가 없으면 `defaultOrder`로 초기화 — **기존 사용자 설정 보존**.

---

## Feature B — 테스트 데이터 로그인

### 원칙

- `dev:개발자` 계정은 **절대 건드리지 않음**
- 전용 `dev:테스터` 계정에만 시드 데이터 주입
- 시드는 매 로그인 시 항상 초기화·재주입 (멱등)
- dev 환경에서만 노출 (`settings.env == "dev"` 가드)

### 백엔드 — `POST /dev/seed`

`backend/app/api/dev.py` 신규.

```python
@router.post("/dev/seed", status_code=200)
async def seed_tester(settings, db): ...
```

주입 데이터:

| 도메인 | 내용 |
|---|---|
| `users` | `dev:테스터` 유저 생성 또는 조회 |
| `reading_sessions` | 90일치 — 평일 25분, 주말 45분, 중간에 3일 공백 포함 |
| `user_books` | 5권 — 완독 1, 읽는중 2, 읽고싶어요 1, 일시정지 1 |
| `reading_goals` | 주간(5h)/월간(20h)/연간(100h), 각 65-80% 달성 |
| `feed_events` | BOOK_COMPLETED · STREAK_MILESTONE · CHAPTER_MILESTONE 각 1개 |
| `notifications` | 미읽음 3개 (팔로우 · 리액션 · 클럽 초대) |

등급·통계는 `reading_sessions` 누적에서 자동 계산.

시드 순서:
1. `dev:테스터` 유저 기존 데이터 전량 삭제
2. 정적 픽스처로 각 테이블에 INSERT

### 모바일 — `AuthNotifier.loginTester()`

```dart
Future<void> loginTester() async {
  await _performLogin(() async {
    await _repository.loginDev(nickname: '테스터');
    await _repository.seedTesterData(); // POST /dev/seed
  });
}
```

로그인 화면에 `DevLoginButton(label: '테스트 데이터 로그인')` 추가.  
기존 `개발용 로그인` 버튼 아래에 배치. 두 버튼 모두 `kDebugMode` 가드.

### `AuthRepository`

```dart
Future<void> seedTesterData();  // POST /dev/seed
```

---

## Changelog

- 1.0.0 (2026-07-01): 초안 작성

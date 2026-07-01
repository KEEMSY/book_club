# 홈 UX 개선 구현 계획

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 홈 섹션 드래그 순서 조정 + 테스트 데이터 자동 주입 로그인 추가

**Architecture:** (A) DashboardPrefs에 sectionOrder 필드 추가 → ReorderableListView 설정 시트 → 대시보드 순서 기반 렌더링. (B) POST /dev/seed 백엔드 엔드포인트 → AuthRepository.seedTesterData() → loginTester() notifier 메서드 → 로그인 화면 버튼 추가.

**Tech Stack:** Flutter / Riverpod / shared_preferences / ReorderableListView / FastAPI / SQLAlchemy async

---

## Feature A — 홈 섹션 순서 조정

### Task 1: DashboardPrefs에 sectionOrder 추가

**Files:**
- Modify: `mobile/lib/features/reading/domain/dashboard_prefs.dart`

**Step 1: 파일 읽기**

현재 파일 전체를 확인한다.

**Step 2: sectionOrder 필드 추가**

파일 전체를 아래로 교체:

```dart
/// User preference for which dashboard sections are visible and in what order.
///
/// Persisted via SharedPreferences so the layout survives app restarts.
/// Each bool field defaults to [true] — the first launch shows all sections.
/// [sectionOrder] defaults to [defaultOrder] — stable insertion order.
class DashboardPrefs {
  const DashboardPrefs({
    this.showStreak = true,
    this.showGoal = true,
    this.showGrade = true,
    this.showHeatmap = true,
    List<String>? sectionOrder,
  }) : sectionOrder = sectionOrder ?? defaultOrder;

  final bool showStreak;
  final bool showGoal;
  final bool showGrade;
  final bool showHeatmap;

  /// Ordered list of section IDs. Valid IDs: 'streak', 'goal', 'grade', 'heatmap'.
  /// Order determines render sequence in the dashboard.
  final List<String> sectionOrder;

  static const List<String> defaultOrder = <String>[
    'streak',
    'goal',
    'grade',
    'heatmap',
  ];

  DashboardPrefs copyWith({
    bool? showStreak,
    bool? showGoal,
    bool? showGrade,
    bool? showHeatmap,
    List<String>? sectionOrder,
  }) {
    return DashboardPrefs(
      showStreak: showStreak ?? this.showStreak,
      showGoal: showGoal ?? this.showGoal,
      showGrade: showGrade ?? this.showGrade,
      showHeatmap: showHeatmap ?? this.showHeatmap,
      sectionOrder: sectionOrder ?? this.sectionOrder,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'showStreak': showStreak,
        'showGoal': showGoal,
        'showGrade': showGrade,
        'showHeatmap': showHeatmap,
        'sectionOrder': sectionOrder,
      };

  factory DashboardPrefs.fromJson(Map<String, dynamic> json) {
    final rawOrder = json['sectionOrder'];
    final List<String> order;
    if (rawOrder is List) {
      order = rawOrder.cast<String>();
    } else {
      order = defaultOrder;
    }
    return DashboardPrefs(
      showStreak: json['showStreak'] as bool? ?? true,
      showGoal: json['showGoal'] as bool? ?? true,
      showGrade: json['showGrade'] as bool? ?? true,
      showHeatmap: json['showHeatmap'] as bool? ?? true,
      sectionOrder: order,
    );
  }
}
```

**Step 3: analyze**

```bash
cd mobile && dart analyze lib/features/reading/domain/dashboard_prefs.dart
```
Expected: No issues found.

**Step 4: Commit**

```bash
git add mobile/lib/features/reading/domain/dashboard_prefs.dart
git commit -m "feat: DashboardPrefs에 sectionOrder 필드 추가"
```

---

### Task 2: DashboardPrefsNotifier에 reorder 메서드 추가

**Files:**
- Modify: `mobile/lib/features/reading/application/dashboard_prefs_notifier.dart`

**Step 1: reorder 메서드 추가**

기존 `update()` 메서드 아래에 추가:

```dart
/// Reorders sections when the user drags a row in the settings sheet.
/// [ReorderableListView] passes (oldIndex, newIndex) where newIndex is
/// the position AFTER the item has been removed — standard Flutter convention.
Future<void> reorder(int oldIndex, int newIndex) async {
  final order = List<String>.from(state.sectionOrder);
  if (newIndex > oldIndex) newIndex -= 1;
  final item = order.removeAt(oldIndex);
  order.insert(newIndex, item);
  await update(state.copyWith(sectionOrder: order));
}
```

**Step 2: analyze**

```bash
dart analyze lib/features/reading/application/dashboard_prefs_notifier.dart
```
Expected: No issues found.

**Step 3: Commit**

```bash
git add mobile/lib/features/reading/application/dashboard_prefs_notifier.dart
git commit -m "feat: DashboardPrefsNotifier.reorder() 추가"
```

---

### Task 3: DashboardSettingsSheet — ReorderableListView로 교체

**Files:**
- Modify: `mobile/lib/features/reading/presentation/dashboard_settings_sheet.dart`

**Step 1: 파일 전체 교체**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/dashboard_prefs_notifier.dart';
import '../domain/dashboard_prefs.dart';

/// Bottom sheet that lets the user toggle visibility and drag-reorder the
/// dashboard sections. Opened from the home screen's top action button.
///
/// Uses [ReorderableListView] so each row carries a drag handle on the right.
/// Toggle and order are independent — a hidden section keeps its position in
/// the order so it reappears where the user left it when re-enabled.
class DashboardSettingsSheet extends ConsumerWidget {
  const DashboardSettingsSheet({super.key});

  static const Map<String, ({String title, String subtitle})> _meta = {
    'streak':  (title: '스트릭 카드',  subtitle: '연속 독서 일수'),
    'goal':    (title: '목표 진행률',  subtitle: '주간 · 월간 · 연간 목표'),
    'grade':   (title: '등급 카드',   subtitle: '나의 독서 등급'),
    'heatmap': (title: '독서 잔디',   subtitle: '1년간 독서 캘린더'),
  };

  bool _isVisible(DashboardPrefs prefs, String id) => switch (id) {
        'streak'  => prefs.showStreak,
        'goal'    => prefs.showGoal,
        'grade'   => prefs.showGrade,
        'heatmap' => prefs.showHeatmap,
        _         => false,
      };

  DashboardPrefs _toggle(DashboardPrefs prefs, String id, bool value) =>
      switch (id) {
        'streak'  => prefs.copyWith(showStreak: value),
        'goal'    => prefs.copyWith(showGoal: value),
        'grade'   => prefs.copyWith(showGrade: value),
        'heatmap' => prefs.copyWith(showHeatmap: value),
        _         => prefs,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final DashboardPrefs prefs = ref.watch(dashboardPrefsNotifierProvider);
    final notifier = ref.read(dashboardPrefsNotifierProvider.notifier);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text('홈 섹션 설정', style: theme.textTheme.titleLarge),
                ),
                Icon(
                  Icons.drag_indicator,
                  size: 18,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                const SizedBox(width: 4),
                Text(
                  '길게 눌러 순서 변경',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // ReorderableListView requires a bounded height when used inside a
          // Column. 4 items × ~72px each is well within typical sheet height.
          SizedBox(
            height: prefs.sectionOrder.length * 72.0,
            child: ReorderableListView(
              shrinkWrap: true,
              onReorder: notifier.reorder,
              children: <Widget>[
                for (final id in prefs.sectionOrder)
                  _SectionTile(
                    key: ValueKey<String>(id),
                    id: id,
                    meta: _meta[id]!,
                    isVisible: _isVisible(prefs, id),
                    onChanged: (v) =>
                        notifier.update(_toggle(prefs, id, v)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SectionTile extends StatelessWidget {
  const _SectionTile({
    super.key,
    required this.id,
    required this.meta,
    required this.isVisible,
    required this.onChanged,
  });

  final String id;
  final ({String title, String subtitle}) meta;
  final bool isVisible;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(meta.title),
      subtitle: Text(meta.subtitle),
      value: isVisible,
      onChanged: onChanged,
      // ReorderableListView injects a drag handle via the buildDefaultDragHandles
      // mechanism — the handle appears on the trailing edge automatically.
      // We don't add a custom trailing widget so the default handle shows.
    );
  }
}
```

**Step 2: analyze**

```bash
dart analyze lib/features/reading/presentation/dashboard_settings_sheet.dart
```
Expected: No issues found.

**Step 3: Commit**

```bash
git add mobile/lib/features/reading/presentation/dashboard_settings_sheet.dart
git commit -m "feat: DashboardSettingsSheet — ReorderableListView 드래그 순서 조정"
```

---

### Task 4: DashboardScreen — 순서 기반 렌더링

**Files:**
- Modify: `mobile/lib/features/reading/presentation/dashboard_screen.dart`

**Step 1: 현재 하드코딩 블록 찾기**

아래 4개 블록을 찾는다 (대략 line 172–200):

```dart
if (prefs.showStreak) ...<Widget>[
  _StreakCardWithRecovery(...),
  SizedBox(height: spacing.md),
],
// ... goal, grade, heatmap 동일 패턴
```

**Step 2: 순서 기반 렌더링으로 교체**

4개의 `if (prefs.showX)` 블록을 모두 제거하고 아래 코드 한 블록으로 대체:

```dart
// Render toggleable sections in user-defined order.
for (final String sectionId in prefs.sectionOrder) ...<Widget>[
  if (sectionId == 'streak' && prefs.showStreak) ...<Widget>[
    _StreakCardWithRecovery(
      streak: _streak(gradeState),
      longest: _longest(gradeState),
    ),
    SizedBox(height: spacing.md),
  ],
  if (sectionId == 'goal' && prefs.showGoal) ...<Widget>[
    DashboardGoalCard(
      items: goalItems,
      accent: accent,
      onAddGoal: () => GoRouter.of(context).push('/goals'),
    ),
    SizedBox(height: spacing.md),
  ],
  if (sectionId == 'grade' && prefs.showGrade) ...<Widget>[
    _GradeRow(state: gradeState, accent: accent),
    SizedBox(height: spacing.md),
  ],
  if (sectionId == 'heatmap' && prefs.showHeatmap) ...<Widget>[
    _HeatmapCard(accent: accent),
    SizedBox(height: spacing.md),
  ],
],
```

**Step 3: analyze**

```bash
dart analyze lib/features/reading/presentation/dashboard_screen.dart
```
Expected: No issues found.

**Step 4: Commit**

```bash
git add mobile/lib/features/reading/presentation/dashboard_screen.dart
git commit -m "feat: 대시보드 섹션 순서 기반 렌더링 적용"
```

---

## Feature B — 테스트 데이터 로그인

### Task 5: 백엔드 — POST /dev/seed 엔드포인트

**Files:**
- Create: `backend/app/api/dev.py`
- Modify: `backend/app/main.py`

**Step 1: dev.py 생성**

아래 시드 라우터를 작성한다. `dev:테스터` 유저를 생성 또는 조회하고 기존 데이터를 삭제한 뒤 현실적인 픽스처를 삽입한다.

```python
"""Dev-only seed endpoint.

Accessible only when ``settings.env == "dev"``. Wipes and re-seeds all data
for the ``dev:테스터`` user so the developer can verify every home section
and feature with one tap from the login screen.
"""

from __future__ import annotations

import random
from datetime import UTC, datetime, timedelta
from typing import Annotated
from uuid import uuid4

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import delete, text
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import Settings, get_settings
from app.core.database import get_db
from app.domains.auth.models import AuthProvider, User
from app.domains.auth.repository import UserRepository
from app.domains.auth.service import AuthService
from app.domains.auth.providers import get_auth_service

router = APIRouter(tags=["dev"])

_TESTER_NICKNAME = "테스터"
_TESTER_SUB = f"dev:{_TESTER_NICKNAME}"

# ---------------------------------------------------------------------------
# Seed books — static fixtures (no real ISBN lookup needed)
# ---------------------------------------------------------------------------

_SEED_BOOKS = [
    {"title": "채식주의자", "author": "한강", "isbn": "9788936434120", "page_count": 247},
    {"title": "82년생 김지영", "author": "조남주", "isbn": "9788954651135", "page_count": 190},
    {"title": "아몬드", "author": "손원평", "isbn": "9788954643627", "page_count": 264},
    {"title": "지구 끝의 온실", "author": "김초엽", "isbn": "9791165341909", "page_count": 326},
    {"title": "파친코", "author": "이민진", "isbn": "9788956058191", "page_count": 896},
]

_BOOK_STATUSES = ["completed", "reading", "reading", "want_to_read", "paused"]


@router.post("/dev/seed", status_code=200)
async def seed_tester(
    settings: Annotated[Settings, Depends(get_settings)],
    db: Annotated[AsyncSession, Depends(get_db)],
    auth_service: Annotated[AuthService, Depends(get_auth_service)],
) -> dict[str, str]:
    if settings.env != "dev":
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="not found")

    # 1. Ensure tester user exists
    user_repo = UserRepository(db)
    tester = await user_repo.get_by_provider_sub(AuthProvider.KAKAO, _TESTER_SUB)
    if tester is None:
        now = datetime.now(tz=UTC)
        trial_end = now + timedelta(days=7)
        tester = await user_repo.create(
            provider=AuthProvider.KAKAO,
            sub=_TESTER_SUB,
            email="tester@bookclub.dev",
            nickname=_TESTER_NICKNAME,
            profile_image_url=None,
            trial_started_at=now,
            trial_ends_at=trial_end,
        )

    user_id = str(tester.id)

    # 2. Wipe existing tester data (order matters for FK constraints)
    await db.execute(
        text("DELETE FROM notifications WHERE user_id = :uid"), {"uid": user_id}
    )
    await db.execute(
        text("DELETE FROM reading_sessions WHERE user_book_id IN "
             "(SELECT id FROM user_books WHERE user_id = :uid)"),
        {"uid": user_id},
    )
    await db.execute(
        text("DELETE FROM user_books WHERE user_id = :uid"), {"uid": user_id}
    )
    await db.execute(
        text("DELETE FROM reading_goals WHERE user_id = :uid"), {"uid": user_id}
    )
    await db.execute(
        text("DELETE FROM feed_events WHERE user_id = :uid"), {"uid": user_id}
    )

    # 3. Seed books into catalog (upsert by ISBN)
    book_ids: list[str] = []
    for b in _SEED_BOOKS:
        row = await db.execute(
            text("SELECT id FROM books WHERE isbn = :isbn"), {"isbn": b["isbn"]}
        )
        existing = row.scalar_one_or_none()
        if existing:
            book_ids.append(str(existing))
        else:
            new_id = str(uuid4())
            await db.execute(
                text(
                    "INSERT INTO books (id, title, author, isbn, page_count, created_at, updated_at) "
                    "VALUES (:id, :title, :author, :isbn, :page_count, NOW(), NOW())"
                ),
                {"id": new_id, **{k: v for k, v in b.items()}},
            )
            book_ids.append(new_id)

    # 4. Seed user_books
    user_book_ids: list[str] = []
    for book_id, lib_status in zip(book_ids, _BOOK_STATUSES):
        ub_id = str(uuid4())
        user_book_ids.append(ub_id)
        await db.execute(
            text(
                "INSERT INTO user_books (id, user_id, book_id, status, created_at, updated_at) "
                "VALUES (:id, :user_id, :book_id, :status, NOW(), NOW())"
            ),
            {"id": ub_id, "user_id": user_id, "book_id": book_id, "status": lib_status},
        )

    # 5. Seed reading_sessions — 90 days, realistic pattern
    completed_ub_id = user_book_ids[0]  # 완독한 책의 user_book_id
    reading_ub_id = user_book_ids[1]    # 읽는 중인 책
    now = datetime.now(tz=UTC)
    rng = random.Random(42)  # deterministic

    for day_offset in range(90, 0, -1):
        session_date = now - timedelta(days=day_offset)
        # 3-day gap around day 45 to break perfect streak
        if 44 <= day_offset <= 46:
            continue
        is_weekend = session_date.weekday() >= 5
        duration_min = rng.randint(35, 55) if is_weekend else rng.randint(20, 35)
        duration_sec = duration_min * 60
        ub_id = completed_ub_id if day_offset > 30 else reading_ub_id
        await db.execute(
            text(
                "INSERT INTO reading_sessions "
                "(id, user_book_id, started_at, ended_at, duration_sec, paused_ms, device, created_at) "
                "VALUES (:id, :ub_id, :started, :ended, :dur, 0, 'aos', NOW())"
            ),
            {
                "id": str(uuid4()),
                "ub_id": ub_id,
                "started": session_date.replace(hour=21, minute=0, second=0),
                "ended": session_date.replace(hour=21, minute=0, second=0)
                + timedelta(seconds=duration_sec),
                "dur": duration_sec,
            },
        )

    # 6. Seed reading_goals
    current_year = now.year
    current_month = now.month
    for goal in [
        {"period": "weekly",  "target_minutes": 300,  "year": current_year, "month": current_month, "week": None},
        {"period": "monthly", "target_minutes": 1200, "year": current_year, "month": current_month, "week": None},
        {"period": "yearly",  "target_minutes": 6000, "year": current_year, "month": None, "week": None},
    ]:
        await db.execute(
            text(
                "INSERT INTO reading_goals "
                "(id, user_id, period, target_minutes, year, month, week, created_at, updated_at) "
                "VALUES (:id, :uid, :period, :target, :year, :month, :week, NOW(), NOW())"
            ),
            {"id": str(uuid4()), "uid": user_id, **goal},
        )

    # 7. Seed feed_events
    for event_type in ["BOOK_COMPLETED", "STREAK_MILESTONE", "CHAPTER_MILESTONE"]:
        await db.execute(
            text(
                "INSERT INTO feed_events (id, user_id, event_type, payload, created_at) "
                "VALUES (:id, :uid, :type, :payload, NOW())"
            ),
            {
                "id": str(uuid4()),
                "uid": user_id,
                "type": event_type,
                "payload": "{}",
            },
        )

    # 8. Seed notifications (unread)
    for notif in [
        {"type": "follow",       "body": "새로운 팔로워가 생겼어요!"},
        {"type": "reaction",     "body": "누군가 내 독서 기록에 반응했어요"},
        {"type": "club_invite",  "body": "클럽에 초대받았어요"},
    ]:
        await db.execute(
            text(
                "INSERT INTO notifications "
                "(id, user_id, type, title, body, is_read, created_at) "
                "VALUES (:id, :uid, :type, :title, :body, false, NOW())"
            ),
            {
                "id": str(uuid4()),
                "uid": user_id,
                "type": notif["type"],
                "title": "알림",
                "body": notif["body"],
            },
        )

    await db.commit()
    return {"status": "seeded", "user_id": user_id}
```

**Step 2: main.py에 dev router 등록**

`backend/app/main.py`에서 다른 라우터 import 블록 아래에 추가:

```python
# dev router는 settings.env 가드를 라우트 레벨에서 처리하므로
# 항상 include — prod에서는 404를 반환한다.
from app.api import dev as dev_api
```

그리고 `app.include_router(health.router)` 바로 아래에:

```python
app.include_router(dev_api.router)
```

**Step 3: DB 스키마 확인 — notifications 테이블 컬럼명**

실제 알림 테이블 컬럼이 `type`, `title`, `body`, `is_read`인지 확인:

```bash
docker exec bookclub-api-1 uv run python -c \
  "from app.domains.notification.models import Notification; print([c.name for c in Notification.__table__.columns])"
```

컬럼명이 다르면 `dev.py`의 notifications INSERT를 실제 컬럼명으로 수정한다.

**Step 4: reading_goals 컬럼명 확인**

```bash
docker exec bookclub-api-1 uv run python -c \
  "from app.domains.reading.models import ReadingGoal; print([c.name for c in ReadingGoal.__table__.columns])"
```

`week`, `month` 컬럼이 없으면 해당 INSERT에서 제거한다.

**Step 5: 서버 재시작 후 엔드포인트 테스트**

```bash
docker compose restart api
curl -s -X POST http://localhost:8000/dev/seed | python3 -m json.tool
```

Expected:
```json
{"status": "seeded", "user_id": "..."}
```

**Step 6: Commit**

```bash
git add backend/app/api/dev.py backend/app/main.py
git commit -m "feat: POST /dev/seed — 테스터 계정 픽스처 데이터 주입"
```

---

### Task 6: AuthApi — seed 엔드포인트 추가

**Files:**
- Modify: `mobile/lib/features/auth/data/auth_api.dart`

**Step 1: retrofit 메서드 추가**

기존 `loginDev` 메서드 바로 아래에 추가:

```dart
/// Dev-only. Seeds realistic fixture data for the ``dev:테스터`` account.
/// Returns 404 when the backend is not in dev mode.
@POST('/dev/seed')
Future<void> seedTesterData();
```

**Step 2: analyze**

```bash
dart analyze lib/features/auth/data/auth_api.dart
```

**Step 3: retrofit 코드 재생성**

```bash
dart run build_runner build --delete-conflicting-outputs 2>&1 | tail -5
```

Expected: `Generated N outputs.`

**Step 4: Commit**

```bash
git add lib/features/auth/data/auth_api.dart lib/features/auth/data/auth_api.g.dart
git commit -m "feat: AuthApi.seedTesterData() 추가"
```

---

### Task 7: AuthRepository — seedTesterData 메서드 추가

**Files:**
- Modify: `mobile/lib/features/auth/data/auth_repository.dart`

**Step 1: 메서드 추가**

`loginDev()` 메서드 바로 아래에 추가:

```dart
/// Calls ``POST /dev/seed`` to wipe and re-seed all fixture data for the
/// ``dev:테스터`` account. No-op (silently swallowed) when the backend
/// returns 404 — i.e. in non-dev environments.
Future<void> seedTesterData() async {
  try {
    await _api.seedTesterData();
  } on AuthRepositoryException {
    // 404 from non-dev backend — safe to ignore.
  } catch (_) {
    // Network or unexpected errors — don't block login flow.
  }
}
```

**Step 2: analyze**

```bash
dart analyze lib/features/auth/data/auth_repository.dart
```

**Step 3: Commit**

```bash
git add lib/features/auth/data/auth_repository.dart
git commit -m "feat: AuthRepository.seedTesterData() 추가"
```

---

### Task 8: AuthNotifier — loginTester 메서드 추가

**Files:**
- Modify: `mobile/lib/features/auth/application/auth_notifier.dart`

**Step 1: 메서드 추가**

`loginDev()` 바로 아래에 추가:

```dart
/// Logs in as the fixture tester account and seeds fresh test data.
/// The ``dev:테스터`` user is separate from ``dev:개발자`` — the developer's
/// own data is never touched.
Future<void> loginTester() async {
  await _performLogin(() async {
    final user = await _repository.loginDev(nickname: '테스터');
    await _repository.seedTesterData();
    return user;
  });
}
```

**Step 2: analyze**

```bash
dart analyze lib/features/auth/application/auth_notifier.dart
```

**Step 3: Commit**

```bash
git add lib/features/auth/application/auth_notifier.dart
git commit -m "feat: AuthNotifier.loginTester() — 테스터 로그인 + 시드 호출"
```

---

### Task 9: 로그인 화면 — 테스트 데이터 로그인 버튼 추가

**Files:**
- Modify: `mobile/lib/features/auth/presentation/login_screen.dart`

**Step 1: _BottomCtas에 onTestLogin 콜백 추가**

`_BottomCtas` 생성자와 필드에 `onTestLogin` 추가:

```dart
// 생성자 파라미터 추가:
required this.onTestLogin,

// 필드 추가:
final VoidCallback onTestLogin;
```

**Step 2: 버튼 렌더링 추가**

`_BottomCtas.build()`의 `DevLoginButton` 블록 바로 아래에 추가:

```dart
SizedBox(height: spacing.xs),
DevLoginButton(
  label: '테스트 데이터 로그인',
  onPressed: onTestLogin,
  isLoading: isBusy,
),
```

**Step 3: LoginScreen에서 콜백 연결**

`LoginScreen.build()`의 `_BottomCtas` 생성 부분에 추가:

```dart
onTestLogin: () =>
    ref.read(authNotifierProvider.notifier).loginTester(),
```

**Step 4: analyze**

```bash
dart analyze lib/features/auth/presentation/login_screen.dart
```
Expected: No issues found.

**Step 5: Commit**

```bash
git add lib/features/auth/presentation/login_screen.dart
git commit -m "feat: 로그인 화면 — 테스트 데이터 로그인 버튼 추가"
```

---

### Task 10: 전체 dart analyze + 최종 확인

**Step 1: 전체 분석**

```bash
cd mobile && dart analyze lib/ 2>&1 | grep -E "error|warning" | head -20
```

Expected: 오류 0건.

**Step 2: 백엔드 seed 엔드포인트 최종 검증**

```bash
# 테스터 계정 seed
curl -s -X POST http://localhost:8000/dev/seed | python3 -m json.tool

# 테스터 dev-login 후 토큰 확인
curl -s -X POST http://localhost:8000/auth/dev-login \
  -H "Content-Type: application/json" \
  -d '{"nickname":"테스터"}' | python3 -m json.tool
```

**Step 3: Commit (최종)**

```bash
git add -A
git commit -m "feat: 홈 UX 개선 — 섹션 순서 조정 + 테스트 데이터 로그인 완료"
```

---

## Changelog

- 1.0.0 (2026-07-01): 초안 작성

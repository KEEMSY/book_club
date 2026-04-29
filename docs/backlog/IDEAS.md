# Backlog — 아이디어 & 개선안 저장소

작업 중 떠오른 Phase 범위 밖 아이디어를 여기에 기록한다. 규칙은 `CLAUDE.md` §8 참조.

## 포맷

```
- [ ] (<domain>) <아이디어 한 줄> — 맥락: <당시 진행 중이던 작업> (YYYY-MM-DD)
```

- 완료: `[x]` 로 체크하고 구현 PR 번호를 괄호에 남긴다. 예: `[x] ... (#42)`
- 폐기: `~~취소선~~` 처리 후 사유를 한 줄로 남긴다.

## Phase 전환 리뷰 기록

### Phase 2 → Phase 3 전환 리뷰 (2026-04-29)

- 리뷰 문서: `docs/plans/2026-04-29-phase3.md`
- **편입**: (challenge) evaluate_progress → reading 이벤트 연결 → M12 / (challenge) 어드민 시드 스크립트 → M12 / (discovery) 위시리스트 → M13 / (reading) 하이라이트·메모 → M14
- **보류**: (community) 온/오프 모임 이벤트 → Phase 4 (소셜 인프라 추가 필요) / (discovery) 책 추천 → Phase 4 (ML 파이프라인 필요) / (mobile/login) illustration SVG → M15 폴리시 / (mobile/reading) TimerRing 대안 → M15 폴리시
- 폐기 항목 없음

### Phase 1 → Phase 2 전환 리뷰 (2026-04-26)

- 리뷰 문서: `docs/plans/2026-04-26-community-phase2.md`
- **편입**: (social) 팔로우·차단·신고 → M7 / (engagement) 기간·테마형 챌린지 → M9 / (engagement) 행동 기반 배지 → M9/M10
- **보류**: (reading) 하이라이트·메모 공유, (discovery) 책 추천, (discovery) 위시리스트, (community) 온/오프 모임 이벤트 → Phase 3 이후 재검토
- 폐기 항목 없음

---

## Ideas

### 2026-04-20

- (초기 기획 단계에서 Phase 2 이후로 분류된 후보)
  - [x] (social) 팔로우·차단·신고 등 소셜 그래프 — 맥락: MVP 범위 선정 중 (2026-04-20) → Phase 2 M7 편입
  - [ ] (reading) 하이라이트·메모 저장 및 책 그룹 공유 — 맥락: 추가 기능 후보 B (2026-04-20) → Phase 3 보류
  - [x] (engagement) 기간·테마형 독서 챌린지 — 맥락: 추가 기능 후보 H (2026-04-20) → Phase 2 M9 편입
  - [x] (engagement) 행동 기반 배지 수집 — 맥락: 추가 기능 후보 I (2026-04-20) → Phase 2 M9/M10 편입
  - [ ] (discovery) 독서 이력 기반 책 추천 — 맥락: 추가 기능 후보 K (2026-04-20) → Phase 3 보류
  - [ ] (discovery) 읽고 싶은 책 위시리스트 및 공유 — 맥락: 추가 기능 후보 L (2026-04-20) → Phase 3 보류
  - [ ] (community) 책 그룹 내 정기 모임(온/오프) 이벤트 — 맥락: 추가 기능 후보 G (2026-04-20) → Phase 3 이후 보류

- [x] (design) Claude (Anthropic) 디자인 시스템을 Flutter 테마(ColorScheme · TextTheme · grade_theme)에 적용 — 맥락: M0 Flutter 스캐폴드 완료 직후 사용자 요청으로 M0 범위 내 편입 (2026-04-20)
- [x] (design) 디자인 시스템 교체 — Claude → Apple (awesome-design-md/design-md/apple/DESIGN.md) · 네이밍 중립화(AppPalette·AppTypography 등)로 향후 디자인 시스템 교체 용이성 확보 — 맥락: M0 완료 후 사용자 요청 (2026-04-20)
- [x] (design) 디자인 시스템 교체 — Apple → Airbnb (2030 여성 타겟, 감각적·직관적, 따뜻한 팔레트·세리프 헤드라인·감성 카드 UX) — 맥락: M1 백엔드 진행 중 사용자 디자인 피드백 반영 (2026-04-20)
- [x] (auth) Kakao contract 재조정 — (a) schema `{ access_token }` rename + 어댑터 token 교환 스텝 skip 채택. 2 커밋(`61b941a` backend, `29e7fb2` mobile), 태그 `v0.0.2` (2026-04-22 hotfix)
- [ ] (mobile/login) 로그인 화면 중앙 illustration 자리에 실제 에디토리얼 SVG 적용 — 현재 Rausch 10% 틴트 + 책 아이콘 placeholder. 2030 여성 타겟의 매거진 톤 강화 — 맥락: M1 Mobile 로그인 스크린 폴리시 후보 (2026-04-20)
- [x] (mobile/auth) Kakao 공식 브랜드 SVG 아이콘 교체 — `_KakaoMark` CustomPainter로 말풍선+눈 두 개 공식 마크 구현, Material `chat_bubble` 대체 (2026-04-26)
- [x] (auth) retrofit + custom_lint 의존성 버전 정리 — 분석 결과: retrofit_generator 10.x + custom_lint 0.8.x 모두 freezed 3.x(build ^4.0.0) 필요. pubspec 코멘트를 정확한 차단 사유로 갱신, 해제는 freezed 2→3 마이그레이션 전용 태스크로 분리 (2026-04-26)
- [x] (auth) FCM 디바이스 토큰 등록 M6에서 실 FCM 토큰으로 교체 — M6 Task 6.6(서명 키 + GoogleService-Info.plist) 완료 후 AuthRepository.registerDeviceToken 호출 변경 예정
- [x] (mobile/reading) Android foreground service 네이티브 설정 — `FOREGROUND_SERVICE` · `FOREGROUND_SERVICE_DATA_SYNC` · `WAKE_LOCK` 권한 + `BackgroundService` 서비스 선언 + `ic_bg_service.xml` drawable 추가. Dart bridge(`timer_lifecycle.dart`)에 실제 `FlutterBackgroundService` 호출 연결 완료 (2026-04-26)
- [x] (mobile/reading) 수동 기록 모달에 책 선택기 추가 — `userBookId` optional 전환 + `_BookPicker` (읽는 중 서재 horizontal ChoiceChip 리스트) 내장. library detail 3-dot 진입 시 id 전달하면 picker 스킵 (2026-04-26)
- [x] (mobile/reading) 주간 목표 daily slice 동적 계산 — `target / 7` (flat) → `target / (8 - weekday)` (월요일=7일, 일요일=1일 분배) 로 변경, 주 후반 catch-up 압박 구현 (2026-04-26)
- [ ] (mobile/reading) TimerRing progress 시각 — 현재 시간당 wrap (`elapsed % 3600 / 3600`). "오늘 목표" 비례 등 대안 UX 검토 — 맥락: M3 구현 시 결정 유보 (2026-04-22)
- [ ] (challenge) 챌린지 어드민 생성 API / 시드 스크립트 — `POST /admin/challenges`, `POST /admin/badges` 어드민 전용 엔드포인트 또는 `scripts/seed_challenges.py` 필요. 현재는 DB 직접 INSERT만 가능. 맥락: M9 챌린지 시스템 완료 시점, 운영자가 챌린지·배지를 생성할 방법 없음 (2026-04-28) → Phase 3 M12 편입
- [ ] (challenge) evaluate_progress → reading 이벤트 연결 — `ChallengeService.evaluate_progress`가 현재 플레이스홀더. `end_session` (session 종료) 및 `UserBook.status = completed` (완독) 이벤트 발생 시 `books_count` / `reading_time` / `streak` 챌린지 진행도 자동 갱신 필요. 맥락: M9 완료 시점, evaluate_progress 미구현 (2026-04-28) → Phase 3 M12 편입
- [x] (mobile/design) 다크 모드 완성 — 전체 위젯을 Theme.colorScheme 로 마이그레이션하고 ThemeMode.light 고정 해제. jan-dee bucket 은 alphaBlend 로 양쪽 캔버스에서 opacity ladder 유지, 브랜드 고정(Kakao/Apple/plusMagenta) 은 그대로 — 맥락: 사용자 Chrome 테스트 피드백 (2026-04-23 완료)
- [x] (mobile/reading) 목표 화면 재구성 — "올해의 독서 여정" 단일 흐름으로 재구성 완료 (commit `81eb4c5`, 2026-04-25)
- [ ] (mobile/login) 로그인 화면 중앙 illustration 자리에 실제 에디토리얼 SVG 적용 — 디자인 에셋 필요, M6 QA 후 Phase 2에서 처리 — 맥락: M1 Mobile 로그인 스크린 폴리시 후보 (2026-04-20)

# Backlog — 아이디어 & 개선안 저장소

작업 중 떠오른 Phase 범위 밖 아이디어를 여기에 기록한다. 규칙은 `CLAUDE.md` §8 참조.

## 포맷

```
- [ ] (<domain>) <아이디어 한 줄> — 맥락: <당시 진행 중이던 작업> (YYYY-MM-DD)
```

- 완료: `[x]` 로 체크하고 구현 PR 번호를 괄호에 남긴다. 예: `[x] ... (#42)`
- 폐기: `~~취소선~~` 처리 후 사유를 한 줄로 남긴다.

## Phase 전환 리뷰 기록

### Phase 11 전환 리뷰 (2026-06-16)

- 리뷰 문서: `docs/plans/2026-06-16-phase11.md`
- **편입 (M46)**: (engagement) 리텐션 & 재참여 강화 — 7일 이탈 감지, 재참여 푸시, 스트릭 복구 메커니즘
- **편입 (M47)**: (social) 소셜 피드 강화 — 팔로우 기반 피드, 리액션 시스템(이모지 5종), 댓글 2뎁스
- **편입 (M48)**: (discovery) 클럽 발견 강화 — 클럽 태그/카테고리, AI 기반 클럽 추천
- **편입 (M49)**: (monetization) IAP 쉴드 추가 구매 — 1개 990원·3개 2,490원, RevenueCat 소비형 IAP 연동
- **편입 (M50)**: (infra) 성능 & 모니터링 인프라 — Redis 응답 캐싱, Prometheus/Grafana APM, Sentry 에러 모니터링
- **보류 (Phase 12)**: (audio) 실 오디오 코칭 — M42 큐레이션 카드 MVP 반응 데이터 확보 후
- **보류 (Phase 12)**: (discovery) 딥러닝 추천 — 활성 사용자 1만 이상 확보 후
- **보류 (Phase 12)**: (monetization) Pro 연간 구독 할인 캠페인 — M43 A/B 실험 결과 분석 후

### Phase 10 전환 리뷰 (2026-06-15)

- 리뷰 문서: `docs/plans/2026-06-15-phase10.md`
- **완료 (M41)**: (engagement) 챌린지 배지 희소성 강화 — is_limited/ends_at_exclusive/badge_id_exclusive, 기간 한정 배지 자동 부여·차단, "D-N 종료" UI
- **완료 (M42)**: (discovery) 독서 큐레이션 카드 MVP — curation_cards 테이블, GET /books/{id}/curation-cards/first, 타이머 시작 전 BottomSheet
- **완료 (M43)**: (monetization) Pro 수익화 A/B 실험 인프라 — experiments/user_experiments 테이블, 결정론적 SHA-256 배정, 페이월 진입 시점·가격 표시 실험 2종
- **완료 (M44)**: (discovery) ML 추천 고도화 — user_taste_profiles/user_onboarding_interests, similar_readers·taste_match·cold_start 전략, AI 추천 섹션 + 추천 근거 표시
- **완료 (M45)**: (polish) 앱스토어 제출 준비 — pubspec.yaml v1.0.0+1, PrivacyPolicyScreen, iOS Info.plist 권한 문구, 스토어 메타데이터 완성
- **보류 (Phase 11)**: (engagement) 쉴드 유료 추가 구매 IAP — M43 A/B 전환 데이터 확인 후 결정
- **보류 (Phase 11)**: (audio) 실 오디오 코칭 — M42 큐레이션 카드 MVP 반응 확인 후
- **보류 (Phase 11)**: (discovery) 딥러닝 추천 (딥 협업 필터링 / 콘텐츠 임베딩) — 활성 사용자 1만 이상 확보 후

### Phase 9 전환 리뷰 (2026-06-14)

- 리뷰 문서: `docs/plans/2026-06-12-phase9.md`
- **완료 (M36)**: (monetization) RevenueCat 실 결제 연동 — PurchaseVerifierPort·RevenueCatAdapter·StubVerifier, POST /webhooks/revenuecat (HMAC 검증, 이벤트 처리)
- **완료 (M37)**: (feed) 독서 활동 피드 고도화 — feed_events 테이블, CHAPTER_MILESTONE·STREAK_MILESTONE·BOOK_COMPLETED·CLUB_JOINED 이벤트, 모바일 타입별 카드 UI
- **완료 (M38)**: (search) 통합 검색 강화 — tsvector GIN 인덱스, GET /search?q=&type=all|book|user|club, UnifiedSearchScreen + 탭 UI
- **완료 (M39)**: (admin) 관리자 대시보드 — MAU/DAU/신규가입/Pro 통계, 사용자 조회·패치, GET /admin/stats·users·users/{id}, PATCH /admin/users/{id}
- **완료 (M40)**: (polish) 성능 최적화 & 앱스토어 제출 준비 — Sliver 전환, url_launcher 개인정보처리방침, 접근성 Semantics, App Store Connect 메타데이터, version 0.6.0+6
- **보류 (Phase 10)**: (discovery) 딥러닝 추천 — 활성 사용자 1만 이상 확보 후 검토
- **보류 (Phase 10)**: (engagement) 쉴드 유료 추가 구매 IAP — 수익화 전환 데이터 분석 후 결정

### Phase 8 전환 리뷰 (2026-06-12)

- 리뷰 문서: `docs/plans/2026-06-12-phase8.md`
- **완료 (M31)**: (growth) 친구 초대 & 딥링크 — referral 코드, GET/POST /me/referral, ReferralScreen, /invite/:code 딥링크
- **완료 (M32)**: (club) 공개 클럽 발견 — is_public 컬럼, GET /clubs/public, PublicClubsScreen, 클럽 생성 공개 토글
- **완료 (M33)**: (notification) 개인화 리마인더 — reading_reminders 테이블, CRUD API, ReminderScreen, 스트릭 경고 푸시
- **완료 (M34)**: (monetization) Pro 구독 인프라 — is_pro/pro_expires_at 컬럼, 구독 API stub, PaywallScreen, ProBadge
- **완료 (M35)**: (polish) 앱 폴리시 — 온보딩 3단계 PageView, Firebase 방어 코드, 이미지 캐싱, 접근성 Semantics
- **보류 (Phase 9)**: (discovery) 딥러닝 추천 — 활성 사용자 1만 이상 확보 후 검토
- **보류 (Phase 9)**: (monetization) RevenueCat 실제 영수증 검증 연동 — M34 stub → 실 결제 검증
- **보류 (Phase 9)**: (engagement) 쉴드 유료 추가 구매 — Pro 반응 데이터 확인 후 결정

### Phase 7 전환 리뷰 (2026-06-10)

- 리뷰 문서: `docs/plans/2026-06-07-phase7.md`
- **완료 (M26)**: (reading) 스트릭 쉴드 — streak_shields 누적, 소진 로직, StreakShieldBadge UI
- **완료 (M27)**: (social) 소셜 리더보드 — GET /social/leaderboard/weekly, LeaderboardScreen
- **완료 (M28)**: (reading) 연중 회고 카드 확장 — MonthlyRecap, MonthlyRecapScreen
- **완료 (M29)**: (club) 챕터별 진도 채팅방 게이트 — current_chapter B안, PATCH /me/library/{id}/chapter, club rooms slider 999
- **완료 (M30)**: (community) 오프라인 독서 모임 연결 — ClubEventsScreen, RSVP, event CRUD
- **완료 (추가)**: (club) 클럽 읽는 책 설정/변경 — PATCH /clubs/{id}/book, _ClubBookCard, _SetBookSheet
- **보류 (Phase 8)**: (discovery) 딥러닝 추천 — 활성 사용자 1만 이상 확보 후 검토
- **보류 (Phase 8)**: (engagement) 쉴드 유료화 — 수익화 실험 결정 후 인앱 결제 연동

### Phase 6 전환 리뷰 (2026-06-04)

- 리뷰 문서: `docs/plans/2026-06-04-phase6.md`
- **편입 (M23)**: (club) 그룹 채팅 WebSocket 인프라 — FastAPI websockets + Redis pub/sub
- **편입 (M24)**: (club) 그룹 채팅 UI (메시지 CRUD, 읽음 처리, 미디어)
- **편입 (M25)**: (notification) 실시간 인앱 알림 + FCM 심화 (토픽 구독, 배치)
- **보류 (Phase 7)**: (discovery) 딥러닝 추천 — 활성 사용자 1만 이상 확보 후 검토

### Phase 5 전환 리뷰 (2026-06-03)

- 리뷰 문서: `docs/plans/2026-06-03-phase5.md`
- **편입 (M20)**: Riverpod 3.0 마이그레이션, discovery TypedDict, FCM HTTP v1, retrofit/freezed 업그레이드, DevLoginButton 교체
- **편입 (M21)**: (discovery) ML 기반 추천 고도화 → 협업 필터링 / (reading) 독서 통계 탭 강화
- **편입 (M22)**: (social) 연말 독서 회고 카드 + SNS 공유 / (social) 서재 SNS 캡처 최적화 / (profile) 배지 핀 고급 UI / (mobile/login) 에디토리얼 SVG 일러스트
- **보류 (Phase 6)**: (club) 그룹 채팅 / 실시간 알림 — WebSocket 인프라 선행 필요

### Phase 4 완료 (2026-05-01)

- M16 (탐색 탭·책 추천), M17 (독서 그룹), M18 (프로필 강화), M19 (QA·스토어 준비) 전부 완료.
- 최종 태그: `v0.1.0` — Phase 4 + 앱스토어 출시 버전 기준선.
- 잔여 아이디어: (discovery) ML 기반 추천 고도화, (club) 그룹 채팅 / 실시간 알림, (profile) 배지 핀 고급 UI.

### Phase 3 → Phase 4 전환 리뷰 (2026-05-02)

- 리뷰 문서: `docs/plans/2026-05-02-phase4.md`
- **편입**: (community) 온/오프 모임 이벤트 → M17 / (discovery) 독서 이력 기반 책 추천 → M16 (규칙 기반 시작) / (profile) 공개 프로필 강화 → M18
- **신규 편입**: (profile) 공개 프로필 + 배지 핀 → M18 / QA·스토어 제출 → M19
- 보류 없음 (Phase 3 미완성 항목 전부 완료됨)
- 폐기 항목 없음

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
  - [x] (reading) 하이라이트·메모 저장 및 책 그룹 공유 — M14에서 `post_highlights` 테이블 + CRUD API + PostCard 인용 카드 + 서재 하이라이트 탭 구현 완료
  - [x] (engagement) 기간·테마형 독서 챌린지 — 맥락: 추가 기능 후보 H (2026-04-20) → Phase 2 M9 편입
  - [x] (engagement) 행동 기반 배지 수집 — 맥락: 추가 기능 후보 I (2026-04-20) → Phase 2 M9/M10 편입
  - [ ] (discovery) 독서 이력 기반 책 추천 — 맥락: 추가 기능 후보 K (2026-04-20) → Phase 3 보류
  - [x] (discovery) 읽고 싶은 책 위시리스트 및 공유 — M13에서 `wishlist` status + 서재 탭 + 책 상세 버튼 구현 완료
  - [ ] (community) 책 그룹 내 정기 모임(온/오프) 이벤트 — 맥락: 추가 기능 후보 G (2026-04-20) → Phase 3 이후 보류

- [x] (design) Claude (Anthropic) 디자인 시스템을 Flutter 테마(ColorScheme · TextTheme · grade_theme)에 적용 — 맥락: M0 Flutter 스캐폴드 완료 직후 사용자 요청으로 M0 범위 내 편입 (2026-04-20)
- [x] (design) 디자인 시스템 교체 — Claude → Apple (awesome-design-md/design-md/apple/DESIGN.md) · 네이밍 중립화(AppPalette·AppTypography 등)로 향후 디자인 시스템 교체 용이성 확보 — 맥락: M0 완료 후 사용자 요청 (2026-04-20)
- [x] (design) 디자인 시스템 교체 — Apple → Airbnb (2030 여성 타겟, 감각적·직관적, 따뜻한 팔레트·세리프 헤드라인·감성 카드 UX) — 맥락: M1 백엔드 진행 중 사용자 디자인 피드백 반영 (2026-04-20)
- [x] (auth) Kakao contract 재조정 — (a) schema `{ access_token }` rename + 어댑터 token 교환 스텝 skip 채택. 2 커밋(`61b941a` backend, `29e7fb2` mobile), 태그 `v0.0.2` (2026-04-22 hotfix)
- [x] (mobile/login) 로그인 화면 중앙 illustration SVG 적용 — M22 `v0.1.3-m22` login_hero.svg + flutter_svg 구현 완료 (2026-06-05)
- [x] (mobile/auth) Kakao 공식 브랜드 SVG 아이콘 교체 — `_KakaoMark` CustomPainter로 말풍선+눈 두 개 공식 마크 구현, Material `chat_bubble` 대체 (2026-04-26)
- [x] (auth) retrofit + custom_lint 의존성 버전 정리 — 분석 결과: retrofit_generator 10.x + custom_lint 0.8.x 모두 freezed 3.x(build ^4.0.0) 필요. pubspec 코멘트를 정확한 차단 사유로 갱신, 해제는 freezed 2→3 마이그레이션 전용 태스크로 분리 (2026-04-26)
- [x] (auth) FCM 디바이스 토큰 등록 M6에서 실 FCM 토큰으로 교체 — M6 Task 6.6(서명 키 + GoogleService-Info.plist) 완료 후 AuthRepository.registerDeviceToken 호출 변경 예정
- [x] (mobile/reading) Android foreground service 네이티브 설정 — `FOREGROUND_SERVICE` · `FOREGROUND_SERVICE_DATA_SYNC` · `WAKE_LOCK` 권한 + `BackgroundService` 서비스 선언 + `ic_bg_service.xml` drawable 추가. Dart bridge(`timer_lifecycle.dart`)에 실제 `FlutterBackgroundService` 호출 연결 완료 (2026-04-26)
- [x] (mobile/reading) 수동 기록 모달에 책 선택기 추가 — `userBookId` optional 전환 + `_BookPicker` (읽는 중 서재 horizontal ChoiceChip 리스트) 내장. library detail 3-dot 진입 시 id 전달하면 picker 스킵 (2026-04-26)
- [x] (mobile/reading) 주간 목표 daily slice 동적 계산 — `target / 7` (flat) → `target / (8 - weekday)` (월요일=7일, 일요일=1일 분배) 로 변경, 주 후반 catch-up 압박 구현 (2026-04-26)
- [x] (mobile/reading) TimerRing progress 시각 — 목표 비례 방식(`elapsed / goalSeconds`) M15에서 구현. 목표 달성 시 Chip 표시 추가 (timer_screen.dart)
- [x] (challenge) 챌린지 어드민 생성 API / 시드 스크립트 — M12에서 `POST /admin/challenges`, `POST /admin/badges` + `scripts/seed_challenges.py` 구현 완료
- [x] (challenge) evaluate_progress → reading 이벤트 연결 — M12에서 `ReadingSessionCompleted` / `UserBookCompleted` / `UserGradeRecomputed` 3핸들러 구현 완료
- [x] (mobile/design) 다크 모드 완성 — 전체 위젯을 Theme.colorScheme 로 마이그레이션하고 ThemeMode.light 고정 해제. jan-dee bucket 은 alphaBlend 로 양쪽 캔버스에서 opacity ladder 유지, 브랜드 고정(Kakao/Apple/plusMagenta) 은 그대로 — 맥락: 사용자 Chrome 테스트 피드백 (2026-04-23 완료)
- [x] (mobile/reading) 목표 화면 재구성 — "올해의 독서 여정" 단일 흐름으로 재구성 완료 (commit `81eb4c5`, 2026-04-25)
- [x] (mobile/login) 로그인 화면 중앙 illustration — SVG 에셋 대신 `_BookStackPainter` CustomPainter(3권 책 쌓기)로 M15에서 구현. 테마 색상 반응형, 다크 모드 대응

### 2026-06-03 (경쟁 분석·기술 감사 결과)

- [x] (social) 연말/상반기 독서 회고 카드 (4종) + SNS 공유 — M22 `v0.1.3-m22` 완료 (2026-06-04)
- [x] (social) 서재 SNS 캡처 최적화 — M22 `v0.1.3-m22` RepaintBoundary + share_plus 구현 완료 (2026-06-04)
- [x] (reading) 독서 통계 탭 강화 — M21 `v0.1.2-m21` GET /me/reading-stats 5개 지표 구현 완료 (2026-06-04)
- [x] (club) 그룹 채팅 / 실시간 메시지 — Phase 6 M23-M24 편입 (2026-06-04)
- [ ] (discovery) 딥러닝 추천 (딥 협업 필터링 / 콘텐츠 기반 임베딩) — 활성 사용자 1만 이상 확보 후 Phase 7 검토 (2026-06-04)

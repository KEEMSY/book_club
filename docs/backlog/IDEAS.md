# Backlog — 아이디어 & 개선안 저장소

작업 중 떠오른 Phase 범위 밖 아이디어를 여기에 기록한다. 규칙은 `CLAUDE.md` §8 참조.

## 포맷

```
- [ ] (<domain>) <아이디어 한 줄> — 맥락: <당시 진행 중이던 작업> (YYYY-MM-DD)
```

- 완료: `[x]` 로 체크하고 구현 PR 번호를 괄호에 남긴다. 예: `[x] ... (#42)`
- 폐기: `~~취소선~~` 처리 후 사유를 한 줄로 남긴다.

## Phase 전환 리뷰 기록

### Phase 15 → Phase 16 전환 리뷰 (2026-06-24)

- 리뷰 문서: `docs/plans/2026-06-24-phase16.md`

**Phase 15 완료 확인**: M66(공개 출시 안정화) + M67(AI 개인화 심화) + M68(커뮤니티 2단계) + M69(검색·발견 고도화) + M70(B2B 수익화) 전부 완료. 태그 `v1.2.0`.

**Phase 15 보류 항목 처리**:
- **편입 (M71)**: (infra) Agora RTC 실 연동 — M68 스텁(AgoraStubAdapter) → 실 Agora SDK 교체
- **편입 (M71)**: (community) 카카오맵 SDK 실 연동 — M64/M68 지도뷰 플레이스홀더 → kakao_map_plugin 교체
- **보류 유지 (Phase 17)**: (audio) 실 오디오 코칭 심화(ElevenLabs TTS) — M67 flutter_tts MVP 반응 데이터 3개월 수집 후 결정
- **보류 유지 (Phase 17)**: (discovery) 딥러닝 추천 — MAU 1만 미달 시 Phase 17 재검토
- **보류 유지 (Phase 17)**: (social) 인플루언서 독서 챌린지 파트너십 — 마케팅 예산 확정 후

**신규 편입 (Phase 16)**:
- **편입 (M72)**: (i18n) 국제화 인프라 — flutter_localizations, ARB 파일, 영어·일본어 1차 번역, 백엔드 Accept-Language 처리
- **편입 (M73)**: (web) Flutter Web MVP — 웹 빌드 파이프라인, 반응형 레이아웃, PWA manifest, GitHub Pages 스테이징
- **편입 (M74)**: (infra) 인프라 고도화 — Fly.io 멀티 리전(Tokyo + Singapore), DB 커넥션 풀링(PgBouncer), CDN 이미지 최적화
- **편입 (M75)**: (dx) 개발자 경험 & 품질 강화 — E2E 테스트 인프라(Patrol), 코드 커버리지 게이트, OpenAPI 자동 생성 클라이언트

---

### Phase 14 → Phase 15 전환 리뷰 (2026-06-22)

- 리뷰 문서: `docs/plans/2026-06-22-phase15.md`

**Phase 14 완료 확인**: M61(ASO·공개출시) + M62(SNS 바이럴 루프) + M63(AI 어시스턴트) + M64(위치 기반 모임) + M65(수익화 최적화) 전부 완료. 태그 `v1.1.0`.

**Phase 14 미완 항목 처리**:
- **편입 (M66)**: (mobile) TrialBanner → 홈 화면 배선 — m65에서 위젯만 생성, 홈 탭 연결 미완
- **편입 (M66)**: (reading) firstCurationCardProvider bookId 불일치 버그 수정 — userBookId를 catalog bookId 자리에 전달

**Phase 15 보류 유지**:
- **보류 유지**: (audio) 실 오디오 코칭 — 큐레이션 카드 반응 데이터 충분해지면 검토 (Phase 10 이후 반복 보류)
- **보류 유지**: (discovery) 딥러닝 추천 — 공개 출시 후 활성 사용자 1만 조건 달성 여부 M66 안정화 후 재평가
- **편입 (M68)**: (social) 독서 모임 영상 통화 통합 — M64 안정화 이후 조건 충족

**신규 편입 (Phase 15)**:
- **편입 (M66)**: (infra) 공개 출시 후 안정화 스프린트 — Sentry P1 트리아지, 성능 회귀, UX 피드백 반영
- **편입 (M67)**: (ai) AI 개인화 심화 — 큐레이션 카드 피드백 루프, 오디오 독서 코치 MVP
- **편입 (M68)**: (community) 커뮤니티 2단계 — 오프라인 모임 지도뷰, 영상 통화 통합
- **편입 (M69)**: (discovery) 검색·발견 고도화 — 맞춤 책 큐레이션 채널, 조건부 딥러닝 추천
- **편입 (M70)**: (monetization) 수익화 2단계 — B2B 팀 플랜 탐색, MRR 최적화

---

### Phase 13 → Phase 14 전환 리뷰 (2026-06-21)

- 리뷰 문서: `docs/plans/2026-06-21-phase14.md`
- 시장 분석: `docs/2026-06-21-market-analysis-v2.md` (딥리서치 3차)

**Phase 13 완료 확인**: M56(기술 부채 청산) + M57(앱스토어 메타데이터·온보딩) + M58(CI/CD) + M59(프로덕션 배포) + M60(소프트 런치) 전부 완료. 태그 `v0.1.0`.

**Phase 13 보류 항목 처리**:
- **보류 유지 (Phase 15)**: (audio) 실 오디오 코칭 — 반응 데이터 미확보
- **보류 유지 (Phase 15)**: (discovery) 딥러닝 추천 — 활성 사용자 1만 조건 미충족 (소프트 런치 직후)
- **보류 유지 (Phase 15)**: (social) 독서 모임 영상 통화 통합 — M64 오프라인 모임 안정화 후

**신규 편입 (Phase 14) — 딥리서치 3차 기반**:
- **편입 (M61)**: (growth) 앱스토어 공개 출시 & ASO — TestFlight·내부 테스트 → 공개 배포, 인앱 리뷰
- **편입 (M62)**: (social) SNS 인증 카드 고도화 — 5종 템플릿, 비율 선택, 딥링크 QR, 공유 이벤트 추적
- **편입 (M63)**: (ai) AI 독서 어시스턴트 (Claude API) — 독서 전 준비카드(무료), 완독 성찰 가이드(Pro), 클럽 토론 주제
- **편입 (M64)**: (community) 위치 기반 오프라인 모임 강화 — 카카오맵 연동, 번개 모임, 대기 명단, 모임 후 리뷰
- **편입 (M65)**: (monetization) 수익화 전환율 최적화 — A/B 실험 결과 적용, 얼리버드 연간 캠페인, Pro 7일 체험, MRR 추적

### Phase 12 전환 리뷰 (2026-06-17)

- 리뷰 문서: `docs/plans/2026-06-17-phase12.md`
- **편입 (M51)**: (social) 독서 노트 & 하이라이트 소셜 공유 — visibility 토글, 피드 HIGHLIGHT_SHARED 이벤트, 탐색 화면
- **편입 (M52)**: (club) 클럽 AI 독서 코치 — 주간 계획 자동 생성, 진도 알림, Pro 게이트
- **편입 (M53)**: (monetization) Pro 연간 플랜 + 고급 통계 — 연간 59,000원, 장르 파이차트, 연간 비교
- **편입 (M54)**: (social) 책 리뷰 & 평점 — 완독 후 별점 1–5, 리뷰 피드 카드, 신고 자동 숨김
- **편입 (M55)**: (infra) 안정화 & UX 스프린트 — Sentry 트리아지, P99 쿼리 최적화, 스켈레톤 UI
- **보류 (Phase 13)**: (audio) 실 오디오 코칭, (discovery) 딥러닝 추천, (social) 영상 통화 통합

### Phase 11 완료 리뷰 (2026-06-16)

- **완료 (M46)**: (engagement) 리텐션 & 재참여 강화 — 7일 이탈 감지, 재참여 푸시, 스트릭 복구 메커니즘, LastActiveMiddleware
- **완료 (M47)**: (social) 소셜 피드 강화 — feed_event_reactions/feed_comments 테이블, 이모지 5종 리액션, 댓글 2뎁스 BottomSheet
- **완료 (M48)**: (discovery) 클럽 발견 강화 — club_tags/category, AI 코사인 유사도 추천 TOP5, Redis 1h 캐시, PublicClubsScreen 리뉴얼
- **완료 (M49)**: (monetization) IAP 쉴드 구매 — shield_purchases 테이블, ShieldPurchaseService(구매·환불), ShieldPurchaseSheet UI
- **완료 (M50)**: (infra) 성능 & 모니터링 — cache_response 데코레이터, Prometheus/Grafana APM, Sentry(백엔드+Flutter)
- **보류 (Phase 12)**: (audio) 실 오디오 코칭, (discovery) 딥러닝 추천, (monetization) Pro 연간 할인 캠페인
- Phase 11 종료 태그: v0.8.0 (2026-06-16)

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

- [x] (book) Book 모델에 page_count 컬럼 추가 — M56 migration 0039 + 네이버/카카오 어댑터 파싱 완료 (feat(M56) 08c4941)
- [x] (mobile) RevenueCat SDK(purchases_flutter) 추가 — M56 purchases_flutter ^10.3.0 + Purchases.configure() + purchasePackage() 완료 (feat(M56) 08c4941)
- [x] (book) M2 한줄리뷰(/me/library/.../review)와 M54 book_reviews 통합 — M56에서 M2 엔드포인트 폐기, M54 WriteReviewSheet로 일원화 완료 (feat(M56) 08c4941)
- [x] (book) BookApi.getBookReviews(M2) + BookReviewDto 등 데드 엔드포인트 정리 — M56 데드코드 전량 제거 완료 (feat(M56) 08c4941)

### Phase 12 완료 리뷰 (2026-06-18)

**편입 (Phase 13)**:
- (book) page_count 컬럼 추가 — M52 weekly_pages 계산 정확도
- (mobile) RevenueCat SDK(purchases_flutter) 실 연동 — M53 연간 구독 완성
- (book) M2 한줄리뷰 + M54 book_reviews 통합/폐기 결정

**보류 (Phase 13 이후)**:
- (audio) 실 오디오 코칭 — 반응 데이터 확보 후
- (discovery) 딥러닝 추천 — 활성 사용자 1만 이상 확보 후
- (social) 독서 모임 영상 통화 통합

**Phase 12 완료 요약**: M51(하이라이트 소셜) + M52(클럽 AI 코치) + M53(Pro 연간 플랜) + M54(책 리뷰&평점) + M55(안정화) — 독서 경험 심화 & 수익화 확대 완료. 클럽 테스트 23 passed 복원, 오프라인 배너 및 스켈레톤 UI 전체 적용.

### 2026-06-21 (Phase 14 진행 중 발견)

- [x] (reading) `firstCurationCardProvider`가 `bookId` 파라미터에 `userBookId`(UserBook UUID)를 전달 — M66에서 `widget.bookId`(catalog UUID)로 교체 완료. bookId 없을 때 pre-fetch 스킵 처리 (feat(M66) 68a78a7)

### 2026-06-24 (Phase 16 M71 SDK 연동 중 발견)

- [ ] (video) `AgoraRtcTokenAdapter`는 단순 HMAC-SHA256 서명 토큰 — Agora 공식 AccessToken2 바이너리 포맷이 필요해지면 `agora-token-builder`로 교체 — 맥락: M71 Agora 실 연동 (2026-06-24)
- [ ] (event) 카카오맵 마커 클러스터링(`Clusterer`) 적용 — 이벤트 밀집 지역 가독성. 현재는 단순 마커 1:1 — 맥락: M71 카카오맵 연동 (2026-06-24)
- [ ] (video) Agora 카메라/마이크 런타임 권한 거부 시 안내 UX(설정 이동 유도) — 현재는 요청만 하고 거부 시 빈 영상. `permission_handler` openAppSettings 활용 — 맥락: M71 (2026-06-24)
- [ ] (event) `kakao_map_plugin`은 webview 기반(0.3.x) — 성능/네이티브 마커 필요 시 네이티브 SDK 래퍼로 재검토. 계획서의 `^2.1.1`은 pub.dev 미존재 — 맥락: M71 (2026-06-24)

### 2026-06-24 (Phase 16 M73 Flutter Web 진행 중 발견)

- [ ] (mobile) `dart:io` 직접 import 7개 파일 웹 호환 처리 — `flutter build web` 컴파일 차단 블로커. `dart:io`는 웹에서 미지원이라 조건부 import(`dart.library.io` / `dart.library.html`) 또는 `kIsWeb` 분기 + 플랫폼 추상화 필요. 대상: `core/network/dio_provider.dart`, `reading/application/timer_lifecycle.dart`, `reading/application/timer_notifier.dart`, `auth/data/apple_login_adapter.dart`, `auth/application/auth_notifier.dart`, `auth/presentation/login_screen.dart`, `auth/data/kakao_login_adapter.dart` — 맥락: M73 웹 빌드 파이프라인 구축 (2026-06-24)

### 2026-08-06 (BC-42 발제문 모임 에픽 마감 시 발견)

- [ ] (monetization) **유료 모임 후속 에픽** — 모임/회차 단위 유료 입장·결제·정산. BC-42에서 데이터 모델 훅만 심어둠(`reading_clubs.access_type`/`join_price_cents`, `club_sessions.access_tier`/`price_cents`, 현재 전부 미사용). 필요한 것: (1) 가입 게이팅 로직(open/approval/paid), (2) 결제 연동(RevenueCat/PG), (3) 호스트 정산, (4) 유료 모임 발견·환불 정책. 트레바리형 시즌제 참고 — 맥락: BC-42 발제문 모임(유료화는 훅만) (2026-08-06)
- [ ] (mobile) 모임 회차/발제문/토론 **실 UI E2E 자동화** — BC-49~52는 fake, BC-60에서 실 REST 배선했으나 위젯 테스트는 mock 기준. Chrome MCP 로컬 E2E(회차 생성→발제문 게시→논제 토론)를 CI에 편입할지 검토 — 맥락: BC-54 마감(E2E는 로컬 스택 기동 필요로 수동 확인) (2026-08-06)
- [ ] (mobile) 피드 알림 `session_opened` ntype는 실제 발화되는 알림이 없음(BC-48은 agenda_published·discussion_commented만 푸시) — BC-52가 추가한 해당 라우팅 case는 dead. 정리하거나 향후 회차 오픈 알림 추가 시 활용 — 맥락: BC-52/BC-60 (2026-08-06)

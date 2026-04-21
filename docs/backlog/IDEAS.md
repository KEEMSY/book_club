# Backlog — 아이디어 & 개선안 저장소

작업 중 떠오른 Phase 범위 밖 아이디어를 여기에 기록한다. 규칙은 `CLAUDE.md` §8 참조.

## 포맷

```
- [ ] (<domain>) <아이디어 한 줄> — 맥락: <당시 진행 중이던 작업> (YYYY-MM-DD)
```

- 완료: `[x]` 로 체크하고 구현 PR 번호를 괄호에 남긴다. 예: `[x] ... (#42)`
- 폐기: `~~취소선~~` 처리 후 사유를 한 줄로 남긴다.

## Phase 전환 리뷰 기록

- (아직 없음) 각 Phase 시작 전 리뷰를 진행하고 결과를 본 섹션에 요약한다.

---

## Ideas

### 2026-04-20

- (초기 기획 단계에서 Phase 2 이후로 분류된 후보)
  - [ ] (social) 팔로우·차단·신고 등 소셜 그래프 — 맥락: MVP 범위 선정 중 (2026-04-20)
  - [ ] (reading) 하이라이트·메모 저장 및 책 그룹 공유 — 맥락: 추가 기능 후보 B (2026-04-20)
  - [ ] (engagement) 기간·테마형 독서 챌린지 — 맥락: 추가 기능 후보 H (2026-04-20)
  - [ ] (engagement) 행동 기반 배지 수집 — 맥락: 추가 기능 후보 I (2026-04-20)
  - [ ] (discovery) 독서 이력 기반 책 추천 — 맥락: 추가 기능 후보 K (2026-04-20)
  - [ ] (discovery) 읽고 싶은 책 위시리스트 및 공유 — 맥락: 추가 기능 후보 L (2026-04-20)
  - [ ] (community) 책 그룹 내 정기 모임(온/오프) 이벤트 — 맥락: 추가 기능 후보 G (2026-04-20)

- [x] (design) Claude (Anthropic) 디자인 시스템을 Flutter 테마(ColorScheme · TextTheme · grade_theme)에 적용 — 맥락: M0 Flutter 스캐폴드 완료 직후 사용자 요청으로 M0 범위 내 편입 (2026-04-20)
- [x] (design) 디자인 시스템 교체 — Claude → Apple (awesome-design-md/design-md/apple/DESIGN.md) · 네이밍 중립화(AppPalette·AppTypography 등)로 향후 디자인 시스템 교체 용이성 확보 — 맥락: M0 완료 후 사용자 요청 (2026-04-20)
- [x] (design) 디자인 시스템 교체 — Apple → Airbnb (2030 여성 타겟, 감각적·직관적, 따뜻한 팔레트·세리프 헤드라인·감성 카드 UX) — 맥락: M1 백엔드 진행 중 사용자 디자인 피드백 반영 (2026-04-20)
- [ ] (auth) Kakao contract 재조정 — 현재 백엔드 `POST /auth/kakao` 는 `{ code }` 를 받고 내부에서 kauth.kakao.com/oauth/token 으로 access_token 교환 후 user info 를 호출하지만, Kakao Flutter SDK (`kakao_flutter_sdk_user`) 는 모바일에서 code 없이 access_token 만 반환. 모바일은 임시로 access_token 을 `code` 필드로 전송 중. 해결 방향: (a) schema 를 `{ access_token }` 으로 rename + 어댑터의 token 교환 스텝 skip, (b) 두 필드 동시 허용, (c) 새 엔드포인트 분리. M2 진입 직전에 결정 후 적용 필수(실제 로그인이 안 됨) — 맥락: M1 Mobile 완료 후 발견된 contract gap (2026-04-20)
- [ ] (mobile/login) 로그인 화면 중앙 illustration 자리에 실제 에디토리얼 SVG 적용 — 현재 Rausch 10% 틴트 + 책 아이콘 placeholder. 2030 여성 타겟의 매거진 톤 강화 — 맥락: M1 Mobile 로그인 스크린 폴리시 후보 (2026-04-20)
- [ ] (mobile/auth) Kakao 공식 브랜드 SVG 아이콘 교체 — 현재 Material `chat_bubble` 사용. 앱스토어 심사 전 필수 — 맥락: M1 완료 후 QA 단계 (2026-04-20)
- [ ] (auth) retrofit + custom_lint 의존성 버전 정리 — retrofit `<4.5` 고정 + analyzer_plugin `^0.13.0` override 상태. custom_lint 0.8+ / retrofit_generator 호환 버전 나오는 대로 해제 — 맥락: M1 Mobile 구현 시 freezed/custom_lint/analyzer 버전 충돌 해결 (2026-04-20)
- [ ] (auth) FCM 디바이스 토큰 등록은 M5 로 공식 이관 — AuthRepository.registerDeviceToken 메서드는 wiring 완료, M5 에서 실 FCM 토큰으로 호출 — 맥락: M1 에서는 placeholder 토큰 등록 대신 deferral 선택 (2026-04-20)

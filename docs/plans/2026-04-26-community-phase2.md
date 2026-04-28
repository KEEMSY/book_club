---
title: Book Club — Phase 2 커뮤니티 화면 구현 계획
version: 0.1.0
status: draft
author: sy
created: 2026-04-26
---

# Book Club — Phase 2 커뮤니티 화면 구현 계획

## 1. 배경 및 목표

Phase 1(MVP)에서 개인 독서 기록(타이머·히트맵·등급)과 책 단위 피드(M4)가 완성됐다.
그러나 앱의 소셜 레이어는 '책 상세 하단 댓글 구역'에 고립되어 있어 사용자가 의도적으로 탐색하지 않으면 다른 독자의 활동을 발견하기 어렵다.

Phase 2의 핵심 목표:

1. **발견성**: 전용 커뮤니티 탭을 추가해 사회적 활동이 앱 진입 경로에 드러나게 한다.
2. **관계**: 팔로우 그래프를 도입해 관심 독자를 구독하고 피드를 개인화한다.
3. **동기부여 확장**: 챌린지·배지 시스템으로 등급 외 두 번째 동기부여 레이어를 추가한다.
4. **안전성**: 신고·차단 정책을 구축해 콘텐츠 안전망을 형성한다.

---

## 2. 커뮤니티 탭 전체 화면 구조

### 2.1 하단 네비게이션 변경

현행 3탭 → 4탭으로 확장한다.

```
홈 | 검색 | 커뮤니티(신규) | 서재
```

탭 순서 결정 이유: 서재는 개인 공간이므로 우측 끝에 위치시키고,
커뮤니티를 검색과 서재 사이에 배치해 탐색(검색) → 대화(커뮤니티) → 보관(서재) 흐름을 유도한다.

### 2.2 커뮤니티 탭 내부 화면 계층

```
/community                         # 커뮤니티 홈 (피드 + 챌린지 배너)
  /community/feed                  # 팔로잉 피드 (전체 포스트 타임라인)
  /community/explore               # 탐색 피드 (비팔로잉 포스트 + 추천)
  /community/challenges            # 챌린지 목록 / 내 챌린지
  /community/challenges/:id        # 챌린지 상세 (참여자·진행 현황·리더보드)
  /community/badges                # 배지 컬렉션 (내 배지 + 전체 배지 도감)

/users/:id                         # 사용자 프로필 (팔로워·팔로잉·포스트·배지)
  /users/:id/followers             # 팔로워 목록
  /users/:id/following             # 팔로잉 목록
```

커뮤니티 탭 내부는 두 개의 서브탭(팔로잉 / 탐색)으로 시작하고,
챌린지·배지는 커뮤니티 홈 상단 배너에서 진입한다.

---

## 3. 기능 명세

### 3.1 커뮤니티 홈 (`/community`)

**역할**: 커뮤니티 탭의 루트. 팔로잉 피드가 기본 뷰이며, 진행 중 챌린지 배너가 상단에 고정된다.

**핵심 기능**:

- 상단 고정 배너: 현재 참여 중인 챌린지 D-day 카드 (최대 1개; 없으면 숨김)
- 서브탭 스위처: 팔로잉 / 탐색
- 플로팅 액션 버튼(FAB): 포스트 작성 → 책 선택 → `/books/:id/posts/new` 로 라우팅
- 팔로잉이 0명이고 포스트가 없을 때: 온보딩 빈 상태 (추천 독자 3인 + 진행 챌린지 1개 표시)

**UI 컴포넌트**:

| 컴포넌트 | 설명 |
|---|---|
| `ChallengeProgressBanner` | 참여 챌린지 진행률 바 + D-day 텍스트 |
| `FeedSubTabBar` | 팔로잉 / 탐색 2탭 스위처 |
| `PostCard` | 기존 feed 도메인 포스트 카드 재사용 + 작성자 아바타·닉네임 추가 |
| `CommunityEmptyState` | 온보딩 빈 상태 위젯 |

**사용자 스토리**:

- 독자로서, 내가 팔로우한 사람들의 최신 포스트를 한 곳에서 볼 수 있다. 그래야 개별 책 상세를 탐색하지 않고도 독서 커뮤니티 활동을 파악할 수 있다.
- 독자로서, 팔로잉이 없어도 커뮤니티 탭에서 활동 중인 독자와 챌린지를 바로 발견할 수 있다. 그래야 소셜 그래프 형성의 진입 장벽을 낮출 수 있다.

**수락 기준**:

- 팔로잉 포스트가 최신순으로 로드되며 무한 스크롤(페이지당 20개)이 동작한다.
- FAB 탭 시 책 선택 바텀시트 → 책 선택 후 `/books/:id/posts/new`로 이동한다.
- 팔로잉 0명 상태에서 추천 독자 카드가 3개 이상 표시된다.

---

### 3.2 팔로잉 피드 (`/community` → 팔로잉 서브탭)

**역할**: 내가 팔로우한 사용자들의 포스트 타임라인.

**핵심 기능**:

- 작성자 정보(아바타·닉네임·등급 배지)가 포스트 카드 상단에 표시된다.
- 포스트 카드에서 작성자 닉네임 탭 → 사용자 프로필로 이동한다.
- 포스트 카드에서 책 표지/제목 탭 → 책 상세로 이동한다.
- 리액션·댓글은 기존 feed 도메인 로직 그대로 재사용한다.
- 우측 상단 더보기(···) 메뉴: 신고 / 차단 (작성자가 나 자신이면 삭제)

**페이지네이션**: cursor 기반 (created_at + id 복합 커서). 스크롤 하단 도달 시 다음 페이지 fetch.

---

### 3.3 탐색 피드 (`/community` → 탐색 서브탭)

**역할**: 팔로잉 여부와 무관하게 활동이 활발한 포스트·사용자 탐색.

**핵심 기능**:

- 정렬 옵션 칩: 최신 / 인기 (리액션 수 기준, 최근 7일)
- 포스트 카드 위에 "이 책을 읽은 독자 N명" 맥락 텍스트 표시
- 작성자 카드 하단 팔로우 버튼 인라인 노출 (팔로잉 상태면 팔로잉 표시)
- 탭 내 검색창: 닉네임·책 제목으로 필터

---

### 3.4 사용자 프로필 (`/users/:id`)

**역할**: 특정 사용자의 독서 활동·포스트·배지를 공개하는 페르소나 페이지.

**핵심 기능**:

- 헤더: 프로필 이미지, 닉네임, 등급 배지, 소개글(최대 100자), 팔로워 수·팔로잉 수
- 팔로우 / 팔로잉 토글 버튼 (내 프로필이면 프로필 편집 버튼으로 대체)
- 서브탭: 포스트 / 완독 / 배지
  - 포스트 탭: 해당 사용자가 작성한 포스트 그리드 또는 리스트
  - 완독 탭: 완독한 책 표지 그리드 (공개 설정 시)
  - 배지 탭: 획득 배지 목록 (미획득 배지는 흑백 잠금 처리)
- 차단된 사용자 프로필 접근 시: "이 사용자의 콘텐츠를 볼 수 없습니다" 빈 상태

**UI 컴포넌트**:

| 컴포넌트 | 설명 |
|---|---|
| `UserProfileHeader` | 아바타·등급배지·닉네임·팔로우 버튼 |
| `ProfileSubTabBar` | 포스트 / 완독 / 배지 3탭 |
| `PostGrid` / `PostList` | 포스트 카드 그리드 또는 리스트 뷰 |
| `BookCoverGrid` | 완독 책 표지 그리드 |
| `BadgeGrid` | 배지 그리드 (획득·미획득 구분) |

**사용자 스토리**:

- 독자로서, 다른 독자의 프로필에서 그 사람이 어떤 책을 읽었는지, 어떤 글을 남겼는지 한눈에 파악할 수 있다.
- 독자로서, 프로필에서 팔로우 버튼을 바로 누를 수 있다.

**수락 기준**:

- 팔로워·팔로잉 수를 탭하면 해당 목록 화면으로 이동한다.
- 본인 프로필에서 팔로우 버튼은 렌더링되지 않고 프로필 편집 버튼이 노출된다.
- 차단한 사용자 프로필은 콘텐츠 없이 빈 상태 문구만 표시된다.

---

### 3.5 챌린지 목록 (`/community/challenges`)

**역할**: 진행 중·예정·완료된 챌린지를 탐색하고 참여한다.

**핵심 기능**:

- 서브탭: 진행 중 / 내 챌린지 / 지난 챌린지
- 챌린지 카드: 제목, 테마 색, 기간(D-day), 참여자 수, 참여 여부 표시
- 참여 버튼: 탭 즉시 참여 (별도 폼 없이; 참여 후 버튼이 "참여 중"으로 전환)
- 챌린지 카드 탭 → 챌린지 상세로 이동

---

### 3.6 챌린지 상세 (`/community/challenges/:id`)

**역할**: 챌린지 규칙·진행 현황·참여자 리더보드·관련 포스트 확인.

**핵심 기능**:

- 헤더: 챌린지 이름, 기간, 달성 조건 설명 (예: "4월 동안 3권 완독")
- 내 진행 상황 카드: 달성률 프로그레스 바 + 달성 조건별 체크리스트
- 리더보드: 참여자 상위 10명 (달성 진행률 기준, 동률 시 먼저 참여한 사람 우선)
- 관련 포스트 탭: 해당 챌린지 해시태그·연결 포스트 모음
- 달성 시 배지 자동 수여 알림 및 배지 프리뷰 표시

---

### 3.7 배지 컬렉션 (`/community/badges`)

**역할**: 내가 획득한 배지와 전체 배지 도감 표시.

**핵심 기능**:

- 섹션 분리: 독서 활동 배지 / 챌린지 배지 / 소셜 배지
- 각 배지 카드: 아이콘, 이름, 달성 조건 한 줄 요약, 획득 날짜(획득 시)
- 미획득 배지: 흑백 처리, 달성 조건만 표시 (진행률 바 포함 가능)
- 배지 탭 시 바텀시트: 배지 상세 (전체 달성 조건, 몇 명이 획득했는지 카운트)

**사용자 스토리**:

- 독자로서, 어떤 배지가 있는지 미리 볼 수 있고, 다음 달성 목표를 스스로 선택할 수 있다.

---

## 4. 소셜 그래프 — 팔로우·신고·차단 정책

### 4.1 팔로우

| 항목 | 정책 |
|---|---|
| 방향 | 단방향 (Twitter/X 모델). A가 B를 팔로우해도 B는 A를 자동 팔로우하지 않는다. |
| 맞팔 표시 | 상호 팔로우 시 "맞팔" 뱃지 표시 (선택적 UI 요소, v1에서는 생략 가능) |
| 팔로잉 피드 | 팔로우한 모든 사용자의 포스트가 시간순으로 표시된다. |
| 공개 범위 | 모든 사용자 프로필은 기본 공개. 비공개 계정은 Phase 3 이후 검토. |
| 알림 | 누군가 나를 팔로우하면 인앱 알림 + (선택 설정) 푸시 알림. |
| 한도 | 팔로잉 최대 1,000명 (스팸 방지). 팔로워 수 제한 없음. |

### 4.2 차단

| 항목 | 정책 |
|---|---|
| 차단 시 효과 | 차단한 사용자의 포스트가 내 피드에서 즉시 사라진다. 차단된 사용자는 내 프로필·포스트를 볼 수 없다. |
| 팔로우 해제 | 차단 시 기존 팔로우·팔로잉 관계가 양방향 모두 자동 해제된다. |
| 차단 목록 | 설정 화면에서 차단 목록 관리 가능. 차단 해제 시 팔로우는 복원되지 않는다. |
| 차단 사실 | 차단 사실을 차단된 사용자에게 알리지 않는다. |

### 4.3 신고

| 항목 | 정책 |
|---|---|
| 신고 대상 | 포스트, 댓글, 사용자 프로필 |
| 신고 유형 | 스팸·광고 / 불쾌한 콘텐츠 / 저작권 위반 / 기타 |
| 신고 처리 | 신고 접수 즉시 신고 내역 DB 저장. 관리자 검토 후 조치 (Phase 2에서는 수동 검토). 자동 임시 숨김은 단기간에 동일 포스트 신고가 N건 누적 시 적용 (N=5, 운영 시 조정). |
| 신고자 보호 | 신고 사실을 신고 대상 사용자에게 노출하지 않는다. |
| 누적 제재 | 동일 계정에 대한 신고가 임계치를 넘으면 계정 정지 검토 (운영 정책, 코드 범위 밖). |

---

## 5. 챌린지 시스템

### 5.1 챌린지 유형

| 유형 | 설명 | 예시 |
|---|---|---|
| 기간형 | 특정 기간 내 독서량·권수 달성 | "4월 한 달 3권 완독" |
| 테마형 | 특정 장르·주제 책을 읽는 챌린지 | "SF 소설 2권 읽기" |
| 시간형 | 누적 독서 시간 달성 | "30일 동안 50시간 기록" |
| 연속형 | 연속 독서 스트릭 달성 | "21일 연속 독서" |

Phase 2에서는 운영자가 관리자 도구(백엔드 직접 등록 또는 간단한 어드민 API)로 챌린지를 생성한다. 사용자 자체 챌린지 생성은 Phase 3 이후 검토.

### 5.2 달성 판정

| 챌린지 유형 | 판정 데이터 소스 | 판정 주기 |
|---|---|---|
| 권수 달성 | `UserBook.status = completed` AND `completed_at` in 챌린지 기간 | 완독 이벤트 발생 시 즉시 |
| 시간 달성 | `ReadingSession.source = timer` AND `started_at` in 기간 누적 | 세션 종료 이벤트 발생 시 |
| 스트릭 달성 | `DailyReadingStat` 연속일 체크 | 매일 자정 배치 또는 세션 종료 시 |
| 장르 달성 | `Book.genre` (네이버/카카오 API 메타데이터) + `completed_at` in 기간 | 완독 이벤트 발생 시 |

달성 확인은 `challenge` 도메인 Service 내에서 reading 도메인 Service를 호출하여 집계한다. 직접 `ReadingSession` 테이블을 건드리지 않는다(도메인 경계 준수).

### 5.3 배지 수여 흐름

```
ReadingSession.ended  →  reading.SessionService.end_session()
                      →  (이벤트) challenge.ChallengeService.evaluate_progress(user_id)
                      →  달성 판정 완료 시 Badge 수여
                      →  notification.NotificationService.push_badge_earned()
```

이벤트 연결은 기존 아키텍처와 동일하게 SQLAlchemy `after_commit` 훅 또는 Redis Pub/Sub으로 처리한다 (구현 시 확정).

### 5.4 배지 카탈로그 초안

배지는 세 카테고리로 분류된다.

**독서 활동 배지**

| 배지 이름 | 달성 조건 |
|---|---|
| 첫 책 완독 | 첫 번째 책 완독 |
| 7일 스트릭 | 7일 연속 독서 |
| 30일 스트릭 | 30일 연속 독서 |
| 100일 스트릭 | 100일 연속 독서 |
| 10권 독파 | 누적 완독 10권 |
| 50권 독파 | 누적 완독 50권 |
| 독서 마라톤 | 단일 세션 3시간 이상 |
| 새벽 독서가 | 오전 6시 이전 세션 10회 |

**챌린지 배지**

| 배지 이름 | 달성 조건 |
|---|---|
| 첫 챌린지 완수 | 챌린지 1개 달성 |
| 챌린지 마스터 | 챌린지 5개 달성 |
| 4월 독서 챌린지 | 4월 챌린지 완수 (시즌 배지) |

**소셜 배지**

| 배지 이름 | 달성 조건 |
|---|---|
| 첫 포스트 | 첫 번째 포스트 작성 |
| 소통왕 | 댓글 50개 작성 |
| 팔로워 10 | 팔로워 10명 돌파 |

---

## 6. Backend 도메인 추가 사항

### 6.1 신규 도메인

| 도메인 | 책임 |
|---|---|
| `social` | 팔로우 관계, 차단, 신고 |
| `community` | 커뮤니티 피드 집계 (팔로잉 타임라인, 탐색 피드) |
| `challenge` | 챌린지 CRUD, 참여, 달성 판정, 배지 수여 |

기존 `feed` 도메인은 책 단위 포스트·리액션·댓글을 그대로 유지한다.
`community` 도메인은 `feed` 도메인의 포스트를 집계·재정렬해 반환하는 뷰 레이어 역할이며, 포스트 원본 데이터는 건드리지 않는다.

### 6.2 신규 엔드포인트 목록

**social 도메인**

```
POST   /social/follow/{target_user_id}          # 팔로우
DELETE /social/follow/{target_user_id}          # 언팔로우
GET    /social/followers                        # 내 팔로워 목록
GET    /social/following                        # 내 팔로잉 목록
GET    /social/users/{user_id}/followers        # 특정 유저 팔로워 목록
GET    /social/users/{user_id}/following        # 특정 유저 팔로잉 목록

POST   /social/block/{target_user_id}           # 차단
DELETE /social/block/{target_user_id}           # 차단 해제
GET    /social/blocks                           # 내 차단 목록

POST   /social/reports/posts/{post_id}          # 포스트 신고
POST   /social/reports/comments/{comment_id}    # 댓글 신고
POST   /social/reports/users/{user_id}          # 사용자 신고
```

**community 도메인**

```
GET    /community/feed                          # 팔로잉 타임라인 (cursor 페이지네이션)
GET    /community/explore                       # 탐색 피드 (sort=latest|popular)
GET    /community/users/{user_id}/profile       # 사용자 프로필 (포스트·완독·배지 통합)
GET    /community/users/{user_id}/posts         # 사용자 포스트 목록
GET    /community/users/{user_id}/books         # 사용자 완독 목록 (공개)
```

**challenge 도메인**

```
GET    /challenges                              # 챌린지 목록 (status=active|upcoming|ended)
GET    /challenges/{id}                         # 챌린지 상세
POST   /challenges/{id}/join                    # 챌린지 참여
DELETE /challenges/{id}/join                    # 챌린지 탈퇴
GET    /challenges/{id}/leaderboard             # 리더보드 (상위 50명)
GET    /challenges/{id}/posts                   # 챌린지 연결 포스트
GET    /challenges/my                           # 내가 참여한 챌린지 목록

GET    /badges                                  # 전체 배지 도감
GET    /badges/my                               # 내 획득 배지
```

### 6.3 기존 도메인 확장

| 도메인 | 변경 내용 |
|---|---|
| `auth` | `User` 모델에 `bio`, `profile_image_url`, `is_public` 필드 추가. 프로필 편집 엔드포인트 추가. |
| `notification` | 팔로우 알림, 배지 수여 알림 타입 추가 (`follow_received`, `badge_earned`). |
| `feed` | 포스트에 `challenge_id` 외래키 추가 (챌린지 연결 포스트 지원). |

---

## 7. Mobile 화면 목록

### 7.1 신규 Flutter 화면 (`lib/features/`)

```
features/
  community/
    presentation/
      community_home_screen.dart         # 커뮤니티 탭 루트 (팔로잉/탐색 서브탭)
      following_feed_screen.dart         # 팔로잉 피드
      explore_feed_screen.dart           # 탐색 피드
      user_profile_screen.dart           # 사용자 프로필
      follower_list_screen.dart          # 팔로워 목록
      following_list_screen.dart         # 팔로잉 목록
    application/
      community_providers.dart
    data/
      community_repository.dart
      community_api.dart                 # retrofit 정의

  challenge/
    presentation/
      challenge_list_screen.dart         # 챌린지 목록 (진행중/내챌린지/지난)
      challenge_detail_screen.dart       # 챌린지 상세 + 리더보드
      badge_collection_screen.dart       # 배지 컬렉션
    application/
      challenge_providers.dart
    data/
      challenge_repository.dart
      challenge_api.dart

  social/
    application/
      social_providers.dart              # 팔로우/차단 상태 관리
    data/
      social_repository.dart
      social_api.dart
```

### 7.2 기존 화면 수정

| 화면 | 수정 내용 |
|---|---|
| `app_shell.dart` | 4탭으로 확장 (커뮤니티 탭 아이콘·라우트 추가) |
| `app_router.dart` | 커뮤니티·챌린지·소셜 라우트 추가, `StatefulShellBranch` 4번째 브랜치 추가 |
| `book_detail_screen.dart` | 포스트 카드에 작성자 아바타·닉네임 → 프로필 이동 링크 추가 |
| `post_compose_screen.dart` | 챌린지 태그 선택 옵션 추가 (현재 참여 중인 챌린지 목록 드롭다운) |
| `notification_screen.dart` | `follow_received`, `badge_earned` 알림 타입 렌더링 추가 |

### 7.3 신규 공용 위젯 (`lib/shared/widgets/`)

```
user_avatar.dart                # 프로필 이미지 + 등급 배지 오버레이
follow_button.dart              # 팔로우 / 팔로잉 토글 버튼
badge_chip.dart                 # 배지 소형 칩
challenge_progress_bar.dart     # 챌린지 달성률 프로그레스 바
report_bottom_sheet.dart        # 신고 유형 선택 바텀시트
```

### 7.4 라우트 상수 추가 (`AppRoutes`)

```dart
static const community = '/community';
static const explore    = '/community/explore';
static const challenges = '/community/challenges';
static String challengeDetail(String id) => '/community/challenges/$id';
static const badges     = '/community/badges';
static String userProfile(String id) => '/users/$id';
static String followers(String id)   => '/users/$id/followers';
static String following(String id)   => '/users/$id/following';
```

---

## 8. 데이터 모델 초안

세부 컬럼·인덱스·마이그레이션 번호는 각 Milestone 구현 단계에서 Alembic과 함께 확정한다.

### 8.1 social 도메인

```
Follow
  follower_id   FK(users.id)   NOT NULL
  followee_id   FK(users.id)   NOT NULL
  created_at    TIMESTAMPTZ    NOT NULL DEFAULT now()
  PRIMARY KEY (follower_id, followee_id)
  INDEX (followee_id)   -- 팔로워 조회

Block
  blocker_id    FK(users.id)   NOT NULL
  blocked_id    FK(users.id)   NOT NULL
  created_at    TIMESTAMPTZ    NOT NULL DEFAULT now()
  PRIMARY KEY (blocker_id, blocked_id)

Report
  id            UUID           PK
  reporter_id   FK(users.id)   NOT NULL
  target_type   ENUM(post, comment, user)   NOT NULL
  target_id     UUID           NOT NULL
  reason        ENUM(spam, offensive, copyright, other)   NOT NULL
  note          TEXT           NULLABLE   -- 기타 사유 자유 입력
  status        ENUM(pending, reviewed, dismissed)   DEFAULT pending
  created_at    TIMESTAMPTZ    NOT NULL DEFAULT now()
  INDEX (target_type, target_id)
  INDEX (reporter_id)
```

### 8.2 challenge 도메인

```
Challenge
  id              UUID           PK
  title           VARCHAR(100)   NOT NULL
  description     TEXT
  challenge_type  ENUM(books_count, reading_time, streak, genre)   NOT NULL
  target_value    INTEGER        NOT NULL   -- 목표 권수 or 시간(초) or 스트릭 일수
  genre_filter    VARCHAR(50)    NULLABLE   -- challenge_type=genre 일 때
  starts_at       TIMESTAMPTZ    NOT NULL
  ends_at         TIMESTAMPTZ    NOT NULL
  badge_id        FK(badges.id)  NULLABLE   -- 달성 시 수여 배지
  created_at      TIMESTAMPTZ    NOT NULL DEFAULT now()
  INDEX (starts_at, ends_at)

ChallengeParticipant
  challenge_id    FK(challenges.id)   NOT NULL
  user_id         FK(users.id)        NOT NULL
  current_value   INTEGER             NOT NULL DEFAULT 0   -- 현재 달성 값
  achieved_at     TIMESTAMPTZ         NULLABLE             -- 달성 완료 시각
  joined_at       TIMESTAMPTZ         NOT NULL DEFAULT now()
  PRIMARY KEY (challenge_id, user_id)
  INDEX (challenge_id, current_value DESC)   -- 리더보드

Badge
  id          UUID           PK
  name        VARCHAR(100)   NOT NULL
  description TEXT           NOT NULL   -- 달성 조건 설명
  category    ENUM(reading, challenge, social)   NOT NULL
  icon_url    VARCHAR(500)   NOT NULL   -- R2 URL
  created_at  TIMESTAMPTZ    NOT NULL DEFAULT now()

UserBadge
  user_id     FK(users.id)    NOT NULL
  badge_id    FK(badges.id)   NOT NULL
  earned_at   TIMESTAMPTZ     NOT NULL DEFAULT now()
  PRIMARY KEY (user_id, badge_id)
  INDEX (badge_id)   -- "몇 명이 획득했는지" 카운트
```

### 8.3 기존 모델 확장

```
User (auth 도메인 기존 테이블에 컬럼 추가)
  + bio               VARCHAR(100)   NULLABLE
  + profile_image_url VARCHAR(500)   NULLABLE
  + is_public         BOOLEAN        NOT NULL DEFAULT true

Post (feed 도메인 기존 테이블에 컬럼 추가)
  + challenge_id      FK(challenges.id)   NULLABLE
  INDEX (challenge_id)   -- 챌린지 연결 포스트 조회

Notification (notification 도메인 기존 테이블에 타입 추가)
  notification_type: 기존 ENUM에 follow_received, badge_earned 추가
```

---

## 9. 마일스톤 분리 제안

Phase 1 마일스톤이 M1~M6으로 구성되었으므로 Phase 2는 M7부터 시작한다.

| 마일스톤 | 이름 | 핵심 범위 | 예상 기간 |
|---|---|---|---|
| M7 | 소셜 그래프 + 프로필 | 팔로우·차단·신고 백엔드 + 사용자 프로필 화면 + 커뮤니티 탭 뼈대 | 3주 |
| M8 | 커뮤니티 피드 | 팔로잉 타임라인·탐색 피드·포스트 카드 작성자 정보 연동 | 2주 |
| M9 | 챌린지 시스템 | 챌린지 CRUD·참여·달성 판정·배지 수여 백엔드 + 챌린지 화면 | 3주 |
| M10 | 배지 컬렉션 + 알림 확장 | 배지 도감 화면 + 팔로우·배지 알림 타입 + 푸시 연동 | 2주 |
| M11 | QA·폴리시·스테이징 | 신고 플로우 검증, 차단 엣지케이스, 성능 튜닝, 스테이징 배포 | 2주 |

**총 예상 기간**: 약 12주 (3개월)

### 9.1 마일스톤별 품질 게이트

모든 마일스톤은 CLAUDE.md §7.3에 따라 아래 조건 충족 후 종료 커밋 + 태그를 생성한다.

- `dart analyze` 경고 0, `ruff` 오류 0, `mypy --strict` 통과
- 새 Service 클래스에 단위 테스트 존재
- 스테이징 배포 후 에러율 < 1%

태그 규칙: `v0.0.2-m7`, `v0.0.2-m8`, ... `v0.0.2-m11`
Phase 2 완료 태그: `v0.0.2`

---

## 10. 백로그 항목 Phase 2 편입/보류/폐기 분류

`docs/backlog/IDEAS.md`의 Phase 2 이전 미구현 항목에 대한 분류.

| 항목 | 분류 | 마일스톤 | 사유 |
|---|---|---|---|
| (social) 팔로우·차단·신고 등 소셜 그래프 | **편입** | M7 | 커뮤니티 탭 핵심 인프라. 피드 개인화·안전성 모두 여기에 의존. |
| (engagement) 기간·테마형 독서 챌린지 | **편입** | M9 | 커뮤니티 탭의 두 번째 핵심 동기부여 레이어. 백로그 중 사용자 요청 우선순위 최상. |
| (engagement) 행동 기반 배지 수집 | **편입** | M9/M10 | 챌린지 달성과 자연스럽게 결합. 별도 구현 비용이 낮아 함께 편입. |
| (reading) 하이라이트·메모 저장 및 책 그룹 공유 | **보류** | Phase 3 | 커뮤니티 탭 안정화 이후 포스트 타입 확장으로 다루는 것이 더 자연스럽다. Phase 2 범위에 넣으면 `feed` 도메인 리팩토링이 필요해 M9~M10 일정 압박이 된다. |
| (discovery) 독서 이력 기반 책 추천 | **보류** | Phase 3 | 추천 엔진은 독립적인 ML/데이터 파이프라인이 필요하다. Phase 2에서 쌓이는 소셜 그래프·완독 데이터가 추천 입력으로 활용될 수 있으므로, 데이터 축적 이후 Phase 3에서 의미 있는 구현이 가능하다. |
| (discovery) 읽고 싶은 책 위시리스트 및 공유 | **보류** | Phase 3 | `UserBook.status`에 `wishlist` 값을 추가하면 구현 가능하지만, 커뮤니티 피드에서 위시리스트 공유가 가치 있으려면 팔로우 그래프가 먼저 형성되어야 한다. M10 이후 데이터 보고 결정한다. |
| (community) 책 그룹 내 정기 모임(온/오프) 이벤트 | **보류** | Phase 3 이후 | 온/오프라인 이벤트 관리는 별도 캘린더·지도·RSVP 플로우가 필요해 Phase 2 범위에 비해 구현 비용이 크다. 사용자 규모와 수요를 Phase 2에서 확인한 뒤 결정한다. |

---

## 11. 비목표 (이번 Phase에서 명시적으로 제외)

- **DM(다이렉트 메시지)**: 실시간 채팅 인프라(WebSocket 또는 Pusher)가 필요하며 Phase 2 범위에 비해 비용·복잡도가 과하다. Phase 3 이후 검토.
- **비공개 계정**: 공개/비공개 접근 제어 레이어가 모든 피드·프로필 API에 추가되어야 한다. Phase 2 사용자 규모에서는 오버엔지니어링.
- **사용자 직접 챌린지 생성**: 운영 부담(콘텐츠 검수)과 UX 복잡도가 높다. Phase 3 이후 수요 검증 후 결정.
- **추천 알고리즘**: 데이터 파이프라인 미구비 상태에서 의미 있는 추천은 불가하다. 위 §10 보류 항목 참조.
- **웹 지원**: 모바일 앱의 커뮤니티 탭을 먼저 안정화한 뒤 `/mobile/web/` 방향 별도 검토.

---

## Changelog

- **0.1.0** (2026-04-26) — Phase 2 커뮤니티 화면 계획 초안 작성. 화면 구조·소셜 그래프·챌린지 시스템·데이터 모델·마일스톤·백로그 분류 포함.
- **0.2.0** (2026-04-27) — M10 완료: `badge_earned` 알림 타입 추가, `BadgeEarned` 도메인 이벤트, `ChallengeService.award_badge` 구현, `follow_received`·`badge_earned` 모바일 알림 아이콘 + 탭 네비게이션 연결. 태그 `v0.0.2-m10`.
- **0.3.0** (2026-04-28) — M11 완료: `list_challenges` N+1 → 배치 쿼리(3쿼리 고정), 소셜 엣지케이스 5개·알림 핸들러 4개 테스트 추가, mypy strict 오류 수정, ruff format 전체 정렬. 태그 `v0.0.2-m11`. Phase 2 완료.

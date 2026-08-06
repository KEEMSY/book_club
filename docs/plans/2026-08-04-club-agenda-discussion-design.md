---
title: 발제문 기반 구조화 토론 모임
epic: BC-42
version: 1.0.0
status: draft
created: 2026-08-04
owner: 김성연
---

# 발제문 기반 구조화 토론 모임 (Session-based Agenda & Discussion)

기존 `club` 도메인을 확장해, 모임 토론을 "진도 게이팅 자유 채팅"에서 **발제문 기반
구조화 토론**으로 끌어올린다. 배포 전 추가하는 단일 핵심 기능이며, 향후 유료 모임
수익화의 토대가 된다.

관련 에픽: **BC-42** / 하위 태스크: BC-43 ~ BC-54.

## 1. 배경과 문제 (왜)

현재 모임의 토론 수단은 진도 게이팅된 실시간 채팅(`ClubRoom` / `ClubMessage`)뿐이다.
실시간 잡담에는 적합하지만 다음 한계가 있다.

- 토론이 **콘텐츠 자산으로 남지 않는다.** "이 책을 왜 이렇게 읽었는가"라는 해석이
  채팅 스크롤에 묻혀 재방문·검색·공유 유인이 약하다.
- 모임의 **지적 밀도**를 외부에 보여줄 방법이 없어 신규 유입·전환 근거가 부족하다.
- 운영자(호스트)가 토론을 **주도할 도구**가 없다. 좋은 독서모임의 핵심은 발제자가
  준비한 논제로 토론을 이끄는 것이다.

**발제문(agenda)** 은 비동기 구조화 토론의 앵커다. 발제자가 책의 특정 범위에 대해
논제를 던지고, 멤버가 각 논제에 깊이 답하면 토론이 구조를 갖고 축적된다. 이는 국내
유료 독서모임(트레바리류)의 핵심 운영 방식이며, **유료화의 근거(가치)와
단위(회차/시즌)** 를 동시에 만든다.

이번 에픽은 유료화를 **구현하지 않되**, 데이터 모델에 훅(컬럼)만 심어 다음 수익화
에픽이 마이그레이션 충돌 없이 얹히게 한다. (YAGNI — 로직·결제 연동은 후속 에픽)

## 2. 목표 / 비목표

**목표 (In)**

- 모임 하위에 **회차(session)** 개념 도입. 회차는 **특정 책(`book_id`)** 을 참조하며,
  한 모임이 여러 책을 진행하고 책마다 여러 회차·발제문이 쌓인다.
- 회차별 **발제문(agenda)** — 회차당 1..N, 발제자별. 본문 + 게시 상태.
- 발제문 내 **논제(topic)** N개, 순서(position) 지정.
- **논제별 스레드 토론(comment)** — 1단계 대댓글 지원.
- 권한: 회차 생성·발제자 지정 = host / 발제문 작성 = host·presenter / 답글 = 멤버.
- feed·notification 연동, (선택) AI 논제 초안 추천.
- 유료화 훅: `reading_clubs`(모임 레벨) + `club_sessions`(회차 레벨) 컬럼만.

**비목표 (Out — 후속 에픽)**

- 실제 유료 입장/결제/정산 (RevenueCat·PG 연동, 가입 게이팅 로직).
- 발제문 버전 관리·초안 협업, 실시간 동시 편집.
- 논제 다단계(2단계 이상) 대댓글, 리치 텍스트 에디터.

## 3. 도메인 배치

기존 `club` 도메인을 확장한다. 새 하위 도메인을 만들지 않는다 — 회차·발제문·토론은
모두 모임(ReadingClub)의 하위 개념이고 권한이 클럽 멤버십에 종속되기 때문이다.

레이어 규칙(§3.1) 준수:
- Router: HTTP in/out, DTO 변환, 인증 의존성만.
- Service: 회차/발제문/토론 도메인 로직, 권한 판정, 트랜잭션 경계.
  feed·notification·ai_assistant service는 **Port(Protocol)** 로 주입 (기존
  `FeedClubPort` 패턴 재사용).
- Repository: `club` 테이블 쿼리만.

## 4. 데이터 모델

```
ReadingClub (기존, 컬럼 2개 추가)
 └─ club_sessions        회차   [club_id, book_id, presenter_id, status, access_tier]
    └─ session_agendas   발제문 [session_id, author_id, body, status]
        └─ agenda_topics 논제   [agenda_id, position, prompt]
            └─ topic_comments  스레드 [topic_id, author_id, parent_comment_id, body]
```

### 4.1 신규 테이블

**`club_sessions` — 회차**

| 컬럼 | 타입 | 비고 |
|---|---|---|
| id | UUID PK | |
| club_id | UUID FK → reading_clubs (CASCADE) | |
| book_id | UUID FK → books | 책별 필수 |
| title | String(200) | |
| scope | Text nullable | 챕터/페이지 범위(자유 텍스트) |
| presenter_id | UUID FK → users nullable | 지정 발제자 |
| scheduled_at | DateTime(tz) nullable | 회차 예정 일시 |
| status | String(12) | `draft` / `open` / `closed` |
| access_tier | String(16) default `included` | **유료 훅** (현재 항상 included) |
| price_cents | Integer nullable | **유료 훅** |
| created_by | UUID FK → users | |
| created_at | DateTime(tz) | |

인덱스: `club_id`, `book_id`. CHECK: `status IN ('draft','open','closed')`.

**`session_agendas` — 발제문**

| 컬럼 | 타입 | 비고 |
|---|---|---|
| id | UUID PK | |
| session_id | UUID FK → club_sessions (CASCADE) | |
| author_id | UUID FK → users | 발제자 |
| body | Text | 발제문 본문 |
| status | String(12) | `draft` / `published` |
| published_at | DateTime(tz) nullable | 게시 시각 |
| created_at | DateTime(tz) | |

인덱스: `session_id`. CHECK: `status IN ('draft','published')`.

**`agenda_topics` — 논제**

| 컬럼 | 타입 | 비고 |
|---|---|---|
| id | UUID PK | |
| agenda_id | UUID FK → session_agendas (CASCADE) | |
| position | Integer | 표시 순서 |
| prompt | Text | 논제 질문 |
| created_at | DateTime(tz) | |

인덱스: `agenda_id`.

**`topic_comments` — 논제별 스레드 토론**

| 컬럼 | 타입 | 비고 |
|---|---|---|
| id | UUID PK | |
| topic_id | UUID FK → agenda_topics (CASCADE) | |
| author_id | UUID FK → users | |
| parent_comment_id | UUID FK → topic_comments nullable | 1단계 대댓글 |
| body | Text | |
| created_at | DateTime(tz) | |
| edited_at | DateTime(tz) nullable | |

인덱스: `topic_id`, `parent_comment_id`.

### 4.2 유료화 훅 (모델만, 로직 없음)

이번 에픽에서 **읽지도 쓰지도 않는다.** 다음 수익화 에픽이 가입 게이팅·결제를 얹을 때
핵심 테이블 마이그레이션 충돌을 피하기 위한 예약 컬럼이다.

- `reading_clubs.access_type` — String default `open`. (`open` / `approval` / `paid`)
- `reading_clubs.join_price_cents` — Integer nullable. (모임 가입 = 유료 모델)
- `club_sessions.access_tier` — String default `included`. (회차 단건 결제 모델)
- `club_sessions.price_cents` — Integer nullable.

## 5. 권한 규칙

| 행위 | 허용 |
|---|---|
| 회차 생성·수정·삭제, 발제자 지정, 상태 전이 | club owner(host) |
| 발제문 작성·수정·게시 | 해당 회차의 host **또는** presenter |
| 논제 추가·수정·순서 변경 | 발제문 author (= host/presenter) |
| 논제 답글 작성 | club 멤버 |
| 답글 수정·삭제 | 본인 **또는** host |
| 회차·발제문·토론 조회 | 멤버 (공개 클럽은 공개 열람) |

권한 판정은 Service 계층에서 `ClubMember.role`(owner/member) + `session.presenter_id`
로 수행한다.

## 6. 통합 지점 (기존 자산 재사용)

### 6.1 feed (BC-47)

신규 이벤트 타입 3종: `session_opened`, `agenda_published`, `discussion_commented`.
club service가 `FeedClubPort`로 이벤트를 기록한다(기존 `record_club_joined` 패턴).

> ⚠️ **feed_events 드리프트 버그 클래스 (BC-37/BC-38).** 이벤트 타입은
> enum ↔ CHECK 제약 ↔ 드리프트 가드 테스트 **세 곳을 동시에** 갱신해야 한다.
> 마이그레이션으로 CHECK 제약에 3종을 추가하고, BC-38 가드 테스트를 통과시킨다.

### 6.2 notification (BC-48)

- 발제문 게시(published) → 클럽 멤버 푸시.
- 내 발제문/논제에 답글 → 작성자 푸시(본인 제외).

club service가 notification service(Port) 호출.

### 6.3 ai_assistant (BC-53, 선택)

발제자용 "논제 초안 3~5개 추천": 책 + scope 입력 → 논제 후보 생성. 기존
ai_assistant(M63 클럽 토론 주제 생성) 자산을 Port로 재사용. Pro 게이팅 여부는
구현 시 결정.

## 7. Flutter 구조

`lib/features/club/` 확장. UI는 Riverpod Provider로만 상태·Repository 접근(§3.4).

- 회차 목록(모임 상세 하위 탭): **책별 그룹**, 상태 배지.
- 회차 상세: 발제문 + 논제 아코디언, 논제별 답글 수/미리보기.
- 발제문 작성 에디터: 본문 + 논제 추가/삭제/드래그 정렬, draft/publish.
- 논제 스레드 토론: 답글 트리, 컴포저, 1단계 대댓글, 본인/host 수정·삭제.
- 피드 카드·알림 딥링크(회차 상세).

## 8. 테스트 전략

- **Service 단위 테스트(필수, §5)**: Fake feed/notification/ai Port 주입, DB 없이.
  권한(비-host/비-presenter 거부), 상태 전이(draft→open→closed, draft→published),
  논제 순서, 대댓글 트리, 알림 대상 산정, 유료 훅 기본값.
- **Repository 통합 테스트**: testcontainers Postgres.
- **feed 드리프트 가드**: 신규 이벤트 타입 반영 확인(BC-38 확장).
- **Flutter Widget 테스트**: 회차 목록/상세, 발제문 에디터, 스레드 토론.
- **E2E**: Chrome MCP — 회차 생성 → 발제문 게시 → 논제 토론 플로우(BC-54).

## 9. 태스크 분해 (BC-42 하위)

**M1 — 백엔드 코어**

| 티켓 | 내용 | 의존 |
|---|---|---|
| BC-43 | 스키마 4개 테이블 + reading_clubs/club_sessions 유료 훅 + 마이그레이션 + 본 설계문서 | — |
| BC-44 | 회차 service/repo/router (생성·발제자 지정·상태 전이·권한) | BC-43 |
| BC-45 | 발제문·논제 service/repo/router | BC-43, BC-44 |
| BC-46 | 논제 스레드 토론(답글·대댓글) service/repo/router | BC-45 |
| BC-47 | feed 연동 + feed_events 드리프트 가드 갱신 | BC-45, BC-46 |
| BC-48 | notification 연동 | BC-45, BC-46 |

**M2 — 클라이언트 (Flutter)**

| 티켓 | 내용 | 의존 |
|---|---|---|
| BC-49 | 회차 목록·상세 (책별 그룹, 아코디언) | BC-44, BC-45 |
| BC-50 | 발제문 작성 에디터 | BC-45 |
| BC-51 | 논제 스레드 토론 UI | BC-46, BC-49 |
| BC-52 | 피드 카드·알림 배선 | BC-47, BC-48 |

**M3 — 마감**

| 티켓 | 내용 | 의존 |
|---|---|---|
| BC-53 | (선택) AI 논제 초안 추천 | BC-45 |
| BC-54 | QA 시트 + E2E + 문서/IDEAS 마감(유료 모임 후속 에픽 기록) | T1~T10 |

각 티켓 = 워크트리 1개 = PR 1개(§6). 독립 티켓은 병렬 진행.

## 10. 리스크 & 대응

- **feed_events 드리프트 재발**: BC-37/38에서 겪은 클래스. BC-47에서 enum·CHECK·가드
  테스트를 한 커밋에 묶어 방지.
- **기존 채팅(ClubRoom)과 혼동**: 세션 토론(비동기 구조화)과 실시간 채팅은 **공존**한다.
  UI에서 역할을 분리해 안내(발제·토론 = 회차 탭 / 실시간 = 채팅 탭).
- **유료 훅 과설계**: 컬럼만 두고 로직·인덱스 튜닝은 후속 에픽으로 미룬다(YAGNI).
- **배포 시점 가정**: 본 에픽은 다음 릴리스 전 편입 기능으로 가정. 실제 배포 트랙과의
  정합은 배포 에픽에서 확인.

## Changelog

- **1.0.0** (2026-08-04) — 최초 작성. 회차·발제문·논제·스레드 4계층 모델, 권한 규칙,
  feed/notification/ai 통합, 유료화 훅(모임·회차 레벨), BC-43~BC-54 태스크 분해 확정.

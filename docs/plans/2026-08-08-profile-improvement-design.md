---
title: 프로필 개선 — 계정·설정 허브 · 내 활동 통합 · 표현력
epic: BC-77
version: 1.0.1
status: delivered
created: 2026-08-08
owner: 김성연
---

# 프로필 개선 (Profile Improvement)

기존 프로필(등급·배지·하이라이트·팔로우·게시글)에서 부족했던 세 영역 —
**계정·설정 허브**, **내 활동 통합 보기**, **프로필 표현력** — 을 보강한 에픽.

관련 에픽: **BC-77**. 관리자/로그인 분리(BC-78)는 별도 에픽.

## 1. 배경
프로필은 읽기 지표(등급/배지)는 갖췄으나, (1) 설정이 팝업 메뉴에 흩어져 있고,
(2) 내가 남긴 활동(리뷰·하이라이트·발제문·모임·읽는 중)을 한 곳에서 볼 수 없으며,
(3) 표현 수단(커버/테마/대표 책·인용구)이 없었다.

## 2. 범위와 결과 (전부 배포됨)

### 계정·설정 허브 (A3 / BC-82)
- `SettingsScreen`(`/settings`)으로 재구성. 프로필 팝업 5항목 → 설정 아이콘 1개.
- 이관: 언어·개인정보처리방침·이용약관·로그아웃·관리자(is_admin 게이팅, BC-78).
- 신규 배선: 구독·결제(paywall 재사용), 차단 목록(`social/blocks`), 계정 관리
  (`AccountScreen` — 소셜 연동 상태 + **계정 탈퇴 DELETE /me 실연동**).
- 알림 수신 설정(preferences)은 백엔드 부재 → 인박스로 임시 연결(백로그).

### 내 활동 통합 (A1 / BC-80 백엔드 · A4 / BC-83 모바일)
- 백엔드: `GET /community/me/activity` 요약(counts + 5개 프리뷰) + 목록 엔드포인트
  `GET /me/reviews`·`/me/highlights/recent`·`/clubs/me/agendas`(+ 기존 `/me/library`,
  `/clubs/me`). 각 도메인 service 오케스트레이션(§3.3).
- 모바일: 프로필 '내 활동' 섹션 + 더보기 4화면 + 딥링크(책/회차/클럽).

### 프로필 표현력 (A2 / BC-81 백엔드 · A5 / BC-84 모바일)
- 백엔드: `users`에 `cover_image_url`·`theme`(6종 팔레트)·`featured_book_id`(FK)·
  `featured_quote` (마이그레이션 0053) + `FeaturedBookLookupPort`(도메인 경계).
- 모바일: 헤더 커버/테마 그라디언트 + 대표 책 카드 + 인용구 카드, 편집 폼(PATCH /me).

### 마감 (A6 / BC-85)
- 본 문서, 백로그 정리(아래 §4), 각 티켓 위젯 테스트 확인.

## 3. 티켓 매핑
| 태스크 | 티켓 | PR |
|---|---|---|
| A1 내 활동 API | BC-80 | #50 |
| A2 표현력 필드 | BC-81 | #51 |
| A3 설정 허브 | BC-82 | #55 |
| A4 내 활동 탭 | BC-83 | #53 |
| A5 표현력 UI | BC-84 | #54 |
| A6 마감 | BC-85 | (본 PR) |

## 4. 알려진 제약 / 후속 (docs/backlog/IDEAS.md)
- ~~'내 활동' 요약이 community 도메인 종속~~ → BC-90으로 해소. 백엔드 집계기를
  `GET /community/me/activity` → `GET /me/activity`(community 게이팅 밖,
  항상 마운트)로 이설, 모바일 `MyActivitySection`도 `FeatureFlags.community`
  무관 노출로 정리.
- 표현력 4필드 **NULL 클리어 불가**(PATCH None=미변경, 기존 bio 한계와 동일).
- 표현력 "대표 책 선택"이 서재 내 책만 대상(카탈로그 검색 아님).
- 알림 수신 설정(preferences) 백엔드 부재 — 별도 티켓 필요.

## Changelog
- **1.0.0** (2026-08-08) — 에픽 배포 완료. A1~A6(BC-80~85) 전부 main 머지.
  계정·설정 허브 + 내 활동 통합 + 표현력. 제약·후속은 §4 참조.
- **1.0.1** (2026-08-11) — BC-90: "내 활동" 집계기를 community 도메인 게이팅
  밖으로 이설(`GET /me/activity`). §4의 관련 제약 항목 해소로 갱신.

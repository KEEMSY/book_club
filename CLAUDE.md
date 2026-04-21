# CLAUDE.md — Book Club 프로젝트 규칙

본 문서는 Book Club 앱을 개발하는 모든 협업 주체(사람·에이전트)가 따라야 하는 프로젝트 규칙이다.
설계 배경과 의사결정 기록은 `docs/plans/2026-04-20-book-club-design.md` 를 참조한다.

## 1. 커뮤니케이션 & 언어

- 소스 코드 식별자·주석·커밋 본문은 **영문**, 사용자 대화·문서·커밋 제목은 **한국어**.
- 외부에 공개되는 UI 문구·에러 메시지는 한국어를 원칙으로 하되 보편적 영문 표기(OK, Cancel 등)는 허용.

## 2. 기술 스택 (확정)

| 영역 | 스택 |
|---|---|
| Mobile | Flutter / Dart 3 / Riverpod / go_router / freezed / dio + retrofit |
| Backend | Python 3.12 / FastAPI / SQLAlchemy 2 (async) / Alembic / Pydantic v2 |
| DB | PostgreSQL 16 |
| Cache / Bus | Redis 7 |
| Storage | Cloudflare R2 (S3 호환) · 로컬은 MinIO |
| Auth | 카카오 OAuth + Apple Sign In (JWT 세션) |
| External | 네이버 책 API (기본), 카카오 책 API (폴백) |
| Push | FCM (iOS는 FCM → APNS 위임) |
| CI | GitHub Actions |

본 스택에서 벗어나는 선택은 **설계 문서 갱신 + 사용자 승인** 이후에만 허용한다.

## 3. 아키텍처 규칙

### 3.1 백엔드 레이어 (엄격)

```
Router  →  Service  →  Repository / External Adapter
```

- **Router**: HTTP in/out, DTO 변환, 인증 의존성만. 비즈니스 로직·DB·외부 HTTP 호출 **금지**.
- **Service**: 도메인 로직, 트랜잭션 경계, 도메인 간 오케스트레이션. FastAPI 의존성 **금지**.
- **Repository**: 자체 DB(Postgres / Redis) 쿼리만. 비즈니스 규칙·외부 HTTP 호출 **금지**.
- **External Adapter (`adapters/`)**: 외부 HTTP·SDK 호출 전용. 재시도·타임아웃·에러 매핑 담당.

### 3.2 Port/Adapter

- 도메인 `service.py` 는 구체 어댑터를 import 하지 않는다. 오직 `ports.py` 의 `Protocol` 에만 의존.
- Port 는 **복수 구현이 실재하는 외부 경계** (외부 검색·OAuth·푸시 등) 에서 엄격히 적용.
- 단순 CRUD Repository 는 Port ↔ 구현 1:1 유지하여 과설계를 방지한다.

### 3.3 도메인 경계

- 도메인: `auth`, `book`, `reading`, `feed`, `notification`
- 한 도메인의 Service 가 다른 도메인 Service 를 호출하는 것은 허용, Repository·모델 직접 접근은 금지.
- 공용 유틸은 `shared/`, 공용 인프라는 `core/` 에 배치.

### 3.4 Flutter 구조

- `lib/features/<domain>/` 로 백엔드 도메인과 1:1 매핑.
- UI 는 Riverpod Provider 를 통해서만 상태·Repository 에 접근. UI 에서 dio 직접 호출 금지.

## 4. 코드 스타일 & 품질 게이트

### 4.1 Python (backend)

- 포매터 / 린터: **ruff** (format + lint)
- 타입: **mypy --strict** (단, 서드파티 stub 미비 영역은 per-module 완화 허용)
- 네이밍: snake_case / PascalCase / UPPER_SNAKE
- 함수·메서드는 **한 가지 책임**, 20줄 이상이면 분리 검토
- 예외 처리: 삼키지 말 것 (로깅 + 재발생 또는 구체 예외 매핑)

### 4.2 Dart (mobile)

- 포매터: `dart format`
- 정적 분석: `dart analyze` — 경고 0 유지
- 네이밍: Dart 표준 (파일 snake_case, 클래스 UpperCamelCase)

### 4.3 공통

- 주석: **"무엇을" 이 아닌 "왜"** 만 기록. 식별자로 설명되는 것은 주석 금지.
- 데드 코드·주석 처리된 코드 커밋 금지.
- TODO 에는 **소유자와 맥락** 을 남긴다. 남발 금지.

## 5. 테스트 정책

- **도메인 Service 단위 테스트 필수** — Port 에 Fake 를 주입하여 DB 없이 실행.
- Repository / Router 는 통합 테스트 (testcontainers Postgres).
- 외부 어댑터는 응답 픽스처 기반 계약 테스트.
- 커버리지 수치는 강제하지 않되, 새 Service 가 단위 테스트 없이 병합되지 않도록 리뷰에서 막는다.
- Flutter: 주요 화면 Widget 테스트 + 타이머·로그인 Integration 테스트.

## 6. 브랜치 & 커밋

### 6.1 브랜치

- 기본 브랜치: `main`
- 작업 브랜치: `feat/<domain>-<slug>`, `fix/<domain>-<slug>`, `chore/<slug>`, `docs/<slug>`
- 머지 전략: Squash merge. PR 단위로 의미 있는 커밋 1건을 남긴다.

### 6.2 커밋 메시지

- 제목은 한국어, 본문은 필요 시 영문/한국어 자유.
- 형식: `<type>: <간결한 요약>` — type 은 `feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `perf`.
- 큰 변경은 본문에 **왜** 변경했는지 기록 (무엇은 diff 로 충분).

### 6.3 PR 체크리스트

- [ ] 도메인 경계·레이어 규칙 준수
- [ ] 새 Service 에 단위 테스트 추가
- [ ] 설계 변경이 동반되면 `docs/plans/` 갱신
- [ ] 백로그에 아이디어가 새로 추가되었다면 `docs/backlog/IDEAS.md` 반영

## 7. 버저닝 정책

### 7.1 애플리케이션 버전

- 앱스토어 **출시 전**: `0.0.X` — PATCH 자리만 증가.
  - `0.0.1` = Phase 1(MVP) 완료 및 첫 스테이징 배포 시점.
  - 이후 스테이징/프로덕션 배포 태그마다 PATCH 증가.
- 앱스토어 **출시 시점** 에 `0.1.0` 으로 승격.
- 이후 시맨틱 버저닝 (MAJOR / MINOR / PATCH).
- 개발 중 버전은 `-dev` 접미사 (예: `0.0.2-dev`).
- 버전 증가 기준 = **배포 태그 시점**. Git 태그: `v0.0.X`.

### 7.2 문서 버전

- 설계 문서(`docs/plans/*.md`)는 상단 frontmatter 에 `version`, 본문 마지막에 `## Changelog` 섹션을 둔다.
- **방향성·범위·아키텍처 결정 변경** 시 버전을 올린다. 오탈자·포맷 수정은 대상 아님.
- 문서명은 `YYYY-MM-DD-<topic>-<type>.md` 로 시간순 정렬.

### 7.3 Phase / Milestone 종료 커밋 (강제)

개별 Task 단위 커밋과 별개로, **Phase 와 Milestone 은 반드시 종료 커밋 + 태그로 매듭짓는다.**

- **Milestone 종료 시**: 해당 Milestone 의 모든 Task 가 completed 이고 품질 게이트(lint / type / test)가 green 이면,
  1. 작업 브랜치를 `main` 으로 squash merge
  2. 머지 커밋 메시지는 `release(MX): <마일스톤 이름> 완료` 형식
  3. Git 태그 부여: `v0.0.X-mN` (예: `v0.0.0-scaffold`, `v0.0.1-m1`)
  4. `docs/plans/<해당 계획 문서>` 의 `## Changelog` 에 종료 기록 한 줄 추가
- **Phase 종료 시**: Phase 내 모든 Milestone 이 태그되어 있으면,
  1. Phase 종료 커밋 메시지: `release: Phase N 완료 — <한 줄 요약>`
  2. Phase 대표 태그 부여: `v0.0.N` (Phase 1 = `v0.0.1`, Phase 2 = `v0.1.0` 등 §7.1 규칙에 맞춰)
  3. `docs/backlog/IDEAS.md` 의 "Phase 전환 리뷰 기록" 섹션에 리뷰 결과 요약
- 종료 커밋을 생략하고 다음 Milestone / Phase 작업을 시작하지 않는다.

## 8. 백로그 & 아이디어 프로세스 (강제 규칙)

### 8.1 작업 중 아이디어 발생 시

1. **즉시 구현 금지.** 현재 Phase 범위 밖의 아이디어·개선안은 어떠한 경우에도 진행 중 작업에 편입하지 않는다.
2. `docs/backlog/IDEAS.md` 하단에 한 줄로 기록:

   ```
   - [ ] (<domain>) <아이디어 한 줄> — 맥락: <당시 진행 중이던 작업> (YYYY-MM-DD)
   ```

3. 기록 직후 **원래 작업으로 복귀 명시** ("현재 작업 <X> 이어갑니다") 후 계속 진행.

### 8.2 Phase 전환 시 (강제)

- 새로운 Phase 작업을 시작하기 **직전** 반드시 `docs/backlog/IDEAS.md` 를 리뷰한다.
- 리뷰 산출물: 편입 / 보류 / 삭제 라벨링, 편입 항목은 해당 Phase 계획에 반영.
- 이 리뷰를 거치지 않은 상태로 새로운 Phase 작업을 시작하지 않는다.

### 8.3 완료 처리

- 편입되어 구현된 항목은 체크박스를 `[x]` 로 바꾸고 구현 PR 번호를 괄호에 남긴다.
- 폐기 결정된 항목은 `~~취소선~~` 처리 후 사유를 한 줄로 남긴다.

## 9. 개인정보 & 보안 기본선

- 소셜 로그인 반환 값(email, 이름, 프로필) 은 수집 목적 범위 내에서만 저장.
- 액세스 토큰·리프레시 토큰은 DB 평문 저장 금지 (해시 또는 KMS 필요).
- 시크릿은 `.env` + Fly.io secrets. 레포 커밋 금지.
- 로그에 개인정보·토큰·OAuth 코드가 유출되지 않도록 로거 필터링 규칙을 둔다.

## 10. 에이전트 작업 규칙

- 영역별 작업은 **글로벌 에이전트** 로 분배 (백엔드 / 프론트 / 인프라 / QA 등).
- 에이전트는 작업 시작 전 `CLAUDE.md` 와 관련 `docs/plans/*.md` 를 반드시 읽는다.
- 작업 결과물은 본 규칙을 위반하지 않아야 하며, 위반 시 리뷰에서 반려한다.
- 에이전트가 새로운 아이디어를 제안하는 경우 본 문서 §8 절차를 따라 백로그에 기록한다.

---

**Last updated**: 2026-04-20
**CLAUDE.md version**: 1.0.0

---
name: pr-description
description: Book Club의 리뷰 친화적 PR 설명 표준 포맷. GitHub PR을 열거나 수정할 때(gh pr create / gh pr edit) 항상 이 포맷으로 본문을 작성해 모든 PR을 일관되고 리뷰하기 쉽게 만든다. Triggers on "PR 작성", "PR 본문", "PR 열어", "open a PR", "gh pr create", or any time a pull request body is written.
---

# 리뷰 친화적 PR 설명

모든 PR 본문은 아래 템플릿을 따른다. 리뷰어가 위에서 아래로 읽으며 충분히 이해되면 멈출 수 있도록 **스캔 가능하게** 쓴다. `gh pr create --body-file <file>` 로 파일을 넘겨 멀티라인·마크다운이 깨지지 않게 한다(인라인 `--body`는 escape가 어긋나기 쉬움).

## 템플릿

```markdown
## 요약
<1–2문장. 무엇을, 왜. 리뷰어가 목적을 한눈에.>

**Jira**: BC-XX  ·  **type**: feature | backlog | hotfix

## 변경 사항
- <파일/영역별 핵심 변경. "무엇"이 diff로 자명하면 "의도" 위주로.>

## 배경 / 왜
<이 변경이 필요한 맥락·근거. 버린 대안이 있으면 한 줄 이유.>

## 검증
- <실행 명령과 결과를 증거로: `flutter test 141 pass`, `ruff/mypy green`, 릴리즈 빌드, 스크린샷(UI).>
- CI: <어떤 잡이 green인지 / 아직이면 무엇 대기>

## 리뷰 포인트
- <리뷰어가 집중할 곳, 트레이드오프, 확신 없는 부분. 큰 diff는 "어디부터 보라"를 명시.>

## 리스크 / 롤아웃
- <마이그레이션·시크릿·피처플래그·후속 작업·되돌리기 방법. 해당 없으면 "없음".>

## 체크리스트
- [ ] 도메인 경계·레이어 규칙 준수 (CLAUDE.md §3)
- [ ] 새 Service에 단위 테스트 (§5)
- [ ] 품질 게이트 green — lint·type·test + (모바일/릴리즈 변경 시) 릴리즈 빌드·CI
- [ ] 설계 변경 시 `docs/plans/` 갱신 / 아이디어 발생 시 `docs/backlog/IDEAS.md` 반영
- [ ] 머지 전 CI green 확인
```

## 원칙

- **제목**: `<type>/<TICKET> <한 줄 요약>` — 브랜치·커밋 컨벤션(CLAUDE.md §6)과 일치.
- **"왜"에 지면을 쓴다**: "무엇"은 diff가 말한다. 배경·의도·리스크·트레이드오프가 리뷰어에게 가치.
- **검증은 증거로**: "테스트 통과" (X) → "flutter test 141 pass, analyze green, CI build-android/ios ✓" (O).
- **리뷰어의 시간을 아낀다**: 리뷰 포인트로 스캔 경로를 제시. 위험한 부분·확신 없는 부분을 스스로 표시.
- **UI 변경엔 스크린샷/GIF** 필수.
- **빈 섹션은 삭제하지 말고 "없음"** 으로 명시 — 누락과 구분되게.
- 여러 티켓을 한 PR로 묶을 땐 요약·Jira에 모두 명시하고 이유를 한 줄.

## 적용

`ticket-worktree-workflow` 스킬의 PR 단계(6)는 이 포맷을 사용한다. PR 생성/수정 시:
1. 위 템플릿을 채워 임시 파일(예: 스크래치패드)에 작성.
2. `gh pr create --title "<type>/<TICKET> <요약>" --body-file <file>` (또는 `gh pr edit <n> --body-file <file>`).

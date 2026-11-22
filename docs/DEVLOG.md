# 개발 일지

> 겪은 일 · 막힌 일 · 그때 배운 것을 적는다. **최신이 위.**
> 진행 상황은 [PLAN.md](PLAN.md), 결정의 이유는 [decisions/](decisions/README.md).

## 현재 상태
| 항목 | 내용 |
|---|---|
| 단계 | M0 · 정하기 |
| 진행 중 | 디자인 방향 고르기 — `mockups/Directions.html`에 네 방향(A 노선도 · B 승차권 · C 출발 안내판 · D 여행 수첩) |
| 다음에 할 일 | 사용자가 방향을 고름(섞기 가능) → DESIGN 확정 값(색 · 글꼴 · 모양 · 움직임) → 하위 주소 |
| 기기별로 할 일 | 노트북만 씀. 다른 기기는 `git clone https://github.com/sagming40/Itinerail` |

---

## 2026-11-22 (2) · 디자인 방향 시안 (노트북)

### 한 일
- 주제(여행 · 노선 · 같이 짜기)에서 시각 언어를 가져와 방향 넷을 한 문장씩 정하고, **같은 일정 판(모바일) 한 화면을 넷으로 그렸다** — [mockups/Directions.html](mockups/Directions.html). 파일 하나에 시안 넷, 마크업은 같고 모양만 시안이 덮는다. 날짜 바꾸기(노선 색 바뀜)와 "옮기기 데모"(View Transitions)가 실제로 돈다.
- 주소 파라미터: `d`(A ~ D 하나만 크게) · `dark` · `edit`. 다크는 A · B · D에 값을 따로 줬고 C는 원래 어둡다.
- 브라우저 확인(내장 브라우저, 로컬 정적 서버 `127.0.0.1:5178`): 네 방향 · B 다크를 스크린샷으로 봤다.

### 막힌 것
- **C의 시각 칸이 검은 덩어리로 늘어남** — 증상: 출발 안내판 시안에서 시각 배경이 카드 높이만큼 길어짐. 원인: 그리드 칸 기본값이 늘이기(stretch). 해결: `time`에 `align-self: start`.
- **동선 선이 일부만 그려진 채 멈춤** — 원인 1: 선 길이를 모르고 `stroke-dasharray: 1000`을 씀 → `pathLength="1"`로 길이와 상관없이 0 → 1. 원인 2(확인함): 내장 브라우저 창이 가려져 있으면 CSS 애니메이션이 `currentTime 0`에서 멈춘다(`getAnimations()`로 봄) — 목업 문제가 아니다. 창이 보이는 브라우저에서는 끝까지 그려지는지 아직 눈으로 안 봤다.
- `file://`로는 내장 브라우저가 열지 못해서 로컬 정적 서버(node 한 줄)로 봤다. 사용자가 더블클릭으로 열었을 때 되는지는 확인 전.

### 다음에 할 일
- 사용자가 방향을 고른다(둘을 섞어도 된다). 고른 것을 DESIGN 1장에 한 문장으로, 그다음 색 · 글꼴 · 모양 · 움직임 표.

## 2026-11-22 (1) · 문서 세트 시작 (노트북)

### 한 일
- 스택 · 주제를 minor-stacks 저장소에서 골랐다 — 같은 날 그쪽 DEVLOG 2026-11-22 (1) · (2). 사용자가 Clojure 포트폴리오에서 이쪽으로 갈아탔다. 이름은 Itinerail(itinerary + rail).
- 사용자가 이 폴더를 만들고 minor-stacks의 `plan_travel.md` · `final-choice-elixir.md`를 복사해 뒀다(내용이 원본과 같은지 `diff`로 확인).
- 전역 "문서 체계"대로 `docs/`를 세웠다(docs-setup new):
  - `plan_travel.md`를 나눠 [PLAN.md](PLAN.md)(목표 · 스택 칸이 맡는 곳 · 진행 현황 · 단계 · 안 정한 것)와 [REQUIREMENTS.md](REQUIREMENTS.md)(기능 F-01 ~ F-17 · 하지 않을 것 · 장소 검색 외부 데이터 · 사전 검증)로 옮기고 루트 파일은 지웠다.
  - [decisions/](decisions/README.md) 0001 스택 · 0002 주제 · 0003 장소 검색 공급자.
  - `final-choice-elixir.md`는 조사 기록이라 [research/](research/README.md)에 고치지 않고 둔다 — 전역 세트에 없는 폴더라 프로젝트 CLAUDE.md에 이유를 적었다.
  - 화면이 있는 프로젝트라 [DESIGN.md](DESIGN.md)(방향은 비워 둠, 화면 목록 초안) · [mockups/README.md](mockups/README.md)를 만들었다.
- 프로젝트 `CLAUDE.md` · `README.md`를 만들었다.
- minor-stacks 쪽 `plan_travel.md` · `final-choice-elixir.md`는 같은 내용이 두 곳에 남지 않게 지우고, 그쪽 문서에서 이 저장소를 가리키게 했다.

- 사용자가 `.gitattributes` · `.editorconfig` · `.gitignore`를 쳤다(cbt-journal · PlayLedger 규칙 + Phoenix 1.8.17 생성기 `.gitignore` 템플릿). 검수: 줄바꿈 LF, `git check-ignore`로 `.env` · `.elixir_ls/` · `_build/`가 무시되는 것 확인.
- 사용자가 `git init -b main` · GitHub 공개 저장소 `sagming40/Itinerail` · 원격 연결을 했다. 공개라서 push 전에 문서에서 IP · 메일 · 계정 번호 · 키 모양 문자열을 찾아봤다 — 0건.

### 이번 세션 커밋
- `6f369c9` init: 문서 세트와 저장소 설정으로 시작 (16개 파일)
- 이 블록 · PLAN · CLAUDE.md 저장소 상태 맞추기 (docs)

### 다음에 할 일
- "현재 상태" 다음에 할 일.
- ~~작업 방식 정하기~~ → **타이핑 학습 모드**로 정했다(같은 날, 사용자). CLAUDE.md "작업 방식"에 "전역 작업 방식과 다르게"로 적었다 — `mix` 생성기 명령 · `iex`도 사용자가 친다.

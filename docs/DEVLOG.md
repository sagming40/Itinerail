# 개발 일지

> 겪은 일 · 막힌 일 · 그때 배운 것을 적는다. **최신이 위.**
> 진행 상황은 [PLAN.md](PLAN.md), 결정의 이유는 [decisions/](decisions/README.md).

## 현재 상태
| 항목 | 내용 |
|---|---|
| 단계 | M0 · 정하기 |
| 진행 중 | `docs/` 세트를 세웠다. 아직 git 저장소가 아니다 |
| 다음에 할 일 | `git init` · 첫 커밋 · GitHub 저장소(사용자) → 하위 주소 → 디자인 방향 한 문장 → 목업 시안 비교 → DESIGN |
| 기기별로 할 일 | 노트북만 씀. 다른 기기는 GitHub에 올린 뒤 `git clone` |

---

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

### 이번 세션 커밋
- 없음 — git 저장소가 아니다. `git init` · 첫 커밋은 사용자가 한다.

### 다음에 할 일
- "현재 상태" 다음에 할 일.
- ~~작업 방식 정하기~~ → **타이핑 학습 모드**로 정했다(같은 날, 사용자). CLAUDE.md "작업 방식"에 "전역 작업 방식과 다르게"로 적었다 — `mix` 생성기 명령 · `iex`도 사용자가 친다.

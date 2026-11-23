# 0005. 명령 묶기는 Task 없이 Mix 하나로

- 상태: 채택
- 날짜: 2026-11-23

## 맥락

조사 문서(research/final-choice-elixir.md 5장)와 0001은 명령 묶기를 **mix 별칭 + Task**로 나눴다 — Elixir 안의 것은 별칭, Docker · 배포처럼 Elixir 밖의 것은 Taskfile. Task를 고른 이유는 cbt-journal · PlayLedger의 `task deploy` + `scripts/deploy.ps1` 구조를 거의 그대로 가져오려는 것 하나였다.

집 PC에서 첫 `mix phx.server`까지 띄운 뒤 Taskfile(`db` · `db:stop` · `dev` · `test`)을 치기 전에 사용자가 "Task · just 말고 다른 걸 써 보자"고 했다(just는 pc-buildcheck, Task는 cbt-journal · PlayLedger, Babashka도 써 봄). 후보는 Mix만 · mise · Make였다.

## 결정

**새 도구 없이 Mix 하나로 묶는다** (사용자 결정).
- Elixir 밖의 명령도 mix 별칭에서 `cmd`로 부른다: `mix db`(= `docker compose up -d --wait`) · `mix dev`(= `db` → `phx.server`).
- 검사 묶음은 원래 계획대로 `mix ci` 별칭.
- 배포는 직접 만드는 Mix 태스크 `lib/mix/tasks/deploy.ex`(`mix deploy`). 확인 단계(미커밋 없음 → origin/main과 같음 → CI 성공 대기 → SSH → 헬스)는 PlayLedger `deploy.ps1`을 따른다. 처음부터 Elixir로 옮길지, ps1을 부르기만 할지는 배포 때 정한다.
- **Docker를 부르는 별칭(`db` · `dev`)은 `ci`에 넣지 않는다** — CI는 Postgres를 GitHub 서비스 컨테이너로 띄운다.

## 검토한 대안

- **Task(원래 계획)**: 이미 익숙하고 빠르다(BEAM을 안 띄움). 하지만 사용자가 다른 걸 원했고, 이 저장소의 목적(Elixir를 손으로 익히기)에 보탬이 없다.
- **mise**: `mise.toml`의 `[tasks]` — Task를 TOML로 바꾼 것과 거의 같은 경험. 세 기기에 새로 설치해야 하고, winget 설치의 PATH 문제가 또 나올 수 있다. 도구 버전 고정 기능은 winget으로 깐 Elixir · Erlang과 이중 관리가 된다.
- **Make**: 기기에 없고 Windows에서 다루기 불편하다.

## 감수할 것

- `mix 무엇`은 매번 BEAM을 띄우고 컴파일을 확인해서 Task보다 느리다(0.5 ~ 1초).
- 목록이 `mix help`에 생성기 태스크와 섞여 나온다(별칭은 맨 위에 모여 있다).
- 배포 스크립트를 Elixir로 쓰는 숙제가 생긴다 — 대신 `Mix.Task` · `System.cmd` · `OptionParser`를 익힌다. 시드 · 데이터 정리 스크립트에도 같은 기본기를 쓴다.
- 0001의 "명령 묶기(mix 별칭 + Task)" 부분과 research 5장은 이 결정이 대신한다(옛 문서는 고치지 않는다).

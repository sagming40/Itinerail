# CLAUDE.md

이 저장소에서 일하는 Claude가 지키는 규칙이다. 세션끼리는 기억을 공유하지 않으니 **이 파일과 `docs/`가 공용 노트**다.

**Itinerail**: 친구 · 가족과 여행 일정을 같이, 실시간으로 짜고 경비를 정산하는 웹앱. Elixir + Phoenix + LiveView. 스택 · 주제는 2026-11-22 minor-stacks 저장소에서 골랐다([docs/decisions/](docs/decisions/README.md) 0001 · 0002).

## 문서 지도 (질문 하나 = 문서 하나)

| 질문 | 문서 |
|---|---|
| 지금 어디까지 왔고 바로 다음에 뭘 해? | [docs/DEVLOG.md](docs/DEVLOG.md) "현재 상태" |
| 목표 · 단계 · 진행 현황은? 스택 칸이 이 앱에서 맡는 곳은? | [docs/PLAN.md](docs/PLAN.md) |
| 무엇을 만들고 안 만드나? 외부 데이터(장소 검색) 조건은? 사전 검증에서 본 경우는? | [docs/REQUIREMENTS.md](docs/REQUIREMENTS.md) |
| 화면 · 색 · 서체 · 움직임은? | [docs/DESIGN.md](docs/DESIGN.md) · 그림은 [docs/mockups/](docs/mockups/README.md) |
| 왜 이렇게 정했어? | [docs/decisions/](docs/decisions/README.md) |
| 스택 칸별 버전 · 근거 · CI/CD · 개발 첫날 확인할 것은? | [docs/research/final-choice-elixir.md](docs/research/final-choice-elixir.md) (2026-11-22 조사 기록, 고치지 않음) |

## 문서 규칙

기본은 전역 설정 "문서 체계" 절이다. **전역 문서 체계와 다르게** `docs/research/`를 하나 더 둔다 — 스택을 고르며 쓴 조사 메모(칸별 버전 · 확인 출처 · PlayLedger에서 가져올 것)를 결정 기록에 다 옮기면 decisions가 너무 길어지고, 버리기엔 개발 첫날 다시 볼 내용이 많아서다. `archive/`(옛 문서)와 달리 시작 전 조사라서 따로 둔다. **고치지 않는다** — 바뀐 결정은 decisions에 새로 남긴다.

## 작업 방식

기본은 전역 설정 "작업 방식" 절이다. **전역 작업 방식과 다르게** 이 저장소는 아래를 따른다 — Elixir · Phoenix · LiveView · OTP가 전부 처음이라 손으로 익히는 게 목적이다(2026-11-22 사용자 결정, minor-stacks와 같은 방식).

- **코드는 기본이 타이핑 학습 모드**: Claude는 파일에 코드를 쓰지 않고, 비유를 곁들인 주석을 단 코드를 보여 준다. 사용자가 치고 "코드 검수!"라고 하면 오타 · 버그를 리뷰한다. 수정 지시는 "파일 위치 + 지금 코드 + 바꿀 코드"로.
  - 코드에 해당하는 것: Elixir(`.ex` · `.exs`), HEEx 템플릿, 우리가 쓰는 CSS · JS(훅 포함), Ecto 마이그레이션, `mix.exs` · `config/*.exs`, Dockerfile · compose · Taskfile · CI 워크플로, `assets/package.json`.
  - **`mix` 생성기 명령(`mix phx.new` · `mix phx.gen.auth` · `mix ecto.gen.migration` 등)도 사용자가 친다.** Claude는 명령과 "무엇이 생기는지"를 먼저 보여 주고, 생긴 파일을 같이 읽는다.
  - **`iex`에서도 같다**: Claude는 평가할 식을 보여 주고, 사용자가 `iex -S mix`에서 친다.
- **자동 작업은 사용자가 요청할 때만** 한다. 익숙한 것이라도 Claude가 먼저 파일에 쓰지 않는다.
- **도구 설치 · 의존성은 사용자가 직접 받는다**: Elixir 설치, `mix.exs`의 `deps`에 줄 넣기 · `mix deps.get`, npm 패키지 모두. 큰 작업 전에 필요한 목록과 "왜 필요한지"를 먼저 보여 준다. (전역의 "자동 작업 중 미리 못 본 의존성은 Claude가 설치" 예외는 여기선 쓰지 않는다 — 자동 작업이 기본이 아니어서다.)
- **처음 나오는 것은 설명부터**: 짧게, 일상 비유로, 이 앱 어디에 쓰는지까지. 사용자가 아는 것에 빗대면 잘 통한다 — Clojure(불변 데이터 · REPL), Gleam(BEAM · 프로세스 · 패턴 매칭), Go · sqlc · goose, Python · SQLAlchemy · Alembic, React, HTMX.
- **이미 익숙한 것**은 개념 설명을 줄이고 이 스택에서 달라지는 점만 짚는다: Tailwind · daisyUI, PostgreSQL · SQL, Docker Compose, Task, GitHub Actions, PlayLedger 배포 방식.
- **문서 작성 · 목업 · 커밋 · push는 Claude가 알아서** 한다(저장소가 생긴 뒤). 사용자는 코드 타이핑에 집중한다.
- 그 밖(사전 검증 · 검증 관찰값 · 마일스톤 닫기 전 점검)은 전역 설정 그대로.

**디자인은 도구보다 먼저** — 전역 "mockups/" 절. DESIGN에 방향 · 값을 정한 뒤 daisyUI 테마 · 부품 · 움직임을 입힌다.

## 조사 · 확인 원칙

minor-stacks에서 이어 온다. **버전 · 활동 · 지원 여부 · 외부 API 조건은 기억으로 쓰지 않는다.**

| 알고 싶은 것 | 어디서 |
|---|---|
| Hex 패키지 버전 · 다운로드 | `hex.pm/api/packages/이름` (Python이 PATH에 없으니 node로 읽는다) |
| Phoenix 생성기 기본값 | `phoenixframework/phoenix` 저장소 `installer/templates/` (태그 기준) |
| 저장소 활동 · 릴리스 | `gh api repos/소유자/이름` · `.../releases` |
| 외부 API 할당량 · 약관 | 공급자 공식 페이지를 직접 읽는다. 검색 요약만으로 "확인함"이라고 적지 않는다 |

## 함정 (미리 알아 둘 것)

- **`phx.gen.auth` 해시 기본값이 OS마다 다르다**(Unix bcrypt · Windows pbkdf2, Phoenix 소스). `--hashing-lib argon2`로 못 박는다.
- **Postgres는 Docker로 따로, 포트를 비켜서**: 이 노트북은 5432에 PostgreSQL 18이 서비스로 돈다. Postgres 18 이미지 볼륨은 `/var/lib/postgresql`(pc-buildcheck · cbt-journal에서 겪음).
- **Python은 PATH에 없다**(전역 설정). 스크립트는 node로.

## 시작할 때 · 끝날 때

- **시작할 때**: [docs/DEVLOG.md](docs/DEVLOG.md) "현재 상태"를 먼저 읽는다. 저장소가 생긴 뒤에는 `git status` · `git pull --ff-only`.
- **끝날 때**: DEVLOG 맨 위에 날짜 블록을 더하고 "현재 상태"와 PLAN 진행 표를 맞춘다(`devlog` 스킬). 커밋 · push.
- 저장소: GitHub 공개 `sagming40/Itinerail`, 브랜치 `main`(2026-11-22 사용자가 `git init` · 원격 연결). 커밋 · push는 Claude가 한다.
- 커밋 메시지는 **Summary + Description**: 첫 줄은 접두사(`init` · `chore` · `feat` · `fix` · `refactor` · `docs` 등) + 한 줄 요약, 한 줄 띄우고 무엇을 · 왜 바꿨는지 목록으로.
- 공개 저장소라 비밀값 · 서버 IP · 개인 정보는 문서 · 커밋에 넣지 않는다.

## 기기

| 기기 | 이 폴더 |
|---|---|
| 노트북 | `C:\_dev\Itinerail` |

다른 기기는 GitHub에 올린 뒤 `git clone`하고 이 표에 줄을 더한다. 도구 현황은 `~/.claude/DEVTOOLS.md`.

## 말투

대화 말투는 전역 설정을 따른다. 문서 · 주석은 "~한다" 평서문.

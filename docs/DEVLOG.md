# 개발 일지

> 겪은 일 · 막힌 일 · 그때 배운 것을 적는다. **최신이 위.**
> 진행 상황은 [PLAN.md](PLAN.md), 결정의 이유는 [decisions/](decisions/README.md), 끝난 단계의 일지는 [archive/](archive/README.md).

## 현재 상태
| 항목 | 내용 |
|---|---|
| 단계 | M1 · 뼈대 + 첫 배포 |
| 진행 중 | 개발 DB(5440) · `mix db` / `mix dev` 별칭 · `phx.gen.auth`(argon2 · LiveView)까지. `mix test` 112 passed, 인증 한 바퀴 화면 확인 |
| 다음에 할 일 | daisyUI 테마(DESIGN 3 ~ 6장)를 입히고 가입 · 로그인 화면을 DESIGN 7.1대로 → `mix ci`(Credo · Sobelow) → CI → release · `mix deploy` |
| 기기별로 할 일 | **노트북**: `git pull` → `mix deps.get` → VS 개발자 셸(amd64)에서 `mix db` · `mix ecto.migrate` · `mix test`(argon2 NIF 빌드, CLAUDE.md 함정). 집 PC는 끝 |

---

## 2026-11-23 (1) · 집 PC 세팅 · 개발 DB · Mix 별칭 · phx.gen.auth (집 PC)

### 한 일
- 집 PC에 저장소(`D:\_dev\Itinerail`) — 사용자가 Elixir 1.20.5(winget) · Hex 2.7.0 설치, `mix deps.get`. phx_new 아카이브는 안 깔았다(`phx.new`에만 쓰고 `phx.gen.*`는 프로젝트 의존성 `phoenix` 안에 있다). Erlang 29.1.2 · Docker 29.8.2는 원래 있었고, 5440이 비어 있음(5432는 PostgreSQL 서비스, 5433 ~ 5438은 다른 프로젝트 compose).
- 개발 DB(사용자 타이핑): `compose.yml`(postgres:18, `127.0.0.1` · `[::1]`의 5440, 볼륨 `/var/lib/postgresql`, healthcheck) + `dev.exs` · `test.exs`에 `port: 5440`. `docker compose ps` healthy → `mix ecto.create` "The database for Itinerail.Repo has been created". 의존성 컴파일 때 나온 노란 경고(gettext · dns_cluster · `xref: [exclude:]`)는 전부 의존성 쪽 — Elixir 1.20 타입 검사가 잡은 것, 우리 앱은 깨끗.
- 첫 `mix phx.server`: `localhost:4000` 환영 화면, `home.html.heex`를 고치자 새로고침 없이 바뀜(`Live reload:` 로그) → 되돌림.
- 명령 묶기를 **Task 대신 Mix 하나로**(사용자 결정, [decisions/0005](decisions/0005-commands-mix-only.md)). 사용자가 Task · just 말고 다른 걸 원했고, mise와 비교해 Mix를 골랐다. `mix.exs` 별칭 `db`(`cmd docker compose up -d --wait`) · `db.stop` · `dev`(`db` → `phx.server`). 확인: `mix help`에 셋, `db.stop` → Stopped, `mix dev` → Healthy 뒤 서버, `mix test` 5 passed.
- `mix phx.gen.auth Accounts User users --live --hashing-lib argon2`(사용자). argon2_elixir 4.1.3 · comeonin 5.5.1, 스코프 `Itinerail.Accounts.Scope`(`schema_type: :binary_id`), 마이그레이션 citext · `users` · `users_tokens`. 생성기 결과 그대로 따로 커밋. `mix ecto.migrate` 성공, **`mix test` 112 passed**(0.8초 — test만 `t_cost: 1, m_cost: 8`).
- 화면 한 바퀴: `/users/register` 가입 → `/dev/mailbox` 링크 → "Confirm and stay logged in" → 위 메뉴 `test@example.com` · Settings · Log out → Settings 화면 → 로그아웃 → `/users/settings` 직접 입력 시 `/users/log-in`으로 + "You must log in to access this page." DB에서 사용자 1명 confirmed · 토큰 1개(세션) 확인.
- 코드 읽기(짧게): `fetch_current_scope_for_user`(세션 · 쿠키 토큰 → `current_scope`) → 라우트 `:require_authenticated_user` → LiveView `on_mount` 이중 검사. 로그인 유지 쿠키 14일, 세션 토큰 7일마다 재발급. Settings의 sudo 모드는 **10분**(`user_auth.ex:237`이 넘김, `Accounts.sudo_mode?/2` 기본값은 20분).
- `~/.claude/DEVTOOLS.md` 집 PC 절에 Elixir 줄을 더하고, 드라이브 사본(노트북에서 더 새로 고친 쪽)과 맞춰 두 파일이 같음을 `cmp`로 확인.

### [설계]
- 명령 묶기는 Mix만 — decisions 0005. 0001의 "mix 별칭 + Task"는 상태 줄에 "0005가 대체"로 표시. Docker를 부르는 별칭(`db` · `dev`)은 `test` · `ci`에 넣지 않는다(CI는 서비스 컨테이너).
- DESIGN 7.1과 다른 점: 생성기 로그인 화면은 비밀번호 폼이 펼쳐져 있다(DESIGN은 접어 둠). 테마 · 화면 단계에서 맞춘다 — 지금은 생성기 그대로.

### 막힌 것
- **`elixir --version` → `"erl.exe" is not recognized`** — 원인: 사용자 PATH가 Elixir 두 줄로 덮어써져 원래 있던 `Erlang OTP\bin` 등 23줄이 사라졌다. 내가 준 `[Environment]::SetEnvironmentVariable("Path", 옛값 + ";…", "User")`에서 옛 값이 빈 문자열로 읽혔다(이유는 확실히 모름, 시작 `;`로 보아 빈 값). 해결: 이 세션 프로세스가 아직 들고 있던 옛 PATH에서 시스템 PATH 줄을 빼 사용자 PATH 23줄 + Elixir를 되살리는 명령을 사용자가 실행 → `elixir` 1.20.5, 다른 도구도 다시 잡힘. 배운 것: PATH는 환경 변수 창 "새로 만들기"로 한 줄씩. `erl.exe`를 못 찾는다는 건 Elixir가 아니라 Erlang PATH 문제다. CLAUDE.md 함정 · DEVTOOLS에 적음.
- **argon2 NIF 빌드** — 사전 검증에서 발견: argon2_elixir 4.1.3은 Windows 완성 바이너리가 없고 `Makefile.win`(nmake + cl)로 빌드한다. 일반 PowerShell엔 둘 다 없어 VS 2022 개발자 셸(`Launch-VsDevShell.ps1 -Arch amd64 -HostArch amd64 -SkipAutomaticLocation`)에서 `mix ecto.migrate` · `mix test`를 돌려 dev · test `_build`에 `argon2_nif.dll`을 만들었다(cl 19.44 x64). 처음 한 번에 통과. MSVC 메시지가 CP949라 터미널에서 글자가 깨져 보이지만 오류 아님.
- **`mix format --check-formatted` 실패** — 원인: 내가 준 `dev.exs`의 줄 끝 주석(`port: 5440, # …`)을 포매터가 윗줄로 옮긴다. 해결: 사용자가 주석을 윗줄로 → 통과. 배운 것: Elixir 코드 예시에 줄 끝 주석을 쓰지 않는다(CLAUDE.md 함정).
- `mix phx.server`의 symlink 경고 — 개발자 모드가 켜져 있어도(레지스트리 1) 뜬다. Erlang이 비특권 심볼릭 링크 플래그를 안 넘기는 걸로 본다 *(판단)*. 복사로 대신해 리로드가 조금 느린 정도라 둠.
- Ctrl+C: 한 번 → `BREAK:` 메뉴에서 `a` → `mix.bat` 때문에 `Terminate batch job (Y/N)?`가 한 번 더 나온다. 정상.

### 이번 세션 커밋
- `bcdc8be` docs: 집 PC · PATH 함정 → `bec8c75` chore: 개발 DB 5440 → `3e7a55b` docs: decisions 0005 → `971136d` chore: mix db · db.stop · dev 별칭 → `879eea4` docs: PLAN 체크 → `a473952` init: phx.gen.auth → `7b2a48d` docs: argon2 · 줄 끝 주석 함정 → `fd2fa53` fix: dev.exs 주석

### 다음에 할 일
- "현재 상태" 다음에 할 일 · 기기별로 할 일.

## 2026-11-22 (8) · 뼈대 생성 (노트북)

### 한 일
- 사용자가 `mix phx.new . --app itinerail --binary-id`를 쳤다(의존성 받기 Y, `README.md` · `.gitignore` 덮어쓰기 n). 확인한 것: `mix.exs` `app: :itinerail`, `config/config.exs` `generators: [timestamp_type: :utc_datetime, binary_id: true]`, `README.md` · `.gitignore` 변경 없음(`git diff` 비어 있음), `AGENTS.md` 448줄(Phoenix 1.8 관례 안내 — 기본대로 둠), `deps/` 44개, `_build/`에 Tailwind 4.3.3 · esbuild 실행 파일, `deps/` · `_build/`는 `.gitignore`가 막음. 앱 코드는 아직 컴파일 안 됨(`_build/dev/lib/itinerail` 없음).
- 손대지 않은 생성기 결과 그대로 따로 커밋했다 — 뒤에 우리가 고친 것과 구분하려고.
- 개발 DB 계획: 이 노트북은 5432에 Postgres 18 서비스, 다른 프로젝트가 5433 · 5434 · 5435 · 5436 · 5438 · 5439를 쓴다(`C:\_dev\*` compose 파일 검색) → **5440**. `compose.yaml`(pc-buildcheck 모양, IPv4 · IPv6 둘 다 열기, 볼륨 `/var/lib/postgresql`, healthcheck)과 `dev.exs` · `test.exs`에 `port: 5440`을 보여 줬다 — 사용자가 다음에 친다. DB 비밀번호는 생성기가 `config/dev.exs`에 커밋하는 `postgres`/`postgres`를 그대로 써서 `.env`로 빼지 않는다(같은 값을 두 곳에 두지 않게, `127.0.0.1`에서만 열림).

### 막힌 것
- 마지막에 친 `mix phx.new`(인자 없음)가 도움말만 띄움 — 생성은 그 전 명령으로 이미 끝나 있었다. 걱정할 것 없음.

### 이번 세션 커밋 (2026-11-22, (1) ~ (8) 전체)
- `6f369c9` init: 문서 세트와 저장소 설정으로 시작 → `540ac14` 저장소 상태 맞춤 → `b163d9d` · `738d7d1` 방향 시안 → `43e47d6` E 채택 · PC 일정 판 → `62bee8e` 순서 시간순 → `66cab30` 디자인 확정 값 → `6c8638b` 하위 주소 → `8b48166` M0 점검 → `c1d9f8b` M0 닫음 → `a6599ec` · `1136684` 가입 · 로그인 화면 → `8f26e48` Elixir 설치 기록 → `eb44fce` init: mix phx.new 뼈대

### 다음에 할 일
- "현재 상태" 다음에 할 일.

## 2026-11-22 (7) · 개발 첫날 — Elixir 설치 (노트북)

### 한 일
- 설치 방법을 공식 자료로 확인: Elixir 설치 페이지(Windows는 "OTP 버전에 맞는 설치 파일"), 릴리스 v1.20.5의 `elixir-otp-29.exe`, winget `Elixir.Elixir` 1.20.5가 그 파일을 쓰고 **SHA256이 공식 `.sha256sum`과 같음**(`db2d566e…`), 필요 조건 `Erlang.ErlangOTP >= 29.0.5`(노트북 29.1.2).
- 사용자가 설치: `winget install --id Elixir.Elixir --exact` → `elixir --version` = **Elixir 1.20.5 (compiled with Erlang/OTP 29)** → `mix local.hex --force`(Hex 2.7.0) → `mix archive.install hex phx_new 1.8.17 --force`(아카이브 `~/.mix/archives/phx_new-1.8.17`).
- `DEVTOOLS.md` 노트북 절에 Elixir 줄을 더했다(원본 · 드라이브 사본).

### 막힌 것
- **설치했는데 `elixir`를 못 찾음**(사용자가 겪음 — 터미널 · VS Code를 다시 켜도 그대로) — 원인: `C:\Program Files\Elixir\bin`에 파일은 다 있고 전체 경로로는 돌았는데(1.20.5 출력), 사용자 · 시스템 PATH 어디에도 없었다. 설치 프로그램은 `update_system_path.erl`로 PATH를 넣는데 winget 조용한 설치에서 그 단계가 빠졌다고 본다 *(판단)*. 해결: 사용자 PATH에 bin 폴더를 직접 추가 → VS Code 완전히 다시 켬 → 됨. 배운 것: 설치 뒤 "다시 켜도 안 되면" 실행 파일 위치와 PATH를 따로 본다.
- **`iex`는 PowerShell 별칭**(`Invoke-Expression`) — 미리 확인, `iex.bat`로 연다. CLAUDE.md 함정에 둘 다 적었다.
- **내 실수로 DEVTOOLS.md 두 사본이 깨짐** — Elixir 줄을 넣다 경로의 역슬래시가 사라져(`node -e` 따옴표) PowerShell로 고치려 했는데, 배열 인덱싱이 문자열 대신 문자 하나(`'|'`)를 돌려줘 `Replace('|', $null)`가 표 구분자 527개를 전부 NUL로 바꿨다. 같은 명령이 드라이브 사본에도 돌았다. 복구: NUL → `|`로 되돌리고(527개, 남은 제어 문자 0) 경로를 고친 뒤 두 사본이 같은지 `cmp`로 확인. 배운 것: 파일 고치기는 편집 도구나 스크립트 파일로, 사본 두 곳에 한 번에 쓰는 명령은 먼저 하나에만 돌려 본다.

### 정한 것 (다음 명령)
- `mix phx.new . --app itinerail --binary-id` — 폴더 이름이 대문자라 앱 이름을 소문자로 못 박고, 기본 키를 UUID로(여행 주소의 번호를 짐작할 수 없게. 막는 건 여전히 멤버 확인이다 — REQUIREMENTS 4장). 나머지는 생성기 기본(Postgres · Bandit · Tailwind + daisyUI · esbuild · 메일 · 대시보드 · LiveView). 생성기가 `AGENTS.md`(Phoenix 관례 안내)를 만드는데 기본대로 둔다 *(사용자 확인 전)*.

## 2026-11-22 (6) · M1 첫 작업 — 가입 · 로그인 화면 (노트북)

### 한 일
- `phx.gen.auth`(Phoenix v1.8.17 템플릿 소스)가 만드는 화면 · 흐름 · 문구를 읽었다: 가입은 메일만(`registration_live`), 로그인은 매직 링크 + 비밀번호 폼 둘(`login_live`), 링크 열면 "로그인 유지 / 이번만"(`confirmation_live`), 설정은 sudo 모드. 기간은 `schema_token` · `auth`에서: 매직 링크 15분, 세션 · 로그인 유지 쿠키 14일, 메일 바꾸기 7일. 로그인 링크 안내 문구는 가입 여부를 드러내지 않는다("If your email is in our system…").
- 그 흐름 그대로 E 방향 화면을 그렸다 — [mockups/Auth.html](mockups/Auth.html): 모바일 상태 열 개 + PC 로그인(왼쪽 큰 창문 + 기차 띠, 오른쪽 양식). 화면마다 창밖 풍경이 다르다.
- DESIGN에 7장 "화면별 규칙"을 열고 7.1 가입 · 로그인(흐름 · 배치 · 상태 · 문구 표)을 썼다. 3장 색에 `danger` · `success`를 더했다(대비: 라이트 카드 위 5.96 · 5.05, 다크 7.10 · 8.61 — node로 계산).
- 브라우저 확인(1440 × 900): 보드 · `?s=confirm` · `?s=login&dark=1` · PC 로그인 스크린샷, 콘솔 오류 0.

### 막힌 것
- 제목("어디로 떠나 볼까요?")이 14px로 작게 나옴 — 원인: 보드의 `.slot h2` 규칙이 `.title`보다 구체적이라 이겼다. 해결: `.slot .title`로.

### 정한 것
- 비밀번호 로그인은 **생성기 기본대로 둔다**(사용자) — 설정에서 켠 사람만, 로그인 화면엔 접어 둠. 메일을 못 여는 상황의 대안. DESIGN 7.1에 적었다.

### 다음에 할 일
- 개발 첫날: Elixir 설치(사용자) → `mix phx.new` → `phx.gen.auth --hashing-lib argon2`.

## 지난 단계

- **M0 · 정하기** ✅ 2026-11-22 — 이름 Itinerail · 문서 세트 · 공개 저장소 · 방향 E 기차 창가 · 디자인 확정 값 · 카드 순서 시간순 · 하위 주소 `rail.sagming.com`. 닫기 전 점검에서 화면 목업 7개 · 빈 상태 문구를 각 단계 첫 작업으로 미룸. → [archive/DEVLOG_M0.md](archive/DEVLOG_M0.md)

# 개발 일지

> 겪은 일 · 막힌 일 · 그때 배운 것을 적는다. **최신이 위.**
> 진행 상황은 [PLAN.md](PLAN.md), 결정의 이유는 [decisions/](decisions/README.md), 끝난 단계의 일지는 [archive/](archive/README.md).

## 현재 상태
| 항목 | 내용 |
|---|---|
| 단계 | M1 · 뼈대 + 첫 배포 |
| 진행 중 | 뼈대 생성까지(`mix phx.new`, 커밋 `eb44fce`). 개발 DB는 아직 — 서버를 한 번도 안 띄웠다 |
| 다음에 할 일 | `compose.yaml`(Postgres 18, 포트 **5440**) · `config/dev.exs` · `test.exs`에 `port: 5440` 타이핑(사용자) → `docker compose up -d` → `mix ecto.create` → `mix phx.server` → 코드 검수 → Taskfile → `phx.gen.auth --hashing-lib argon2` |
| 기기별로 할 일 | 노트북만 씀. 다른 기기는 `git clone https://github.com/sagming40/Itinerail` |

---

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

# 최종 조합 — Elixir (두 번째 스택)

> **Clojure 다음으로 쓸 두 번째 스택을 마이너로만 골라 칸마다 확정한 문서다.** Clojure 쪽 확정안은 [final-choice.md](final-choice.md) · [rest_of_stack.md](rest_of_stack.md), 후보 스택의 근거는 [minor_stacks.md](minor_stacks.md) · [major_but_minor_stacks.md](major_but_minor_stacks.md), 부품 · 움직임의 갈래 설명은 [ui_components.md](ui_components.md) · [animation_ui.md](animation_ui.md).
> 2026-11-22 노트북에서 대화로 고르고 사용자가 확정했다. 버전은 같은 날 Hex API(`hex.pm/api/packages/이름`) · GitHub 릴리스로, 기본 구성은 **Phoenix v1.8.17 생성기 템플릿 소스**(`installer/templates/phx_single/mix.exs.eex`)로, 그 밖은 공식 문서 · 소스(아래 각 절에 출처)로 확인했다. 공식 자료에 없는 내 판단은 *(판단)*으로 표시했다. **시험 앱은 아직 돌리지 않았다.**

## 결론

**Elixir + Phoenix + LiveView — 생성기 기본값을 뼈대로, 모양은 daisyUI · 까다로운 부품만 Zag.js · 움직임은 브라우저 기본 먼저**

| 칸 | 고른 것 |
|---|---|
| 언어 | **Elixir** (BEAM 위 동적 함수형) |
| 백 | **Phoenix** |
| 프런트 | **LiveView** — 화면 상태를 서버 프로세스가 들고 바뀐 부분만 웹소켓으로 보낸다. 브라우저 쪽은 작은 JS 클라이언트뿐 |

**어떻게 여기까지 왔나** (2026-11-22 대화)
- 메이저 + 마이너 섞기(ASP.NET Core + F# 등)도 봤지만 **마이너로만** 가기로 했다. 이미 써 본 Gleam · Lustre · Clojure는 뺐다.
- 남은 후보 중 Phoenix LiveView(실제로 끝까지 만들기 · 자료 중상) · Haskell IHP(패러다임이 가장 크게 바뀜, Nix · WSL 세팅이 무거움) · OCaml(Gleam과 ML 계열로 겹침) 순으로 보고 **Phoenix LiveView**를 골랐다.
- 프런트를 따로 두는 안(Phoenix JSON API + ReScript · React)도 봤지만 앞뒤 사이 칸(API 계약 · 토큰 · 서버 두 개)이 다시 생겨서 **LiveView로 돌아왔다.**
- 이 구조는 실시간이 있어야 장점이 산다 — 무엇을 만들지 고를 때 실시간 요소를 기준에 넣는다 *(판단)*.

## 한눈에

| 절 | 칸 | 고른 것 | 버전 (2026-11-22) | 누가 정했나 |
|---|---|---|---|---|
| 기반 | 언어 · 런타임 | Elixir + Erlang/OTP | Elixir 1.20.5 (2026-10-29) · OTP 29.1.2 (2026-10-14) | — |
| 기반 | 웹 프레임워크 | Phoenix | 1.8.17 (2026-11-20) | — |
| 기반 | 화면 | LiveView + HEEx | phoenix_live_view 1.2.15 (2026-11-21) · phoenix_html 4.4.0 | — |
| 기반 | 웹 서버 | Bandit | 1.15.0 | 생성기 |
| 백 | 부품 수명 관리 | OTP 슈퍼비전 트리 (언어 내장) | | 생성기 |
| 백 | 설정 | `config/*.exs` + `runtime.exs`(환경 변수) | | 생성기 |
| 백 | DB | PostgreSQL (Docker, 따로 포트) | | 기존 방식 |
| 백 | DB 접근 · 마이그레이션 | Ecto + Postgrex, `mix ecto.gen.migration` | ecto_sql 3.14.0 · postgrex 0.22.4 | 생성기 |
| 백 | 인증 | `mix phx.gen.auth` **`--hashing-lib argon2`** | | 생성기 + 고름 |
| 백 | 메일 | Swoosh + Req | 1.30.0 · 0.7.5 | 생성기 |
| 백 | 실시간 | Phoenix.PubSub · Presence (내장) | | 생성기 |
| 백 | 백그라운드 작업 | Oban — **필요해질 때만** | 2.24.2 | 고름 |
| 프런트 | 모양 | Tailwind v4 + **daisyUI** (DESIGN 값으로 테마를 덮음) + heroicons | daisyUI 태그 v5.5.20 (생성기 고정) | 생성기 |
| 프런트 | 기본 부품 | 생성된 `core_components.ex` + 브라우저 `<dialog>` · `popover` + `Phoenix.LiveView.JS` | | 고름 |
| 프런트 | 까다로운 부품 | **Zag.js** 순수 JS 어댑터를 colocated hook으로 — npm 들이는 날부터 | | 고름 |
| 프런트 | 움직임 | `JS.transition` · CSS(`@starting-style` · 스크롤 연동) · **View Transitions**(`onDocumentPatch`) → **anime.js** v4(npm 들이는 날부터) | | 고름 |
| 프런트 | JS · CSS 빌드 | esbuild · tailwind **단독 실행 파일**(Hex로 받음, Node 불필요) | esbuild 0.10.1 · tailwind 0.5.2 | 생성기 |
| 검사 | 형식 | `mix format` (내장) | | 생성기 |
| 검사 | 린트 | Credo | 1.7.19 | 고름 |
| 검사 | 타입 | Elixir 1.20 컴파일러 경고 — Dialyxir는 넣지 않음 | | 고름 |
| 검사 | 보안 | Sobelow + `mix hex.audit` (내장) | sobelow 0.19.0 | 고름 |
| 테스트 | 기본 | ExUnit + `Phoenix.LiveViewTest` + LazyHTML | lazy_html 0.1.14 | 생성기 |
| 테스트 | 가짜 객체 | Mox — 필요할 때 | 1.3.2 | 고름 |
| 개발 | 모니터링 · 디버깅 | LiveDashboard + **LiveDebugger** | 0.9.1 · 1.0.3 | 생성기 + 고름 |
| 개발 | 편집기 | VS Code + **ElixirLS** (Expert는 맛보기) | ElixirLS v0.31.1 · Expert v0.2.4 | 고름 |
| 운영 | 명령 묶기 | **mix 별칭**(Elixir 안) + **Task**(Elixir 밖) | | 고름 |
| 운영 | CI | GitHub Actions + erlef/setup-beam → `mix ci` | setup-beam v1.24.1 | 고름 |
| 운영 | 이미지 | `mix phx.gen.release --docker` → GHCR | | 생성기 + 고름 |
| 운영 | 배포 | **PlayLedger 방식** — `task deploy` → 서버 release 스크립트 | | 고름 |

- "생성기"는 `mix phx.new`가 기본으로 넣어 주는 것이다. 고를 게 없어서 Clojure 때보다 칸이 훨씬 적다 — Clojure에서 직접 고른 Ring · Integrant · Aero · next.jdbc · Migratus · Transit · Malli 공유 칸이 Phoenix에서는 생성기 기본값이나 언어 내장으로 사라진다.
- Elixir 1.20은 OTP 27 ~ 29를 지원한다(Elixir 공식 "Compatibility and deprecations" 표). 노트북에 OTP 29가 있으니 Elixir만 새로 깐다.

## 1. 생성기가 정해 주는 것

Phoenix v1.8.17 생성기 템플릿 소스로 확인한 기본 의존성: `phoenix_ecto` · `ecto_sql` · `postgrex` · `phoenix_html` · `phoenix_live_reload`(개발) · `phoenix_live_view` · `lazy_html`(테스트) · `phoenix_live_dashboard` · `esbuild` · `tailwind` · heroicons(GitHub 태그 v2.2.0) · **daisyUI(GitHub 태그 v5.5.20)** · `swoosh` · `req` · `telemetry_metrics` · `telemetry_poller` · `gettext` · `jason` · `dns_cluster` · 웹 서버(Bandit).

생성기가 만들어 주는 mix 별칭(같은 템플릿):

| 별칭 | 하는 일 |
|---|---|
| `setup` | `deps.get` → `ecto.setup` → `assets.setup` → `assets.build` |
| `ecto.setup` · `ecto.reset` | DB 만들기 · 마이그레이션 · 시드 / 지우고 다시 |
| `test` | 테스트 DB를 조용히 만들고 마이그레이션한 뒤 테스트 |
| `assets.deploy` | tailwind · esbuild `--minify` → `phx.digest` |
| `precommit` | `compile --warnings-as-errors` → `deps.unlock --unused` → `format` → `test` (test 환경에서) |

- **Node 없이 시작한다**: tailwind · esbuild를 Hex 패키지가 단독 실행 파일로 받아 오고, daisyUI · heroicons도 GitHub 태그를 직접 받는다. Clojure 구성(shadow-cljs · npm)과 가장 크게 다른 점이다.
- daisyUI는 v5.5.20으로 고정돼 들어온다. ui_components.md에 적은 최신(v5.8.0, 2026-11-14)으로 올릴지는 디자인을 정할 때 본다.
- 실시간: PubSub · Channels · Presence(접속자 추적)가 추가 의존성 없이 들어 있다(major_but_minor_stacks.md Elixir 절).
- `dns_cluster`는 서버 여러 대를 묶을 때 쓴다. 서버 한 대라 손대지 않는다 *(판단)*.

## 2. 백엔드에서 고른 것

### 인증: `mix phx.gen.auth --hashing-lib argon2`

- Phoenix 소스(`lib/mix/tasks/phx.gen.auth.ex`) 문서: 해시 라이브러리 기본값은 **Unix에서 bcrypt, Windows에서 pbkdf2**다. `--hashing-lib`로 `bcrypt` · `pbkdf2` · `argon2`를 고를 수 있고, 공식이 **argon2를 가장 튼튼하다며 권한다**.
- 그대로 두면 노트북(Windows)에서 만든 프로젝트는 pbkdf2가 되고, 다른 기기에서 만들면 bcrypt가 된다 → **옵션으로 못 박는다.** PlayLedger도 argon2를 골랐다(PlayLedger decisions 0004).
- 감수할 것: argon2_elixir는 C로 컴파일되는 라이브러리다. Windows에서는 MSVC가 필요하다 *(판단)* — 노트북에 VS 2022(MSVC)가 있다. 개발 첫날 실제로 빌드되는지 본다.

### 백그라운드 작업: Oban — 필요해질 때만

- Postgres만으로 돌아가는 작업 큐라 Redis가 필요 없다 *(판단: 공식 소개 기준, 이번에 문서를 다시 읽지는 않음)*. 정기 수집 · 메일 재시도 같은 일이 생기면 들인다.

### 메일

- 매직 링크 로그인에 메일이 필요하다. 개발 중에는 Swoosh가 주는 메일함 미리보기로 보고, 운영 메일 서비스는 배포를 정할 때 고른다.

## 3. 프런트에서 고른 것

### 부품 — 모양은 daisyUI, 까다로운 동작은 상태 머신

Clojure 구성의 역할 나누기(final-choice.md "역할 나누기")를 그대로 가져온다.

| 부품 | 맡는 것 | 이유 |
|---|---|---|
| 버튼 · 카드 · 입력 · 배지 · 알림 · 표 | **daisyUI** 클래스 + 생성된 `core_components.ex` | 모양만 있으면 되는 부품 |
| 다이얼로그 · 팝오버 | 브라우저 `<dialog>` · `popover` + `Phoenix.LiveView.JS` | npm 없이 키보드 · 포커스를 꽤 처리한다 *(판단)* |
| 콤보박스 · 날짜 선택 · 메뉴 등 Zag 1순위 부품 | **Zag.js 순수 JS 어댑터**(`@zag-js/vanilla`)를 colocated hook으로 + daisyUI 테마 토큰으로 모양 | 상태 머신 경험을 이어 간다. 고르는 범위는 final-choice.md "Zag.js 부품 고르기" |

**LiveView용 부품 라이브러리 — 비교용** (Hex 2026-11-22. "최근"은 Hex의 최근 다운로드 수)

| 이름 | 갈래 | 상태 | 판정 |
|---|---|---|---|
| Petal Components | 코드 복사형(shadcn 스타일) | 4.18.1 · 최근 7.5만 | 안 씀 — 자기 모양을 가져와 daisyUI와 모양 체계가 둘이 된다 *(판단)* |
| SaladUI | 코드 복사형(shadcn 스타일) | 1.0.0 · GitHub 별 1,059 · MIT | 같은 이유로 안 씀 |
| Doggo | 헤드리스 Phoenix 부품 | 0.18.4 · 별 404 · MIT · 2026-11 활동 | 보류 — 결은 맞지만 Zag와 역할이 겹친다 |
| **Corex** | Zag.js 훅을 묶은 Phoenix 부품 | 0.2.3 · 별 68 · 최근 2,863 · GitHub에서 라이선스 확인 안 됨(`NOASSERTION`) | **지켜볼 목록** — 하려는 것과 가장 가깝지만 아직 작고 라이선스가 불분명하다 |
| Mishka Chelekom | 생성기형 UI 키트 | 0.0.10 | 안 씀 |

### 움직임 — 브라우저 기본 먼저, 엔진은 필요해질 때

| 자리 | 도구 |
|---|---|
| 보이기 · 숨기기 · 클래스 전환 | `JS.show` · `JS.hide` · `JS.transition` + Tailwind 클래스 (LiveView 내장) |
| 처음 나타날 때 · 스크롤 연동 | CSS `@starting-style` · `animation-timeline` (Baseline은 animation_ui.md 1층) |
| 화면 상태 전환 | **View Transitions** — `LiveSocket` 옵션 `dom.onDocumentPatch(start)`에서 `document.startViewTransition(start)` |
| SVG · 드래그 · 순서 있는 연출 | **anime.js v4**를 colocated hook으로. 훅의 `destroyed`에서 `scope.revert()` *(판단: Clojure 때 `useEffect` 정리와 같은 자리)* |

- **View Transitions 확인 결과**: LiveView 소스 `assets/js/phoenix_live_view/live_socket.ts`에 `onDocumentPatch` 옵션이 있고, 주석 예시가 바로 `document.startViewTransition(start)`이다. "start 콜백은 받은 순서대로, 되도록 빨리 불러야 한다"는 주의가 붙어 있다. 높은 수준 API는 **일부러 만들지 않았다** — 제안 이슈 #4092가 2025-12-21 "not planned"로 닫혔고, 메인테이너가 별도 패키지로 실험해 보라고 답했다.
- 모든 화면 갱신에 전환을 걸면 실시간 갱신마다 전환이 돈다 → **표시가 있을 때만 켠다** *(판단: 방법은 구현할 때 정함)*.
- 안 쓰는 것: Motion(React 전용), AutoAnimate(LiveView의 DOM 교체와 부딪힐 수 있다 *(판단)*), Rive · Lottie · 3D(이번 범위 밖).

### 훅 JS 두는 곳: colocated hooks

- LiveView 공식 가이드(`guides/client/js-interop.md`): HEEx 안에 `<script :type={Phoenix.LiveView.ColocatedHook} name=".이름">`으로 훅을 컴포넌트 옆에 둔다. 빌드 때 `phoenix-colocated/앱이름` 폴더로 뽑혀 나오고, 새 프로젝트의 esbuild 설정에 기본으로 들어 있다(`{:esbuild, "~> 0.10"}` 이상).
- LiveView 1.2부터 **colocated CSS**(`Phoenix.LiveView.ColocatedCSS`)도 있다(1.2 CHANGELOG). 이름이 점(`.`)으로 시작하는 훅은 그 모듈 범위로 묶여 다른 컴포넌트와 이름이 겹치지 않는다.

### npm 들이는 날 — Zag.js와 anime.js를 같이

- Phoenix 공식 가이드(`guides/asset_management.md`): `npm install 패키지 --prefix assets`로 `assets/package.json`을 만들면 esbuild가 알아서 읽는다. 체크아웃 · 릴리스 빌드에서 깔리게 `assets.build` · `assets.deploy` 별칭에 `"cmd --cd assets npm ci"`를 넣으라고 한다. 다른 길은 파일을 `assets/vendor/`에 직접 넣는 것(vendoring).
- 그날부터 **"Node 없이 시작"이 깨진다** → Zag.js와 anime.js를 따로 들이지 않고, 콤보박스나 SVG 연출이 처음 필요해지는 단계에서 **한 번에** 들인다. 그 전까지는 daisyUI · `<dialog>` · JS 명령 · CSS · View Transitions만 쓴다.

## 4. 검사 · 테스트 · 개발 도구

| 칸 | 고른 것 | 이유 |
|---|---|---|
| 형식 | `mix format` | 내장. 고를 게 없다 |
| 린트 | **Credo** 1.7.19 | 사실상 표준 *(판단: 최근 다운로드 약 560만)* |
| 타입 | Elixir 1.20 컴파일러 경고. **Dialyxir 1.4.9는 넣지 않는다** | Dialyxir는 느리다. 컴파일러가 점점 많이 잡아 준다 *(판단 — 1.20이 실제로 어디까지 잡는지는 개발하며 본다)* |
| 보안 | **Sobelow** 0.19.0 + `mix hex.audit` | Sobelow는 Phoenix 전용 정적 보안 분석. mix_audit 2.1.5는 마지막 릴리스가 2025-06이라 보조로만 |
| 테스트 | ExUnit + `Phoenix.LiveViewTest` + LazyHTML (생성기) · Mox(필요할 때) | ExMachina는 넣지 않는다 — 생성기가 만드는 fixture로 충분하다 *(판단)* |
| 디버깅 | LiveDashboard(생성기) + **LiveDebugger** 1.0.3 | LiveView 상태 · 이벤트를 들여다보는 전용 도구. Clojure 때 re-frame-10x를 못 붙였던 자리 |
| 편집기 | VS Code + **ElixirLS** v0.31.1 | Expert(elixir-lang 공식 언어 서버)는 아직 v0.2.4라 맛보기로 *(판단)* |

## 5. 명령 묶기 — mix 별칭 + Task

Elixir는 **mix 별칭이 명령 묶기 도구로 들어 있다.** 그래서 나눠 맡긴다.

| 어디에 | 무엇 | 예 |
|---|---|---|
| **mix 별칭** (`mix.exs`) | Elixir 안에서 끝나는 것 | 생성기 별칭(`setup` · `precommit` 등) + 새로 만들 **`ci`**: `format --check-formatted` → `compile --warnings-as-errors` → `credo --strict` → `sobelow` → `test` |
| **Taskfile** | Elixir 밖의 것 | `task db`(Docker Postgres) · `task dev` · `task ci`(→ `mix ci`) · `task deploy` |

- **just가 아니라 Task인 이유**: cbt-journal · PlayLedger가 Task + `scripts/deploy.ps1` 구조다. 배포 스크립트를 거의 그대로 가져온다.
- Taskfile에는 mix 명령을 다시 풀어 쓰지 않고 별칭만 부른다 — 같은 내용이 두 곳에 생기지 않게.

## 6. CI/CD — PlayLedger 방식

**왜 PlayLedger 방식인가**
1. **새로 배울 것을 Elixir에 몰아준다.** Elixir · Phoenix · LiveView · OTP가 다 처음이다. 배포까지 새 방식이면 막혔을 때 원인 후보가 두 배가 된다. PlayLedger 구조는 이미 운영 중이다(2026-11-04 첫 배포, 11-05 `task deploy` 첫 실행 — PlayLedger SERVER.md).
2. **12월 서버 이사와 안 부딪힌다.** "이미지 빌드 → SSH → 서버 스크립트" 구조는 서버가 Vultr든 AWS든 같다. 바뀌는 건 SSH 별명과 DNS A 레코드뿐이다. PaaS(Fly.io 등)는 크레딧으로 서버비 0원을 만드는 계획(전역 설정 "서버 이사 계획")에서 벗어난다.
3. **Phoenix가 그 자리에 맞는다.** `mix phx.gen.release --docker`가 Dockerfile과 `rel/migrate.sh`(운영 마이그레이션 진입점)를 만든다.
4. **안전장치를 그대로 쓴다.** PlayLedger `scripts/deploy.ps1`이 이미 다듬어 둔 확인들이다(아래).

**PlayLedger에서 가져올 것** (2026-11-22, PlayLedger `9bea557` 기준으로 읽음)

| PlayLedger | 하는 일 | 이 스택에서 |
|---|---|---|
| `ci.yml` `test` (pytest) | 테스트 | setup-beam + Postgres 서비스 컨테이너 + `deps` · `_build` 캐시 → `mix ci` |
| `ci.yml` `web` (Vue lint · tsc · test · build) | 프런트 검사 | **없어진다** — LiveView라 프런트 빌드가 mix 안에 있다 |
| `ci.yml` `images` | `needs: [test, web]`, main push일 때만, **GHCR**에 `커밋 SHA` 태그로 push, GHA 캐시 | 같은 구조, Dockerfile만 phx.gen.release 것 |
| `ci.yml` `audit` | 알려진 취약점. 테스트와 섞지 않고 따로 | `sobelow` · `mix hex.audit` |
| `scripts/deploy.ps1` | 미커밋 없음 → 지금 커밋 = origin/main → 그 커밋의 CI 성공을 GitHub API로 기다림 → SSH로 서버 release 스크립트 한 번 → 밖에서 헬스 확인. `-DryRun`은 서버에 안 간다 | 그대로. 저장소 · 사이트 · SSH 별명만 바꾼다 |
| 서버 `play-release` | 이미지 받기 → 직전 백업 → 마이그레이션 → 교체 → 헬스 | 마이그레이션을 `bin/migrate`(release)로 |

- **배포를 push 자동이 아니라 `task deploy`로 사람이 시작한다** — PlayLedger 구조 그대로다. 자동 배포 대신 이걸 고른 이유는 PlayLedger 문서에서 찾지 못했다(SERVER.md · decisions 목록에서 안 보임). deploy.ps1 주석이 밝힌 건 확인 단계의 이유다: 기기가 3대라 push 안 한 코드나 뒤처진 코드로 운영을 덮어쓰는 일을 막는다. "CI 성공 = 이미지 있음"(images가 test · web 뒤에 돈다)이라 CI가 실패한 커밋은 서버가 받을 이미지가 없다.
- **공식 Dockerfile 템플릿**: 빌드 이미지 `hexpm/elixir:<Elixir>-erlang-<OTP>-debian-<버전>`, 실행 이미지 `debian:<버전>`. 템플릿 주석이 **Alpine보다 Debian/Ubuntu를 권한다**(DNS 해석 실패 · 동적 링크 네이티브 라이브러리 문제).
- 안 고른 것: **Kamal 2**(v2.12.0) — Docker만 있으면 어디든 배포하는 좋은 도구지만 새 도구가 하나 는다. Ruby 쪽 도구라 설치 방식도 따로 봐야 한다 *(판단)*. **Fly.io 등 PaaS** — 위 2번.

## 개발 첫날에 확인할 것

| 확인할 것 | 왜 |
|---|---|
| Elixir 설치(사용자) · `mix phx.new` · `mix setup`이 Windows에서 끝까지 도는지 | 처음 띄우는 것 자체가 목적이다 |
| `phx.gen.auth --hashing-lib argon2`가 Windows에서 빌드되는지 | argon2_elixir는 C 컴파일이 필요하다 *(판단)* |
| ElixirLS가 VS Code에서 경고 · 정의 이동을 보여 주는지 | Clojure 때 "오타가 늦게 잡힘" 불편이 얼마나 남는지 |
| 서버 메모리 | 1GB 서버에서 BEAM 릴리스가 얼마나 쓰는지는 배포할 서버에서 직접 잰다(12월 이사 뒤) |

## 아직 안 정한 것

- **무엇을 만들지** — 실시간이 있는 것이 이 구조와 맞는다 *(판단)*. 후보는 [ideas.md](ideas.md) 보관함: 둘이 하는 실시간 턴제 보드게임 · 같이 쓰는 뽀모도로 · 실시간 투표 · 오늘의 시드 순위표.
- **디자인 방향** — 도구보다 먼저(전역 "mockups/" 절). daisyUI 테마 · 부품 · 움직임 값은 그 뒤에 입힌다.
- **프로젝트 폴더 · 저장소 이름 · 하위 주소**, 운영 메일 서비스, 배포 서버(12월 이사 뒤).

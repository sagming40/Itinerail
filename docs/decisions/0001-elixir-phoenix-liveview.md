# 0001. 스택은 Elixir + Phoenix + LiveView, 생성기 기본값을 뼈대로

- 상태: 채택
- 날짜: 2026-11-22

## 맥락

"써 보면 생각하는 방식이 바뀌는" 스택으로 새 프로젝트를 하려 했다(조사는 minor-stacks 저장소). 처음 고른 Clojure 풀스택 포트폴리오에서 갈아타면서 다시 골랐다. 이미 써 본 Gleam · Lustre · Clojure는 뺐고, **마이너로만** 짜기로 했다. 기준은 minor-stacks의 네 조건 — 재미, 막혔을 때 참고 자료(중상 이상), 실제로 끝까지 만들 수 있음, 1GB 서버.

## 결정

- 언어 **Elixir**, 백 **Phoenix**, 프런트 **LiveView**.
- `mix phx.new` 생성기 기본값(Bandit · Ecto · Tailwind + daisyUI · esbuild · Swoosh · LiveDashboard 등)을 뼈대로 쓰고, 고르는 칸은 검사(Credo · Sobelow) · 부품 · 움직임을 들이는 시점 · 명령 묶기(mix 별칭 + Task) · 배포(PlayLedger 방식)뿐이다.
- 모양은 daisyUI, 까다로운 부품만 Zag.js, 움직임은 브라우저 기본(JS 명령 · CSS · View Transitions) 먼저 + anime.js. Zag.js · anime.js는 **npm 들이는 날 하나로 묶는다**.
- 칸별 버전 · 근거 · 확인 출처는 [research/final-choice-elixir.md](../research/final-choice-elixir.md)(2026-11-22 확인).

## 검토한 대안

- **메이저 + 마이너 섞기** (ASP.NET Core + F#, Spring Boot + Vaadin): 마이너로만 가기로 해서 뺐다.
- **메이저로만** (Spring Boot + React): 같은 이유.
- **Haskell IHP**: 패러다임이 가장 크게 바뀌지만 Nix · WSL 세팅이 무겁다.
- **OCaml (Dream + Melange)**: Gleam과 ML 계열로 겹친다.
- **Phoenix JSON API + ReScript · React**: 앞뒤 사이 칸(API 계약 · 토큰 · 서버 두 개)이 다시 생긴다.

## 감수할 것

- Elixir는 동적 타입이라 오타가 실행이나 컴파일 경고에서야 드러난다(Clojure 때 불편이 일부 남는다).
- LiveView는 실시간이 있어야 장점이 산다 — 만들 것을 고를 때 이 기준을 넣었다([0002](0002-travel-planner-topic.md)).
- LiveView는 오프라인이 안 된다. View Transitions는 저수준 훅(`onDocumentPatch`)으로만 건다(높은 수준 API는 LiveView 팀이 일부러 안 만들었다).
- npm을 들이는 날부터 "Node 없이 시작"이 깨진다.

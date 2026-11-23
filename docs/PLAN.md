# 개발 계획

> **무엇을 어떤 순서로 만들고, 어디까지 왔는지** 적는 문서다. 진행 상황은 여기에만 둔다.
> 무엇을 만들고 무엇을 안 만드는지는 [REQUIREMENTS.md](REQUIREMENTS.md), 겪은 일은 [DEVLOG.md](DEVLOG.md), 결정의 이유는 [decisions/](decisions/README.md), 스택 칸별 버전 · 근거는 [research/final-choice-elixir.md](research/final-choice-elixir.md).

## 1. 목표

친구 · 가족과 **여행 일정을 같이, 실시간으로** 짜고, 다녀온 뒤 경비를 정산하고 돌아보는 웹앱 **Itinerail**(itinerary + rail).

- **같이 짠다**: 날짜별 일정 카드(장소 · 시간 · 메모 · 태그)를 여럿이 동시에 고치고 끌어 옮긴다. 누가 어디를 보고 있는지 보인다.
- **동선은 노선도처럼**: 실제 지도 대신 하루의 장소를 역처럼 찍고 선으로 잇는 추상 동선.
- **국내 + 해외**, **경비 정산**(누가 누구에게 얼마 — 보여 주기만), **미래와 과거**(출발 전 알림 메일, 다녀온 여행 돌아보기).

이 프로젝트로 얻으려는 것: ① 확정 스택(Elixir + Phoenix + LiveView, [decisions/0001](decisions/0001-elixir-phoenix-liveview.md))을 칸마다 역할대로 쓴다(아래 표) ② 처음 다뤄 보는 도메인(여행) ③ **여럿이 동시에 고치는 문제를 OTP로 푸는 경험**.

### 스택 칸이 맡는 곳

| 스택 칸 | 이 앱에서 |
|---|---|
| LiveView + HEEx | 모든 화면 — 일정 판 · 정산 · 돌아보기 |
| **GenServer + 슈퍼비전** (DynamicSupervisor · Registry) | **여행마다 프로세스 하나가 편집을 줄 세워 받는다** — 순서 바꾸기 · 옮기기 · 메모 수정이 한 줄로 지나가서 순서가 저절로 정해진다. 아무도 없으면 스스로 끝난다 |
| PubSub | 확정된 변경을 여행 멤버 화면에 뿌린다 |
| Presence | 날짜 칸마다 지금 보고 있는 멤버 얼굴, "누가 이 카드를 편집 중" |
| Ecto + PostgreSQL | 여행 · 멤버 · 날짜 · 일정 카드 · 장소 · 태그 · 체크리스트 · 지출 · 분담 |
| `phx.gen.auth` (argon2) + scope | 가입 · 로그인(매직 링크), **남의 여행은 못 봄** |
| Swoosh | 초대 메일, 출발 D-1 "내일 일정", 변경 요약 |
| **Oban** | 출발 D-1 메일 예약, 변경 요약 묶어 보내기, 초대 만료 정리 |
| daisyUI | 카드 · 배지 · 표 · 알림 — DESIGN 값으로 덮은 테마 |
| **Zag.js** | 여행 기간 **Date Picker(범위)** · 장소 **Combobox** · 태그 **Tags Input** · 카드 **Menu** · 확인 **Dialog** |
| **anime.js** | 카드 **끌어 옮기기**(드래그) · 동선 **SVG 선 그리기** · 순서가 바뀔 때 역이 미끄러지는 연출 |
| View Transitions (`onDocumentPatch`) | 날짜 바꾸기 · 카드 → 상세 |
| CSS 스크롤 연동 | **돌아보기 화면의 주인공** — 내려가면 날짜별 동선이 차례로 그려진다 |
| Elixir behaviour | **장소 검색 어댑터** — 국내 · 해외 공급자를 같은 함수 모양 뒤에 숨긴다([decisions/0003](decisions/0003-place-search-providers.md)) |
| mix 별칭 · Mix 태스크 | 명령 묶기 전부 — `mix db` · `mix dev` · `mix ci` · `mix deploy`([decisions/0005](decisions/0005-commands-mix-only.md)) |
| CI/CD | research/final-choice-elixir.md 6장 |

## 2. 진행 현황

| 단계 | 내용 | 상태 |
|---|---|---|
| M0 | 정하기 — 저장소 · 하위 주소 · 디자인 방향 · DESIGN | ✅ 2026-11-22 |
| M1 | 뼈대 + 첫 배포 | 🔄 |
| M2 | 혼자 짜기 | ⬜ |
| M3 | 같이 짜기 (실시간 · OTP) | ⬜ |
| M4 | 장소 검색 + npm 들이는 날 | ⬜ |
| M5 | 정산 | ⬜ |
| M6 | 미래 · 과거 (Oban · 돌아보기) | ⬜ |
| M7 | 다듬기 | ⬜ |

표기: ⬜ 시작 전 / 🔄 진행 중 / ✅ 완료 + 날짜. 계획에 없던 작업은 `*(계획에 없던 작업)*`.

## 3. 단계별 작업과 완료 기준

완료 기준은 속을 수 없는 형태로만 쓴다: 테스트 건수, 응답 코드, 실제 기기에서 한 동작. 기능 번호(F-xx)는 [REQUIREMENTS.md](REQUIREMENTS.md) 2장.

### M0 · 정하기
- [x] 프로젝트 이름 — Itinerail (2026-11-22)
- [x] `docs/` 세트 · decisions 0001 ~ 0003 (2026-11-22)
- [x] `git init` · GitHub 공개 저장소 `sagming40/Itinerail` · 원격 연결(사용자), 첫 커밋 `6f369c9` · push (2026-11-22)
- [x] 저장소 설정 파일 `.gitattributes` · `.editorconfig` · `.gitignore` (사용자, 2026-11-22)
- [x] 하위 주소 `rail.sagming.com` (2026-11-22 사용자). DNS 레코드는 배포 서버가 정해지는 M1에서 — 개인 기록 앱이라 Cloudflare **DNS만(회색 구름)**, HTTPS는 서버 Caddy(전역 설정 "공용 인프라")
- [x] 디자인 방향 한 문장 → 목업 시안 비교 → [DESIGN.md](DESIGN.md) 확정 값 — 방향 E 기차 창가, 색 · 글꼴(Pretendard) · 모양 · 움직임 3 ~ 6장 (2026-11-22)
- [x] 카드 순서 규칙 — 시간순 자동(decisions 0004) *(계획에 없던 작업)*
- [x] 작업 방식 — 코드는 타이핑 학습 모드(프로젝트 CLAUDE.md, 2026-11-22)
- **완료 기준**: DESIGN에 방향 · 색 · 글꼴 · 모양 · 움직임 표가 있고, [mockups/README.md](mockups/README.md)에 고른 시안이 "채택"

### M1 · 뼈대 + 첫 배포
- [x] 첫 작업: 가입 · 로그인 화면 목업(`mockups/Auth.html`) · 상태 · 문구를 DESIGN 7.1에 *(M0 점검에서 미룸)* (2026-11-22)
- [x] Elixir 1.20.5 · Hex · phx_new 1.8.17 설치(사용자, 2026-11-22)
- [x] `mix phx.new . --app itinerail --binary-id`(사용자, 커밋 `eb44fce`, 2026-11-22)
- [x] 개발 DB(Docker Postgres 18, 포트 5440) · 첫 `mix phx.server`(집 PC, 커밋 `bec8c75`, 2026-11-23)
- [x] `mix db` · `mix db.stop` · `mix dev` 별칭(decisions 0005 — Taskfile 대신, 커밋 `971136d`, 2026-11-23)
- [x] `phx.gen.auth Accounts User users --live --hashing-lib argon2`(사용자, 커밋 `a473952`, `mix test` 112 passed, 화면 한 바퀴, 2026-11-23)
- [ ] daisyUI 테마(DESIGN 3 ~ 6장) · 가입 · 로그인 화면을 DESIGN 7.1대로(비밀번호 폼 접기 · 문구)
- [ ] `mix ci` 별칭(Credo · Sobelow) · CI · release 이미지 · `mix deploy` · 배포
- **완료 기준**: `mix ci` 통과, CI 초록, **휴대폰(LTE)으로 하위 주소에서 가입 → 매직 링크 로그인**

### M2 · 혼자 짜기
- [ ] 첫 작업: 내 여행 목록 · 여행 만들기 · 카드 상세 화면 목업(`mockups/`) · 빈 상태 / 로딩 / 오류 · 문구를 DESIGN에 *(M0 점검에서 미룸)*
- [ ] F-02 · F-03(시간순 자동 · 시간 미정 묶음, decisions 0004) · F-04(다른 날로 옮기기 — 드래그는 M4, 여기선 버튼) · F-07 정적 동선
- **완료 기준**: 남의 여행 주소 → 404(테스트), 빈 날짜 · 하루짜리 · 30일짜리 여행 화면

### M3 · 같이 짜기
- [ ] 첫 작업: 멤버 · 초대 화면 목업(`mockups/`) · 빈 상태 / 로딩 / 오류 · 문구를 DESIGN에 *(M0 점검에서 미룸)*
- [ ] F-05 · F-06 — 여행 GenServer · DynamicSupervisor · Registry · PubSub · Presence
- **완료 기준**: **두 브라우저에서 같은 카드를 동시에 다른 날로 옮겨도 양쪽 화면 결과가 같다**(LiveViewTest로 재현), 보기 전용 멤버의 편집 요청 거부(테스트), 여행 프로세스를 강제로 죽여도 다시 뜨고 DB 상태와 같다

### M4 · 장소 검색 + npm 들이는 날
- [ ] 시작 전 확인: REQUIREMENTS 3장 "M4 전에 확인할 것"
- [ ] F-08 장소 검색 어댑터, Zag(Date Picker · Combobox · Menu · Dialog), anime.js(드래그 · 선 그리기)
- **완료 기준**: 카카오 429 · Photon 장애를 흉내 내도 직접 입력으로 일정 추가가 된다(테스트), 키보드만으로 장소 검색 → 선택

### M5 · 정산
- [ ] 첫 작업: 경비 · 정산 화면 목업(`mockups/`) · 빈 상태 / 로딩 / 오류 · 문구를 DESIGN에 *(M0 점검에서 미룸)*
- [ ] F-09 — 통화 · 환율, 최소 송금 계산
- **완료 기준**: 나누어떨어지지 않는 금액의 나머지가 정해진 규칙대로 한 사람에게 가고 합계가 0(테스트), 통화 섞인 지출 정산이 손으로 계산한 값과 같다

### M6 · 미래 · 과거
- [ ] 첫 작업: 준비물 · 돌아보기 화면 목업(`mockups/`) · 빈 상태 / 로딩 / 오류 · 문구를 DESIGN에 *(M0 점검에서 미룸)*
- [ ] F-12 · F-13 · F-14 (Oban · Swoosh · 스크롤 연동)
- **완료 기준**: Oban 테스트 모드로 D-1 메일이 KST 기준 정해진 시각에 한 번만 예약된다

### M7 · 다듬기
- [ ] 나머지 S 기능

## 4. 아직 안 정한 것

- 배포 서버 — 12월 AWS 이사 뒤(전역 설정 "서버 이사 계획"). 운영 메일 발송 서비스.
- 카카오 앱 등록 — 카카오맵 무료 쿼터는 "개발자 계정에서 처음 활성화한 앱에만" 준다(카카오 쿼터 페이지). 키는 사용자가 발급한다.
- 정산 금액 저장 방식(통화별 최소 단위 정수 vs Decimal) — M5 설계 때.

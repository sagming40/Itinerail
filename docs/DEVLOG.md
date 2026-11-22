# 개발 일지

> 겪은 일 · 막힌 일 · 그때 배운 것을 적는다. **최신이 위.**
> 진행 상황은 [PLAN.md](PLAN.md), 결정의 이유는 [decisions/](decisions/README.md), 끝난 단계의 일지는 [archive/](archive/README.md).

## 현재 상태
| 항목 | 내용 |
|---|---|
| 단계 | M1 · 뼈대 + 첫 배포 |
| 진행 중 | 첫 작업(가입 · 로그인 목업 · 문구, DESIGN 7.1) 끝 |
| 다음에 할 일 | 개발 첫날 — Elixir 설치(사용자) → `mix phx.new` → `phx.gen.auth --hashing-lib argon2` (`research/final-choice-elixir.md` "개발 첫날에 확인할 것") |
| 기기별로 할 일 | 노트북만 씀. 다른 기기는 `git clone https://github.com/sagming40/Itinerail` |

---

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

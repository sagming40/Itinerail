defmodule ItinerailWeb.Scenery do
  @moduledoc """
  기차 창문과 창밖 풍경(DESIGN 1 · 3 · 5 · 6장).

  모양 · 색은 docs/mockups/Tokens.html에서 옮겼고, 이제 이 파일이 원본이다.
  그림은 390 × 180 기준이고, 창문 크기에 맞춰 잘라 채운다(slice).
  """
  use Phoenix.Component

  # 풍경 하나 = 이름 + 하늘 두 색 + 해 + 먼 땅 · 가까운 땅(색 · 경로).
  # 해는 바다 · 사막만 낮게 뜬다(해 질 녘).
  @scenes %{
    sea: %{
      name: "바다 노을",
      sky_top: "#ff8a65",
      sky_bottom: "#ffd59e",
      sun: "#fff3d6",
      sun_y: 112,
      far_color: "#c2667a",
      far:
        "M0 120 L40 98 L80 110 L130 84 L180 104 L230 90 L280 108 L330 92 L390 112 L390 180 L0 180Z",
      near_color: "#5b4a7a",
      near:
        "M0 140 Q 25 132 50 140 T 100 140 T 150 140 T 200 140 T 250 140 T 300 140 T 350 140 T 400 140 L400 180 L0 180Z"
    },
    mountain: %{
      name: "산 · 온천 아침",
      sky_top: "#7fc3ff",
      sky_bottom: "#e6f5ff",
      sun: "#fffbe8",
      sun_y: 54,
      far_color: "#7aa98f",
      far:
        "M0 128 L50 70 L95 112 L150 52 L210 118 L255 80 L310 120 L350 88 L390 126 L390 180 L0 180Z",
      near_color: "#3f6f5a",
      near: "M0 150 Q 60 128 120 146 T 240 142 T 390 148 L390 180 L0 180Z"
    },
    city: %{
      name: "도시 · 공항",
      sky_top: "#5aa0e6",
      sky_bottom: "#cfe8ff",
      sun: "#ffffff",
      sun_y: 54,
      far_color: "#9fb3c8",
      far:
        "M0 124 h30 v-26 h22 v26 h18 v-44 h26 v44 h20 v-30 h30 v30 h24 v-56 h20 v56 h28 v-22 h34 v22 h22 v-38 h26 v38 h70 v56 H0Z",
      near_color: "#4d6178",
      near: "M0 152 L390 152 L390 180 L0 180Z"
    },
    field: %{
      name: "들판 · 시골길",
      sky_top: "#9ad0ec",
      sky_bottom: "#f4f1d0",
      sun: "#fff6c2",
      sun_y: 54,
      far_color: "#a8c47a",
      far: "M0 132 Q 100 112 200 126 T 390 120 L390 180 L0 180Z",
      near_color: "#6f8f45",
      near:
        "M0 150 L20 144 L22 150 L60 146 L62 150 L110 145 L112 150 L170 146 L172 150 L240 144 L242 150 L320 146 L322 150 L390 147 L390 180 L0 180Z"
    },
    snow: %{
      name: "설산 · 겨울",
      sky_top: "#b8c9e8",
      sky_bottom: "#f3f6fb",
      sun: "#ffffff",
      sun_y: 54,
      far_color: "#dfe7f2",
      far:
        "M0 130 L60 64 L80 80 L120 40 L170 110 L230 58 L260 76 L300 50 L350 104 L390 90 L390 180 L0 180Z",
      near_color: "#8a9bb8",
      near: "M0 152 Q 90 140 180 150 T 390 148 L390 180 L0 180Z"
    },
    desert: %{
      name: "사막 · 해 질 녘",
      sky_top: "#f2a65a",
      sky_bottom: "#fbe3b8",
      sun: "#fff1d0",
      sun_y: 112,
      far_color: "#d9925a",
      far: "M0 140 Q 70 104 150 132 Q 230 96 310 128 Q 350 112 390 124 L390 180 L0 180Z",
      near_color: "#a0603a",
      near: "M0 156 Q 120 146 240 154 T 390 152 L390 180 L0 180Z"
    }
  }

  # 풍경 순서. 날짜마다 안 고르면 이 순서로 돌려 쓴다(DESIGN 3장, M2).
  # 맵은 순서를 약속하지 않아서 목록을 따로 둔다.
  @scene_names [:sea, :mountain, :city, :field, :snow, :desert]

  def scene_names, do: @scene_names

  @doc """
  기차 창문 하나. 창밖 풍경이 왼쪽으로 흐른다.

      <Scenery.train_window id="login-window" scene={:sea} class="h-60" />
  """
  attr :id, :string, required: true, doc: "창문이 여럿이어도 하늘 그라데이션 id가 겹치지 않게"
  attr :scene, :atom, required: true, values: @scene_names
  attr :class, :any, default: nil
  slot :inner_block, doc: "창문 위에 얹을 것(앱 이름 등)"

  def train_window(assigns) do
    assigns = assign(assigns, :s, Map.fetch!(@scenes, assigns.scene))

    ~H"""
    <div id={@id} class={["train-window", @class]}>
      <svg
        class="scene"
        viewBox="0 0 390 180"
        preserveAspectRatio="xMidYMid slice"
        aria-hidden="true"
      >
        <defs>
          <linearGradient id={"#{@id}-sky"} x1="0" y1="0" x2="0" y2="1">
            <stop offset="0" stop-color={@s.sky_top} />
            <stop offset="1" stop-color={@s.sky_bottom} />
          </linearGradient>
        </defs>
        <rect width="390" height="180" fill={"url(##{@id}-sky)"} />
        <circle cx="300" cy={@s.sun_y} r="24" fill={@s.sun} />
        <.land class="far" color={@s.far_color} d={@s.far} />
        <.land class="near" color={@s.near_color} d={@s.near} />
      </svg>
      <span class="where" aria-hidden="true">창밖 · {@s.name}</span>
      {render_slot(@inner_block)}
    </div>
    """
  end

  # 같은 땅을 두 장 이어 붙인다(0과 390). 한 장 길이만큼 왼쪽으로 흘린 뒤 처음으로
  # 돌아가도 이음매가 안 보인다 — 회전 초밥 레일이 끝없이 도는 것처럼.
  attr :class, :string, required: true
  attr :color, :string, required: true
  attr :d, :string, required: true

  defp land(assigns) do
    ~H"""
    <g class={@class} fill={@color}>
      <path d={@d} />
      <path d={@d} transform="translate(390 0)" />
    </g>
    """
  end
end

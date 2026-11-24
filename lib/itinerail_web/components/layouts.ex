defmodule ItinerailWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use ItinerailWeb, :html
  alias ItinerailWeb.Scenery

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://phoenix.hexdocs.pm/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <%!-- 위 띠: 왼쪽 앱 이름, 오른쪽 테마 토글 + 사용자 메뉴 --%>
    <header class="navbar px-4 sm:px-6 lg:px-8">
      <div class="flex-1">
        <%!-- "/"는 LiveView가 아니라 컨트롤러 화면이라 navigate 말고 href(페이지를 새로 받는다) --%>
        <.link href={~p"/"} class="text-lg font-extrabold tracking-tight">Itinerail</.link>
      </div>
      <nav class="flex items-center gap-2 text-sm">
        <.theme_toggle />
        <%!-- current_scope는 "지금 누가 타고 있나" 승차권. 없으면 nil --%>
        <%= if @current_scope do %>
          <%!-- 좁은 화면에선 메일을 숨긴다(HTML에는 남는다) --%>
          <span class="hidden sm:inline text-muted">{@current_scope.user.email}</span>
          <.link href={~p"/users/settings"} class="btn btn-ghost btn-sm">설정</.link>
          <%!-- method="delete": 링크지만 DELETE 요청으로 보낸다(로그아웃은 GET으로 하면 안 된다) --%>
          <.link href={~p"/users/log-out"} method="delete" class="btn btn-ghost btn-sm">
            로그아웃
          </.link>
        <% else %>
          <.link href={~p"/users/register"} class="btn btn-ghost btn-sm">가입</.link>
          <.link href={~p"/users/log-in"} class="btn btn-primary btn-sm">로그인</.link>
        <% end %>
      </nav>
    </header>

    <main class="px-4 py-10 sm:px-6 lg:px-8">
      <div class="mx-auto max-w-2xl space-y-4">
        {render_slot(@inner_block)}
      </div>
    </main>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  가입 · 로그인 화면 틀(DESIGN 7.1).

  모바일은 창문이 위, PC는 왼쪽에 기차 옆면 패널이 선다.

      <Layouts.auth flash={@flash} scene={:sea}>
        <h1>어디로 떠나 볼까요?</h1>
      </Layouts.auth>
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :scene, :atom, default: :sea, doc: "창밖 풍경 — 화면마다 다르게"
  slot :inner_block, required: true

  def auth(assigns) do
    ~H"""
    <%!-- PC에서만 두 칸(1.35 : 1). 모바일은 그냥 위에서 아래로 --%>
    <div class="min-h-dvh lg:grid lg:grid-cols-[1.35fr_1fr]">
      <%!-- PC 왼쪽: 기차 옆면. 모바일에선 숨긴다 --%>
      <aside class="hidden lg:flex flex-col gap-4.5 bg-train p-7">
        <Scenery.train_window id="auth-window-pc" scene={@scene} class="big flex-1">
          <.brand />
        </Scenery.train_window>
        <div class="rail"></div>
        <p class="text-white">
          <b class="block text-3xl leading-tight tracking-tight">다음 여행, 같이 짜요</b>
          <span class="text-[15px] text-white/70">
            창밖으로 지나가는 풍경처럼 일정도 함께 흘러가요.
          </span>
        </p>
      </aside>

      <div class="flex min-h-dvh flex-col lg:items-center lg:justify-center lg:p-10">
        <%!-- 모바일 위쪽 창문. PC에선 숨긴다 --%>
        <Scenery.train_window
          id="auth-window"
          scene={@scene}
          class="mx-3.5 mt-3.5 h-59 shrink-0 lg:hidden"
        >
          <.brand />
        </Scenery.train_window>

        <%!-- 테스트가 "main a"로 링크를 찾으니 본문은 main 안에 둔다 --%>
        <main class="flex w-full flex-col gap-3.5 px-5.5 pt-6 pb-7 lg:w-95 lg:p-0">
          {render_slot(@inner_block)}
        </main>

        <div class="mt-auto flex justify-center pb-5 lg:mt-8 lg:pb-0">
          <.theme_toggle />
        </div>
      </div>
    </div>

    <.flash_group flash={@flash} />
    """
  end

  # 창문 왼쪽 위 앱 이름. 누르면 홈으로.
  defp brand(assigns) do
    ~H"""
    <.link href={~p"/"} class="brand"><i></i>Itinerail</.link>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title="⚡ 인터넷에 연결할 수 없어요 ⚡"
        phx-disconnected={
          show(".phx-client-error #client-error")
          |> JS.remove_attribute("hidden", to: ".phx-client-error #client-error")
        }
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        다시 연결하는 중이에요... <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title="⚠️ 문제가 생겼어요 ⚠️"
        phx-disconnected={
          show(".phx-server-error #server-error")
          |> JS.remove_attribute("hidden", to: ".phx-server-error #server-error")
        }
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        다시 연결하는 중이에요... <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full border border-base-200 bg-base-100 brightness-200 left-0 in-data-[theme=light]:left-1/3 in-data-[theme=dark]:left-2/3 in-data-[theme-source=system]:left-0! transition-[left]" />

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end
end

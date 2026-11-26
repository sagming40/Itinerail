defmodule ItinerailWeb.UserLive.Confirmation do
  use ItinerailWeb, :live_view

  alias Itinerail.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.auth flash={@flash} scene={:city}>
      <div>
        <h1 class="text-2xl font-bold tracking-tight">어서 오세요</h1>
        <p class="mt-1 text-muted">{@user.email}</p>
      </div>

      <%!-- 아직 확인 안 된 계정: 누르면 가입 확인 + 로그인 --%>
      <.form
        :if={!@user.confirmed_at}
        for={@form}
        id="confirmation_form"
        phx-mounted={JS.focus_first()}
        phx-submit="submit"
        action={~p"/users/log-in?_action=confirmed"}
        phx-trigger-action={@trigger_submit}
      >
        <input type="hidden" name={@form[:token].name} value={@form[:token].value} />
        <.button
          name={@form[:remember_me].name}
          value="true"
          phx-disable-with="확인하는 중…"
          class="btn btn-primary w-full"
        >
          이 기기에서 로그인 유지 <span aria-hidden="true">→</span>
        </.button>
        <.button phx-disable-with="확인하는 중…" class="btn btn-secondary w-full mt-2">
          이번만 로그인
        </.button>
      </.form>

      <%!-- 이미 확인된 계정: 로그인만 --%>
      <.form
        :if={@user.confirmed_at}
        for={@form}
        id="login_form"
        phx-submit="submit"
        phx-mounted={JS.focus_first()}
        action={~p"/users/log-in"}
        phx-trigger-action={@trigger_submit}
      >
        <input type="hidden" name={@form[:token].name} value={@form[:token].value} />
        <%= if @current_scope do %>
          <.button phx-disable-with="로그인하는 중…" class="btn btn-primary w-full">
            로그인 <span aria-hidden="true">→</span>
          </.button>
        <% else %>
          <.button
            name={@form[:remember_me].name}
            value="true"
            phx-disable-with="로그인하는 중…"
            class="btn btn-primary w-full"
          >
            이 기기에서 로그인 유지 <span aria-hidden="true">→</span>
          </.button>
          <.button phx-disable-with="로그인하는 중…" class="btn btn-secondary w-full mt-2">
            이번만 로그인
          </.button>
        <% end %>
      </.form>

      <%!-- 버튼이 둘일 때만 뜻을 풀어 준다 --%>
      <p :if={!@current_scope} class="text-center text-xs text-muted">
        로그인 유지는 14일이에요. 공용 기기라면 '이번만'을 눌러 주세요.
      </p>

      <p
        :if={!@user.confirmed_at}
        class="rounded-box border border-base-300 p-3 text-sm text-muted"
      >
        <b class="block text-base-content">비밀번호가 편하신가요?</b> 설정에서 비밀번호를 켤 수 있어요.
      </p>
    </Layouts.auth>
    """
  end

  @impl true
  def mount(%{"token" => token}, _session, socket) do
    if user = Accounts.get_user_by_magic_link_token(token) do
      form = to_form(%{"token" => token}, as: "user")

      {:ok, assign(socket, user: user, form: form, trigger_submit: false),
       temporary_assigns: [form: nil]}
    else
      {:ok,
       socket
       |> put_flash(:error, "링크가 만료됐어요\n로그인 링크는 15분 동안, 한 번만 사용할 수 있어요. 새 링크를 받아 주세요.")
       |> push_navigate(to: ~p"/users/log-in")}
    end
  end

  @impl true
  def handle_event("submit", %{"user" => params}, socket) do
    {:noreply, assign(socket, form: to_form(params, as: "user"), trigger_submit: true)}
  end
end

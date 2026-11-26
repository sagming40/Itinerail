defmodule ItinerailWeb.UserLive.Login do
  use ItinerailWeb, :live_view

  alias Itinerail.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <%!-- 틀은 Layouts.auth — 창문(바다)은 틀이 그리고, 여기는 오른쪽 양식만 --%>
    <Layouts.auth flash={@flash} scene={:sea}>
      <%!-- 제목 두 벌: 처음 온 사람 / 설정 바꾸려다 다시 확인받는 사람(sudo) --%>
      <div>
        <%= if @current_scope do %>
          <h1 class="text-2xl font-bold tracking-tight">다시 한 번 확인해주세요</h1>
          <p class="mt-1 text-muted">계정 설정을 바꾸려면 다시 로그인해 주세요.</p>
        <% else %>
          <h1 class="text-2xl font-bold tracking-tight">어디로 떠나 볼까요?</h1>
          <p class="mt-1 text-muted">
            메일로 로그인 링크를 보내 드릴게요. 비밀번호는 없어도 돼요.
          </p>
        <% end %>
      </div>

      <%!-- 기본 길: 매직 링크. 승차권을 메일로 부쳐 주는 쪽 --%>
      <.form
        :let={f}
        for={@form}
        id="login_form_magic"
        action={~p"/users/log-in"}
        phx-submit="submit_magic"
      >
        <.input
          readonly={!!@current_scope}
          field={f[:email]}
          type="email"
          label="이메일"
          autocomplete="username"
          spellcheck="false"
          required
          phx-mounted={JS.focus()}
        />
        <%!-- 누르는 동안엔 버튼을 잠그고 글자를 바꾼다 — 두 번 눌러 메일이 두 통 가는 걸 막는다 --%>
        <.button class="btn btn-primary w-full" phx-disable-with="보내는 중…">
          로그인 링크 받기 <span aria-hidden="true">→</span>
        </.button>
      </.form>

      <div class="divider text-muted">또는</div>

      <%!--
        비밀번호는 접어 둔 서랍. open은 서버가 정하는 "처음 상태"일 뿐이고,
        ignore_attributes는 사용자가 연 서랍을 LiveView가 다시 그리면서 닫지 않게
        "open 칸은 건드리지 마" 하고 붙여 두는 메모다.
      --%>
      <details
        id="password-login"
        open={@password_open}
        phx-mounted={JS.ignore_attributes(["open"])}
      >
        <summary class="cursor-pointer text-sm font-semibold text-muted">
          비밀번호로 로그인
        </summary>

        <.form
          :let={f}
          for={@form}
          id="login_form_password"
          action={~p"/users/log-in"}
          phx-submit="submit_password"
          phx-trigger-action={@trigger_submit}
          class="mt-3"
        >
          <.input
            readonly={!!@current_scope}
            field={f[:email]}
            type="email"
            label="이메일"
            autocomplete="username"
            spellcheck="false"
            required
          />
          <.input
            field={@form[:password]}
            type="password"
            label="비밀번호"
            autocomplete="current-password"
            spellcheck="false"
          />
          <.button class="btn btn-primary w-full" name={@form[:remember_me].name} value="true">
            로그인 유지 <span aria-hidden="true">→</span>
          </.button>
          <.button class="btn btn-secondary w-full mt-2">
            이번만 로그인
          </.button>
        </.form>
      </details>

      <%!-- 이미 로그인한 사람(sudo)에게 "가입하기"는 어색하니 숨긴다 --%>
      <p :if={!@current_scope} class="text-center text-sm text-muted">
        처음이에요 · <.link
          navigate={~p"/users/register"}
          class="font-semibold text-base-content hover:underline"
          phx-no-format
        >가입하기</.link>
      </p>

      <p :if={local_mail_adapter?()} class="text-center text-xs text-muted">
        개발 중에는 실제 메일 대신 <.link href="/dev/mailbox" class="underline">/dev/mailbox</.link>에서 볼 수 있어요.
      </p>
    </Layouts.auth>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    # 컨트롤러는 비밀번호가 틀렸을 때만 :email을 flash에 넣어 돌려보낸다.
    # 그 쪽지가 있으면 "비밀번호로 하다 왔구나" → 서랍을 열어 둔다.
    flash_email = Phoenix.Flash.get(socket.assigns.flash, :email)

    email =
      flash_email ||
        get_in(socket.assigns, [:current_scope, Access.key(:user), Access.key(:email)])

    form = to_form(%{"email" => email}, as: "user")

    {:ok, assign(socket, form: form, trigger_submit: false, password_open: flash_email != nil)}
  end

  @impl true
  def handle_event("submit_password", _params, socket) do
    {:noreply, assign(socket, :trigger_submit, true)}
  end

  def handle_event("submit_magic", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_login_instructions(
        user,
        &url(~p"/users/log-in/#{&1}")
      )
    end

    # 첫 줄 = 굵은 제목, 둘째 줄 = 본문 (③에서 만든 split_flash가 나눠 준다)
    # 가입 여부는 드러내지 않는다 — 있든 없든 같은 문구
    info =
      "이메일을 확인해 주세요\n가입된 이메일로 로그인 링크가 전송돼요. 링크는 15분 동안 한 번만 사용할 수 있어요."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> push_navigate(to: ~p"/users/log-in")}
  end

  defp local_mail_adapter? do
    Application.get_env(:itinerail, Itinerail.Mailer)[:adapter] == Swoosh.Adapters.Local
  end
end

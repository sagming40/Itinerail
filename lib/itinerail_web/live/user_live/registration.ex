defmodule ItinerailWeb.UserLive.Registration do
  use ItinerailWeb, :live_view

  alias Itinerail.Accounts
  alias Itinerail.Accounts.User

  @impl true
  def render(assigns) do
    ~H"""
    <%!-- 로그인과 같은 틀, 창 밖만 들판으로 --%>
    <Layouts.auth flash={@flash} scene={:field}>
      <div>
        <h1 class="text-2xl font-bold tracking-tight">처음이신가요?</h1>
        <p class="mt-1 text-muted">
          이메일만 있으면 돼요. 비밀번호는 설정에서 만들 수 있어요.
        </p>
      </div>

      <.form for={@form} id="registration_form" phx-submit="save" phx-change="validate">
        <%!-- debounce="blur": 칠 때마다 검사하지 않고 칸에서 손을 뗄 때 한 번만 --%>
        <.input
          field={@form[:email]}
          type="email"
          label="이메일"
          autocomplete="username"
          spellcheck="false"
          required
          phx-debounce="blur"
          phx-mounted={JS.focus()}
        />
        <.button class="btn btn-primary w-full" phx-disable-with="보내는 중…">
          가입 메일 받기 <span aria-hidden="true">→</span>
        </.button>
      </.form>

      <p class="text-center text-sm text-muted">
        이미 계정이 있어요 · <.link
          navigate={~p"/users/log-in"}
          class="font-semibold text-base-content hover:underline"
          phx-no-format
        >로그인</.link>
      </p>
    </Layouts.auth>
    """
  end

  @impl true
  def mount(_params, _session, %{assigns: %{current_scope: %{user: user}}} = socket)
      when not is_nil(user) do
    {:ok, redirect(socket, to: ItinerailWeb.UserAuth.signed_in_path(socket))}
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_email(%User{}, %{}, validate_unique: false)

    {:ok, assign_form(socket, changeset), temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_login_instructions(
            user,
            &url(~p"/users/log-in/#{&1}")
          )

        # 조사(로/으로)는 주소 끝 글자에 따라 달라지기 때문에 "에"로 피한다
        info =
          "승차권이 발급됐어요\n#{user.email}에 가입 확인 메일을 보냈어요. " <>
            "메일 링크를 눌러주세요."

        {:noreply,
         socket
         |> put_flash(:info, info)
         |> push_navigate(to: ~p"/users/log-in")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_email(%User{}, user_params, validate_unique: false)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")
    assign(socket, form: form)
  end
end

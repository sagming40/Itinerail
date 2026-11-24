defmodule ItinerailWeb.PageControllerTest do
  use ItinerailWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "다음은 어디로 떠나볼까요?"
  end
end

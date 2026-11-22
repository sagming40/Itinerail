defmodule ItinerailWeb.PageController do
  use ItinerailWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end

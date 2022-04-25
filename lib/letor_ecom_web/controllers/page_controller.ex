defmodule LetorEcomWeb.PageController do
  use LetorEcomWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

defmodule BalaioWeb.PageController do
  use BalaioWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.

    businesses = Balaio.Catalog.list_business()

    conn
    |> put_layout(html: :public)
    |> render(businesses: businesses)
  end
end

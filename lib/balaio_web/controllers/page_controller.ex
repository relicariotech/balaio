defmodule BalaioWeb.PageController do
  use BalaioWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    businesses = Balaio.Catalog.list_business()
    render(conn, :home, layout: false, businesses: businesses)
  end
end

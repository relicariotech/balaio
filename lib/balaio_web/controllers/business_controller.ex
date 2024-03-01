defmodule BalaioWeb.BusinessController do
  use BalaioWeb, :controller

  def index(conn, _params) do
    businesses = Balaio.Catalog.list_business()

    conn
    |> put_layout(html: :public)
    |> render(:index, businesses: businesses)
  end

  def show(conn, %{"id" => id}) do
    business =
      id
      |> Balaio.Catalog.get_business!()

    conn
    |> put_layout(html: :public)
    |> render(:show, business: business)
  end
end

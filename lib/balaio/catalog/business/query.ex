defmodule Balaio.Catalog.Business.Query do
  import Ecto.Query
  alias Balaio.Catalog.Business
  alias Balaio.Catalog.Category

  def base, do: Business

  def filter_by_category(query \\ base(), filter) do
    query
    |> apply_category_filter(filter)
  end

  defp apply_category_filter(query, "all") do
    query
  end

  defp apply_category_filter(query, filter) do
    query
    |> where([b, c], c.category == ^filter)
  end
end

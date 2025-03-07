defmodule Balaio.Catalog.Category.Query do
  import Ecto.Query
  alias Balaio.Catalog.Category
  alias Balaio.Catalog.BusinessCategory

  def base, do: Category

  def with_count_business(query \\ base()) do
    query
    |> join_business
    |> count_business
  end

  defp join_business(query) do
    query
    |> join(:inner, [c], bc in BusinessCategory, on: bc.category_id == c.id)
  end

  defp count_business(query) do
    query
    |> group_by([c], c.title)
    |> select([c, bc], {c.title, count(bc.business_id)})
  end

  def filter_by_category(query \\ base(), filter) do
    query
    |> apply_category_filter(filter)
  end

  defp apply_category_filter(query, "all") do
    query
  end

  defp apply_category_filter(query, filter) do
    query
    |> where([b, c], c.category_id == ^filter)
  end
end

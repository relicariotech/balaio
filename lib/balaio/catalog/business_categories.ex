defmodule Balaio.Catalog.BusinessCategory do
  use Ecto.Schema
  import Ecto.Changeset

  alias Balaio.Catalog.Business
  alias Balaio.Catalog.Category

  @foreign_key_type :binary_id
  schema "business_categories" do
    belongs_to :business, Business
    belongs_to :category, Category
  end

  def changeset(business_category, attrs) do
    business_category
    |> cast(attrs, [:business_id, :category_id])
    |> unique_constraint([:business, :category],
      name: "business_categories_business_id_category_id_index"
    )
  end
end

defmodule Balaio.Catalog.Category do
  use Ecto.Schema
  import Ecto.Changeset

  alias Balaio.Catalog.BusinessCategory

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "categories" do
    field :title, :string

    many_to_many :business, BusinessCategory, join_through: "business_categories"
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> unique_constraint(:title)
  end
end

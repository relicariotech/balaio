defmodule Balaio.Catalog.Category do
  use Ecto.Schema
  import Ecto.Changeset

  alias Balaio.Catalog.BusinessCategory

  schema "categories" do
    field :title, :string

    many_to_many :business, BusinessCategory, join_through: "business_categories"

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> unique_constraint(:title)
  end
end

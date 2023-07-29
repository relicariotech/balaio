defmodule Balaio.Catalog.Business do
  use Ecto.Schema
  import Ecto.Changeset

  alias Balaio.Catalog.Category

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "business" do
    field :name, :string
    field :address, :string
    field :description, :string
    field :category, :string
    field :phone, :string
    field :thumbnail, :string
    field :is_delivery, :boolean, default: false
    field :user_id, :binary_id

    many_to_many :categories, Category, join_through: "business_categories", on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(business, attrs) do
    business
    |> cast(attrs, [
      :name,
      :description,
      :phone,
      :address,
      :category,
      :thumbnail,
      :is_delivery
    ])
    |> validate_required([
      :name,
      :description,
      :phone,
      :address,
      :category,
      :thumbnail,
      :is_delivery
    ])
    |> unique_constraint(:user_id)
  end
end

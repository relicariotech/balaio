defmodule Balaio.Catalog.Business do
  use Ecto.Schema
  import Ecto.Changeset

  alias Balaio.Catalog.Category
  alias Balaio.Catalog.BusinessCategory

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "business" do
    field :name, :string
    field :address, :string
    field :description, :string
    field :phone, :string
    field :thumbnail, :string
    field :is_delivery, :boolean, default: false
    field :user_id, :binary_id

    has_many :business_categories, BusinessCategory, on_replace: :delete

    has_many :categories, through: [:business_categories, :category]

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
      :thumbnail,
      :is_delivery
    ])
    |> validate_required([
      :name,
      :description,
      :phone,
      :address,
      :thumbnail,
      :is_delivery
    ])
    |> cast_assoc(:business_categories, with: &BusinessCategory.changeset/2)
    |> unique_constraint(:user_id)
  end
end

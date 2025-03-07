defmodule Balaio.Catalog.Business do
  use Ecto.Schema
  import Ecto.Changeset

  alias Balaio.Accounts.User
  alias Balaio.Catalog.BusinessCategory

  schema "business" do
    field :name, :string
    field :address, :string
    field :description, :string
    field :phone, :string
    field :thumbnail, :string
    field :is_delivery, :boolean, default: false
    belongs_to :user, User

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
      :is_delivery,
      :user_id
    ])
    |> validate_required([
      :name,
      :description,
      :phone,
      :address,
      :thumbnail,
      :is_delivery
      # :user_id
    ])
    |> cast_assoc(:business_categories,
      with: &BusinessCategory.changeset/2,
      sort_param: :categories_order,
      drop_param: :categories_delete
    )

    # |> unique_constraint(:name, :name)
  end
end

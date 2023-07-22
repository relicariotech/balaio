defmodule Balaio.Catalog.Business do
  use Ecto.Schema
  import Ecto.Changeset

  alias Balaio.Accounts.User

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

    belongs_to :user, User

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
      :is_delivery,
      :user_id
    ])
    |> validate_required([
      :name,
      :description,
      :phone,
      :address,
      :category,
      :thumbnail,
      :is_delivery,
      :user_id
    ])
    |> unique_constraint(:user_id)
  end
end

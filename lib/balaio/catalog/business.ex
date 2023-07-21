defmodule Balaio.Catalog.Business do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "business" do
    field :name, :string
    field :address, :string
    field :description, :string
    field :category, :string
    field :phone, :string
    field :thumbnail, :string
    field :menu_online, :string
    field :menu_as_pdf, :string
    field :social_media_link, :string
    field :is_delivery, :boolean, default: false
    field :user_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(business, attrs) do
    business
    |> cast(attrs, [:name, :description, :phone, :address, :category, :thumbnail, :menu_online, :menu_as_pdf, :social_media_link, :is_delivery])
    |> validate_required([:name, :description, :phone, :address, :category, :thumbnail, :menu_online, :menu_as_pdf, :social_media_link, :is_delivery])
    |> unique_constraint(:user_id)
  end
end

defmodule Balaio.Catalog.BusinessCategories do
  use Ecto.Schema
  import Ecto.Changeset

  alias Balaio.Catalog.Business
  alias Balaio.Catalog.Category

  schema "business_categories" do
    belongs_to :business, Business, primary_key: true
    belongs_to :categories, Category, primary_key: true
  end
end

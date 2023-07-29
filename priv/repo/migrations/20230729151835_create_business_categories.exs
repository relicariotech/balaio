defmodule Balaio.Repo.Migrations.CreateBusinessCategories do
  use Ecto.Migration

  def change do
    create table(:business_categories, primary_key: false) do
      add :business_id, references(:business, on_delete: :delete_all, type: :binary_id)
      add :category_id, references(:categories, on_delete: :delete_all, type: :binary_id)
    end

    create index(:business_categories, [:business_id])
    create unique_index(:business_categories, [:category_id, :business_id])
  end
end

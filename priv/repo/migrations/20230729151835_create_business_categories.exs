defmodule Balaio.Repo.Migrations.CreateBusinessCategories do
  use Ecto.Migration

  def change do
    create table(:business_categories) do
      # add :id, :binary_id, primary_key: true
      add :business_id, references(:business, on_delete: :delete_all)
      add :category_id, references(:categories, on_delete: :delete_all)
    end

    # create index(:business_categories, [:business_id])
    create unique_index(:business_categories, [:category_id, :business_id])
  end
end

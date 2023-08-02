defmodule Balaio.Repo.Migrations.RemoveBusinessCategoryColumn do
  use Ecto.Migration

  def change do
    alter table(:business) do
      remove :category
    end
  end
end

defmodule Balaio.Repo.Migrations.CreateBusiness do
  use Ecto.Migration

  def change do
    create table(:business) do
      add :name, :string
      add :description, :string
      add :phone, :string
      add :address, :string
      add :category, :string
      add :thumbnail, :string
      add :is_delivery, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:business, [:user_id])
  end
end

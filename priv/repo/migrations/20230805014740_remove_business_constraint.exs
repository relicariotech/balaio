defmodule Balaio.Repo.Migrations.RemoveBusinessConstraint do
  use Ecto.Migration

  def change do
    drop constraint(:business, "business_user_id_fkey")
  end
end

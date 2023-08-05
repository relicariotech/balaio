defmodule Balaio.Repo.Migrations.RemoveBusinessIndex do
  use Ecto.Migration

  def change do
    drop index("business", [:user_id])
  end
end

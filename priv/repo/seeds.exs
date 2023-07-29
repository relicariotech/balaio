# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Balaio.Repo.insert!(%Balaio.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Seed on Category table
for title <- [
      "Agência Bancária",
      "Agência de Viagens",
      "Turismo",
      "Roupas e Calçados",
      "Confecções",
      "Engenharia",
      "Pintura",
      "Supermercado",
      "Farmácia"
    ] do
  {:ok, _} = Balaio.Catalog.create_category(%{title: title})
end

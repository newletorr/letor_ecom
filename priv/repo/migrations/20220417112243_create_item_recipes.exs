defmodule LetorEcom.Repo.Migrations.CreateItemRecipes do
  use Ecto.Migration

  def change do
    create table(:item_recipes, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :item_id, references(:items, on_delete: :delete_all, type: :binary_id)
      add :recipe_id, references(:recipes, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:item_recipes, [:id])
    create index(:item_recipes, [:item_id])
    create index(:item_recipes, [:recipe_id])
  end
end

defmodule LetorEcom.Repo.Migrations.CreateUserRecipes do
  use Ecto.Migration

  def change do
    create table(:user_recipes, primary_key: false) do
      add(:id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()"))
      add :recipe_id, references(:recipes, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:user_recipes, [:id])
    create index(:user_recipes, [:user_id])
    create unique_index(:user_recipes, [:recipe_id, :user_id])
  end
end

defmodule LetorEcom.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :description, :text
      add :name, :string
      add :directions, :text
      add :image1_url, :string
      add :image2_url, :string
      add :image3_url, :string
      add :video, :string
      add :special, :boolean
      add :meal_type, :string
      add :recipe_class_id, references(:recipe_classes, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:recipes, [:id])
    create index(:recipes, [:recipe_class_id])
  end
end

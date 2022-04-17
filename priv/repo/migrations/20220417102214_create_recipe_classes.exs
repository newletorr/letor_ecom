defmodule LetorEcom.Repo.Migrations.CreateRecipeClasses do
  use Ecto.Migration

  def change do
    create table(:recipe_classes, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :name, :string
      add :description, :string
      add :pickup_centre_id, references(:pickup_centres, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:recipe_classes, [:id])
    create index(:recipe_classes, [:pickup_centre_id])
  end
end

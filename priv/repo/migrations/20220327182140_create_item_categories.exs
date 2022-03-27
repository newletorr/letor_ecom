defmodule LetorEcom.Repo.Migrations.CreateItemCategories do
  use Ecto.Migration

  def change do
    create table(:item_categories, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :name, :string
      add :description, :string
      add :pickup_centre_id, references(:pickup_centres, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:item_categories, [:id])
    create index(:item_categories, [:pickup_centre_id])
    create unique_index(:item_categories, [:name])
  end
end

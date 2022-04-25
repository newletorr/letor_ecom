defmodule LetorEcom.Repo.Migrations.CreateInventoryLocation do
  use Ecto.Migration

  def change do
    create table(:inventory_location, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :name, :string, null: false
      add :type, :string, null: false
      add :pickup_centre_id, references(:pickup_centres, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create unique_index(:inventory_location, [:id])
    create index(:inventory_location, [:pickup_centre_id])
  end
end

defmodule LetorEcom.Repo.Migrations.CreatePopularItems do
  use Ecto.Migration

  def change do
    create table(:popular_items, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :pickup_centre_id, references(:pickup_centres, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:popular_items, [:pickup_centre_id])
  end
end

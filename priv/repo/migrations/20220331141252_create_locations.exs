defmodule LetorEcom.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS postgis")

    create table(:locations, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :country, :string, null: false
      add :city, :string, null: false
      add :state, :string, null: false
      add :location_area, :string, null: false
      add :postal_code, :string
      add :pickup_centre_id, references(:pickup_centres, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:locations, [:id])
    create index(:locations, :pickup_centre_id)
    create(unique_index(:locations, [:location_area]))

    execute("SELECT AddGeometryColumn('locations', 'location_coordinates', 4326, 'POINT', 2)")

    execute(
      "CREATE INDEX location_location_coordinates_index on locations USING gist (location_coordinates)"
    )
  end

  def down do
    drop table(:pickup_centres)
    execute("DROP EXTENSION IF EXISTS postgis")
  end
end

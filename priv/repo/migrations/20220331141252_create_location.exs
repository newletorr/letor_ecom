defmodule LetorEcom.Repo.Migrations.CreateLocation do
  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS postgis")

    create table(:location, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :country, :string, null: false
      add :city, :string, null: false
      add :state, :string, null: false
      add :location_area, :string, null: false
      add :postal_code, :string
      add :pickup_centre_id, references(:pickup_centres, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:location, [:id])
    create index(:location, :pickup_centre_id)
    create(unique_index(:location, [:location_area]))

    execute("SELECT AddGeometryColumn('location', 'location_coordinates', 4326, 'POINT', 2)")

    execute(
      "CREATE INDEX location_location_coordinates_index on location USING gist (location_coordinates)"
    )
  end

  def down do
    drop table(:pickup_centres)
    execute("DROP EXTENSION IF EXISTS postgis")
  end
end

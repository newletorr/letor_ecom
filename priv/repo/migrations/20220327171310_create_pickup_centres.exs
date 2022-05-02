defmodule LetorEcom.Repo.Migrations.CreatePickupCentres do
  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS postgis")

    create table(:pickup_centres, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :address, :string, null: false
      add :name, :string, null: false
      add :area, :string, null: false
      add :city, :string, null: false
      add :state, :string, null: false
      add :country, :string, null: false
      add :centre_code, :string

      add :ecommerce_control_id,
          references(:ecommerce_controls, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:pickup_centres, :id)
    create index(:pickup_centres, [:ecommerce_control_id])
    create unique_index(:pickup_centres, [:name])
    create unique_index(:pickup_centres, [:area])
    create unique_index(:pickup_centres, [:address])

    execute(
      "SELECT AddGeometryColumn('pickup_centres', 'location_coordinates', 4326, 'POINT', 2)"
    )

    execute(
      "CREATE INDEX pickup_centres_location_coordinates_index on pickup_centres USING gist (location_coordinates)"
    )
  end

  def down do
    drop table(:pickup_centres)
    execute("DROP EXTENSION IF EXISTS postgis")
  end
end

defmodule LetorEcom.Repo.Migrations.CreatePickupCentres do
  use Ecto.Migration

  def change do
    create table(:pickup_centres, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :address, :string, null: false
      add :name, :string, null: false
      add :area, :string, null: false
      add :city, :string, null: false
      add :state, :string, null: false
      add :country, :string, null: false
      add :location_coordinates, :string
      add :centre_code_id, references(:centre_code, on_delete: :nothing, type: :binary_id)

      add :ecommerce_control_id,
          references(:ecommerce_controls, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:pickup_centres, :id)
    create index(:pickup_centres, [:centre_code_id])
    create index(:pickup_centres, [:ecommerce_control_id])
    create unique_index(:pickup_centres, [:name])
    create unique_index(:pickup_centres, [:area])
    create unique_index(:pickup_centres, [:address])
  end
end

defmodule LetorEcom.Repo.Migrations.CreateSku do
  use Ecto.Migration

  def change do
    create table(:sku, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :code, :string
      add :name, :string
      add :pickup_centre_id, references(:pickup_centres, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:sku, [:pickup_centre_id])
    create index(:sku, [:id])
    create unique_index(:sku, [:name, :pickup_centre_id])
  end
end

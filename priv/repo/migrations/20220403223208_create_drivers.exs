defmodule LetorEcom.Repo.Migrations.CreateDrivers do
  use Ecto.Migration

  def change do
    create table(:drivers, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :email, :string
      add :name, :string
      add :status, :string
      add :phone, :string
      add :pickup_centre_id, references(:pickup_centres, on_delete: :nothing, type: :binary_id)
      add :staff_id, references(:staff, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:drivers, [:id])
    create index(:drivers, [:pickup_centre_id])
    create index(:drivers, [:staff_id])
    create unique_index(:drivers, [:email])
    create unique_index(:drivers, [:phone])
  end
end

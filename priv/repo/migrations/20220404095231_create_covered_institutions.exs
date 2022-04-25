defmodule LetorEcom.Repo.Migrations.CreateCoveredInstitutions do
  use Ecto.Migration

  def change do
    create table(:covered_institutions, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :name, :string
      add :campus_name, :string
      add :location_id, references(:location, on_delete: :nothing, type: :binary_id)

      add :ecommerce_control_id,
          references(:ecommerce_controls, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:covered_institutions, [:location_id])
    create index(:covered_institutions, [:ecommerce_control_id])
    create unique_index(:covered_institutions, [:campus_name, :name])
  end
end

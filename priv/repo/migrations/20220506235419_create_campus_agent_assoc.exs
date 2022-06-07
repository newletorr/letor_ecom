defmodule LetorEcom.Repo.Migrations.CreateCampusAgentAssoc do
  use Ecto.Migration

  def change do
    alter table(:agents) do
      add(
        :covered_institution_id,
        references(:covered_institutions, on_delete: :nothing, type: :binary_id)
      )

      add(
        :ecommerce_control_id,
        references(:ecommerce_controls, on_delete: :nothing, type: :binary_id)
      )

      add(:location_id, references(:locations, on_delete: :nothing, type: :binary_id))
    end

    create(index(:agents, [:covered_institution_id]))
    create(index(:agents, [:ecommerce_control_id]))
    create(index(:agents, [:location_id]))
  end
end

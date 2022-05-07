defmodule LetorEcom.Repo.Migrations.CreateCampusAgentAssoc do
  use Ecto.Migration

  def change do
    alter table(:campus_agents) do
      add(
        :covered_institution_id,
        references(:covered_institutions, on_delete: :nothing, type: :binary_id)
      )

      add(
        :ecommerce_control_id,
        references(:ecommerce_controls, on_delete: :nothing, type: :binary_id)
      )
    end

    create(index(:campus_agents, [:covered_institution_id]))
    create(index(:campus_agents, [:ecommerce_control_id]))
  end
end

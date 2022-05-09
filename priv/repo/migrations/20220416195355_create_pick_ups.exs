defmodule LetorEcom.Repo.Migrations.CreatePickUps do
  use Ecto.Migration

  def change do
    create table(:pick_ups, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :pick_up_time, :utc_datetime
      add :picked, :boolean, default: false, null: false
      add :pickup_code, :string
      add :order_id, references(:orders, on_delete: :nothing, type: :binary_id)
      add :campus_agent_id, references(:campus_agents, on_delete: :nothing, type: :binary_id)
      add :pickup_centre_id, references(:pickup_centres, on_delete: :nothing, type: :binary_id)
      add :staff_id, references(:staff, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:pick_ups, [:id])
    create index(:pick_ups, [:order_id])
    create index(:pick_ups, [:campus_agent_id])
    create index(:pick_ups, [:pickup_centre_id])
    create index(:pick_ups, [:staff_id])
  end
end

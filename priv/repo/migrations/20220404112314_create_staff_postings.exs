defmodule LetorEcom.Repo.Migrations.CreateStaffPostings do
  use Ecto.Migration

  def change do
    create table(:staff_postings, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :date_posted, :date
      add :previous_posting, :string
      add :pickup_centre_id, references(:pickup_centres, on_delete: :nothing, type: :binary_id)

      add :ecommerce_control_id,
          references(:ecommerce_controls, on_delete: :nothing, type: :binary_id)

      add :staff_id, references(:staff, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:staff_postings, [:id])
    create index(:staff_postings, [:pickup_centre_id])
    create index(:staff_postings, [:ecommerce_control_id])
    create index(:staff_postings, [:staff_id])
  end
end

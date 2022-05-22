defmodule LetorEcom.Repo.Migrations.CreatePurchases do
  use Ecto.Migration

  def change do
    create table(:purchases, primary_key: false) do
      add(:id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()"))
      add :code, :string
      add :approval_remark, :string
      add :status, :string
      add :finished, :boolean, default: false, null: false
      add :creators_remark, :string
      add :quality_assurance_cleared, :boolean, default: false, null: false
      add :delivered, :boolean, default: false, null: false
      add :staff_id, references(:staff, on_delete: :nothing, type: :binary_id)
      add :pickup_centre_id, references(:pickup_centres, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:purchases, [:staff_id])
    create index(:purchases, [:pickup_centre_id])
  end
end

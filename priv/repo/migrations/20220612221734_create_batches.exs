defmodule LetorEcom.Repo.Migrations.CreateBatches do
  use Ecto.Migration

  def change do
    create table(:batches, primary_key: false) do
      add(:id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()"))
      add(:code, :string)
      # batch_type => suppliers, farmers, internal purchase
      add(:batch_type, :string)
      add(:name, :string)
      add(:description, :string)
      add(:expiry_date, :date)
      add(:expired, :boolean, default: false, null: false)
      add(:quality_assurance_cleared, :boolean, default: false, null: false)
      add(:pickup_centre_id, references(:pickup_centres, on_delete: :nothing, type: :binary_id))
      add(:staff_id, references(:staff, on_delete: :nothing, type: :binary_id))

      timestamps(type: :timestamptz)
    end

    create(index(:batches, [:id]))
    create(index(:batches, [:pickup_centre_id]))
    create(index(:batches, [:staff_id]))
  end
end

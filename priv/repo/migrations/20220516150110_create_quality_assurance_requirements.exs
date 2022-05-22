defmodule LetorEcom.Repo.Migrations.CreateQualityAssuranceRequirements do
  use Ecto.Migration

  def change do
    create table(:quality_assurance_requirements, primary_key: false) do
      add(:id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()"))
      add :acceptable_quantity_of_damage_item, :boolean, default: false, null: false
      add :broken_seal, :boolean, default: false, null: false
      add :number_of_items_with_broken_seal, :integer
      add :damaged_containers, :boolean, default: false, null: false
      add :number_of_damaged_containers, :integer
      add :expired, :boolean, default: false, null: false
      add :expiry_date, :date
      add :firmness, :boolean, default: false, null: false
      add :describe_firmness, :string
      add :good_color, :string
      add :observed_fungal_growth, :boolean, default: false, null: false
      add :describe_observed_fungal_growth, :string
      add :product_type, :string
      add :rusty_cans, :boolean, default: false, null: false
      add :no_of_rusty_cans, :integer
      add :inventory_id, references(:inventories, on_delete: :nothing, type: :binary_id)
      add :pickup_centre_id, references(:pickup_centres, on_delete: :nothing, type: :binary_id)
      add :staff_id, references(:staff, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:quality_assurance_requirements, [:id])
    create index(:quality_assurance_requirements, [:inventory_id])
    create index(:quality_assurance_requirements, [:pickup_centre_id])
    create index(:quality_assurance_requirements, [:staff_id])
  end
end

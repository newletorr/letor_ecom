defmodule LetorEcom.Repo.Migrations.CreateCampusAgents do
  use Ecto.Migration

  def change do
    create table(:agents, primary_key: false) do
      add(:id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()"))
      add(:residential_address, :string)
      add(:agents_image, :string)
      add(:business_address, :string)
      add(:email, :string)
      add(:first_name, :string)
      add(:last_name, :string)
      add(:phone, :string)
      add(:status, :string)
      add(:verified, :boolean, default: false)
      add(:secret_code, :string)
      add(:nationality, :string)
      add(:home_town, :string)
      add(:state_of_origin, :string)
      add(:means_of_id, :string)
      add(:id_image, :string)
      add(:guarantor_first_name, :string)
      add(:guarantor_last_name, :string)
      add(:guarantor_phone, :string)
      add(:guarantor_residential_address, :string)
      add(:guarantor_verified, :boolean, null: false, default: false)

      timestamps(type: :timestamptz)
    end

    create(index(:agents, [:id]))
  end
end

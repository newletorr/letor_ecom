defmodule LetorEcom.Repo.Migrations.CreateCentreCode do
  use Ecto.Migration

  def change do
    create table(:centre_code, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :centre_code, :string
      add :centre_name, :string

      timestamps(type: :timestamptz)
    end

    create index(:centre_code, [:id])
    create unique_index(:centre_code, [:centre_name])
  end
end

defmodule LetorEcom.Repo.Migrations.CreateReferedLists do
  use Ecto.Migration

  def change do
    create table(:refered_lists, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :date_activated, :utc_datetime
      add :refered_person_id, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:refered_lists, [:id])
    create index(:refered_lists, [:user_id])
  end
end

defmodule LetorEcom.Repo.Migrations.CreateItemTag do
  use Ecto.Migration

  def change do
    create table(:item_tag, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :description, :string, null: false
      add :name, :string, null: false
      add :class, :string, null: false

      timestamps(type: :timestamptz)
    end

    create unique_index(:item_tag, [:name])
    create index(:item_tag, [:id])
  end
end

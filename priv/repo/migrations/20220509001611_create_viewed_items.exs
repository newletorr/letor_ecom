defmodule LetorEcom.Repo.Migrations.CreateViewedItems do
  use Ecto.Migration

  def change do
    create table(:viewed_items, primary_key: false) do
      add(:id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()"))
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :item_id, references(:items, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:viewed_items, [:id])
    create index(:viewed_items, [:user_id])
    create index(:viewed_items, [:item_id])
  end
end

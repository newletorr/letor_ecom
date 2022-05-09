defmodule LetorEcom.Repo.Migrations.CreateShoppingLists do
  use Ecto.Migration

  def change do
    create table(:shopping_lists, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :title, :string
      add :quantity, :integer
      add :item_price, :decimal
      add :total, :decimal
      add :item_id, references(:items, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :timestamptz)
    end

    create index(:shopping_lists, [:id])
    create index(:shopping_lists, [:item_id])
    create unique_index(:shopping_lists, [:title, :user_id])
  end
end

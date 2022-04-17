defmodule LetorEcom.Repo.Migrations.CreateCartItems do
  use Ecto.Migration

  def change do
    create table(:cart_items, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("gen_random_uuid()")
      add :quantity, :integer
      add :sub_total, :decimal
      add :additional_info, :string
      add :decline_item, :boolean, default: false, null: false
      add :sold, :boolean, default: false, null: false
      add :purchase_price, :decimal

      timestamps(type: :utc_datetime)
    end

    create index(:cart_items, [:id])
  end
end

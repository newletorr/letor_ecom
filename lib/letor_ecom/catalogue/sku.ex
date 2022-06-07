defmodule LetorEcom.Catalogue.Sku do
  use LetorEcom.SchemaHelper

  alias LetorEcom.Catalogue.Item
  alias LetorEcom.Centres.{Inventory, PickupCentre}

  schema "sku" do
    field(:code, :string)
    field(:name, :string)
    belongs_to(:pickup_centre, PickupCentre)
    has_many(:items, Item)
    has_many(:inventories, Inventory)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(sku, attrs) do
    sku
    |> cast(attrs, [:pickup_centre_id, :code, :name])
    # |> validate_required([:pickup_centre_id, :name])
    |> unique_constraint(:name,
      message: "Item with the same name already exists",
      name: :sku_name_pickup_centre_id_index
    )
    |> assoc_constraint(:pickup_centre)
    |> gen_code
  end

  def update_changeset(sku, attrs) do
    sku
    |> cast(attrs, [:pickup_centre_id, :code, :name])
    |> unique_constraint(:name,
      message: "Item with the same name already exists",
      name: :sku_name_pickup_centre_id_index
    )
    |> assoc_constraint(:pickup_centre)
  end

  defp gen_code(changeset) do
    case changeset.valid? do
      true ->
        alphabet = Enum.to_list(?a..?z) ++ Enum.to_list(?0..?9)
        length = 4
        value = for _ <- 1..length, into: "", do: <<Enum.random(alphabet)>>

        actual_value =
          value
          |> String.upcase()

        changeset |> put_change(:code, actual_value)

      _ ->
        changeset
    end
  end
end

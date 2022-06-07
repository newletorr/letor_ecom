defmodule LetorEcom.Account.ViewedItem do
  use LetorEcom.SchemaHelper

  schema "viewed_items" do
    belongs_to(:user, User)
    belongs_to(:item, Item)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(viewed_item, attrs) do
    viewed_item
    |> cast(attrs, [:user_id, :item_id])
    |> validate_required([:item_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:item, message: "Sorry! this item has been removed")
  end
end

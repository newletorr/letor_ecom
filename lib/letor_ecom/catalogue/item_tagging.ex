defmodule LetorEcom.Catalogue.ItemTagging do
  use LetorEcom.SchemaHelper

  schema "item_taggings" do
    belongs_to(:item, Item)
    belongs_to(:item_tag, ItemTag)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item_tagging, attrs) do
    item_tagging
    |> cast(attrs, [:item_id, :item_tag_id])
    |> validate_required([:item_id, :item_tag_id])
  end
end

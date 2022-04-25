defmodule LetorEcom.Catalogue.ItemTag do
  use LetorEcom.SchemaHelper

  schema "item_tag" do
    field :class, :string, read_after_writes: true
    field :description, :string, read_after_writes: true
    field :name, :string, read_after_writes: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item_tag, attrs) do
    item_tag
    |> cast(attrs, [:description, :name, :class])
    |> validate_required([:description, :name, :class])
    |> unique_constraint(:name, message: "Already exists")
  end

   @doc false
  def update_changeset(item_tag, attrs) do
    item_tag
    |> cast(attrs, [:description, :name, :class])
    |> unique_constraint(:name, message: "Already exists")
  end
end

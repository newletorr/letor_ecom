defmodule LetorEcom.Catalogue.ItemImage do
  use LetorEcom.SchemaHelper
  use Waffle.Ecto.Schema
  alias LetorEcom.Catalogue.Item
  alias LetorEcom.Centres.Inventory
  alias LetorEcom.Control.EcommerceControl

  schema "item_images" do
    field :item_image1, :string, read_after_writes: true
    field :item_image2, :string, read_after_writes: true
    field :item_image3, :string, read_after_writes: true
    field :item_image4, :string, read_after_writes: true
    field(:item_name, :string, read_after_writes: true)
    field(:video_url, :string, read_after_writes: true)
    belongs_to(:ecommerce_control, EcommerceControl)
    has_many(:items, Item)
    has_many(:inventories, Inventory)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item_image, attrs) do
    item_image
    |> cast(attrs, [
      :ecommerce_control_id,
      :item_name,
      :video_url
    ])
    |> validate_required([
      :ecommerce_control_id,
      :item_name
    ])
    |> unique_constraint(:item_name, message: "An image with the same already exist")
    |> assoc_constraint(:ecommerce_control)
  end

  @spec update_changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def update_changeset(item_image, attrs) do
    item_image
    |> cast(attrs, [
      :ecommerce_control_id,
      :item_name,
      :item_image1,
      :item_image2,
      :item_image3,
      :item_image4,
      :video_url
    ])
    |> cast_attachments(attrs, [:item_image1, :item_image2, :item_image3, :item_image4],
      allow_urls: true
    )
    |> unique_constraint(:item_name, message: "An image with the same already exist")
    |> assoc_constraint(:ecommerce_control)
  end

  @spec image_uploads_changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def image_uploads_changeset(item_image, attrs) do
    item_image
    |> cast(attrs, [:item_image1, :item_image2, :item_image3, :item_image4])

    # |> cast_attachments(attrs, [:item_image1, :item_image2, :item_image3, :item_image4],
    # allow_urls: true
    # )
  end
end

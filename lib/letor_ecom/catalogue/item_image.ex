defmodule LetorEcom.Catalogue.ItemImage do
  use LetorEcom.SchemaHelper
  use Waffle.Ecto.Schema
  alias LetorEcom.Control.EcommerceControl

  schema "item_images" do
    field(:item_image1, LetorEcom.Uploads.Type, read_after_writes: true)
    field(:item_image2, LetorEcom.Uploads.Type, read_after_writes: true)
    field(:item_image3, LetorEcom.Uploads.Type, read_after_writes: true)
    field(:item_image4, LetorEcom.Uploads.Type, read_after_writes: true)
    field(:item_name, :string, read_after_writes: true)
    field(:video_url, :string, read_after_writes: true)
    belongs_to(:ecommerce_control, EcommerceControl)

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
      :item_name,
      :item_image1,
      :item_image2,
      :item_image3,
      :item_image4
    ])
    |> cast_attachments(attrs, [:item_image1, :item_image2, :item_image3, :item_image4])
    |> unique_constraint(:item_name, message: "An image with the same already exist")
    |> assoc_constraint(:ecommerce_control)
  end

  @doc false
  def update_changeset(item_image, attrs) do
    item_image
    |> cast(attrs, [
      :ecommerce_control_id,
      :item_name,
      :video_url
    ])
    |> unique_constraint(:item_name, message: "An image with the same already exist")
    |> assoc_constraint(:ecommerce_control)
  end

  def image_uploads_changeset(item_image, attrs) do
    item_image
    |> cast(attrs, [:item_image1, :item_image2, :item_image3, :item_image4])
  end
end

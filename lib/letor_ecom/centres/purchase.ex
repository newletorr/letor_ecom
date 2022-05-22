defmodule LetorEcom.Centres.Purchase do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Centres.{PickupCentre, PurchaseItem}
  alias LetorEcom.HumanResource.Staff

  schema "purchases" do
    field :approval_remark, :string, read_after_writes: true
    field :code, :string, read_after_writes: true
    field :creators_remark, :string, read_after_writes: true
    field :delivered, :boolean, default: false, read_after_writes: true
    field :finished, :boolean, default: false, read_after_writes: true
    field :quality_assurance_cleared, :boolean, default: false, read_after_writes: true
    field :status, :string, read_after_writes: true
    belongs_to(:staff, Staff)
    belongs_to(:pickup_centre, PickupCentre)
    has_many(:purchase_items, PurchaseItem)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(purchase, attrs) do
    purchase
    |> cast(attrs, [
      :pickup_centre_id,
      :staff_id,
      :code,
      :approval_remark,
      :status,
      :finished,
      :creators_remark,
      :quality_assurance_cleared,
      :delivered
    ])
    |> assoc_constraint(:staff)
    |> assoc_constraint(:pickup_centre)
  end

  def update_changeset(purchase, attrs) do
    purchase
    |> cast(attrs, [
      :code,
      :approval_remark,
      :status,
      :finished,
      :creators_remark,
      :quality_assurance_cleared,
      :delivered
    ])
  end
end

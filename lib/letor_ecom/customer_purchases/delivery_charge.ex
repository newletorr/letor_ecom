defmodule LetorEcom.CustomerPurchases.DeliveryCharge do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Control.EcommerceControl

  schema "delivery_charges" do
    field :eight_to_twelve, :decimal, read_after_writes: true
    field :fifteen_to_thirty_minutes, :decimal, read_after_writes: true
    field :four_to_ten, :decimal, read_after_writes: true
    field :twelve_to_four, :decimal, read_after_writes: true
    belongs_to(:ecommerce_control, EcommerceControl)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(delivery_charge, attrs) do
    delivery_charge
    |> cast(attrs, [
      :ecommerce_control_id,
      :eight_to_twelve,
      :four_to_ten,
      :fifteen_to_thirty_minutes,
      :twelve_to_four
    ])
    |> validate_required([
      :ecommerce_control_id,
      :eight_to_twelve,
      :four_to_ten,
      :fifteen_to_thirty_minutes,
      :twelve_to_four
    ])
    |> assoc_constraint(:ecommerce_control)
  end
end

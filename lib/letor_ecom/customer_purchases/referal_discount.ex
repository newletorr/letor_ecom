defmodule LetorEcom.CustomerPurchases.ReferalDiscount do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Control.EcommerceControl

  schema "referal_discounts" do
    field :first_discount, :decimal
    field :fourth_discount, :decimal
    field :second_discount, :decimal
    field :third_discount, :decimal
    belongs_to(:ecommerce_control, EcommerceControl)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(referal_discount, attrs) do
    referal_discount
    |> cast(attrs, [
      :ecommerce_control_id,
      :first_discount,
      :second_discount,
      :third_discount,
      :fourth_discount
    ])
    |> validate_required([
      :ecommerce_control_id,
      :first_discount,
      :second_discount,
      :third_discount,
      :fourth_discount
    ])
    |> assoc_constraint(:ecommerce_control)
  end
end

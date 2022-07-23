defmodule LetorEcom.Centres.PurchaseOrder do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Control.EcommerceControl
  alias LetorEcom.AgentsAndSuppliers.Supplier

  schema "purchase_orders" do
    field :fob_point, :string
    field :po_number, :string
    field :shipping_and_handling, :decimal
    field :state, :string
    field :tax_rate, :float
    field :terms_and_conditions, :string
    belongs_to(:ecommerce_control, EcommerceControl)
    belongs_to(:supplier, Supplier)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(purchase_order, attrs) do
    purchase_order
    |> cast(attrs, [
      :ecommerce_control_id,
      :supplier_id,
      :state,
      :fob_point,
      :po_number,
      :shipping_and_handling,
      :tax_rate,
      :terms_and_conditions
    ])
    |> validate_required([
      :ecommerce_control_id,
      :supplier_id,
      :state,
      :fob_point,
      :po_number,
      :shipping_and_handling,
      :tax_rate,
      :terms_and_conditions
    ])
    |> assoc_constraint(:ecommerce_control)
    |> assoc_constraint(:staff)
  end
end

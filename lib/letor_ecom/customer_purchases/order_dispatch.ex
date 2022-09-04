defmodule LetorEcom.CustomerPurchases.OrderDispatch do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Centres.PickupCentre
  alias LetorEcom.CustomerPurchases.Order
  alias LetorEcom.HumanResource.{Staff, Driver}

  schema "order_dispatches" do
    field :all_delivered, :boolean, default: false
    field :delayed, :boolean, default: false
    field :dispatch_id, :string
    field :dispatched, :boolean, default: false
    field :order_count, :integer
    field :order_delivered, :integer
    belongs_to(:staff, Staff)
    belongs_to(:driver, Driver)
    belongs_to(:pickup_centre, PickupCentre)
    has_many(:order, Order)

    timestamps(type: :utc_datetime)
  end

  def changeset(order_dispatch, attrs) do
    order_dispatch
    |> cast(attrs, [
      :dispatch_id,
      :staff_id,
      :driver_id,
      :pickup_centre_id,
      :order_count,
      :order_delivered
      #:all_orders_delivered
    ])
    |> unique_constraint(:staff_id,
      message: "Please dispatch your existing dispatch(es) before creating a new one.",
      name: :order_dispatches_staff_id_dispatched_index
    )
    |> gen_dispatch_id
    |> assoc_constraint(:staff)
    |> assoc_constraint(:driver)
    |> assoc_constraint(:pickup_centre)
  end

  @spec update_changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def update_changeset(order_dispatch, attrs) do
    order_dispatch
    |> cast(attrs, [
      :driver_id,
      :pickup_centre_id,
      :order_count,
      :order_delivered,
      :all_orders_delivered
    ])
    |> all_orders_delivered
  end

  @spec dispatch_changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def dispatch_changeset(order_dispatch, attrs) do
    order_dispatch
    |> cast(attrs, [:dispatched])
  end

  @spec delay_changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def delay_changeset(order_dispatch, attrs) do
    order_dispatch
    |> cast(attrs, [:delayed])
  end

  defp gen_dispatch_id(changeset) do
    case changeset.valid? do
      true ->
        alphabet = Enum.to_list(?a..?z) ++ Enum.to_list(?0..?9)
        length = 6
        value = for _ <- 1..length, into: "", do: <<Enum.random(alphabet)>>

        actual_value =
          value
          |> String.upcase()

        changeset |> put_change(:dispatch_id, actual_value)

      _ ->
        changeset
    end
  end

  defp all_orders_delivered(changeset) do
    case changeset.valid? do
      true ->
        order_count = get_field(changeset, :order_count)
        order_delivered = get_field(changeset, :order_delivered)

        if order_count == order_delivered do
          changeset |> put_change(:all_orders_delivered, true)
        else
          changeset
        end

      _ ->
        changeset
    end
  end
end

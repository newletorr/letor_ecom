defmodule LetorEcom.Sales.Sale do
  use LetorEcom.SchemaHelper
  alias LetorEcom.{CustomerPurchases, Repo}
  alias LetorEcom.Centres.PickupCentre
  alias LetorEcom.CustomerPurchases.{CartItem, Order}
  alias LetorEcom.HumanResource.Staff
  alias LetorEcom.Sales.InstoreSale

  schema "sales" do
    field :buy_price, :decimal, read_after_writes: true
    field :cash_amount, :decimal, read_after_writes: true
    field :difference, :decimal, read_after_writes: true
    field :discount, :decimal, read_after_writes: true
    field :payment_method, :string, read_after_writes: true
    field :pos_amount, :decimal, read_after_writes: true
    field :pos_ref, :string, read_after_writes: true
    field :quantity, :integer, read_after_writes: true
    field :reversed, :boolean, default: false, read_after_writes: true
    field :sales_amount, :decimal, read_after_writes: true
    field :sales_channel, :string, read_after_writes: true
    field :sales_price, :decimal, read_after_writes: true
    field :sales_status, :string, read_after_writes: true
    belongs_to(:cart_item, CartItem)
    belongs_to(:pickup_centre, PickupCentre)
    belongs_to(:staff, Staff)
    has_many(:instore_sales, InstoreSale)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def online_sales_changeset(sales, attrs) do
    sales
    |> cast(attrs, [
      :staff_id,
      :pickup_centre_id,
      :cart_item_id,
      :quantity,
      :sales_price,
      :buy_price,
      :discount,
      :sales_channel,
      :reversed,
      :sales_amount,
      :sales_status
    ])
    |> validate_required([
      :cart_item_id
    ])
    |> assoc_constraint(:staff)
    |> assoc_constraint(:cart_item)
    |> assoc_constraint(:pickup_centre)
    |> cart_item_already_sold
    |> get_cart_item_sales_price
    |> get_cart_item_buy_price
    |> get_quantity_from_cart_items
    |> get_sales_channel
    |> get_online_sales_amount
  end

  def self_checkout_sales_changeset(sales, attrs) do
    sales
    |> cast(attrs, [
      :staff_id,
      :pickup_centre_id,
      :checkout_item_id,
      :quantity,
      :sales_price,
      :buy_price,
      :discount,
      :sales_channel,
      :reversed,
      :sales_amount,
      :sales_status
    ])
    |> validate_required([
      :checkout_item_id
    ])
    |> assoc_constraint(:staff)
    |> assoc_constraint(:checkout_item)
    |> assoc_constraint(:pickup_centre)
    # |> get_checkout_item_sales_price
    # |> get_checkout_item_buy_price
    |> get_sales_channel
    |> get_online_sales_amount
  end

  @spec reversal_changeset(
          {map, map} | %{:__struct__ => atom | %{__changeset__: map}, optional(atom) => any},
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def reversal_changeset(sales, attrs) do
    sales
    |> cast(attrs, [
      :reversed
    ])
  end

  @spec in_store_sales_changeset(
          {map, map} | %{:__struct__ => atom | %{__changeset__: map}, optional(atom) => any},
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def in_store_sales_changeset(sales, attrs) do
    sales
    |> cast(attrs, [
      :staff_id,
      :pickup_centre_id,
      :sales_amount,
      :sales_channel,
      :reversed,
      :sales_status,
      :difference,
      :cash_amount,
      :discount,
      :pos_ref
    ])
    |> assoc_constraint(:pickup_centre)
    |> assoc_constraint(:staff)
    |> get_instore_sales_amount
  end

  def cash_payment_changeset(sales, attrs) do
    sales
    |> cast(attrs, [:payment_method, :cash_amount, :difference, :discount, :sales_amount])
    |> validate_required([:payment_method, :cash_amount])
    |> check_cash_amount
    |> calculate_balance
  end

  def card_payment_changeset(sales, attrs) do
    sales
    |> cast(attrs, [:payment_method, :pos_ref])
    |> validate_required([:payment_method, :pos_ref])
  end

  def split_payment_changeset(sales, attrs) do
    sales
    |> cast(attrs, [
      :payment_method,
      :pos_ref,
      :cash_amount,
      :pos_amount,
      :sales_amount,
      :discount,
      :difference
    ])
    |> validate_required([
      :payment_method,
      :sales_amount,
      :pos_ref,
      :cash_amount,
      :pos_amount
    ])
    |> check_amount_for_splits
    |> calculate_balance_for_splits
  end

  def sales_reversal_changeset(sales, attrs) do
    sales
    |> cast(attrs, [:reversed])
  end

  defp get_online_sales_amount(changeset) do
    case changeset.valid? do
      true ->
        quantity = get_field(changeset, :quantity)
        sales_price = get_field(changeset, :sales_price)

        sales_amount = Decimal.mult(Decimal.new(quantity), sales_price)

        changeset |> put_change(:sales_amount, sales_amount)

      _ ->
        changeset
    end
  end

  defp get_instore_sales_amount(changeset) do
    case changeset.valid? do
      true ->
        staff_id = get_field(changeset, :staff_id)

        in_store_sales =
          Repo.one(
            from(sale in __MODULE__,
              join: in_store_sale in assoc(sale, :in_store_sales),
              where: sale.staff_id == ^staff_id and sale.sales_status == "processing",
              select: sum(in_store_sale.sale_amount)
            )
          )

        changeset |> put_change(:sales_amount, in_store_sales)

      _ ->
        changeset
    end
  end

  defp get_quantity_from_cart_items(changeset) do
    case changeset.valid? do
      true ->
        cart_items = Repo.get(CartItem, get_field(changeset, :cart_items_id))

        changeset |> put_change(:quantity, cart_items.quantity)

      _ ->
        changeset
    end
  end

  defp get_cart_item_sales_price(changeset) do
    case changeset.valid? do
      true ->
        cart_items_id = get_field(changeset, :cart_items_id)

        item_sales_price =
          Repo.one(
            from(cart_item in CartItem,
              join: item in assoc(cart_item, :item),
              where: cart_item.id == ^cart_items_id,
              select: item.actual_price
            )
          )

        changeset
        |> put_change(:sales_price, item_sales_price)

      _ ->
        changeset
    end
  end

  # defp get_checkout_item_sales_price(changeset) do
  # case changeset.valid? do
  #  true ->
  #   checkout_item_id = get_field(changeset, :checkout_item_id)

  #  item_sales_price =
  #   Repo.one(
  #    from(checkout_item in CheckoutItem,
  #     join: item in assoc(checkout_item, :item),
  #    where: checkout_item.id == ^checkout_item_id,
  #   select: item.actual_price
  # )
  # )

  # changeset
  # |> put_change(:sales_price, item_sales_price)

  # _ ->
  # changeset
  # end
  # end

  defp get_cart_item_buy_price(changeset) do
    case changeset.valid? do
      true ->
        cart_items_id = get_field(changeset, :cart_items_id)

        buy_price =
          Repo.one(
            from(cart_item in CartItem,
              join: item in assoc(cart_item, :item),
              join: sku in assoc(item, :sku),
              join: centre_inventory in assoc(sku, :centre_inventory),
              where: cart_item.id == ^cart_items_id and item.sku_id == centre_inventory.sku_id,
              select: centre_inventory.buy_price
            )
          )

        changeset
        |> put_change(:buy_price, buy_price)

      _ ->
        changeset
    end
  end

  # defp get_checkout_item_buy_price(changeset) do
  # case changeset.valid? do
  #  true ->
  #   checkout_item_id = get_field(changeset, :checkout_item_id)

  #  buy_price =
  #   Repo.one(
  #    from(checkout_item in CheckoutItem,
  #     join: item in assoc(checkout_item, :item),
  #    join: sku in assoc(item, :sku),
  #   join: centre_inventory in assoc(sku, :centre_inventory),
  #  where:
  #   checkout_item.id == ^checkout_item_id and item.sku_id == centre_inventory.sku_id,
  # select: centre_inventory.buy_price
  # )
  # )

  # changeset
  # |> put_change(:buy_price, buy_price)

  # _ ->
  # changeset
  # end
  # end

  defp get_sales_channel(changeset) do
    case changeset.valid? do
      true ->
        cart_items_id = get_field(changeset, :cart_items_id)

        if is_nil(cart_items_id) == false do
          order =
            Repo.one(
              from order in Order,
                join: cart_item in assoc(order, :cart_items),
                where: cart_item.id == ^cart_items_id
            )

          if order.centre_pick_up == true or order.door_step_delivery == true do
            changeset |> put_change(:sales_channel, "Online")
          else
            changeset
          end
        else
          changeset |> put_change(:sales_channel, "Store")
        end

      _ ->
        changeset
    end
  end

  defp cart_item_already_sold(changeset) do
    case changeset.valid? do
      true ->
        cart_item = Repo.get(CartItem, get_field(changeset, :cart_items_id))

        if cart_item.sold == true do
          add_error(changeset, :item_already_sold, "Item already sold")
        else
          CustomerPurchases.update_cart_item(cart_item, %{sold: true})

          changeset
        end

      _ ->
        changeset
    end
  end

  defp check_cash_amount(changeset) do
    case changeset.valid? do
      true ->
        cash_amount = get_field(changeset, :cash_amount)
        sales_amount = get_field(changeset, :sales_amount)

        case cash_amount < sales_amount do
          true ->
            add_error(
              changeset,
              :cash_less_than_sales_amount,
              "Cash amount must be greater than or equals to sales amount"
            )

          _ ->
            changeset
        end

      _ ->
        changeset
    end
  end

  defp calculate_balance(changeset) do
    case changeset.valid? do
      true ->
        sales_amount = get_field(changeset, :sales_amount)

        cash_amount = get_field(changeset, :cash_amount)

        sales_difference = Decimal.sub(cash_amount, sales_amount)
        changeset |> put_change(:difference, sales_difference)

      _ ->
        changeset
    end
  end

  defp check_amount_for_splits(changeset) do
    case changeset.valid? do
      true ->
        cash_amount = get_field(changeset, :cash_amount)
        sales_amount = get_field(changeset, :sales_amount)
        pos_amount = get_field(changeset, :pos_amount)

        pos_and_cash_amount = Decimal.add(cash_amount, pos_amount)

        case pos_and_cash_amount < sales_amount do
          true ->
            add_error(
              changeset,
              :cash_less_than_sales_amount,
              "Cash amount must be greater than pos and cash amount"
            )

          _ ->
            changeset
        end

      _ ->
        changeset
    end
  end

  defp calculate_balance_for_splits(changeset) do
    case changeset.valid? do
      true ->
        sales_amount = get_field(changeset, :sales_amount)

        cash_amount = get_field(changeset, :cash_amount)
        pos_amount = get_field(changeset, :pos_amount)

        pos_and_cash = Decimal.add(cash_amount, pos_amount)

        sales_difference = Decimal.sub(pos_and_cash, sales_amount)

        changeset |> put_change(:difference, sales_difference)

      _ ->
        changeset
    end
  end
end

defmodule LetorEcom.Sales do
  @moduledoc """
  The Sale context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi
  alias LetorEcom.{CustomerPurchases, Repo}
  alias LetorEcom.Centres.{Inventory, InventoryChangeHistory}
  alias LetorEcom.CustomerPurchases.CartItem
  alias LetorEcom.HumanResource.Staff
  alias LetorEcom.Sales.{CustomerInfo, InstoreSale, Sale}

  @spec list_all_sales(any) :: any
  def list_all_sales(args) do
    args
    |> query_all_sales
    |> Repo.all()
  end

  @spec query_all_sales(any) :: any
  def query_all_sales(args) do
    sales = from(s in Sale)

    args
    |> Enum.reduce(sales, fn
      {:keywords, term}, query ->
        pattern = "%#{term}%"

        from(s in query,
          join: stf in assoc(s, :staff),
          join: p in assoc(s, :pickup_centre),
          join: c in assoc(s, :cart_items),
          join: it in assoc(c, :item),
          where:
            ilike(stf.first_name, ^pattern) or
              ilike(stf.last_name, ^pattern) or ilike(stf.email, ^pattern) or
              ilike(stf.phone, ^pattern) or ilike(p.name, ^pattern) or
              ilike(it.name, ^pattern) or
              ilike(it.description, ^pattern)
        )

      {:filters, filters}, query ->
        sales_filter(filters, query)

      {:limit, limit}, query ->
        from(s in query, limit: ^limit)

      {:offset, offset}, query ->
        from(s in query, offset: ^offset)

      {:order, order}, query ->
        from(s in query, order_by: [{^order, :inserted_at}])
    end)
  end

  defp sales_filter(filters, query) do
    Enum.reduce(filters, query, fn
      {:sales_channel, sales_channel}, query ->
        from(s in query, where: ilike(s.sales_channel, ^"%#{sales_channel}%"))

      {:reversed, value}, query ->
        from(s in query, where: s.reversed == ^value)
    end)
  end

  @doc """
  Creates a online sales.

  ## Examples

      iex> create_online_sales(%{field: value})
      {:ok, %Sale{}}

      iex> create_online_sales(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_online_sales(attrs \\ %{}) do
    sales_changeset = %Sale{} |> Sale.online_sales_changeset(attrs)
    # Inventory levels to be displayed of sales page
    Multi.new()
    |> Multi.insert(:sales, sales_changeset)
    |> Multi.run(:inventory, fn repo, _ ->
      inventory =
        Repo.one(
          from(inventory in Inventory,
            join: sku in assoc(inventory, :sku),
            join: item in assoc(sku, :items),
            join: cart_items in assoc(item, :cart_items),
            where: cart_items.id == ^attrs.cart_items_id and item.sku_id == inventory.sku_id
          )
        )

      cart_item = Repo.get(CartItem, attrs.cart_items_id)

      inventory_changeset =
        inventory
        |> Inventory.update_changeset(%{
          internal_quantity: inventory.internal_quantity - cart_item.quantity
        })

      repo.update(inventory_changeset)
    end)
    |> Repo.transaction()
  end

  def create_self_checkout_sales(attrs \\ %{}) do
    sales_changeset = %Sale{} |> Sale.self_checkout_sales_changeset(attrs)

    Multi.new()
    |> Multi.insert(:sales, sales_changeset)
    |> Multi.run(:inventory, fn repo, _ ->
      inventory =
        Repo.one(
          from(inventory in Inventory,
            join: sku in assoc(inventory, :sku),
            join: item in assoc(sku, :items),
            join: checkout_item in assoc(item, :checkout_item),
            where: checkout_item.id == ^attrs.checkout_item_id and item.sku_id == inventory.sku_id
          )
        )

      checkout_item = Repo.get(CheckoutItem, attrs.checkout_item_id)

      inventory_changeset =
        inventory
        |> Inventory.update_changeset(%{
          internal_quantity: inventory.internal_quantity - checkout_item.quantity
        })

      repo.update(inventory_changeset)
    end)
    |> Repo.transaction()
  end

  def bulk_cart_item_sales(attrs) do
    cart_items =
      Repo.all(
        from(cart_item in CartItem,
          where: cart_item.order_id == ^attrs.order_id and cart_item.decline_item == false
        )
      )

    Enum.each(cart_items, fn cart_item ->
      create_online_sales(%{
        cart_item_id: cart_item.id,
        pickup_centre_id: attrs.pickup_centre_id,
        staff_id: attrs.staff_id,
        sales_status: "completed"
      })
    end)

    Enum.each(cart_items, fn cart_item ->
      CustomerPurchases.sell_cart_items(cart_item)
    end)
  end

  def get_instore_total(sales) do
    instore_sales =
      Repo.one(
        from instore_sales in InstoreSale,
          where: instore_sales.sales_id == ^sales.id,
          select: sum(instore_sales.sales_amount)
      )

    case instore_sales do
      nil ->
        {:error, "Error sales total"}

      value ->
        {:ok, value}
    end
  end

  @doc """
  Updates a sales.

  ## Examples

      iex> update_sales(sales, %{field: new_value})
      {:ok, %Sale{}}

      iex> update_sales(sales, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sales(%Sale{} = sales, attrs) do
    sales
    |> Sale.online_sales_changeset(attrs)
    |> Repo.update()
  end

  @spec reverse_sales(EcomHealthService.Analytics.Sale.t()) :: any
  def reverse_sales(%Sale{} = sales) do
    sales
    |> Sale.reversal_changeset(%{reversed: true})
    |> Repo.update()
  end

  def instore_checkout(%Sale{} = sales, attrs) do
    sales
    |> Sale.in_store_sales_changeset(attrs)
    |> Repo.update()
  end

  def instore_cash_payment(%Sale{} = sales, attrs) do
    sales
    |> Sale.cash_payment_changeset(attrs)
    |> Repo.update()
  end

  def instore_card_payment(%Sale{} = sales, attrs) do
    sales
    |> Sale.card_payment_changeset(attrs)
    |> Repo.update()
  end

  def instore_split_payment(%Sale{} = sales, attrs) do
    sales
    |> Sale.split_payment_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a sales.

  ## Examples

      iex> delete_sales(sales)
      {:ok, %Sale{}}

      iex> delete_sales(sales)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sales(%Sale{} = sales) do
    Repo.delete(sales)
  end

  @doc """
  Creates a customer_info.

  ## Examples

      iex> create_customer_info(%{field: value})
      {:ok, %CustomerInfo{}}

      iex> create_customer_info(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_customer_info(attrs \\ %{}) do
    %CustomerInfo{}
    |> CustomerInfo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a customer_info.

  ## Examples

      iex> update_customer_info(customer_info, %{field: new_value})
      {:ok, %CustomerInfo{}}

      iex> update_customer_info(customer_info, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_customer_info(%CustomerInfo{} = customer_info, attrs) do
    customer_info
    |> CustomerInfo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a customer_info.

  ## Examples

      iex> delete_customer_info(customer_info)
      {:ok, %CustomerInfo{}}

      iex> delete_customer_info(customer_info)
      {:error, %Ecto.Changeset{}}

  """
  def delete_customer_info(%CustomerInfo{} = customer_info) do
    Repo.delete(customer_info)
  end

  @doc """
  Returns the list of instore_sales.

  ## Examples

      iex> list_instore_sales()
      [%InstoreSale{}, ...]

  """
  def list_instore_sales do
    Repo.all(InstoreSale)
  end

  @doc """
  Gets a single instore_sale.

  Raises `Ecto.NoResultsError` if the Instore sale does not exist.

  ## Examples

      iex> get_instore_sale!(123)
      %InstoreSale{}

      iex> get_instore_sale!(456)
      ** (Ecto.NoResultsError)

  """
  def get_instore_sale!(id), do: Repo.get!(InstoreSale, id)

  @doc """
  Creates a instore_sale.

  ## Examples

      iex> create_instore_sale(%{field: value})
      {:ok, %InstoreSale{}}

      iex> create_instore_sale(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_instore_sale(attrs \\ %{}) do
    Multi.new()
    |> Multi.run(:sales, fn repo, _ ->
      instore_sales_changeset = %InstoreSale{} |> InstoreSale.changeset(attrs)

      sales =
        Repo.one(
          from(staff in Staff,
            join: sales in assoc(staff, :sales),
            where: staff.id == ^attrs.staff_id and sales.sales_status == "processing"
          )
        )

      case sales do
        nil -> repo.insert(instore_sales_changeset)
        _ -> {:ok, sales}
      end
    end)
    |> Multi.run(:instore_sale, fn repo, %{sales: sales} ->
      instore_sales_changeset = %InstoreSale{} |> InstoreSale.changeset(attrs)

      in_store_sale =
        Repo.one(
          from(instore_sale in InstoreSale,
            where: instore_sale.item_id == ^attrs.item_id and instore_sale.sales_id == ^sales.id,
            lock: "FOR UPDATE"
          )
        )

      case in_store_sale do
        nil ->
          repo.insert(instore_sales_changeset)

        _ ->
          in_store_sale
          |> update_instore_sale(%{quantity: in_store_sale.quantity + attrs.quantity})
      end
    end)
    |> Repo.transaction()
  end

  @doc """
  Updates a instore_sale.

  ## Examples

      iex> update_instore_sale(instore_sale, %{field: new_value})
      {:ok, %InstoreSale{}}

      iex> update_instore_sale(instore_sale, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_instore_sale(%InstoreSale{} = instore_sale, attrs) do
    instore_sale
    |> InstoreSale.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a instore_sale.

  ## Examples

      iex> delete_instore_sale(instore_sale)
      {:ok, %InstoreSale{}}

      iex> delete_instore_sale(instore_sale)
      {:error, %Ecto.Changeset{}}

  """
  def delete_instore_sale(%InstoreSale{} = instore_sale) do
    Repo.delete(instore_sale)
  end
end

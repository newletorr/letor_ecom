defmodule LetorEcom.CustomerPurchases do
  @moduledoc """
  The CustomerPurchases context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi

  alias LetorEcom.{Account, Transactions}
  alias LetorEcom.Account.User

  alias LetorEcom.CustomerPurchases.{
    CartItem,
    DeliveryCharge,
    Order,
    OrderDispatch,
    PickUp,
    ReferalDiscount
  }

  alias LetorEcom.Transactions.Payment
  alias LetorEcom.Repo

  def data do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  @spec query(any, any) :: any
  def query(queryable, _params) do
    queryable
  end

  @doc """
  Creates a cart_items.
  """
  def create_cart_items(user, attrs \\ %{}) do
    Multi.new()
    |> Multi.run(:order, fn repo, _ ->
      order_changeset =
        %Order{}
        |> Order.activate_cart_changeset(%{user_id: user.id, order_status: "cart activated"})

      order =
        Repo.one(
          from(order in Order,
            where: order.user_id == ^user.id and order.order_status == "cart activated"
          )
        )

      case order do
        nil -> repo.insert(order_changeset)
        _ -> {:ok, order}
      end
    end)
    |> Multi.run(:cart_item, fn repo, %{order: order} ->
      cart_changeset = %CartItem{} |> CartItem.changeset(Map.put(attrs, :order_id, order.id))

      cart_item =
        Repo.one(
          from(cart_item in CartItem,
            where: cart_item.item_id == ^attrs.item_id and cart_item.order_id == ^order.id,
            lock: "FOR UPDATE"
          )
        )

      case cart_item do
        nil ->
          repo.insert(cart_changeset)

        _ ->
          update_cart_item(cart_item, %{
            quantity: cart_item.quantity + attrs.quantity
          })
      end
    end)
    |> Repo.transaction()
  end

  @doc """
  Updates a cart_item.

  ## Examples

      iex> update_cart_item(cart_item, %{field: new_value})
      {:ok, %CartItem{}}

      iex> update_cart_item(cart_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cart_item(%CartItem{} = cart_item, attrs) do
    cart_item
    |> CartItem.quantity_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a cart_item.

  ## Examples

      iex> delete_cart_item(cart_item)
      {:ok, %CartItem{}}

      iex> delete_cart_item(cart_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cart_item(%CartItem{} = cart_item) do
    Repo.delete(cart_item)
  end

  def payment_verification(order) do
    query =
      from(order in Order,
        join: u in assoc(order, :user),
        join: p in assoc(order, :payment),
        where: u.id == ^order.user_id and order.id == ^order.id,
        select: p.verified
      )

    check_payment_status = query |> last(:inserted_at) |> Repo.one()

    if check_payment_status == true do
      "PAID"
    else
      "NOT PAID"
    end
  end

  @doc """
  Place Order an order.

  ## Examples

      iex> place_order(order)
      {:ok, %Order{}}

      iex> place_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def place_order(%Order{} = order) do
    query =
      from payment in Payment, join: order in assoc(payment, :order), on: order.id == ^order.id

    payment = query |> last(:inserted_at) |> Repo.one()

    if(payment, do: Transactions.verify_order_payment(payment))

    order_changeset =
      order
      |> Order.place_order_changeset(%{
        order_status: "processing",
        order_confirmed: true,
        order_placed_at: Timex.now(),
        payment_status: payment_verification(order)
      })

    Multi.new()
    |> Multi.update(:order, order_changeset)
    |> Multi.run(:user, fn _repo, %{order: order} ->
      user = Repo.get(User, order.user_id)

      # Get the current users referer
      code_owner =
        if is_nil(user.referers_code) == false do
          Repo.get_by(User, referal_code: user.referers_code)
        else
          nil
        end

      # check if this user has already been refered
      already_refered =
        Repo.exists?(
          from(user in User,
            join: refered_list in assoc(user, :refered_list),
            where: refered_list.refered_person_id == ^user.id
          )
        )

      if is_nil(code_owner) == false and already_refered == false do
        Account.update_cus_pat_referal_points_earned(code_owner, %{
          referal_points_earned: code_owner.referal_points_earned + 1,
          cum_referal_earned_points: code_owner.cum_referal_earned_points + 1
        })

        Account.create_refered_list(%{
          date_activated: Timex.now(),
          refered_person_id: user.id,
          user_id: code_owner.id
        })
      else
        {:ok, nil}
      end
    end)
    |> Repo.transaction()
  end

  def complete_order(%Order{} = order, attrs) do
    order_changeset =
      case is_nil(attrs[:address]) == true or attrs[:address] == "" do
        true ->
          order |> Order.pickup_changeset(attrs)

        _ ->
          order |> Order.door_step_delivery_changeset(attrs)
      end

    user = Repo.get(User, order.user_id)
    attrs = payment_attributes(user, order, attrs)
    payment_changeset = %Payment{} |> Payment.order_payment_changeset(attrs)

    Multi.new()
    |> Multi.update(:order, order_changeset)
    |> Multi.insert(:payment, payment_changeset)
    |> Multi.run(:user, fn repo, %{order: order} ->
      referal_discount = order.referal_discount
      pickup_centre_id = order.pickup_centre_id

      ref_discounts =
        Repo.one(
          from ref_discount in ReferalDiscount,
            join: ecommerce_control in assoc(ref_discount, :ecommerce_control),
            join: pickup_centre in assoc(ecommerce_control, :pickup_centres),
            where: pickup_centre.id == ^pickup_centre_id
        )

      if user.first_referal_earned == false and referal_discount == ref_discounts.first_discount do
        repo.update(User.update_referals_earned_changeset(user, %{first_referal_earned: true}))
      else
        if user.second_referal_earned == false and
             referal_discount == ref_discounts.second_discount do
          repo.update(User.update_referals_earned_changeset(user, %{second_referal_earned: true}))
        else
          if user.third_referal_earned == false and
               referal_discount == ref_discounts.third_discount do
            repo.update(
              User.update_referals_earned_changeset(user, %{third_referal_earned: true})
            )
          else
            if user.fourth_referal_earned == false and
                 referal_discount == ref_discounts.fourth_discount do
              repo.update(
                User.update_referals_earned_changeset(user, %{
                  referal_points_earned: 0,
                  first_referal_earned: false,
                  second_referal_earned: false,
                  third_referal_earned: false,
                  fourth_referal_earned: false
                })
              )

              repo.update(
                Order.referal_discount_changeset(order, %{referal_discount: Decimal.new(0)})
              )
            else
              {:ok, nil}
            end
          end
        end
      end
    end)
    |> Repo.transaction()
  end

  defp payment_attributes(user, order, attrs) do
    [url, headers] = [
      "https://api.paystack.co/transaction/initialize",
      [
        Authorization: "Bearer #{System.get_env("PAYSTACK_KEY")}",
        Accept: "Application/json; Charset=utf-8"
      ]
    ]

    grand_total_to_string = Decimal.to_string(Decimal.mult(order.grand_total, 100))

    {:ok, body} =
      Poison.encode(%{
        email: user.email,
        amount: grand_total_to_string,
        custom_fields: [
          %{display_name: "Order ID", variable_name: "Order ID", value: order.id}
        ]
      })

    {:ok, response} = HTTPoison.post(url, body, headers)

    {:ok, res_body} = response.body |> Poison.decode()

    ref_code = res_body["data"]["reference"]

    auth_url = res_body["data"]["authorization_url"]

    payment_attrs =
      Map.merge(attrs, %{
        reference_code: ref_code,
        authorization_url: auth_url,
        amount: order.grand_total,
        order_id: order.id,
        user_id: order.user_id
      })

    payment_attrs
  end

  def dispatch_order(%Order{} = order) do
    order
    |> Order.dispatch_changeset(%{order_status: "dispatched"})
    |> Repo.update()
  end

  @spec confirm_delivery(EcomHealthService.Ordering.Order.t(), map) :: any
  @doc """
  Confirm delivery.



  """
  def confirm_delivery(%Order{} = order, attrs) do
    delivery_confirmation_changeset =
      if is_nil(order.agent_id) == false do
        order
        |> Order.agent_delivery_confirmation_changeset(
          Map.merge(attrs, %{time_delivered: Timex.now(), order_status: "delivered to agent"})
        )
      else
        order
        |> Order.customer_delivery_confirmation_changeset(
          Map.merge(attrs, %{time_delivered: Timex.now(), order_status: "delivered"})
        )
      end

    order_dispatch = Repo.get(OrderDispatch, order.order_dispatch_id)

    order_dispatch_changeset =
      order_dispatch
      |> OrderDispatch.update_changeset(%{order_delivered: order_dispatch.order_delivered + 1})

    Multi.new()
    |> Multi.update(:order, delivery_confirmation_changeset)
    |> Multi.update(:order_dispatch, order_dispatch_changeset)
    |> Multi.run(:pickups, fn repo, %{order: order} ->
      pickup_changeset =
        %PickUp{}
        |> PickUp.campus_agent_changeset(%{
          order_id: order.id,
          campus_agent_id: order.campus_agent_id
        })

      case order.campus_agent_id do
        nil ->
          {:ok, nil}

        _ ->
          repo.insert(pickup_changeset)
      end
    end)
    |> Repo.transaction()
  end

  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Creates a order_dispatch.

  ## Examples

      iex> create_order_dispatch(%{field: value})
      {:ok, %OrderDispatch{}}

      iex> create_order_dispatch(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order_dispatch(attrs \\ %{}) do
    %OrderDispatch{}
    |> OrderDispatch.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order_dispatch.

  ## Examples

      iex> update_order_dispatch(order_dispatch, %{field: new_value})
      {:ok, %OrderDispatch{}}

      iex> update_order_dispatch(order_dispatch, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order_dispatch(%OrderDispatch{} = order_dispatch, attrs) do
    order_dispatch
    |> OrderDispatch.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  dispatch an order_dispatch.

  ## Examples

      iex> dispatch_order_dispatch(order_dispatch, %{field: new_value})
      {:ok, %OrderDispatch{}}

      iex> dispatch_order_dispatch(order_dispatch, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def dispatch_order_dispatch(%OrderDispatch{} = order_dispatch) do
    order_dispatch_changeset =
      order_dispatch |> OrderDispatch.dispatch_changeset(%{dispatched: true})

    {:ok, order_dispatch} = Repo.update(order_dispatch_changeset)

    orders =
      Repo.all(
        from o in Order,
          join: od in assoc(o, :order_dispatch),
          where: o.order_dispatch_id == ^order_dispatch.id
      )

    for order <- orders, do: dispatch_order(order)

    # for order <- orders, do: Sms.text_user_confirmation_code(order)

    {:ok, order_dispatch}
  end

  @doc """
  Deletes a order_dispatch.

  ## Examples

      iex> delete_order_dispatch(order_dispatch)
      {:ok, %OrderDispatch{}}

      iex> delete_order_dispatch(order_dispatch)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order_dispatch(%OrderDispatch{} = order_dispatch) do
    Repo.delete(order_dispatch)
  end

  @doc """
  Returns the list of delivery_charges.

  ## Examples

      iex> list_delivery_charges()
      [%DeliveryCharge{}, ...]

  """
  def list_delivery_charges do
    Repo.all(DeliveryCharge)
  end

  @doc """
  Gets a single delivery_charge.

  Raises `Ecto.NoResultsError` if the Delivery charge does not exist.

  ## Examples

      iex> get_delivery_charge!(123)
      %DeliveryCharge{}

      iex> get_delivery_charge!(456)
      ** (Ecto.NoResultsError)

  """
  def get_delivery_charge!(id), do: Repo.get!(DeliveryCharge, id)

  @doc """
  Creates a delivery_charge.

  ## Examples

      iex> create_delivery_charge(%{field: value})
      {:ok, %DeliveryCharge{}}

      iex> create_delivery_charge(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_delivery_charge(attrs \\ %{}) do
    %DeliveryCharge{}
    |> DeliveryCharge.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a delivery_charge.

  ## Examples

      iex> update_delivery_charge(delivery_charge, %{field: new_value})
      {:ok, %DeliveryCharge{}}

      iex> update_delivery_charge(delivery_charge, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_delivery_charge(%DeliveryCharge{} = delivery_charge, attrs) do
    delivery_charge
    |> DeliveryCharge.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a delivery_charge.

  ## Examples

      iex> delete_delivery_charge(delivery_charge)
      {:ok, %DeliveryCharge{}}

      iex> delete_delivery_charge(delivery_charge)
      {:error, %Ecto.Changeset{}}

  """
  def delete_delivery_charge(%DeliveryCharge{} = delivery_charge) do
    Repo.delete(delivery_charge)
  end

  @doc """
  Returns the list of referal_discounts.

  ## Examples

      iex> list_referal_discounts()
      [%ReferalDiscount{}, ...]

  """
  def list_referal_discounts do
    Repo.all(ReferalDiscount)
  end

  @doc """
  Gets a single referal_discount.

  Raises `Ecto.NoResultsError` if the Referal discount does not exist.

  ## Examples

      iex> get_referal_discount!(123)
      %ReferalDiscount{}

      iex> get_referal_discount!(456)
      ** (Ecto.NoResultsError)

  """
  def get_referal_discount!(id), do: Repo.get!(ReferalDiscount, id)

  @doc """
  Creates a referal_discount.

  ## Examples

      iex> create_referal_discount(%{field: value})
      {:ok, %ReferalDiscount{}}

      iex> create_referal_discount(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_referal_discount(attrs \\ %{}) do
    %ReferalDiscount{}
    |> ReferalDiscount.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a referal_discount.

  ## Examples

      iex> update_referal_discount(referal_discount, %{field: new_value})
      {:ok, %ReferalDiscount{}}

      iex> update_referal_discount(referal_discount, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_referal_discount(%ReferalDiscount{} = referal_discount, attrs) do
    referal_discount
    |> ReferalDiscount.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a referal_discount.

  ## Examples

      iex> delete_referal_discount(referal_discount)
      {:ok, %ReferalDiscount{}}

      iex> delete_referal_discount(referal_discount)
      {:error, %Ecto.Changeset{}}

  """
  def delete_referal_discount(%ReferalDiscount{} = referal_discount) do
    Repo.delete(referal_discount)
  end

  @doc """
  Creates a pick_up.

  ## Examples

      iex> create_pick_up(%{field: value})
      {:ok, %PickUp{}}

      iex> create_pick_up(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pick_up(attrs \\ %{}) do
    %PickUp{}
    |> PickUp.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pick_up.

  ## Examples

      iex> update_pick_up(pick_up, %{field: new_value})
      {:ok, %PickUp{}}

      iex> update_pick_up(pick_up, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pick_up(%PickUp{} = pick_up, attrs) do
    pick_up
    |> PickUp.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a pick_up.

  ## Examples

      iex> delete_pick_up(pick_up)
      {:ok, %PickUp{}}

      iex> delete_pick_up(pick_up)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pick_up(%PickUp{} = pick_up) do
    Repo.delete(pick_up)
  end
end

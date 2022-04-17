defmodule LetorEcom.CustomerPurchasesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LetorEcom.CustomerPurchases` context.
  """

  @doc """
  Generate a cart_item.
  """
  def cart_item_fixture(attrs \\ %{}) do
    {:ok, cart_item} =
      attrs
      |> Enum.into(%{
        additional_info: "some additional_info",
        decline_item: true,
        quantity: 42,
        sold: true,
        sub_total: "some sub_total"
      })
      |> LetorEcom.CustomerPurchases.create_cart_item()

    cart_item
  end

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        address: "some address",
        agent_delivery_confirmation_code: "some agent_delivery_confirmation_code",
        centre_pickup: "some centre_pickup",
        contact_person: "some contact_person",
        customer_delivery_confirmation_code: "some customer_delivery_confirmation_code",
        delivery_charge: "120.5",
        delivery_date: ~D[2022-03-30],
        delivery_period: "some delivery_period",
        deliviery_option: "some deliviery_option",
        door_step_delivery: true,
        eight_am_twelve_pm: true,
        fifteen_to_thirty_minutes: true,
        four_pm_ten_pm: true,
        grand_total: "120.5",
        latest_time: ~T[14:00:00],
        one_to_two_hours: true,
        order_confirmed: true,
        order_instructions: "some order_instructions",
        order_number: "some order_number",
        order_placed_at: ~U[2022-03-30 12:32:00Z],
        order_status: "some order_status",
        pay_at_pickup: true,
        pay_on_delivery: true,
        pay_with_card: true,
        payment_option: "some payment_option",
        payment_status: "some payment_status",
        phone: "some phone",
        referal_discount: "120.5",
        time_delivered: ~U[2022-03-30 12:32:00Z],
        twelve_pm_four_pm: true,
        urgency_status: "some urgency_status"
      })
      |> LetorEcom.CustomerPurchases.create_order()

    order
  end

  @doc """
  Generate a order_dispatch.
  """
  def order_dispatch_fixture(attrs \\ %{}) do
    {:ok, order_dispatch} =
      attrs
      |> Enum.into(%{
        all_delivered: true,
        delayed: true,
        dispatch_id: "some dispatch_id",
        dispatched: true,
        order_count: 42,
        order_delivered: 42
      })
      |> LetorEcom.CustomerPurchases.create_order_dispatch()

    order_dispatch
  end

  @doc """
  Generate a delivery_charge.
  """
  def delivery_charge_fixture(attrs \\ %{}) do
    {:ok, delivery_charge} =
      attrs
      |> Enum.into(%{
        eight_to_twelve: "120.5",
        fifteen_to_thirty_minutes: "120.5",
        four_to_ten: "120.5",
        next_day: "120.5",
        twelve_to_four: "120.5"
      })
      |> LetorEcom.CustomerPurchases.create_delivery_charge()

    delivery_charge
  end

  @doc """
  Generate a referal_discount.
  """
  def referal_discount_fixture(attrs \\ %{}) do
    {:ok, referal_discount} =
      attrs
      |> Enum.into(%{
        first_discount: "120.5",
        fourth_discount: "120.5",
        second_discount: "120.5",
        third_discount: "120.5"
      })
      |> LetorEcom.CustomerPurchases.create_referal_discount()

    referal_discount
  end

  @doc """
  Generate a pickup.
  """
  def pickup_fixture(attrs \\ %{}) do
    {:ok, pickup} =
      attrs
      |> Enum.into(%{
        pick_up_time: ~U[2022-04-15 19:49:00Z],
        picked: true,
        pickup_code: "some pickup_code"
      })
      |> LetorEcom.CustomerPurchases.create_pickup()

    pickup
  end

  @doc """
  Generate a pickp.
  """
  def pickp_fixture(attrs \\ %{}) do
    {:ok, pickp} =
      attrs
      |> Enum.into(%{
        pick_up_time: ~U[2022-04-15 19:50:00Z],
        picked: true,
        pickup_code: "some pickup_code"
      })
      |> LetorEcom.CustomerPurchases.create_pickp()

    pickp
  end

  @doc """
  Generate a pick_up.
  """
  def pick_up_fixture(attrs \\ %{}) do
    {:ok, pick_up} =
      attrs
      |> Enum.into(%{
        pick_up_time: ~U[2022-04-15 19:50:00Z],
        picked: true,
        pickup_code: "some pickup_code"
      })
      |> LetorEcom.CustomerPurchases.create_pick_up()

    pick_up
  end

  @doc """
  Generate a pick_up.
  """
  def pick_up_fixture(attrs \\ %{}) do
    {:ok, pick_up} =
      attrs
      |> Enum.into(%{
        pick_up_time: ~U[2022-04-15 19:53:00Z],
        picked: true,
        pickup_code: "some pickup_code"
      })
      |> LetorEcom.CustomerPurchases.create_pick_up()

    pick_up
  end
end

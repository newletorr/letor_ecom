defmodule LetorEcom.CustomerPurchasesTest do
  use LetorEcom.DataCase

  alias LetorEcom.CustomerPurchases

  describe "cart_items" do
    alias LetorEcom.CustomerPurchases.CartItem

    import LetorEcom.CustomerPurchasesFixtures

    @invalid_attrs %{
      additional_info: nil,
      decline_item: nil,
      quantity: nil,
      sold: nil,
      sub_total: nil
    }

    test "list_cart_items/0 returns all cart_items" do
      cart_item = cart_item_fixture()
      assert CustomerPurchases.list_cart_items() == [cart_item]
    end

    test "get_cart_item!/1 returns the cart_item with given id" do
      cart_item = cart_item_fixture()
      assert CustomerPurchases.get_cart_item!(cart_item.id) == cart_item
    end

    test "create_cart_item/1 with valid data creates a cart_item" do
      valid_attrs = %{
        additional_info: "some additional_info",
        decline_item: true,
        quantity: 42,
        sold: true,
        sub_total: "some sub_total"
      }

      assert {:ok, %CartItem{} = cart_item} = CustomerPurchases.create_cart_item(valid_attrs)
      assert cart_item.additional_info == "some additional_info"
      assert cart_item.decline_item == true
      assert cart_item.quantity == 42
      assert cart_item.sold == true
      assert cart_item.sub_total == "some sub_total"
    end

    test "create_cart_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CustomerPurchases.create_cart_item(@invalid_attrs)
    end

    test "update_cart_item/2 with valid data updates the cart_item" do
      cart_item = cart_item_fixture()

      update_attrs = %{
        additional_info: "some updated additional_info",
        decline_item: false,
        quantity: 43,
        sold: false,
        sub_total: "some updated sub_total"
      }

      assert {:ok, %CartItem{} = cart_item} =
               CustomerPurchases.update_cart_item(cart_item, update_attrs)

      assert cart_item.additional_info == "some updated additional_info"
      assert cart_item.decline_item == false
      assert cart_item.quantity == 43
      assert cart_item.sold == false
      assert cart_item.sub_total == "some updated sub_total"
    end

    test "update_cart_item/2 with invalid data returns error changeset" do
      cart_item = cart_item_fixture()

      assert {:error, %Ecto.Changeset{}} =
               CustomerPurchases.update_cart_item(cart_item, @invalid_attrs)

      assert cart_item == CustomerPurchases.get_cart_item!(cart_item.id)
    end

    test "delete_cart_item/1 deletes the cart_item" do
      cart_item = cart_item_fixture()
      assert {:ok, %CartItem{}} = CustomerPurchases.delete_cart_item(cart_item)
      assert_raise Ecto.NoResultsError, fn -> CustomerPurchases.get_cart_item!(cart_item.id) end
    end
  end

  describe "orders" do
    alias LetorEcom.CustomerPurchases.Order

    import LetorEcom.CustomerPurchasesFixtures

    @invalid_attrs %{
      address: nil,
      agent_delivery_confirmation_code: nil,
      centre_pickup: nil,
      contact_person: nil,
      customer_delivery_confirmation_code: nil,
      delivery_charge: nil,
      delivery_date: nil,
      delivery_period: nil,
      deliviery_option: nil,
      door_step_delivery: nil,
      eight_am_twelve_pm: nil,
      fifteen_to_thirty_minutes: nil,
      four_pm_ten_pm: nil,
      grand_total: nil,
      latest_time: nil,
      one_to_two_hours: nil,
      order_confirmed: nil,
      order_instructions: nil,
      order_number: nil,
      order_placed_at: nil,
      order_status: nil,
      pay_at_pickup: nil,
      pay_on_delivery: nil,
      pay_with_card: nil,
      payment_option: nil,
      payment_status: nil,
      phone: nil,
      referal_discount: nil,
      time_delivered: nil,
      twelve_pm_four_pm: nil,
      urgency_status: nil
    }

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert CustomerPurchases.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert CustomerPurchases.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      valid_attrs = %{
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
      }

      assert {:ok, %Order{} = order} = CustomerPurchases.create_order(valid_attrs)
      assert order.address == "some address"
      assert order.agent_delivery_confirmation_code == "some agent_delivery_confirmation_code"
      assert order.centre_pickup == "some centre_pickup"
      assert order.contact_person == "some contact_person"

      assert order.customer_delivery_confirmation_code ==
               "some customer_delivery_confirmation_code"

      assert order.delivery_charge == Decimal.new("120.5")
      assert order.delivery_date == ~D[2022-03-30]
      assert order.delivery_period == "some delivery_period"
      assert order.deliviery_option == "some deliviery_option"
      assert order.door_step_delivery == true
      assert order.eight_am_twelve_pm == true
      assert order.fifteen_to_thirty_minutes == true
      assert order.four_pm_ten_pm == true
      assert order.grand_total == Decimal.new("120.5")
      assert order.latest_time == ~T[14:00:00]
      assert order.one_to_two_hours == true
      assert order.order_confirmed == true
      assert order.order_instructions == "some order_instructions"
      assert order.order_number == "some order_number"
      assert order.order_placed_at == ~U[2022-03-30 12:32:00Z]
      assert order.order_status == "some order_status"
      assert order.pay_at_pickup == true
      assert order.pay_on_delivery == true
      assert order.pay_with_card == true
      assert order.payment_option == "some payment_option"
      assert order.payment_status == "some payment_status"
      assert order.phone == "some phone"
      assert order.referal_discount == Decimal.new("120.5")
      assert order.time_delivered == ~U[2022-03-30 12:32:00Z]
      assert order.twelve_pm_four_pm == true
      assert order.urgency_status == "some urgency_status"
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CustomerPurchases.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()

      update_attrs = %{
        address: "some updated address",
        agent_delivery_confirmation_code: "some updated agent_delivery_confirmation_code",
        centre_pickup: "some updated centre_pickup",
        contact_person: "some updated contact_person",
        customer_delivery_confirmation_code: "some updated customer_delivery_confirmation_code",
        delivery_charge: "456.7",
        delivery_date: ~D[2022-03-31],
        delivery_period: "some updated delivery_period",
        deliviery_option: "some updated deliviery_option",
        door_step_delivery: false,
        eight_am_twelve_pm: false,
        fifteen_to_thirty_minutes: false,
        four_pm_ten_pm: false,
        grand_total: "456.7",
        latest_time: ~T[15:01:01],
        one_to_two_hours: false,
        order_confirmed: false,
        order_instructions: "some updated order_instructions",
        order_number: "some updated order_number",
        order_placed_at: ~U[2022-03-31 12:32:00Z],
        order_status: "some updated order_status",
        pay_at_pickup: false,
        pay_on_delivery: false,
        pay_with_card: false,
        payment_option: "some updated payment_option",
        payment_status: "some updated payment_status",
        phone: "some updated phone",
        referal_discount: "456.7",
        time_delivered: ~U[2022-03-31 12:32:00Z],
        twelve_pm_four_pm: false,
        urgency_status: "some updated urgency_status"
      }

      assert {:ok, %Order{} = order} = CustomerPurchases.update_order(order, update_attrs)
      assert order.address == "some updated address"

      assert order.agent_delivery_confirmation_code ==
               "some updated agent_delivery_confirmation_code"

      assert order.centre_pickup == "some updated centre_pickup"
      assert order.contact_person == "some updated contact_person"

      assert order.customer_delivery_confirmation_code ==
               "some updated customer_delivery_confirmation_code"

      assert order.delivery_charge == Decimal.new("456.7")
      assert order.delivery_date == ~D[2022-03-31]
      assert order.delivery_period == "some updated delivery_period"
      assert order.deliviery_option == "some updated deliviery_option"
      assert order.door_step_delivery == false
      assert order.eight_am_twelve_pm == false
      assert order.fifteen_to_thirty_minutes == false
      assert order.four_pm_ten_pm == false
      assert order.grand_total == Decimal.new("456.7")
      assert order.latest_time == ~T[15:01:01]
      assert order.one_to_two_hours == false
      assert order.order_confirmed == false
      assert order.order_instructions == "some updated order_instructions"
      assert order.order_number == "some updated order_number"
      assert order.order_placed_at == ~U[2022-03-31 12:32:00Z]
      assert order.order_status == "some updated order_status"
      assert order.pay_at_pickup == false
      assert order.pay_on_delivery == false
      assert order.pay_with_card == false
      assert order.payment_option == "some updated payment_option"
      assert order.payment_status == "some updated payment_status"
      assert order.phone == "some updated phone"
      assert order.referal_discount == Decimal.new("456.7")
      assert order.time_delivered == ~U[2022-03-31 12:32:00Z]
      assert order.twelve_pm_four_pm == false
      assert order.urgency_status == "some updated urgency_status"
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = CustomerPurchases.update_order(order, @invalid_attrs)
      assert order == CustomerPurchases.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = CustomerPurchases.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> CustomerPurchases.get_order!(order.id) end
    end
  end

  describe "order_dispatch" do
    alias LetorEcom.CustomerPurchases.OrderDispatch

    import LetorEcom.CustomerPurchasesFixtures

    @invalid_attrs %{
      all_delivered: nil,
      delayed: nil,
      dispatch_id: nil,
      dispatched: nil,
      order_count: nil,
      order_delivered: nil
    }

    test "list_order_dispatch/0 returns all order_dispatch" do
      order_dispatch = order_dispatch_fixture()
      assert CustomerPurchases.list_order_dispatch() == [order_dispatch]
    end

    test "get_order_dispatch!/1 returns the order_dispatch with given id" do
      order_dispatch = order_dispatch_fixture()
      assert CustomerPurchases.get_order_dispatch!(order_dispatch.id) == order_dispatch
    end

    test "create_order_dispatch/1 with valid data creates a order_dispatch" do
      valid_attrs = %{
        all_delivered: true,
        delayed: true,
        dispatch_id: "some dispatch_id",
        dispatched: true,
        order_count: 42,
        order_delivered: 42
      }

      assert {:ok, %OrderDispatch{} = order_dispatch} =
               CustomerPurchases.create_order_dispatch(valid_attrs)

      assert order_dispatch.all_delivered == true
      assert order_dispatch.delayed == true
      assert order_dispatch.dispatch_id == "some dispatch_id"
      assert order_dispatch.dispatched == true
      assert order_dispatch.order_count == 42
      assert order_dispatch.order_delivered == 42
    end

    test "create_order_dispatch/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CustomerPurchases.create_order_dispatch(@invalid_attrs)
    end

    test "update_order_dispatch/2 with valid data updates the order_dispatch" do
      order_dispatch = order_dispatch_fixture()

      update_attrs = %{
        all_delivered: false,
        delayed: false,
        dispatch_id: "some updated dispatch_id",
        dispatched: false,
        order_count: 43,
        order_delivered: 43
      }

      assert {:ok, %OrderDispatch{} = order_dispatch} =
               CustomerPurchases.update_order_dispatch(order_dispatch, update_attrs)

      assert order_dispatch.all_delivered == false
      assert order_dispatch.delayed == false
      assert order_dispatch.dispatch_id == "some updated dispatch_id"
      assert order_dispatch.dispatched == false
      assert order_dispatch.order_count == 43
      assert order_dispatch.order_delivered == 43
    end

    test "update_order_dispatch/2 with invalid data returns error changeset" do
      order_dispatch = order_dispatch_fixture()

      assert {:error, %Ecto.Changeset{}} =
               CustomerPurchases.update_order_dispatch(order_dispatch, @invalid_attrs)

      assert order_dispatch == CustomerPurchases.get_order_dispatch!(order_dispatch.id)
    end

    test "delete_order_dispatch/1 deletes the order_dispatch" do
      order_dispatch = order_dispatch_fixture()
      assert {:ok, %OrderDispatch{}} = CustomerPurchases.delete_order_dispatch(order_dispatch)

      assert_raise Ecto.NoResultsError, fn ->
        CustomerPurchases.get_order_dispatch!(order_dispatch.id)
      end
    end
  end

  describe "delivery_charges" do
    alias LetorEcom.CustomerPurchases.DeliveryCharge

    import LetorEcom.CustomerPurchasesFixtures

    @invalid_attrs %{
      eight_to_twelve: nil,
      fifteen_to_thirty_minutes: nil,
      four_to_ten: nil,
      next_day: nil,
      twelve_to_four: nil
    }

    test "list_delivery_charges/0 returns all delivery_charges" do
      delivery_charge = delivery_charge_fixture()
      assert CustomerPurchases.list_delivery_charges() == [delivery_charge]
    end

    test "get_delivery_charge!/1 returns the delivery_charge with given id" do
      delivery_charge = delivery_charge_fixture()
      assert CustomerPurchases.get_delivery_charge!(delivery_charge.id) == delivery_charge
    end

    test "create_delivery_charge/1 with valid data creates a delivery_charge" do
      valid_attrs = %{
        eight_to_twelve: "120.5",
        fifteen_to_thirty_minutes: "120.5",
        four_to_ten: "120.5",
        next_day: "120.5",
        twelve_to_four: "120.5"
      }

      assert {:ok, %DeliveryCharge{} = delivery_charge} =
               CustomerPurchases.create_delivery_charge(valid_attrs)

      assert delivery_charge.eight_to_twelve == Decimal.new("120.5")
      assert delivery_charge.fifteen_to_thirty_minutes == Decimal.new("120.5")
      assert delivery_charge.four_to_ten == Decimal.new("120.5")
      assert delivery_charge.next_day == Decimal.new("120.5")
      assert delivery_charge.twelve_to_four == Decimal.new("120.5")
    end

    test "create_delivery_charge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               CustomerPurchases.create_delivery_charge(@invalid_attrs)
    end

    test "update_delivery_charge/2 with valid data updates the delivery_charge" do
      delivery_charge = delivery_charge_fixture()

      update_attrs = %{
        eight_to_twelve: "456.7",
        fifteen_to_thirty_minutes: "456.7",
        four_to_ten: "456.7",
        next_day: "456.7",
        twelve_to_four: "456.7"
      }

      assert {:ok, %DeliveryCharge{} = delivery_charge} =
               CustomerPurchases.update_delivery_charge(delivery_charge, update_attrs)

      assert delivery_charge.eight_to_twelve == Decimal.new("456.7")
      assert delivery_charge.fifteen_to_thirty_minutes == Decimal.new("456.7")
      assert delivery_charge.four_to_ten == Decimal.new("456.7")
      assert delivery_charge.next_day == Decimal.new("456.7")
      assert delivery_charge.twelve_to_four == Decimal.new("456.7")
    end

    test "update_delivery_charge/2 with invalid data returns error changeset" do
      delivery_charge = delivery_charge_fixture()

      assert {:error, %Ecto.Changeset{}} =
               CustomerPurchases.update_delivery_charge(delivery_charge, @invalid_attrs)

      assert delivery_charge == CustomerPurchases.get_delivery_charge!(delivery_charge.id)
    end

    test "delete_delivery_charge/1 deletes the delivery_charge" do
      delivery_charge = delivery_charge_fixture()
      assert {:ok, %DeliveryCharge{}} = CustomerPurchases.delete_delivery_charge(delivery_charge)

      assert_raise Ecto.NoResultsError, fn ->
        CustomerPurchases.get_delivery_charge!(delivery_charge.id)
      end
    end
  end

  describe "referal_discount" do
    alias LetorEcom.CustomerPurchases.ReferalDiscount

    import LetorEcom.CustomerPurchasesFixtures

    @invalid_attrs %{
      first_discount: nil,
      fourth_discount: nil,
      second_discount: nil,
      third_discount: nil
    }

    test "list_referal_discount/0 returns all referal_discount" do
      referal_discount = referal_discount_fixture()
      assert CustomerPurchases.list_referal_discount() == [referal_discount]
    end

    test "get_referal_discount!/1 returns the referal_discount with given id" do
      referal_discount = referal_discount_fixture()
      assert CustomerPurchases.get_referal_discount!(referal_discount.id) == referal_discount
    end

    test "create_referal_discount/1 with valid data creates a referal_discount" do
      valid_attrs = %{
        first_discount: "120.5",
        fourth_discount: "120.5",
        second_discount: "120.5",
        third_discount: "120.5"
      }

      assert {:ok, %ReferalDiscount{} = referal_discount} =
               CustomerPurchases.create_referal_discount(valid_attrs)

      assert referal_discount.first_discount == Decimal.new("120.5")
      assert referal_discount.fourth_discount == Decimal.new("120.5")
      assert referal_discount.second_discount == Decimal.new("120.5")
      assert referal_discount.third_discount == Decimal.new("120.5")
    end

    test "create_referal_discount/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               CustomerPurchases.create_referal_discount(@invalid_attrs)
    end

    test "update_referal_discount/2 with valid data updates the referal_discount" do
      referal_discount = referal_discount_fixture()

      update_attrs = %{
        first_discount: "456.7",
        fourth_discount: "456.7",
        second_discount: "456.7",
        third_discount: "456.7"
      }

      assert {:ok, %ReferalDiscount{} = referal_discount} =
               CustomerPurchases.update_referal_discount(referal_discount, update_attrs)

      assert referal_discount.first_discount == Decimal.new("456.7")
      assert referal_discount.fourth_discount == Decimal.new("456.7")
      assert referal_discount.second_discount == Decimal.new("456.7")
      assert referal_discount.third_discount == Decimal.new("456.7")
    end

    test "update_referal_discount/2 with invalid data returns error changeset" do
      referal_discount = referal_discount_fixture()

      assert {:error, %Ecto.Changeset{}} =
               CustomerPurchases.update_referal_discount(referal_discount, @invalid_attrs)

      assert referal_discount == CustomerPurchases.get_referal_discount!(referal_discount.id)
    end

    test "delete_referal_discount/1 deletes the referal_discount" do
      referal_discount = referal_discount_fixture()

      assert {:ok, %ReferalDiscount{}} =
               CustomerPurchases.delete_referal_discount(referal_discount)

      assert_raise Ecto.NoResultsError, fn ->
        CustomerPurchases.get_referal_discount!(referal_discount.id)
      end
    end
  end

  describe "referal_discounts" do
    alias LetorEcom.CustomerPurchases.ReferalDiscount

    import LetorEcom.CustomerPurchasesFixtures

    @invalid_attrs %{
      first_discount: nil,
      fourth_discount: nil,
      second_discount: nil,
      third_discount: nil
    }

    test "list_referal_discounts/0 returns all referal_discounts" do
      referal_discount = referal_discount_fixture()
      assert CustomerPurchases.list_referal_discounts() == [referal_discount]
    end

    test "get_referal_discount!/1 returns the referal_discount with given id" do
      referal_discount = referal_discount_fixture()
      assert CustomerPurchases.get_referal_discount!(referal_discount.id) == referal_discount
    end

    test "create_referal_discount/1 with valid data creates a referal_discount" do
      valid_attrs = %{
        first_discount: "120.5",
        fourth_discount: "120.5",
        second_discount: "120.5",
        third_discount: "120.5"
      }

      assert {:ok, %ReferalDiscount{} = referal_discount} =
               CustomerPurchases.create_referal_discount(valid_attrs)

      assert referal_discount.first_discount == Decimal.new("120.5")
      assert referal_discount.fourth_discount == Decimal.new("120.5")
      assert referal_discount.second_discount == Decimal.new("120.5")
      assert referal_discount.third_discount == Decimal.new("120.5")
    end

    test "create_referal_discount/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               CustomerPurchases.create_referal_discount(@invalid_attrs)
    end

    test "update_referal_discount/2 with valid data updates the referal_discount" do
      referal_discount = referal_discount_fixture()

      update_attrs = %{
        first_discount: "456.7",
        fourth_discount: "456.7",
        second_discount: "456.7",
        third_discount: "456.7"
      }

      assert {:ok, %ReferalDiscount{} = referal_discount} =
               CustomerPurchases.update_referal_discount(referal_discount, update_attrs)

      assert referal_discount.first_discount == Decimal.new("456.7")
      assert referal_discount.fourth_discount == Decimal.new("456.7")
      assert referal_discount.second_discount == Decimal.new("456.7")
      assert referal_discount.third_discount == Decimal.new("456.7")
    end

    test "update_referal_discount/2 with invalid data returns error changeset" do
      referal_discount = referal_discount_fixture()

      assert {:error, %Ecto.Changeset{}} =
               CustomerPurchases.update_referal_discount(referal_discount, @invalid_attrs)

      assert referal_discount == CustomerPurchases.get_referal_discount!(referal_discount.id)
    end

    test "delete_referal_discount/1 deletes the referal_discount" do
      referal_discount = referal_discount_fixture()

      assert {:ok, %ReferalDiscount{}} =
               CustomerPurchases.delete_referal_discount(referal_discount)

      assert_raise Ecto.NoResultsError, fn ->
        CustomerPurchases.get_referal_discount!(referal_discount.id)
      end
    end
  end

  describe "pick_ups" do
    alias LetorEcom.CustomerPurchases.PickUp

    import LetorEcom.CustomerPurchasesFixtures

    @invalid_attrs %{pick_up_time: nil, picked: nil, pickup_code: nil}

    test "list_pick_ups/0 returns all pick_ups" do
      pick_up = pick_up_fixture()
      assert CustomerPurchases.list_pick_ups() == [pick_up]
    end

    test "get_pick_up!/1 returns the pick_up with given id" do
      pick_up = pick_up_fixture()
      assert CustomerPurchases.get_pick_up!(pick_up.id) == pick_up
    end

    test "create_pick_up/1 with valid data creates a pick_up" do
      valid_attrs = %{
        pick_up_time: ~U[2022-04-15 19:53:00Z],
        picked: true,
        pickup_code: "some pickup_code"
      }

      assert {:ok, %PickUp{} = pick_up} = CustomerPurchases.create_pick_up(valid_attrs)
      assert pick_up.pick_up_time == ~U[2022-04-15 19:53:00Z]
      assert pick_up.picked == true
      assert pick_up.pickup_code == "some pickup_code"
    end

    test "create_pick_up/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CustomerPurchases.create_pick_up(@invalid_attrs)
    end

    test "update_pick_up/2 with valid data updates the pick_up" do
      pick_up = pick_up_fixture()

      update_attrs = %{
        pick_up_time: ~U[2022-04-16 19:53:00Z],
        picked: false,
        pickup_code: "some updated pickup_code"
      }

      assert {:ok, %PickUp{} = pick_up} = CustomerPurchases.update_pick_up(pick_up, update_attrs)
      assert pick_up.pick_up_time == ~U[2022-04-16 19:53:00Z]
      assert pick_up.picked == false
      assert pick_up.pickup_code == "some updated pickup_code"
    end

    test "update_pick_up/2 with invalid data returns error changeset" do
      pick_up = pick_up_fixture()

      assert {:error, %Ecto.Changeset{}} =
               CustomerPurchases.update_pick_up(pick_up, @invalid_attrs)

      assert pick_up == CustomerPurchases.get_pick_up!(pick_up.id)
    end

    test "delete_pick_up/1 deletes the pick_up" do
      pick_up = pick_up_fixture()
      assert {:ok, %PickUp{}} = CustomerPurchases.delete_pick_up(pick_up)
      assert_raise Ecto.NoResultsError, fn -> CustomerPurchases.get_pick_up!(pick_up.id) end
    end
  end
end

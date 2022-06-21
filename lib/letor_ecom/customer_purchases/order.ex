defmodule LetorEcom.CustomerPurchases.Order do
  use LetorEcom.SchemaHelper
  alias LetorEcom.Account.{AddressBook, User}
  alias LetorEcom.AgentsAndSuppliers.Agent
  alias LetorEcom.Catalogue.Item
  alias LetorEcom.Control.Location
  alias LetorEcom.CustomerPurchases.{CartItem, DeliveryCharge, OrderDispatch, PickUp}

  alias LetorEcom.Repo
  @order_code 5

  schema "orders" do
    field :address, :string, read_after_writes: true
    field :agent_delivery_confirmation_code, :string, read_after_writes: true
    field :centre_pickup, :string, read_after_writes: true
    field :contact_person, :string, read_after_writes: true
    field :customer_delivery_confirmation_code, :string, read_after_writes: true
    field :delivery_charge, :decimal, read_after_writes: true
    field :delivery_date, :date, read_after_writes: true
    field :delivery_period, :string, read_after_writes: true
    field :delivery_option, :string, read_after_writes: true
    field :door_step_delivery, :boolean, default: false, read_after_writes: true
    field :eight_am_twelve_pm, :boolean, default: false, read_after_writes: true
    field :fifteen_to_thirty_minutes, :boolean, default: false, read_after_writes: true
    field :four_pm_ten_pm, :boolean, default: false, read_after_writes: true
    field :grand_total, :decimal, read_after_writes: true
    field :latest_time, :time, read_after_writes: true
    field :one_to_two_hours, :boolean, default: false, read_after_writes: true
    field :order_confirmed, :boolean, default: false, read_after_writes: true
    field :order_instructions, :string, read_after_writes: true
    field :order_number, :string, read_after_writes: true
    field :order_placed_at, :utc_datetime, read_after_writes: true
    field :order_status, :string, read_after_writes: true
    field :pay_at_pickup, :boolean, default: false, read_after_writes: true
    field :pay_on_delivery, :boolean, default: false, read_after_writes: true
    field :pay_with_card, :boolean, default: false, read_after_writes: true
    field :payment_option, :string, read_after_writes: true
    field :payment_status, :string, read_after_writes: true
    field :phone, :string, read_after_writes: true
    field :referal_discount, :decimal, read_after_writes: true
    field :time_delivered, :utc_datetime, read_after_writes: true
    field :twelve_pm_four_pm, :boolean, default: false, read_after_writes: true
    field :urgency_status, :string, read_after_writes: true
    belongs_to(:item, Item)
    belongs_to(:user, User)
    belongs_to(:location, Location)
    belongs_to(:agent, Agent)
    belongs_to(:order_dispatch, OrderDispatch)
    belongs_to(:address_book, AddressBook)
    has_many(:cart_items, CartItem)
    has_many(:pick_ups, PickUp)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def activate_cart_changeset(order, attrs) do
    order
    |> cast(attrs, [:user_id, :order_status])
    |> assoc_constraint(:user)
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [
      :location_id,
      :order_number,
      :address_book_id,
      :delivery_charge,
      :delivery_date,
      :fifteen_to_thirty_minutes,
      :one_to_two_hours,
      :eight_am_twelve_pm,
      :twelve_pm_four_pm,
      :four_pm_ten_pm,
      :agent_delivery_confirmation_code,
      :customer_delivery_confirmation_code,
      :order_instructions,
      :order_status,
      :pay_with_card,
      :pay_on_delivery,
      :pay_at_pickup,
      :phone,
      :contact_person,
      :centre_pickup,
      :door_step_delivery,
      :order_confirmed,
      :order_placed_at,
      :referal_discount,
      :delivery_period,
      :payment_status,
      :payment_option,
      :latest_time,
      :urgency_status,
      :delivery_option,
      :time_delivered,
      :grand_total
    ])
    |> validate_required([
      :location_id,
      :address,
      :phone,
      :pickup_centre_id
    ])
    |> validate_length(:address,
      message:
        "Your Address should be at list 10 characters long and not more than 40 characters long",
      min: 10,
      max: 40
    )
    |> assoc_constraint(:location)
    |> assoc_constraint(:pickup_centre)
    |> assoc_constraint(:address_book)
    |> valid_delivery_date_on_completion
    |> create_order_number
    |> location_area_in_address
    |> calculate_delivery_charge
    |> calculate_grand_total
    |> get_payment_option
    |> get_delivery_option
    |> set_delivery_period
  end

  def door_step_delivery_changeset(order, attrs) do
    order
    |> cast(attrs, [
      :user_id,
      :location_id,
      :order_number,
      :address,
      :address_book_id,
      :delivery_charge,
      :delivery_date,
      :one_to_two_hours,
      :eight_am_twelve_pm,
      :twelve_pm_four_pm,
      :four_pm_ten_pm,
      :order_instructions,
      :order_status,
      :pay_with_card,
      :pay_on_delivery,
      :pay_at_pickup,
      :phone,
      :contact_person,
      :centre_pick_up,
      :door_step_delivery,
      :order_confirmed,
      :referal_discount,
      :delivery_period,
      :payment_status,
      :payment_option,
      :urgency_status,
      :delivery_option,
      :grand_total
    ])
    |> validate_required([:location_id, :address, :phone, :pickup_centre_id])
    |> validate_length(:address,
      message:
        "Your Address should be at list 10 characters long and not more than 40 characters long",
      min: 10,
      max: 40
    )
    |> assoc_constraint(:location)
    |> assoc_constraint(:pickup_centre)
    |> valid_delivery_date_on_completion
    |> create_order_number
    |> location_area_in_address
    |> calculate_delivery_charge
    |> calculate_grand_total
    |> get_delivery_option
    |> set_delivery_period
  end

  def pickup_changeset(order, attrs) do
    order
    |> cast(attrs, [
      :user_id,
      :location_id,
      :curbside_agent_id,
      :order_number,
      :delivery_date,
      :order_instructions,
      :order_status,
      :pay_with_card,
      :pay_at_pickup,
      :phone,
      :contact_person,
      :centre_pick_up,
      :order_confirmed,
      :referal_discount,
      :delivery_period,
      :payment_status,
      :payment_option,
      :delivery_option,
      :grand_total
    ])
    |> validate_required([:location_id, :phone, :contact_person])
    |> assoc_constraint(:location)
    |> assoc_constraint(:curbside_agent)
    |> valid_delivery_date_on_completion
    |> create_order_number
    |> calculate_grand_total
    |> get_delivery_option
    |> get_default_user_address
  end

  def campus_agent_pickup_changeset(order, attrs) do
    order
    |> cast(attrs, [
      :user_id,
      :location_id,
      :campus_agent_id,
      :order_number,
      :delivery_date,
      :order_instructions,
      :order_status,
      :curbside_pick_up,
      :phone,
      :contact_person,
      :centre_pick_up,
      :order_confirmed,
      :referal_discount,
      :delivery_period,
      :payment_status,
      :payment_option,
      :delivery_option,
      :grand_total
    ])
    |> validate_required([:location_id, :phone, :pickup_centre_id, :curbside_agent_id])
    |> assoc_constraint(:location)
    |> assoc_constraint(:pickup_centre)
    |> assoc_constraint(:agent)
    |> create_order_number
    |> calculate_grand_total
    |> get_delivery_option
    |> get_default_user_address
  end

  def place_order_changeset(order, attrs) do
    order
    |> cast(attrs, [
      :item_id,
      :agent_delivery_confirmation_code,
      :customer_delivery_confirmation_code,
      :order_status,
      :order_confirmed,
      :order_placed_at,
      :payment_status,
      :latest_time
    ])
    |> customer_order_confirmation_code
    # |> agent_order_confirmation_code
    # |> valid_delivery_date_on_placing_order
    |> get_latest_time
    |> assoc_constraint(:item)
    |> get_popular_item
  end

  def add_for_dispatch_changeset(order, attrs) do
    order
    |> cast(attrs, [:order_dispatch_id])
    |> validate_required([:order_dispatch_id])
    |> assoc_constraint(:order_dispatch)
  end

  def dispatch_changeset(order, attrs) do
    order
    |> cast(attrs, [:order_status])
  end

  def referal_discount_changeset(order, attrs) do
    order
    |> cast(attrs, [:referal_discount])
  end

  def customer_delivery_confirmation_changeset(order, attrs) do
    order
    |> cast(attrs, [
      :customer_delivery_confirmation_code,
      :confirm_delivery_code,
      :order_status,
      :time_delivered
    ])
    |> validate_required([:confirm_delivery_code])
    |> customer_delivery_confirmation
  end

  def agent_delivery_confirmation_changeset(order, attrs) do
    order
    |> cast(attrs, [
      :agent_delivery_confirmation_code,
      :confirm_delivery_code,
      :order_status,
      :time_delivered
    ])
    |> validate_required([:confirm_delivery_code])
    |> agent_delivery_confirmation
  end

  def cancel_order_changeset(order, attrs) do
    order
    |> cast(attrs, [:order_status])
    |> validate_required([:order_status])
  end

  def order_status_reconfirmation_changeset(order, attrs) do
    order
    |> cast(attrs, [:payment_status])
  end

  defp valid_delivery_date_on_completion(changeset) do
    case changeset.valid? do
      true ->
        delivery_date = get_field(changeset, :delivery_date)

        todays_date =
          DateTime.utc_now()
          |> DateTime.to_date()

        check_date = Date.compare(delivery_date, todays_date)

        if check_date == :lt do
          add_error(changeset, :invalid_date, "Past date should not be selected")
        else
          changeset
        end

      _ ->
        changeset
    end
  end

  defp valid_delivery_date_on_placing_order(changeset) do
    case changeset.valid? do
      true ->
        delivery_date = get_field(changeset, :delivery_date)

        todays_date =
          DateTime.utc_now()
          |> DateTime.to_date()

        check_date = Date.compare(delivery_date, todays_date)

        if check_date == :lt do
          add_error(
            changeset,
            :invalid_date,
            "The date on this order has past. Please update your order date to continue."
          )
        else
          changeset
        end

      _ ->
        changeset
    end
  end

  defp customer_order_confirmation_code(changeset) do
    case changeset.valid? do
      true ->
        changeset
        |> put_change(
          :customer_delivery_confirmation_code,
          __MODULE__.door_step_delivery_confirmation()
        )

      _ ->
        changeset
    end
  end

  defp customer_delivery_confirmation(changeset) do
    case changeset.valid? do
      true ->
        customer_delivery_confirmation_code =
          get_field(changeset, :customer_delivery_confirmation_code)

        confirm_delivery_code = get_field(changeset, :confirm_delivery_code)

        if customer_delivery_confirmation_code != confirm_delivery_code do
          add_error(
            changeset,
            :in_correct_confirmation_code,
            "incorrect code"
          )
        else
          changeset
          |> put_change(:order_status, "delivered")
        end

      _ ->
        changeset
    end
  end

  defp agent_delivery_confirmation(changeset) do
    case changeset.valid? do
      true ->
        agent_delivery_confirmation_code = get_field(changeset, :agent_delivery_confirmation_code)

        confirm_delivery_code = get_field(changeset, :confirm_delivery_code)

        if agent_delivery_confirmation_code != confirm_delivery_code do
          add_error(
            changeset,
            :in_correct_confirmation_code,
            "incorrect code"
          )
        else
          changeset
          |> put_change(:order_status, "delivered")
        end

      _ ->
        changeset
    end
  end

  # creater order number
  defp create_order_number(changeset) do
    case changeset.valid? do
      true ->
        centre = Repo.get(PickupCentre, get_field(changeset, :pickup_centre_id))

        centre_name =
          centre.name
          |> String.split()
          |> List.first()
          |> binary_part(0, 3)
          |> String.replace(" ", "")
          |> String.replace("-", "")
          |> String.upcase()

        order_number = get_field(changeset, :order_number)

        number = "#" <> centre_name <> gen_unique_code() <> "-" <> gen_order_code()

        if is_nil(order_number) == true do
          changeset
          |> put_change(:order_number, number)
        else
          changeset
        end

      _ ->
        changeset
    end
  end

  defp location_area_in_address(changeset) do
    case changeset.valid? do
      true ->
        location = Repo.get(Location, get_field(changeset, :location_id))
        location_area = location.location_area
        address = get_field(changeset, :address)

        actual_address = address <> " " <> location_area

        changeset |> put_change(:address, actual_address)

      _ ->
        changeset
    end
  end

  defp calculate_delivery_charge(changeset) do
    case changeset.valid? do
      true ->
        pickup_centre_id = get_field(changeset, :pickup_centre_id)
        fifteen_to_thirty_minutes = get_field(changeset, :fifteen_to_thirty_minutes)
        one_to_two_hours = get_field(changeset, :one_to_two_hours)
        eight_am_twelve_pm = get_field(changeset, :eight_am_twelve_pm)
        twelve_pm_four_pm = get_field(changeset, :twelve_pm_four_pm)
        four_pm_ten_pm = get_field(changeset, :four_pm_ten_pm)

        delivery_charge =
          Repo.one(
            from d in DeliveryCharge,
              join: p in assoc(d, :pickup_centre),
              where: p.id == ^pickup_centre_id
          )

        if fifteen_to_thirty_minutes == true do
          changeset |> put_change(:delivery_charge, delivery_charge.fifteen_to_thirty_minutes)
        else
          if one_to_two_hours == true do
            changeset |> put_change(:delivery_charge, delivery_charge.one_hour)
          else
            if eight_am_twelve_pm == true do
              changeset |> put_change(:delivery_charge, delivery_charge.eight_to_twelve)
            else
              if twelve_pm_four_pm == true do
                changeset |> put_change(:delivery_charge, delivery_charge.twelve_to_four)
              else
                if four_pm_ten_pm == true do
                  changeset |> put_change(:delivery_charge, delivery_charge.four_to_ten)
                end
              end
            end
          end
        end

      _ ->
        changeset
    end
  end

  defp calculate_grand_total(changeset) do
    case changeset.valid? do
      true ->
        user_id = get_field(changeset, :user_id)
        delivery_charge = get_field(changeset, :delivery_charge)
        referal_discount = get_field(changeset, :referal_discount)

        cart_total =
          Repo.one(
            from(order in __MODULE__,
              join: cart_items in assoc(order, :cart_items),
              where: order.order_status == "cart activated" and order.user_id == ^user_id,
              select: sum(cart_items.sub_total)
            )
          )

        grand_total = Decimal.sub(Decimal.add(delivery_charge, cart_total), referal_discount)

        changeset |> put_change(:grand_total, grand_total)

      _ ->
        changeset
    end
  end

  defp set_amount_to_zero(changeset) do
    case changeset.valid? do
      true ->
        grand_total = get_field(changeset, :grand_total)
        new_grand_total = Decimal.to_integer(grand_total)

        if new_grand_total < 0 do
          changeset |> put_change(:grand_total, Decimal.new(0))
        else
          changeset
        end

      _ ->
        changeset
    end
  end

  defp gift_card_has_zero_balance(changeset) do
    case changeset.valid? do
      true ->
        gift_card = Repo.get(GiftCard, get_field(changeset, :gift_card_id))
        zero_balance = Decimal.new(0)

        if gift_card.amount == zero_balance do
          add_error(changeset, :gift_card_has_zero_balance, "Your gift card has zero balance.")
        else
          changeset
        end

      _ ->
        changeset
    end
  end

  defp check_card_activation(changeset) do
    case changeset.valid? do
      true ->
        gift_card = Repo.get(GiftCard, get_field(changeset, :gift_card_id))

        if gift_card.activated == false do
          add_error(
            changeset,
            :gift_card_has_zero_balance,
            "Your gift card has not been activated"
          )
        else
          changeset
        end

      _ ->
        changeset
    end
  end

  defp get_payment_option(changeset) do
    case changeset.valid? do
      true ->
        pay_with_card = get_field(changeset, :pay_with_card)
        payment_on_delivery = get_field(changeset, :pay_on_delivery)
        payment_at_pickup = get_field(changeset, :pay_at_pickup)

        if pay_with_card == true do
          changeset |> put_change(:payment_option, "Pay With Card")
        else
          if payment_on_delivery == true do
            changeset |> put_change(:payment_option, "Pay On Delivery")
          else
            if payment_at_pickup == true do
              changeset |> put_change(:payment_option, "Payment On Pickup")
            else
              add_error(
                changeset,
                :payment_option_not_chosen,
                "You have to select a payment option"
              )
            end
          end
        end

      _ ->
        changeset
    end
  end

  defp get_delivery_option(changeset) do
    case changeset.valid? do
      true ->
        centre_pick_up = get_field(changeset, :centre_pick_up)
        door_step_delivery = get_field(changeset, :door_step_delivery)
        curbside_pick_up = get_field(changeset, :curbside_pick_up)

        if centre_pick_up == true do
          changeset |> put_change(:delivery_option, "Store Pick Up")
        else
          if door_step_delivery == true do
            changeset |> put_change(:delivery_option, "Door Step Delivery")
          else
            if curbside_pick_up == true do
              changeset |> put_change(:delivery_option, "Curbside Pickup")
            else
              add_error(
                changeset,
                :delivery_option_not_selected,
                "You have to select a delivery option"
              )
            end
          end
        end

      _ ->
        changeset
    end
  end

  defp get_latest_time(changeset) do
    case changeset.valid? do
      true ->
        order_time = get_field(changeset, :order_placed_at) |> DateTime.to_time()
        thirty_minutes_time = Time.add(order_time, 1800) |> Time.truncate(:second)
        one_to_two_hours_time = Time.add(order_time, 7200) |> Time.truncate(:second)
        one_to_two_hours = get_field(changeset, :one_to_two_hours)
        thirty_minutes = get_field(changeset, :thirty_minutes)
        eight_am_twelve_pm = get_field(changeset, :eight_am_twelve_pm)
        twelve_pm_four_pm = get_field(changeset, :twelve_pm_four_pm)
        four_pm_ten_pm = get_field(changeset, :four_pm_ten_pm)

        if one_to_two_hours == true do
          changeset |> put_change(:latest_time, one_to_two_hours_time)
        else
          if thirty_minutes == true do
            changeset |> put_change(:latest_time, thirty_minutes_time)
          else
            if eight_am_twelve_pm == true do
              changeset |> put_change(:latest_time, ~T[12:00:00])
            else
              if twelve_pm_four_pm == true do
                changeset |> put_change(:latest_time, ~T[16:00:00])
              else
                if four_pm_ten_pm == true do
                  changeset |> put_change(:latest_time, ~T[22:00:00])
                end
              end
            end
          end
        end

        changeset

      _ ->
        changeset
    end
  end

  defp set_delivery_period(changeset) do
    case changeset.valid? do
      true ->
        fifteen_to_thirty_minutes = get_field(changeset, :fifteen_to_thirty_minutes)
        one_to_two_hours = get_field(changeset, :one_to_two_hours)
        eight_am_twelve_pm = get_field(changeset, :eight_am_twelve_pm)
        twelve_pm_four_pm = get_field(changeset, :twelve_pm_four_pm)
        four_pm_ten_pm = get_field(changeset, :four_pm_ten_pm)

        if fifteen_to_thirty_minutes == true do
          changeset |> put_change(:delivery_period, "15 to 30 minutes")
        else
          if one_to_two_hours == true do
            changeset |> put_change(:delivery_period, "1 to 2 hours")
          else
            if eight_am_twelve_pm == true do
              changeset |> put_change(:delivery_period, "8am to 12pm")
            else
              if twelve_pm_four_pm == true do
                changeset |> put_change(:delivery_period, "12pm to 4pm")
              else
                if four_pm_ten_pm == true do
                  changeset |> put_change(:delivery_period, "4pm to 10pm")
                end
              end
            end
          end
        end

        changeset

      _ ->
        changeset
    end
  end

  defp get_default_user_address(changeset) do
    case changeset.valid? do
      true ->
        user = Repo.get(User, get_field(changeset, :user_id))
        address = user.address
        changeset |> put_change(:address, address)

      _ ->
        changeset
    end
  end

  @doc """
  generate a four digit order confirmation code
  """
  def door_step_delivery_confirmation() do
    alphabet = Enum.to_list(?a..?z) ++ Enum.to_list(?0..?9)
    length = 5
    value = for _ <- 1..length, into: "", do: <<Enum.random(alphabet)>>

    actual_value =
      value
      |> String.upcase()

    actual_value
  end

  defp get_popular_item(changeset) do
    case changeset.valid? do
      true ->
        user_id = get_field(changeset, :user_id)

        query =
          from user in User,
            where: user.id == ^user_id,
            join: order in assoc(user, :orders),
            join: cart_item in assoc(order, :cart_items),
            join: item in assoc(cart_item, :item),
            on: true,
            order_by: [desc: cart_item.quantity],
            select: item.id

        item_id = Repo.all(query) |> List.first()

        changeset |> put_change(:item_id, item_id)

      _ ->
        changeset
    end
  end

  @spec gen_order_code :: binary
  def gen_order_code do
    code =
      5
      |> :math.pow(@order_code)
      |> round()
      |> :rand.uniform()
      |> Integer.to_string()
      |> String.pad_leading(@order_code, "0")

    code
  end

  @spec gen_unique_code :: binary
  defp gen_unique_code do
    alphabet = Enum.to_list(?a..?z) ++ Enum.to_list(?0..?9)
    length = 4
    value = for _ <- 1..length, into: "", do: <<Enum.random(alphabet)>>

    actual_value =
      value
      |> String.upcase()

    actual_value
  end
end

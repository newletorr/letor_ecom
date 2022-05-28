defmodule LetorEcom.Sms do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.
  This module holds functions that send SMS to users, suppliers and admins
  """
  # import Ecto.Query
  alias EcomHealthService.Accounts.{Confirmations, User}
  # alias EcomHealthService.Centres.FarmersDeliveryReq
  alias EcomHealthService.Repo
  @twillio_number "+13187029828"

  def send_code(user) do
    {:ok, code, _confirmed_user} = Confirmations.generate_confirmation_code(user)

    body =
      "Hello #{user.first_name}, your confirmation code is #{code}. This code expires in 1 hour time"

    ExTwilio.Message.create(to: user.phone, from: @twillio_number, body: body)
  end

  def sms_users_order_confirmation_code(order) do
    user = Repo.get(User, order.user_id)
    order_time = order.order_placed_at |> DateTime.to_time() |> Time.to_string()

    body =
      "#{order.delivery_confirmation_code} is the delivery confirmation code for items ordered by #{user.full_name} on www.letorr.com today at #{order_time}. Please provide this code to confirm the delivery of the items."

    ExTwilio.Message.create(to: order.phone, from: @twillio_number, body: body)
  end

  def sms_user_return_code(user_return) do
    user = Repo.get(User, user_return.user_id)

    body =
      "Your return code is #{user_return.code}. You are to present this code to the dispatch rider or agent before dropping off your returned items."

    ExTwillio.Message.create(to: user.phone, from: @twillio_number, body: body)
  end

  def send_gift_card_code(phone, gift_card) do
    message =
      "Your Gift Card code is: #{gift_card.id_code}. Please do not share you gift card code with anyone."

    ExTwilio.Message.create(to: phone, from: @twillio_number, body: message)
  end

  def text_user_delivery_confirmation_code(order) do
    message =
      "Your delivery confirmation is: #{order.delivery_confirmation_code}. You have to provide this code for the driver to confirm the delivery of you ordered items"

    ExTwilio.Message.create(to: order.phone, from: @twillio_number, body: message)
  end

  def text_user_pickup_code(order) do
    message =
      "Your Pick up code is: #{order.delivery_confirmation_code}. You have to provide this code during pick up at a store near you."

    ExTwilio.Message.create(to: order.phone, from: @twillio_number, body: message)
  end
end

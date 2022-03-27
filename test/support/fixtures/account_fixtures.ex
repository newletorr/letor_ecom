defmodule LetorEcom.AccountFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LetorEcom.Account` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        address: "No 12 Agip Road Rumueme PHC",
        business_name: "some business_name",
        date_of_birth: ~D[2022-03-23],
        email: "#{Enum.random(1..100)}some@email.com",
        first_name: "first_name",
        last_name: "last_name",
        phone: "081688918#{Enum.random(10..99)}"
        # password: "Password1@",
        # password_confirmation: "Password1@"
      })
      |> LetorEcom.Account.create_user()

    user
  end

  @doc """
  Generate a address.
  """
  def address_fixture(attrs \\ %{}) do
    user = user_fixture()

    {:ok, address} =
      attrs
      |> Enum.into(%{
        address1: "some address1",
        address2: "some address2",
        business_name: "some business_name",
        order_instruction: "some order_instruction",
        zip_code: "some zip_code",
        user_id: user.id
      })
      |> LetorEcom.Account.create_address()

    address
  end
end

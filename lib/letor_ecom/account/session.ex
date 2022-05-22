defmodule LetorEcom.Account.Session do
  @moduledoc """
   Copyright © 2022 Letor Nigeria Limited.
   All rights reserved.

  Session Module for authenticating users
  """
  # alias LetorEcom.Accounts.Facebook
  alias LetorEcom.Account.User
  alias LetorEcom.Repo

  # @spec facebook_auth(<<_::64>>, binary) :: any
  @doc """
  authenticate a user with email and password
  """

  # def facebook_auth("facebook", token) do
  #  attrs = Facebook.get_info(token)

  # search_params = %{
  #  facebook_id: attrs.facebook_id,
  # email: attrs.email,
  # first_name: attrs.first_name,
  # last_name: attrs.last_name
  # }

  # Accounts.get_or_create_users(attrs, search_params)
  # end

  @spec internal_authentication(any, any) ::
          {:error, <<_::64, _::_*8>>}
          | {:ok,
             nil
             | %{:doctor_id => any, :password_hash => <<_::64, _::_*8>>, optional(atom) => any}}
  def internal_authentication(nil, _password), do: {:error, "email is not valid"}
  def internal_authentication(_email, nil), do: {:error, "Password is not valid"}

  def internal_authentication(email, password) do
    {:ok, user} = get_user(email)

    if is_nil(user.farmer_id) == false do
      case check_password(user, password) do
        true ->
          {:ok, user}

        _ ->
          {:error,
           "We're having trouble confirming your login details. Maybe you typed them incorrectly? Please try again."}
      end
    else
      if is_nil(user.external_driver_id) == false do
        case check_password(user, password) do
          true ->
            {:ok, user}

          _ ->
            {:error,
             "We're having trouble confirming your login details. Maybe you typed them incorrectly? Please try again."}
        end
      else
        if is_nil(user.curbside_agent_id) == false and user.curbside_agent.status == "active" do
          case check_password(user, password) do
            true ->
              {:ok, user}

            _ ->
              {:error,
               "We're having trouble confirming your login details. Maybe you typed them incorrectly? Please try again."}
          end
        else
          if is_nil(user.staff_id) == false and user.staff.employment_status == "Active" do
            case check_password(user, password) do
              true ->
                {:ok, user}

              _ ->
                {:error,
                 "We're having trouble confirming your login details. Maybe you typed them incorrectly? Please try again."}
            end
          else
            if is_nil(user.food_vendor_id) == false and user.food_vendor.status == "active" do
              case check_password(user, password) do
                true ->
                  {:ok, user}

                _ ->
                  {:error,
                   "We're having trouble confirming your login details. Maybe you typed them incorrectly? Please try again."}
              end
            else
              if is_nil(user.laboratory_id) == false and user.laboratory.active == true do
                case check_password(user, password) do
                  true ->
                    {:ok, user}

                  _ ->
                    {:error,
                     "We're having trouble confirming your login details. Maybe you typed them incorrectly? Please try again."}
                end
              else
                if is_nil(user.supplier_id) == false and user.supplier.suspended == false and
                     user.supplier.blacklisted == false do
                  case check_password(user, password) do
                    true ->
                      {:ok, user}

                    _ ->
                      {:error,
                       "We're having trouble confirming your login details. Maybe you typed them incorrectly? Please try again."}
                  end
                else
                  if is_nil(user.gym_id) == false and user.gym.active == true do
                    case check_password(user, password) do
                      true ->
                        {:ok, user}

                      _ ->
                        {:error,
                         "We're having trouble confirming your login details. Maybe you typed them incorrectly? Please try again."}
                    end
                  else
                    if is_nil(user.seller_id) == false and user.seller.suspended == false and
                         user.seller.blacklisted == false do
                      case check_password(user, password) do
                        true ->
                          {:ok, user}

                        _ ->
                          {:error,
                           "We're having trouble confirming your login details. Maybe you typed them incorrectly? Please try again."}
                      end

                      if is_nil(user.company_id) == false and user.company.active == true do
                        case check_password(user, password) do
                          true ->
                            {:ok, user}

                          _ ->
                            {:error,
                             "We're having trouble confirming your login details. Maybe you typed them incorrectly? Please try again."}
                        end
                      else
                        if is_nil(user.driver_id) == false and user.driver.active == true do
                          case check_password(user, password) do
                            true ->
                              {:ok, user}

                            _ ->
                              {:error,
                               "We're having trouble confirming your login details. Maybe you typed them incorrectly? Please try again."}
                          end
                        else
                          {:error,
                           "Access Denied, Please contact Letorr Nigeria limited to know why you can't access your account"}
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  @spec external_authentication(any, any) ::
          {:error, <<_::144, _::_*24>>} | {:ok, atom | %{password_hash: <<_::64, _::_*8>>}}
  def external_authentication(nil, _password), do: {:error, "email is not valid"}
  def external_authentication(_email, nil), do: {:error, "Password is not valid"}

  def external_authentication(email, password) do
    user = User |> Repo.get_by(email: String.downcase(email))

    case check_password(user, password) do
      true ->
        {:ok, user}

      _ ->
        {:error,
         "We're having trouble confirming your login details. Maybe you typed them incorrectly? Please try again."}
    end
  end

  defp check_password(user, password) do
    case user do
      nil -> Argon2.no_user_verify()
      _ -> Argon2.verify_pass(password, user.password_hash)
    end
  end

  defp get_user(email) do
    user =
      User
      |> Repo.get_by(email: String.downcase(email))
      |> Repo.preload([
        :doctor,
        :dentist,
        :driver,
        :nurse,
        :staff,
        :hospital,
        :laboratory,
        :supplier,
        :seller,
        :gym,
        :company
      ])

    {:ok, user}
  end
end

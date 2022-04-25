defmodule LetorEcom.Account.Confirmation do
  @moduledoc """
  Copyright © 2020 Letorr Nigeria Limited.
  All rights reserved.

  """
  use Timex
  import Ecto.Query, warn: false
  import Ecto.Changeset
  import LetorEcom.Helpers.DateHelpers
  alias LetorEcom.Account.User
  alias LetorEcom.Repo

  @code_format ~r/^[0-9]{6}$/
  @msg_code_format "The code must contain 6 characters"

  @doc """
  Generate confirmation code
  """
  def generate_confirmation_code(%User{} = user) do
    with {:ok, code} <- generate_code(),
         {:ok, user} <-
           save_code(user, %{confirmation_code: code, confirmation_sent_at: Timex.now()}) do
      {:ok, code, user}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Confirm account
  """
  def confirm_account(%User{} = user, code) do
    attr = %{
      inputed_code: code,
      confirmed_at: Timex.now(),
      confirmation_code: nil,
      confirmation_sent_at: nil
    }

    user
    |> cast(attr, [:inputed_code, :confirmed_at, :confirmation_code, :confirmation_sent_at])
    |> validate_required([:inputed_code])
    |> validate_format(:inputed_code, @code_format, message: @msg_code_format)
    |> validate_already_confirmed([:inputed_code])
    |> validate_code([:inputed_code])
    |> validate_expiration([:inputed_code])
    |> Repo.update()
  end

  @doc """
  Account is confirmed ?
  """
  @spec confirmed?(User.t()) :: boolean() | {:error, String.t(), User.t()}
  def confirmed?(%User{confirmed_at: nil} = user) do
    {:ok, _code, user_with_code} = generate_confirmation_code(user)
    {:error, :no_yet_confirmed, user_with_code}
  end

  def confirmed?(%User{}), do: true

  defp save_code(%User{} = user, attr) do
    user
    |> cast(attr, [:confirmation_code, :confirmation_sent_at])
    |> validate_required([:confirmation_code, :confirmation_sent_at])
    |> validate_format(:confirmation_code, @code_format, message: @msg_code_format)
    |> validate_already_confirmed([:inputed_code])
    |> Repo.update()
  end

  @spec generate_code(integer()) :: {:ok, String.t()}
  defp generate_code(length \\ 6) do
    code =
      10
      |> :math.pow(length)
      |> round()
      |> :rand.uniform()
      |> Integer.to_string()
      |> String.pad_leading(length, "0")

    {:ok, code}
  end

  defp validate_code(changeset, _field) do
    if changeset.valid? && changeset.data.confirmation_code != changeset.changes.inputed_code do
      add_error(changeset, :wrong_code, "The code is invalid")
    else
      changeset
    end
  end

  defp validate_expiration(changeset, _field) do
    confirmation_code_expire_hours =
      Application.fetch_env!(:letor_ecom, :confirmation_code_expire_hours)

    if changeset.valid? &&
         expired?(changeset.data.confirmation_sent_at, hours: confirmation_code_expire_hours) do
      add_error(
        changeset,
        :expired_code,
        "Confirmation code has expired"
      )
    else
      changeset
    end
  end

  defp validate_already_confirmed(changeset, _field) do
    if changeset.valid? && changeset.data.confirmed_at do
      add_error(changeset, :already_confirmed, "This account has already been confirmed")
    else
      changeset
    end
  end
end
